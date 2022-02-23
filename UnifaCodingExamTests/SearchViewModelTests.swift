//
//  SearchViewModelTests.swift
//  SearchViewModelTests
//
//  Created by CYAN on 2022/02/22.
//

import XCTest
import RxTest
import RxSwift
import RxCocoa

@testable import UnifaCodingExam

class SearchViewModelTests: XCTestCase {
   
   var viewModel: SearchViewModel!  /// system under test
   var apiService: ApiService! = MockApiService()
   var disposeBag: DisposeBag!
   var testScheduler: TestScheduler! /// main element of RxTests
   
   override func setUp() {
      super.setUp()
      self.disposeBag = DisposeBag()
      self.viewModel = SearchViewModel(apiService: self.apiService)
      self.apiService = MockApiService()
      self.testScheduler = TestScheduler(initialClock: 0)
   }
   
   override func tearDown() {
      self.disposeBag = nil
      self.viewModel = nil
      self.apiService = nil
      self.testScheduler = nil
      super.tearDown()
   }
   
   func test_fetchPhotos() {
      
      viewModel.fetchPhotos(queryKeyword: "test")
      
//      XCTAssertEqual(sut.photos[0].id, 1)
//      XCTAssertEqual(sut.photos[0].photographer, "Photographer 1")
//      XCTAssertEqual(sut.photos[0].alt, "Mock Photo 1")
//
//      XCTAssertEqual(sut.photos[1].id, 2)
//      XCTAssertEqual(sut.photos[1].photographer, "Photographer 2")
//      XCTAssertEqual(sut.photos[1].alt, "Mock Photo 2")
//
//      XCTAssertEqual(sut.photos[2].id, 3)
//      XCTAssertEqual(sut.photos[2].photographer, "Photographer 3")
//      XCTAssertEqual(sut.photos[2].alt, "Mock Photo 3")
   }
   
}

/// This will be the mock data to be used for Unit Testing
/// Subclass of ApiService, and just overrides the fetchPhotos function
class MockApiService: ApiService {
   override func fetchPhotos(queryKeyword: String) async throws -> PhotosApiResponse {
      let mockPhotos = [
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
      ]
      
      let mockResponse = PhotosApiResponse(total_results: 10000,
                                           page: 1,
                                           per_page: 1,
                                           photos: mockPhotos,
                                           next_page: "https://api.pexels.com/v1/search/?page=2&per_page=1&query=nature",
                                           prev_page: "https://api.pexels.com/v1/search/?page=2&per_page=1&query=nature")
      
      return mockResponse
   }
}
