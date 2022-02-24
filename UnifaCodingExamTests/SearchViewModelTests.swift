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
      self.apiService = MockApiService()
      self.viewModel = SearchViewModel(apiService: self.apiService)
      self.testScheduler = TestScheduler(initialClock: 0)
   }
   
   override func tearDown() {
      self.disposeBag = nil
      self.viewModel = nil
      self.apiService = nil
      self.testScheduler = nil
      super.tearDown()
   }
   
   func test_fetchPhotos() async {
      await viewModel.fetchPhotos(queryKeyword: "test")
      
      /// check if pageNumber is set to 1 when fetchPhotos is called
      XCTAssertEqual(viewModel.pageNumber, 1)
      
      /// check if nextPageURL and prevPageURL are updated when fetchPhotos
      XCTAssertEqual(viewModel.nextPageURL, "expected_next_page_URL")
      XCTAssertEqual(viewModel.prevPageURL, "expected_prev_page_URL")
   }
   
   func test_fetchMorePhotosIfNeeded() async {

      /// need to call fetchPhotos first, to set the nextPage and prevPage variables
      await viewModel.fetchPhotos(queryKeyword: "anything_here")
      
      /// check if pageNumber increases by 1 if paginationType is .next
      viewModel.pageNumber = 1
      await viewModel.fetchMorePhotosIfNeeded(paginationType: .next)
      XCTAssertEqual(viewModel.pageNumber, 2)
      
      /// check if pageNumber increases by 1 if paginationType is .prev
      viewModel.pageNumber = 2
      await viewModel.fetchMorePhotosIfNeeded(paginationType: .prev)
      XCTAssertEqual(viewModel.pageNumber, 1)
      
      /// check if nextPageURL and prevPageURL are updated when fetchMorePhotosIfNeeded
      await viewModel.fetchMorePhotosIfNeeded(paginationType: .next)
      XCTAssertEqual(viewModel.nextPageURL, "expected_next_page_URL")
      XCTAssertEqual(viewModel.prevPageURL, "expected_prev_page_URL")
   }
   
   func test_resetVariables() {
      let testError = CustomError.failedToGetUrl
      viewModel.resetVariables(error: testError)
      XCTAssertEqual(viewModel.prevPageURL, nil)
      XCTAssertEqual(viewModel.nextPageURL, nil)
   }
   
}

/// This will be the mock data to be used for Unit Testing
/// Subclass of ApiService, and just overrides the fetchPhotos function
class MockApiService: ApiService {
   
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
      return mockResponse
   }
   
   override func fetchNextOrPrevPhotos(paginationURL: String) async throws -> PhotosApiResponse {
      return mockResponse
   }
}
