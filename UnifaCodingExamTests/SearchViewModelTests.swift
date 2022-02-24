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
