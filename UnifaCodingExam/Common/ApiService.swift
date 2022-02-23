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
   public func fetchPhotos(queryKeyword: String) async throws -> [Photo] {
      
      let session = URLSession.shared
      
      guard var urlComponents = URLComponents(string: Endpoint.search) else {
         throw CustomError.failedToCreateUrlComponents
      }
      
      urlComponents.queryItems = [
          URLQueryItem(name: "query", value: queryKeyword),
      ]
      
      guard let url = urlComponents.url else {
         throw CustomError.failedToGetUrl
      }
      
      var request = URLRequest(url: url)
      request.httpMethod = "GET"
      request.setValue(apiKey, forHTTPHeaderField: "Authorization")
      
      return try await withCheckedThrowingContinuation { continuation in
         
         let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if let error = error {
               continuation.resume(throwing: error)
               return
            }
            
            guard let data = data else {
               continuation.resume(throwing: CustomError.failedToGetData)
               return
            }
            
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
