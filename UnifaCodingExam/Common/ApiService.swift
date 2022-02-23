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
   
   // MARK: - Variables
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
   
   // MARK: - Public Methods
   /// fetches the photos from the API
   /// will be used by the View Models
   /// using the newly released async/await functions
   public func fetchPhotos(queryKeyword: String) async throws -> [Photo] {
      
      /// check if we could get the URLComponents
      guard var urlComponents = URLComponents(string: Endpoint.search) else {
         throw CustomError.failedToCreateUrlComponents
      }
      
      /// add the query here
      urlComponents.queryItems = [
          URLQueryItem(name: "query", value: queryKeyword),
      ]
      
      /// check if we could get the URL from the URLComponents
      guard let url = urlComponents.url else {
         throw CustomError.failedToGetUrl
      }
      
      /// add the Authorization header
      var request = URLRequest(url: url)
      request.httpMethod = "GET"
      request.setValue(apiKey, forHTTPHeaderField: "Authorization")
      
      /// since we are supporting iOS 13, and we can't use the URLSession.shared.dataTask with async/await
      /// we have to use withCheckThrowingContinuation since this will allow us to us an asynchrounous function (using completionHandler) inside
      /// an asynchrounous function (using the new async/await) functions
      return try await withCheckedThrowingContinuation { continuation in
         
         let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            
            /// check if there is an error returned from API
            if let error = error {
               continuation.resume(throwing: error)
               return
            }
            
            /// check if we could retrieve the data
            guard let data = data else {
               continuation.resume(throwing: CustomError.failedToGetData)
               return
            }
            
            /// decode the data into JSON
            do {
               let decodedResult = try JSONDecoder().decode(SearchApiResponse.self, from: data)
               continuation.resume(returning: decodedResult.photos)
            } catch {
               continuation.resume(throwing: error)
            }
            
         })
         
         task.resume()
      }
      
   }
   
}
