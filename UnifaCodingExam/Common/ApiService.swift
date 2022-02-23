//
//  ApiService.swift
//  UnifaCodingExam
//
//  Created by CYAN on 2022/02/23.
//

import Foundation

struct Endpoint {
   static let search = "https://api.pexels.com/v1/search"
}

class ApiService {
   
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
   
   // MARK: - Public Functions
   /// fetches the photos from the API
   /// will be used by the View Models
   public func fetchPhotos(queryKeyword: String) async -> [Photo] {
      await withCheckedContinuation { continuation in
         fetchPhotos(queryKeyword: queryKeyword) { photos in
            continuation.resume(returning: photos)
         }
      }
   }
   
   // MARK: - Private Functions
   /// fetches the photos objects from the API
   /// will not be used by the View Models
   private func fetchPhotos(queryKeyword: String, completion: @escaping ([Photo]) -> Void ) {
      
      let session = URLSession.shared
      
      guard var urlComponents = URLComponents(string: Endpoint.search) else {
         return
      }
      
      urlComponents.queryItems = [
          URLQueryItem(name: "query", value: queryKeyword),
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
         
         do {
            let decodedResult = try JSONDecoder().decode(SearchApiResponse.self, from: data)
            completion(decodedResult.photos)
         } catch {
            return
         }
         
      })
      
      task.resume()
      
   }
   
   
   
}
