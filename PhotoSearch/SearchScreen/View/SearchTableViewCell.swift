//
//  SearchTableViewCell.swift
//  PhotoSearch
//
//  Created by CYAN on 2022/02/22.
//

import UIKit
import SDWebImage

class SearchTableViewCell: UITableViewCell {
   
   // MARK: - Variables
   var viewModel: SearchTableViewCellViewModel!
   @IBOutlet var itemImageView: UIImageView!
   @IBOutlet var itemDescription: UILabel!
   @IBOutlet var itemPhotographer: UILabel!
   @IBOutlet var activityIndicator: UIActivityIndicatorView!
   
   // MARK: - Override Methods
   override func awakeFromNib() {
      super.awakeFromNib()
      viewModel = SearchTableViewCellViewModel()
      itemImageView.layer.masksToBounds = true
      itemImageView.layer.cornerRadius = 8.0
   }
   
   override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
   }
   
   // MARK: - Public Methods
   public func setup(photo: Photo) {
      
      self.viewModel.photo = photo
      
      /// configure description
      itemDescription.text = self.viewModel.photoDescription
      itemDescription.textColor = self.viewModel.photoColor
      
      /// configure image
      itemImageView.backgroundColor = self.viewModel.photoColor
      activityIndicator.startAnimating()
      activityIndicator.isHidden = false
      if let url = URL(string: self.viewModel.photoURL) {
         itemImageView.sd_setImage(with: url, completed: { _,_,_,_ in
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
         })
      }
      
      /// configure photographer
      itemPhotographer.text = self.viewModel.photoPhotographer
   }
   
}
