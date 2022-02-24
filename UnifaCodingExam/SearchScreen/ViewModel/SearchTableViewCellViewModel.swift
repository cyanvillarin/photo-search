//
//  SearchTableViewCellViewModel.swift
//  UnifaCodingExam
//
//  Created by CYAN on 2022/02/25.
//

import Foundation
import UIKit

class SearchTableViewCellViewModel {
   
   var photo: Photo!
   
   /// photo color for background and text color
   var photoColor: UIColor {
      let averageColor = photo.avg_color.replacingOccurrences(of: "#", with: "")
      return UIColor(hexString: averageColor)
   }
   
   /// photo description
   var photoDescription: String {
      return photo.alt
   }
   
   /// photo URL
   var photoURL: String {
      return photo.src.small
   }
   
   /// photo photographer
   var photoPhotographer: String {
      return photo.photographer
   }
   
}
