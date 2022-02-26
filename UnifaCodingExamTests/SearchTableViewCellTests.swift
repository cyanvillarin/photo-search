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
      
      let itemXib = UINib.init(nibName: "SearchTableViewCell", bundle: nil)
      searchViewController.tableView.register(itemXib,
                         forCellReuseIdentifier: "SearchTableViewCell")
   }
   
   override func tearDown() {
      super.tearDown()
   }
   
}

