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
      if let url = URL(string: photo.src.small) {
         itemImageView.sd_setImage(with: url, completed: nil)
      }
      itemDescription.text = photo.alt
      itemPhotographer.text = photo.photographer
   }
   
}
