//
//  SearchTableViewCellTests.swift
//  UnifaCodingExamTests
//
//  Created by CYAN on 2022/02/24.
//

import XCTest

@testable import UnifaCodingExam

class SearchTableViewCellTests: XCTestCase {

   var searchViewController: SearchViewController!
   var searchTableViewCell: SearchTableViewCell! /// system under test
   var mockApiService = MockApiService()
   
   override func setUp() {
      super.setUp()
      
      /// load the tableView first
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      self.searchViewController = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController
      self.searchViewController.loadView()
      self.searchViewController.viewModel = SearchViewModel(apiService: mockApiService)
      self.searchViewController.viewDidLoad()
   }
   
   override func tearDown() {
      super.tearDown()
   }
   
   func test_setUp() {
            
      guard let firstPhoto = mockApiService.mockResponse.photos.first else {
         return
      }
      
      searchTableViewCell = SearchTableViewCell()
      searchTableViewCell.setup(photo: firstPhoto)
      
      XCTAssert(searchTableViewCell.photo == firstPhoto)
      
   }

}
