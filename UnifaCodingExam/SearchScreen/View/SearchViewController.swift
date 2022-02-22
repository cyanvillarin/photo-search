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
   
   let cellID = "SearchTableViewCell"
   let cellHeight = 115.0
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      tableView.delegate = self
      tableView.dataSource = self
      tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
      
      viewModel.fetchPhotosFromServer()
   }

}

extension SearchViewController: UITableViewDataSource {
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! SearchTableViewCell
      return cell
   }
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 10
   }
}

extension SearchViewController: UITableViewDelegate {
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return cellHeight
   }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      print(indexPath.row)
   }
}
