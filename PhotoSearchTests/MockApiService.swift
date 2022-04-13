//
//  MockApiService.swift
//  PhotoSearchTests
//
//  Created by CYAN on 2022/02/24.
//

import Foundation

@testable import PhotoSearch

/// This will be the mock data to be used for Unit Testing
/// Subclass of ApiService, and just overrides the fetchPhotos function
class MockApiService: ApiService {
   
   var shouldFailApiCall = false
   
   var shouldReturnZeroPhotos = false
   
   let mockResponseWithZeroPhotos = PhotosApiResponse(total_results: 0,
                                                      page: 0,
                                                      per_page: 0,
                                                      photos: [],
                                                      next_page: nil,
                                                      prev_page: nil)
   
   let mockResponse = PhotosApiResponse(total_results: 10000,
                                        page: 1,
                                        per_page: 30,
                                        photos: [
                                          Photo(id: 1,
                                                width: 3066,
                                                height: 3968,
                                                url: "https://www.pexels.com/photo/trees-during-day-3573351/",
                                                photographer: "Photographer 1",
                                                photographer_url: "https://www.pexels.com/@lukas-rodriguez-1845331",
                                                photographer_id: 1845331,
                                                avg_color: "#374824",
                                                src: Source(original: "https://images.pexels.com/photos/3573351/pexels-photo-3573351.png",
                                                            large2x: "https://images.pexels.com/photos/3573351/pexels-photo-3573351.png?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
                                                            large: "https://images.pexels.com/photos/3573351/pexels-photo-3573351.png?auto=compress&cs=tinysrgb&h=650&w=940",
                                                            medium: "https://images.pexels.com/photos/3573351/pexels-photo-3573351.png?auto=compress&cs=tinysrgb&h=350",
                                                            small: "https://images.pexels.com/photos/3573351/pexels-photo-3573351.png?auto=compress&cs=tinysrgb&h=130",
                                                            portrait: "https://images.pexels.com/photos/3573351/pexels-photo-3573351.png?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800",
                                                            landscape: "https://images.pexels.com/photos/3573351/pexels-photo-3573351.png?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200",
                                                            tiny: "https://images.pexels.com/photos/3573351/pexels-photo-3573351.png?auto=compress&cs=tinysrgb&dpr=1&fit=crop&h=200&w=280"),
                                                liked: false,
                                                alt: "Mock Photo 1"),
                                          Photo(id: 2,
                                                width: 3066,
                                                height: 3968,
                                                url: "https://www.pexels.com/photo/trees-during-day-3573351/",
                                                photographer: "Photographer 2",
                                                photographer_url: "https://www.pexels.com/@lukas-rodriguez-1845331",
                                                photographer_id: 1845331,
                                                avg_color: "#374824",
                                                src: Source(original: "https://images.pexels.com/photos/3573351/pexels-photo-3573351.png",
                                                            large2x: "https://images.pexels.com/photos/3573351/pexels-photo-3573351.png?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
                                                            large: "https://images.pexels.com/photos/3573351/pexels-photo-3573351.png?auto=compress&cs=tinysrgb&h=650&w=940",
                                                            medium: "https://images.pexels.com/photos/3573351/pexels-photo-3573351.png?auto=compress&cs=tinysrgb&h=350",
                                                            small: "https://images.pexels.com/photos/3573351/pexels-photo-3573351.png?auto=compress&cs=tinysrgb&h=130",
                                                            portrait: "https://images.pexels.com/photos/3573351/pexels-photo-3573351.png?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800",
                                                            landscape: "https://images.pexels.com/photos/3573351/pexels-photo-3573351.png?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200",
                                                            tiny: "https://images.pexels.com/photos/3573351/pexels-photo-3573351.png?auto=compress&cs=tinysrgb&dpr=1&fit=crop&h=200&w=280"),
                                                liked: false,
                                                alt: "Mock Photo 2"),
                                          Photo(id: 3,
                                                width: 3066,
                                                height: 3968,
                                                url: "https://www.pexels.com/photo/trees-during-day-3573351/",
                                                photographer: "Photographer 3",
                                                photographer_url: "https://www.pexels.com/@lukas-rodriguez-1845331",
                                                photographer_id: 1845331,
                                                avg_color: "#374824",
                                                src: Source(original: "https://images.pexels.com/photos/3573351/pexels-photo-3573351.png",
                                                            large2x: "https://images.pexels.com/photos/3573351/pexels-photo-3573351.png?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
                                                            large: "https://images.pexels.com/photos/3573351/pexels-photo-3573351.png?auto=compress&cs=tinysrgb&h=650&w=940",
                                                            medium: "https://images.pexels.com/photos/3573351/pexels-photo-3573351.png?auto=compress&cs=tinysrgb&h=350",
                                                            small: "https://images.pexels.com/photos/3573351/pexels-photo-3573351.png?auto=compress&cs=tinysrgb&h=130",
                                                            portrait: "https://images.pexels.com/photos/3573351/pexels-photo-3573351.png?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800",
                                                            landscape: "https://images.pexels.com/photos/3573351/pexels-photo-3573351.png?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200",
                                                            tiny: "https://images.pexels.com/photos/3573351/pexels-photo-3573351.png?auto=compress&cs=tinysrgb&dpr=1&fit=crop&h=200&w=280"),
                                                liked: false,
                                                alt: "Mock Photo 3")
                                       ],
                                        next_page: "expected_next_page_URL",
                                        prev_page: "expected_prev_page_URL")
   
   override func fetchPhotos(queryKeyword: String) async throws -> PhotosApiResponse {
      
      /// for testing the response with zero photos
      if shouldReturnZeroPhotos {
         return mockResponseWithZeroPhotos
      }
      
      /// for testing the API call fail case
      if shouldFailApiCall {
         throw CustomError.failedToGetData
      }
      
      return mockResponse
   }
   
   override func fetchNextOrPrevPhotos(paginationURL: String) async throws -> PhotosApiResponse {
      
      /// for testing the response with zero photos
      if shouldReturnZeroPhotos {
         return mockResponseWithZeroPhotos
      }
      
      /// for testing the API call fail case
      if shouldFailApiCall {
         throw CustomError.failedToGetData
      }
      
      return mockResponse
   }
   
}
