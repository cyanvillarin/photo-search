//
//  DetailViewControllerTests.swift
//  UnifaCodingExamTests
//
//  Created by CYAN on 2022/02/26.
//

import XCTest

@testable import UnifaCodingExam

class DetailViewControllerTests: XCTestCase {
   
   var sut: DetailViewController!
   var mockApiService = MockApiService()
   
   override func setUp() {
      super.setUp()
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      self.sut = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
      self.sut.photo = mockApiService.mockResponse.photos.first
      self.sut.loadView()
      self.sut.viewDidLoad()
   }
   
   override func tearDown() {
      super.tearDown()
   }
   
   func testHasATableView() {
      XCTAssertNotNil(sut.activityIndicator)
      XCTAssertNotNil(sut.itemImageView)
      XCTAssertNotNil(sut.itemDescriptionLabel)
      XCTAssertNotNil(sut.itemPhotographerLabel)
   }
   
}

