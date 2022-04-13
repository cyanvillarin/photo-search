//
//  SearchTableViewCellViewModelTests.swift
//  PhotoSearchTests
//
//  Created by CYAN on 2022/02/25.
//

import XCTest

@testable import PhotoSearch

class SearchTableViewCellViewModelTests: XCTestCase {
   
   var sut: SearchTableViewCellViewModel!
   var mockApiService = MockApiService()
   
   override func setUp() {
      super.setUp()
      sut = SearchTableViewCellViewModel()
      guard let firstPhoto = mockApiService.mockResponse.photos.first else { return }
      sut.photo = firstPhoto
   }
   
   override func tearDown() {
      super.tearDown()
   }
   
   func test_variables() {
      XCTAssertEqual(sut.photoColor, UIColor(hexString: "374824"))
      XCTAssertEqual(sut.photoDescription, "Mock Photo 1")
      XCTAssertEqual(sut.photoURL, "https://images.pexels.com/photos/3573351/pexels-photo-3573351.png?auto=compress&cs=tinysrgb&h=130")
      XCTAssertEqual(sut.photoPhotographer, "Photographer 1")
   }
   
}
