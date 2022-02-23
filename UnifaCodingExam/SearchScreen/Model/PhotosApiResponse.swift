//
//  SearchPhotosApiResponse.swift
//  UnifaCodingExam
//
//  Created by CYAN on 2022/02/22.
//

import Foundation

/// Search Photos API Response Structure
/// The keys that will be used from the response, are the same as the variable name
struct PhotosApiResponse: Decodable {
   var total_results: Int
   var page: Int
   var per_page: Int
   var photos: [Photo]
   var next_page: String
}
