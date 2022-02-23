//
//  Source.swift
//  UnifaCodingExam
//
//  Created by CYAN on 2022/02/22.
//

import Foundation

/// Search API Response's Source Structure
struct Source: Decodable {
   var original: String
   var large2x: String
   var large: String
   var medium: String
   var small: String
   var portrait: String
   var landscape: String
   var tiny: String
}
