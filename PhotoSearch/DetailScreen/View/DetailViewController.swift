//
//  DetailViewController.swift
//  PhotoSearch
//
//  Created by CYAN on 2022/02/22.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
   
   // MARK: - Variables
   var photo: Photo!
   @IBOutlet var activityIndicator: UIActivityIndicatorView!
   @IBOutlet var itemImageView: UIImageView!
   @IBOutlet var itemDescriptionLabel: UILabel!
   @IBOutlet var itemPhotographerLabel: UILabel!
   
   // MARK: - Life Cycle Methods
   override func viewDidLoad() {
      super.viewDidLoad()

      self.title = nil
      itemImageView.layer.masksToBounds = true
      itemImageView.layer.cornerRadius = 8.0
      
      /// add a placeholder color
      let averageColor = photo.avg_color.replacingOccurrences(of: "#", with: "")
      itemImageView.backgroundColor = UIColor(hexString: averageColor)
      
      activityIndicator.style = .large
      activityIndicator.startAnimating()
      activityIndicator.isHidden = false
      if let url = URL(string: photo.src.large) {
         itemImageView.sd_setImage(with: url, completed: { _,_,_,_ in 
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
         })
      }
      itemDescriptionLabel.text = photo.alt
      itemPhotographerLabel.text = "撮影者：\(photo.photographer)"
   }
   
}