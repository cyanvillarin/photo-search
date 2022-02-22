//
//  SearchViewModel.swift
//  UnifaCodingExam
//
//  Created by CYAN on 2022/02/22.
//

import Foundation

class SearchViewModel {
   
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
      guard let url = URL(string: apiEndpoint) else {
         return
      }
      
      let task = session.dataTask(with: url, completionHandler: { data, response, error in
         print(data)
         print(response)
         print(error)
      })
      
      task.resume()
      
   }
   
   
}
