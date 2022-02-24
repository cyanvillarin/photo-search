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
   
   // MARK: - Variables
   @IBOutlet var searchBar: UISearchBar!
   @IBOutlet var currentPageLabel: UILabel!
   @IBOutlet var tableView: UITableView!
   @IBOutlet var noResultsFoundView: UIView!
   
   var viewModel = SearchViewModel(apiService: ApiService())
   let disposeBag = DisposeBag()
   
   let cellID = "SearchTableViewCell"
   let cellHeight = 115.0
   
   // MARK: - Life Cycle Methods
   override func viewDidLoad() {
      super.viewDidLoad()
      
      /// Setup UI
      setupNavigationBar()
      setupTapGestures()
      setupUI()
      
      /// Binds ViewController UI Elements to our ViewModel
      bindViewModel()
      
      /// fetch the photos with the keyword Kindergarten for the first results
      viewModel.fetchPhotos(queryKeyword: "Kindergarten")
   }
   
   // MARK: - Private Methods
   /// Setup the Navigation Bar
   private func setupNavigationBar() {
      
      /// Fix Nav Bar tint issue in iOS 15.0 or later - is transparent w/o code below
      if let navigationController = navigationController {
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
      
      /// Add unifa logo as part of titleView
      let image = UIImage(named: "navbar_logo")
      let imageView = UIImageView(image: image)
      imageView.contentMode = .scaleAspectFit
      navigationItem.titleView = imageView
      
   }
   
   /// Setup the tap gestures
   private func setupTapGestures() {
      /// Looks for single or multiple taps.
      let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
      
      /// Uncomment the line below if you want the tap not not interfere and cancel other interactions.
      tap.cancelsTouchesInView = false
      
      /// add the tap gestures
      view.addGestureRecognizer(tap)
   }
   
   /// Setup the inner UI aside from Navigation Bar
   private func setupUI() {
      noResultsFoundView.isHidden = true
      searchBar.delegate = self
      searchBar.placeholder = "ここで検索してください :)"
      tableView.delegate = self
      tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
      tableView.separatorStyle = .none
   }
   
   /// Dismisses the keyboard
   @objc func dismissKeyboard() {
      view.endEditing(true)
   }
   
   /// Binds the View's components to observable properties in ViewModel
   private func bindViewModel() {
      
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
      
      /// bind the shouldShowLoadingView to show the LoadingView while calling the API
      viewModel.shouldShowLoadingView.subscribe(onNext: { (shouldShowLoading) in
         DispatchQueue.main.async {
            if shouldShowLoading {
               LoadingView.show()
               self.tableView.isUserInteractionEnabled = false
            } else {
               LoadingView.hide()
               self.tableView.isUserInteractionEnabled = true
            }
         }
      }).disposed(by: disposeBag)
      
      /// bind the shouldShowNoResultsView to show the noResultsFoundView while calling the API
      viewModel.shouldShowNoResultsView.subscribe(onNext: { (shouldShowNoResultsView) in
         DispatchQueue.main.async {
            print("shouldShowNoResultsView \(shouldShowNoResultsView)")
            if shouldShowNoResultsView {
               self.noResultsFoundView.isHidden = false
            } else {
               self.noResultsFoundView.isHidden = true
            }
         }
      }).disposed(by: disposeBag)
      
      /// observer for shouldScrollToTop
      viewModel.shouldScrollToTop.subscribe(onNext: { (shouldScrollToTop) in
         DispatchQueue.main.async {
            /// scroll to top if needed
            if shouldScrollToTop {
               if self.tableView.numberOfRows(inSection: 0) != 0 {
                  let topRow = IndexPath(row: 0, section: 0)
                  self.tableView.scrollToRow(at: topRow, at: .top, animated: false)
               }
            }
         }
      }).disposed(by: disposeBag)
      
      /// observer for shouldScrollToBottom
      viewModel.shouldScrollToBottom.subscribe(onNext: { (shouldScrollToBottom) in
         DispatchQueue.main.async {
            /// scroll to bottom if needed
            if shouldScrollToBottom {
               let y = self.tableView.contentSize.height - self.tableView.frame.size.height
               if y < 0 { return }
               self.tableView.setContentOffset(CGPoint(x: 0, y: y), animated: false)
               self.tableView.layoutIfNeeded()
            }
         }
      }).disposed(by: disposeBag)
      
      /// observer for currentPageNumber
      viewModel.currentPageNumber.subscribe(onNext: { (pageNumber) in
         DispatchQueue.main.async {
            self.currentPageLabel.text = "Current Page: \(pageNumber)"
         }
      }).disposed(by: disposeBag)
      
   }
   
   /// Moves to the Details screen
   /// - Parameter photo: Photo object
   private func transitionToDetailView(photo: Photo) {
      if let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
         detailVC.photo = photo
         if let navigator = self.navigationController {
            navigator.pushViewController(detailVC, animated: true)
         }
      }
   }
   
}

// MARK: - Extensions
extension SearchViewController: UITableViewDelegate {
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return cellHeight
   }
}

extension SearchViewController: UISearchBarDelegate {
   
   /// allows the program to wait 0.40 before calling the reload function
   func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload(_:)), object: searchBar)
      perform(#selector(self.reload(_:)), with: searchBar, afterDelay: 0.40)
   }
   
   /// this method performs another API call
   @objc func reload(_ searchBar: UISearchBar) {
      
      /// do not search if there is no input in the search bar, or if it is a whitespace
      guard let queryKeyword = searchBar.text, queryKeyword.trimmingCharacters(in: .whitespaces) != "" else {
         print("Nothing to search")
         return
      }
      
      /// hide the keyboard
      view.endEditing(true)
      
      /// scroll to top if needed
      if self.tableView.numberOfRows(inSection: 0) != 0 {
         let topRow = IndexPath(row: 0, section: 0)
         self.tableView.scrollToRow(at: topRow, at: .top, animated: true)
      }
      
      /// fetch photos with the new keyword
      viewModel.fetchPhotos(queryKeyword: queryKeyword)
   }
}

extension SearchViewController: UIScrollViewDelegate {
   func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
      
      /// if the user scrolls to the top
      if (tableView.contentOffset.y < 0) {
         viewModel.fetchMorePhotosIfNeeded(paginationType: .prev)
      }
      
      /// if the user scrolls to the bottom
      if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height) {
         viewModel.fetchMorePhotosIfNeeded(paginationType: .next)
      }
      
   }
}
