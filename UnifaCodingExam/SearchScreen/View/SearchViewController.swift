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
   
   var viewModel = SearchViewModel(apiService: ApiService())
   let disposeBag = DisposeBag()
   
   let cellID = "SearchTableViewCell"
   let cellHeight = 115.0
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      if let navigationController = navigationController {
         /// Fix Nav Bar tint issue in iOS 15.0 or later - is transparent w/o code below
         if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            appearance.backgroundColor = UIColor.clear
            navigationController.navigationBar.standardAppearance = appearance
            navigationController.navigationBar.scrollEdgeAppearance = appearance
            
         } else {
            navigationController.navigationBar.barTintColor = UIColor.clear
         }
      }
      
      //Looks for single or multiple taps.
      let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
      
      //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
      tap.cancelsTouchesInView = false
      
      view.addGestureRecognizer(tap)
      
      let image = UIImage(named: "navbar_logo")
      let imageView = UIImageView(image: image)
      imageView.contentMode = .scaleAspectFit
      navigationItem.titleView = imageView
      
      searchBar.delegate = self
      searchBar.placeholder = "Please search here"
      
      tableView.delegate = self
      tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
      tableView.separatorStyle = .none
      
      self.bindViewModel()
      
      viewModel.fetchPhotos(queryKeyword: "Kindergarten")
   }
   
   @objc func dismissKeyboard() {
      view.endEditing(true)
   }
   
   public func bindViewModel() {
      
      /// bind the photos PublishSubject to tableView.rx.items
      /// TableViewDataSource  is not needed anymore thanks to RxCocoa
      viewModel.photos.bind(to: self.tableView.rx.items(cellIdentifier: cellID, cellType: SearchTableViewCell.self)) { (row, photo, cell) in
         DispatchQueue.main.async {
            cell.setup(photo: photo)
            cell.selectionStyle = .none
         }
      }.disposed(by: disposeBag)
      
      /// TableViewDelegate's didSelectRowAt is also not needed anymore thanks to RxCocoa
      self.tableView.rx.itemSelected
         .subscribe(onNext: { [weak self] indexPath in
            let cell = self?.tableView.cellForRow(at: indexPath) as! SearchTableViewCell
            if let cellPhoto = cell.photo {
               self?.transitionToDetailView(photo: cellPhoto)
            }
         }).disposed(by: disposeBag)
      
      /// bind the isLoading to show the LoadingView while calling the API
      viewModel.isLoading.subscribe(onNext: { (isLoading) in
         DispatchQueue.main.async {
            print(isLoading)
            if isLoading {
               LoadingView.show()
            } else {
               LoadingView.hide()
            }
         }
      }).disposed(by: disposeBag)
   }
   
   /// Moves to the Details screen
   /// - Parameter recipe: Recipe object
   private func transitionToDetailView(photo: Photo) {
      if let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
         detailVC.photo = photo
         if let navigator = self.navigationController {
            navigator.pushViewController(detailVC, animated: true)
         }
      }
   }
   
}

extension SearchViewController: UITableViewDelegate {
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return cellHeight
   }
}

extension SearchViewController: UISearchBarDelegate {
   func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload(_:)), object: searchBar)
      perform(#selector(self.reload(_:)), with: searchBar, afterDelay: 0.40)
   }
   
   @objc func reload(_ searchBar: UISearchBar) {
      guard let queryKeyword = searchBar.text, queryKeyword.trimmingCharacters(in: .whitespaces) != "" else {
         print("nothing to search")
         return
      }
      viewModel.fetchPhotos(queryKeyword: queryKeyword)
   }
}
