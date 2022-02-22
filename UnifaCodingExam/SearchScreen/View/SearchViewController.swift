//
//  SearchViewController.swift
//  UnifaCodingExam
//
//  Created by CYAN on 2022/02/22.
//

import UIKit

class SearchViewController: UIViewController {

   @IBOutlet var searchBar: UISearchBar!
   @IBOutlet var tableView: UITableView!
   
   var viewModel = SearchViewModel()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      viewModel.fetchPhotosFromServer()
   }

}

