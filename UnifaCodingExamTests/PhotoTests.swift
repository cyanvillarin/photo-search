//
//  PhotoTests.swift
//  UnifaCodingExamTests
//
//  Created by CYAN on 2022/02/26.
//

import XCTest

@testable import UnifaCodingExam

class PhotoTests: XCTestCase {
   
   var mockApiService = MockApiService()
   
   override func setUpWithError() throws {
      // Put setup code here. This method is called before the invocation of each test method in the class.
   }
   
   override func tearDownWithError() throws {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
   }
   
   func testEquatableFunction() throws {
      let photo1 = mockApiService.mockResponse.photos[0]
      let photo2 = mockApiService.mockResponse.photos[1]
      if (photo1 == photo2) {
         print("photo are the same")
      } else {
         print("photos are not the same")
      }
   }
   
}
