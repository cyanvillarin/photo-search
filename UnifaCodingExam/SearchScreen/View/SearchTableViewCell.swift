//
//  SearchTableViewCell.swift
//  UnifaCodingExam
//
//  Created by CYAN on 2022/02/22.
//

import UIKit
import SDWebImage

class SearchTableViewCell: UITableViewCell {
   
   // MARK: - Variables
   var photo: Photo!
   @IBOutlet var itemImageView: UIImageView!
   @IBOutlet var itemDescription: UILabel!
   @IBOutlet var itemPhotographer: UILabel!
   @IBOutlet var activityIndicator: UIActivityIndicatorView!
   
   // MARK: - Override Methods
   override func awakeFromNib() {
      super.awakeFromNib()
      itemImageView.layer.masksToBounds = true
      itemImageView.layer.cornerRadius = 8.0
   }
   
   override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
   }
   
   // MARK: - Public Methods
   public func setup(photo: Photo) {
      self.photo = photo
      
      /// add a placeholder color
      let averageColor = photo.avg_color.replacingOccurrences(of: "#", with: "")
      
      /// configure description
      itemDescription.text = photo.alt
      itemDescription.textColor = UIColor(hexString: averageColor)
      
      /// configure image
      itemImageView.backgroundColor = UIColor(hexString: averageColor)
      activityIndicator.startAnimating()
      activityIndicator.isHidden = false
      if let url = URL(string: photo.src.small) {
         itemImageView.sd_setImage(with: url, completed: { _,_,_,_ in
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
         })
      }
      
      /// configure photographer
      itemPhotographer.text = photo.photographer
   }
   
}
