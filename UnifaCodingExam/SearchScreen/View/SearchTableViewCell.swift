//
//  SearchTableViewCell.swift
//  UnifaCodingExam
//
//  Created by CYAN on 2022/02/22.
//

import UIKit
import SDWebImage

class SearchTableViewCell: UITableViewCell {
   
   @IBOutlet var itemImageView: UIImageView!
   @IBOutlet var itemDescription: UILabel!
   @IBOutlet var itemPhotographer: UILabel!
   
   override func awakeFromNib() {
      super.awakeFromNib()
   }
   
   override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
   }
   
   func setup(photo: Photo) {
      if let url = URL(string: photo.src.small) {
         itemImageView.sd_setImage(with: url, completed: nil)
      }
      itemDescription.text = photo.alt
      itemPhotographer.text = photo.photographer
   }
   
}
