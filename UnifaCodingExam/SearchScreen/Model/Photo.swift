//
//  Photo.swift
//  UnifaCodingExam
//
//  Created by CYAN on 2022/02/22.
//

import Foundation

/// Search API Response's Photo Structure
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

extension Photo: Equatable {
   static func ==(lhs: Photo, rhs: Photo) -> Bool {
      return (lhs.id == rhs.id)
      && (lhs.width == rhs.width)
      && (lhs.height == rhs.height)
      && (lhs.url == rhs.url)
      && (lhs.photographer == rhs.photographer)
      && (lhs.photographer_url == rhs.photographer_url)
      && (lhs.photographer_id == rhs.photographer_id)
      && (lhs.avg_color == rhs.avg_color)
      && (lhs.src == rhs.src)
      && (lhs.liked == rhs.liked)
      && (lhs.alt == rhs.alt)
   }
}
