//
//  SearchViewController.swift
//  UnifaCodingExam
//
//  Created by CYAN on 2022/02/22.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {

   @IBOutlet var searchBar: UISearchBar!
   @IBOutlet var tableView: UITableView!
   
   var viewModel = SearchViewModel()
   let disposeBag = DisposeBag()
   
   let cellID = "SearchTableViewCell"
   let cellHeight = 115.0
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      tableView.delegate = self
      
      tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
      
      self.bindViewModel()
      
      viewModel.fetchPhotosFromServer()
   }
   
   public func bindViewModel() {
      
      /// bind the photos PublishSubject to tableView.rx.items
      /// TableViewDataSource  is not needed anymore thanks to RxCocoa
      viewModel.photos.bind(to: self.tableView.rx.items(cellIdentifier: cellID, cellType: SearchTableViewCell.self)) { (row, photo, cell) in
         
         DispatchQueue.main.async {
            cell.setup(photo: photo)
         }
         
      }.disposed(by: disposeBag)
      
      
      /// TableViewDelegate  is also not needed anymore thanks to RxCocoa
      self.tableView.rx.itemSelected
         .subscribe(onNext: { [weak self] indexPath in
            let cell = self?.tableView.cellForRow(at: indexPath) as! SearchTableViewCell
            
            // transition to detail screen
            
         }).disposed(by: disposeBag)
      
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
