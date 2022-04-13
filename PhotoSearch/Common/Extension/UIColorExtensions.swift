//
//  UIColorExtensions.swift
//  PhotoSearch
//
//  Created by CYAN on 2022/02/23.
//

import Foundation
import UIKit

extension UIColor {
   
   /// Create a color using RGB values from 0-255
   /// - Parameters:
   ///   - red: red value
   ///   - green: green value
   ///   - blue: blue value
   convenience init(red: Int, green: Int, blue: Int) {
      assert(red >= 0 && red <= 255, "Invalid red component")
      assert(green >= 0 && green <= 255, "Invalid green component")
      assert(blue >= 0 && blue <= 255, "Invalid blue component")
      
      self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }
   
   
   /// Create a color using hex string
   /// - Parameters:
   ///   - hexString: hex of the clor
   ///   - alpha: the alpha opacity of the color
   convenience init(hexString: String, alpha: CGFloat = 1.0) {
      let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
      let scanner = Scanner(string: hexString)
      var color: UInt64 = 0
      scanner.scanHexInt64(&color)
      let mask = 0x000000FF
      let r = Int(color >> 16) & mask
      let g = Int(color >> 8) & mask
      let b = Int(color) & mask
      let red   = CGFloat(r) / 255.0
      let green = CGFloat(g) / 255.0
      let blue  = CGFloat(b) / 255.0
      self.init(red:red, green:green, blue:blue, alpha:alpha)
   }
   
}
