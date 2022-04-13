//
//  ApiService.swift
//  PhotoSearch
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
   public func fetchPhotos(queryKeyword: String) async throws -> PhotosApiResponse {
      
      /// check if we could get the URLComponents
      guard var urlComponents = URLComponents(string: Endpoint.search) else {
         throw CustomError.failedToCreateUrlComponents
      }
      
      /// add the query here
      urlComponents.queryItems = [
          URLQueryItem(name: "query", value: queryKeyword),
          URLQueryItem(name: "orientation", value: "portrait"),
          URLQueryItem(name: "per_page", value: "30")
      ]
      
      /// check if we could get the URL from the URLComponents
      guard let url = urlComponents.url else {
         throw CustomError.failedToGetUrl
      }
      
      /// perform the API call
      let response = try await performApiCall(inputUrl: url)
      return response
   }
   
   /// fetches the next or previous photos from the API (for Pagination)
   /// will be used by the View Models
   /// using the newly released async/await functions
   public func fetchNextOrPrevPhotos(paginationURL: String) async throws -> PhotosApiResponse {
            
      /// try to get URL
      guard let url = URL(string: paginationURL) else {
         throw CustomError.failedToGetUrl
      }
      
      /// perform the API call
      let response = try await performApiCall(inputUrl: url)
      return response
   }
   
   // MARK: - Private Methods
   /// This is a private method to be used by both fetchPhotos and fetchNextOrPrevPhotos
   /// - Parameter inputUrl: input URL
   private func performApiCall(inputUrl: URL)  async throws -> PhotosApiResponse {
      
      /// add the Authorization header
      var request = URLRequest(url: inputUrl)
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
               let decodedResult = try JSONDecoder().decode(PhotosApiResponse.self, from: data)
               continuation.resume(returning: decodedResult)
            } catch {
               continuation.resume(throwing: error)
            }
            
         })
         
         task.resume()
      }
   }
   
}
