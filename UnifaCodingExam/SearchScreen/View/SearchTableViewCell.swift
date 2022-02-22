//
//  SearchTableViewCell.swift
//  UnifaCodingExam
//
//  Created by CYAN on 2022/02/22.
//

import UIKit

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
   
}
