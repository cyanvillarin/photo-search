//
//  DetailViewController.swift
//  UnifaCodingExam
//
//  Created by CYAN on 2022/02/22.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
   
   var photo: Photo!
   @IBOutlet var itemImageView: UIImageView!
   @IBOutlet var itemDescriptionLabel: UILabel!
   @IBOutlet var itemPhotographerLabel: UILabel!
   
   override func viewDidLoad() {
      super.viewDidLoad()

      self.title = nil
      itemImageView.layer.masksToBounds = true
      itemImageView.layer.cornerRadius = 8.0
      itemImageView.backgroundColor = UIColor(hexString: "CAD5E2")
      
      if let url = URL(string: photo.src.large) {
         itemImageView.sd_setImage(with: url, completed: nil)
      }
      itemDescriptionLabel.text = photo.alt
      itemPhotographerLabel.text = "撮影者：\(photo.photographer)"
   }
   
}
