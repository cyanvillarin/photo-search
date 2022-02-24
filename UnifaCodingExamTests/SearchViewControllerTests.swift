//
//  SearchViewControllerTests.swift
//  UnifaCodingExamTests
//
//  Created by CYAN on 2022/02/25.
//

import XCTest

@testable import UnifaCodingExam

class SearchViewControllerTests: XCTestCase {
   
   var sut: SearchViewController!
   
   override func setUp() {
      super.setUp()
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      self.sut = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController
      self.sut.loadView()
      self.sut.viewDidLoad()
   }
   
   override func tearDown() {
      super.tearDown()
   }
   
   func testHasATableView() {
      XCTAssertNotNil(sut.tableView)
   }
   
   func testTableViewHasDelegate() {
      XCTAssertNotNil(sut.tableView.delegate)
   }

}
