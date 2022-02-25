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

@testable import UnifaCodingExam

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
