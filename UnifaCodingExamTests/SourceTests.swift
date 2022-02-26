//
//  SourceTests.swift
//  UnifaCodingExamTests
//
//  Created by CYAN on 2022/02/26.
//

import XCTest

@testable import UnifaCodingExam

class SourceTests: XCTestCase {
   
   var mockApiService = MockApiService()
   
   override func setUpWithError() throws {
      // Put setup code here. This method is called before the invocation of each test method in the class.
   }
   
   override func tearDownWithError() throws {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
   }
   
   func testEquatableFunction() throws {
      let source1 = mockApiService.mockResponse.photos[0].src
      let source2 = mockApiService.mockResponse.photos[1].src
      if (source1 == source2) {
         print("sources are the same")
      } else {
         print("sources are not the same")
      }
   }
   
}
