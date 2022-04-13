//
//  SearchViewModelTests.swift
//  SearchViewModelTests
//
//  Created by CYAN on 2022/02/22.
//

import XCTest
import RxTest
import RxSwift

/// NOTE: In order to unit test observables, I needed to use the RxTest framework. Since Observables are not just
/// ordinary values, but are streams of data, using XCTest only would not be enough.
/// Reference: https://betterprogramming.pub/rxswift-unit-testing-explained-in-3-minutes-c024b7a26d

@testable import PhotoSearch

class SearchViewModelTests: XCTestCase {
   
   var viewModel: SearchViewModel!  /// system under test
   var mockApiService: MockApiService!
   var disposeBag: DisposeBag!
   var testScheduler: TestScheduler! /// main element of RxTests
   
   override func setUp() {
      super.setUp()
      self.disposeBag = DisposeBag()
      self.mockApiService = MockApiService()
      self.viewModel = SearchViewModel(apiService: self.mockApiService)
      self.testScheduler = TestScheduler(initialClock: 0)
   }
   
   override func tearDown() {
      self.disposeBag = nil
      self.viewModel = nil
      self.mockApiService = nil
      self.testScheduler = nil
      super.tearDown()
   }
   
   func test_fetchPhotos() async {
      
      /// create testSchedulers
      let photos = testScheduler.createObserver([Photo].self)
      let shouldShowNoResultsView = testScheduler.createObserver(Bool.self)
      let shouldShowLoadingView = testScheduler.createObserver(Bool.self)
      let currentPageNumber = testScheduler.createObserver(Int.self)
      
      /// bind
      viewModel.photos.bind(to: photos).disposed(by: disposeBag)
      viewModel.shouldShowNoResultsView.bind(to: shouldShowNoResultsView).disposed(by: disposeBag)
      viewModel.shouldShowLoadingView.bind(to: shouldShowLoadingView).disposed(by: disposeBag)
      viewModel.currentPageNumber.bind(to: currentPageNumber).disposed(by: disposeBag)
      
      /// check if Observables don't have any values yet
      XCTAssertRecordedElements(photos.events, [])
      XCTAssertRecordedElements(shouldShowNoResultsView.events, [])
      XCTAssertRecordedElements(shouldShowLoadingView.events, [])
      XCTAssertRecordedElements(currentPageNumber.events, [])
      
      /// perform the simulation of fetching photos
      await viewModel.fetchPhotos(queryKeyword: "test")
      
      /// check if Observables are updated with the latest value fetched from viewModel.fetchPhotos
      XCTAssertRecordedElements(photos.events, [mockApiService.mockResponse.photos])
      XCTAssertRecordedElements(shouldShowNoResultsView.events, [false])
      XCTAssertRecordedElements(shouldShowLoadingView.events, [true, false])
      XCTAssertRecordedElements(currentPageNumber.events, [1])
      
      /// check if pageNumber is set to 1 when fetchPhotos is called
      XCTAssertEqual(viewModel.pageNumber, 1)
      
      /// check if nextPageURL and prevPageURL are updated when fetchPhotos
      XCTAssertEqual(viewModel.nextPageURL, "expected_next_page_URL")
      XCTAssertEqual(viewModel.prevPageURL, "expected_prev_page_URL")
   }
   
   func test_fetchPhotos_fail_case() async {
      /// set the flag to true
      mockApiService.shouldFailApiCall = true
      
      /// perform the simulation of fetching photos
      await viewModel.fetchPhotos(queryKeyword: "fail")
      
      /// check if nextPageURL and prevPageURL are updated to nil when fetchPhotos
      XCTAssertEqual(viewModel.nextPageURL, nil)
      XCTAssertEqual(viewModel.prevPageURL, nil)
   }
   
   func test_fetchPhotosWithZeroResults() async {
      
      /// reinstantiate viewModel to have the shouldReturnZero to true
      mockApiService.shouldReturnZeroPhotos = true
      viewModel = SearchViewModel(apiService: mockApiService)
      
      /// create testSchedulers
      let photos = testScheduler.createObserver([Photo].self)
      let shouldShowNoResultsView = testScheduler.createObserver(Bool.self)
      let shouldShowLoadingView = testScheduler.createObserver(Bool.self)
      let currentPageNumber = testScheduler.createObserver(Int.self)
      
      /// bind
      viewModel.photos.bind(to: photos).disposed(by: disposeBag)
      viewModel.shouldShowNoResultsView.bind(to: shouldShowNoResultsView).disposed(by: disposeBag)
      viewModel.shouldShowLoadingView.bind(to: shouldShowLoadingView).disposed(by: disposeBag)
      viewModel.currentPageNumber.bind(to: currentPageNumber).disposed(by: disposeBag)
      
      /// simulate the fetching photos but with zero results
      await viewModel.fetchPhotos(queryKeyword: "test")
      XCTAssertRecordedElements(photos.events, [[]])
   }
   
   func test_fetchMorePhotosIfNeeded() async {

      /// create testSchedulers
      let photos = testScheduler.createObserver([Photo].self)
      let shouldShowLoadingView = testScheduler.createObserver(Bool.self)
      let currentPageNumber = testScheduler.createObserver(Int.self)
      
      /// bind
      viewModel.photos.bind(to: photos).disposed(by: disposeBag)
      viewModel.shouldShowLoadingView.bind(to: shouldShowLoadingView).disposed(by: disposeBag)
      viewModel.currentPageNumber.bind(to: currentPageNumber).disposed(by: disposeBag)
      
      /// need to call fetchPhotos first, to set the nextPage and prevPage variables (to be used on fetchMorePhotosIfNeeded)
      await viewModel.fetchPhotos(queryKeyword: "anything_here")
      
      /// check if pageNumber increases by 1 if paginationType is .next
      await viewModel.fetchMorePhotosIfNeeded(paginationType: .next)
      XCTAssertEqual(viewModel.pageNumber, 2)
      
      /// check if pageNumber increases by 1 if paginationType is .prev
      await viewModel.fetchMorePhotosIfNeeded(paginationType: .prev)
      XCTAssertEqual(viewModel.pageNumber, 1)
      
      /// check if nextPageURL and prevPageURL are updated when fetchMorePhotosIfNeeded
      await viewModel.fetchMorePhotosIfNeeded(paginationType: .next)
      XCTAssertEqual(viewModel.nextPageURL, "expected_next_page_URL")
      XCTAssertEqual(viewModel.prevPageURL, "expected_prev_page_URL")
      
      /// check if Observables are updated with the latest value fetched from viewModel.fetchPhotos
      let mockPhotos = mockApiService.mockResponse.photos
      XCTAssertRecordedElements(photos.events, [mockPhotos, mockPhotos, mockPhotos, mockPhotos])
      XCTAssertRecordedElements(shouldShowLoadingView.events, [true, false, true, false, true, false, true, false])
      XCTAssertRecordedElements(currentPageNumber.events, [1, 2, 1, 2])
   }
   
   func test_fetchMorePhotosIfNeeded_fail_case() async {
      
      /// reinstantiate viewModel to have the shouldReturnZero to true
      mockApiService.shouldFailApiCall = true
      viewModel = SearchViewModel(apiService: mockApiService)
      
      /// need to set so that it will proceed until apiService.fetchNextOrPrevPhotos
      viewModel.nextPageURL = "testURL"
      
      /// perform the simulation of fetching photos
      await viewModel.fetchMorePhotosIfNeeded(paginationType: .next)
         
      /// check if nextPageURL and prevPageURL are updated to nil when fetchPhotos
      XCTAssertEqual(viewModel.nextPageURL, nil)
      XCTAssertEqual(viewModel.prevPageURL, nil)
            
   }
   
   func test_fetchMorePhotosIfNeeded_WithNilPrevPageOrNextPage() async {
      
      /// reinstantiate viewModel to have the shouldReturnZero to true
      mockApiService.shouldReturnZeroPhotos = true
      viewModel = SearchViewModel(apiService: mockApiService)
      
      /// simulate the fetching photos but with zero results
      await viewModel.fetchPhotos(queryKeyword: "test")
      
      await viewModel.fetchMorePhotosIfNeeded(paginationType: .next)
      XCTAssertEqual(viewModel.nextPageURL, nil)
      
      await viewModel.fetchMorePhotosIfNeeded(paginationType: .prev)
      XCTAssertEqual(viewModel.prevPageURL, nil)
      
   }
   
   func test_resetVariables() {
      
      let testError = CustomError.failedToGetUrl
      
      /// create testSchedulers
      let photos = testScheduler.createObserver([Photo].self)
      let shouldShowNoResultsView = testScheduler.createObserver(Bool.self)
      let shouldShowLoadingView = testScheduler.createObserver(Bool.self)
      
      /// bind
      viewModel.photos.bind(to: photos).disposed(by: disposeBag)
      viewModel.shouldShowNoResultsView.bind(to: shouldShowNoResultsView).disposed(by: disposeBag)
      viewModel.shouldShowLoadingView.bind(to: shouldShowLoadingView).disposed(by: disposeBag)
      
      /// resetVariables
      viewModel.resetVariables(error: testError)
      
      /// check if Observables are updated with the latest value fetched from viewModel.fetchPhotos
      XCTAssertRecordedElements(photos.events, [[]])
      XCTAssertRecordedElements(shouldShowLoadingView.events, [false])
      XCTAssertRecordedElements(shouldShowNoResultsView.events, [true])
      XCTAssertEqual(viewModel.prevPageURL, nil)
      XCTAssertEqual(viewModel.nextPageURL, nil)
   }
   
}
