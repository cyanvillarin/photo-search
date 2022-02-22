//
//  SearchViewModel.swift
//  UnifaCodingExam
//
//  Created by CYAN on 2022/02/22.
//

import Foundation
import RxSwift

class SearchViewModel {
   
   public var photos: PublishSubject<[Photo]> = PublishSubject()
   
   private var apiEndpoint = "https://api.pexels.com/v1/search"
   
   private var apiKey: String {
      get {
         guard let filePath = Bundle.main.path(forResource: "Keys", ofType: "plist") else {
            fatalError("Couldn't find file 'Keys.plist'.")
         }
         let plist = NSDictionary(contentsOfFile: filePath)
         guard let value = plist?.object(forKey: "API_KEY") as? String else {
            fatalError("Couldn't find key 'API_KEY' in 'Keys.plist'.")
         }
         return value
      }
   }
   
   /// fetches the photos objects from the API
   public func fetchPhotosFromServer() {
      
      let session = URLSession.shared
      
      var urlComponents = URLComponents(string: apiEndpoint)!
      urlComponents.queryItems = [
          URLQueryItem(name: "query", value: "pen"),
      ]
      
      guard let url = urlComponents.url else {
         return
      }
      
      var request = URLRequest(url: url)
      request.httpMethod = "GET"
      request.setValue(apiKey, forHTTPHeaderField: "Authorization")
      
      let task = session.dataTask(with: request, completionHandler: { data, response, error in
         
         if let error = error {
            print("There is some error \(error.localizedDescription)")
            return
         }
         
         guard let data = data else {
            print("There is no data")
            return
         }
         
         let decodedResult = try! JSONDecoder().decode(SearchApiResponse.self, from: data)
         self.photos.onNext(decodedResult.photos)
         
      })
      
      task.resume()
      
   }
   
   
}
