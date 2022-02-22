//
//  Photo.swift
//  UnifaCodingExam
//
//  Created by CYAN on 2022/02/22.
//

import Foundation

struct Photo: Decodable {
   var id: Int
   var width: Int
   var height: Int
   var url: String
   var photographer: String
   var photographer_url: String
   var photographer_id: Int
   var avg_color: String
   var src: Source
   var liked: Bool
   var alt: String
}
