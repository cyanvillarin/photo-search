//
//  SearchViewModel.swift
//  UnifaCodingExam
//
//  Created by CYAN on 2022/02/22.
//

import Foundation
import RxSwift
import RxCocoa

enum PaginationType {
   case next
   case prev
}

class SearchViewModel {
   
   // MARK: - Variables
   public var photos: PublishSubject<[Photo]> = PublishSubject()
   public var shouldShowLoadingView: PublishSubject<Bool> = PublishSubject()
   public var shouldShowNoResultsView: PublishSubject<Bool> = PublishSubject()
   
   public var shouldScrollToTop: PublishSubject<Bool> = PublishSubject()
   public var shouldScrollToBottom: PublishSubject<Bool> = PublishSubject()
   public var currentPageNumber: PublishSubject<Int> = PublishSubject()
   
   var pageNumber = 1
   var prevPageURL: String?
   var nextPageURL: String?
   
   /// Use of dependency injection, so we can use a mock Api while Unit Testing
   var apiService: ApiService!
   init(apiService: ApiService) {
      self.apiService = apiService
   }
   
   /// Fetches photos from the API
   /// - Parameter queryKeyword: the keyword that will be used for searching
   func fetchPhotos(queryKeyword: String) {
      
      /// since we are using async/await, we need to use Task.init whenever we call the asynchronous function (with await keyword)
      Task.init {
         do {
            /// passes the 'true' value to shoudShowLoadingView's next value
            /// this will trigger View to display the LoadingView
            shouldShowLoadingView.onNext(true)
            
            /// fetch photos from API, it has await, so it will wait until this function is finished executing before proceeding to the next step
            let response = try await self.apiService.fetchPhotos(queryKeyword: queryKeyword)
            
            print(response)
            
            /// set values for the shouldShowNoResultsView, and the shouldShowLoadingView
            shouldShowNoResultsView.onNext(false)
            shouldShowLoadingView.onNext(false)
            
            /// after retrieving the data, update the Observable property, so it will trigger the UI update from the View
            self.photos.onNext(response.photos)
            
            /// set the next page and prev page  (if available)
            self.prevPageURL = response.prev_page
            self.nextPageURL = response.next_page
            
            /// reset the page number (since this is a fresh new search)
            pageNumber = 1
            currentPageNumber.onNext(pageNumber)
            
            /// in case there is no photos returned, show the No Results View
            if response.photos.count == 0 {
               print("No photos found")
               shouldShowNoResultsView.onNext(true)
            }
            
         } catch {
            
            /// in case something wrong happens, resets the value of the Observable into empty array
            self.photos.onNext([])
            
            /// set the next and prev page to nil
            self.nextPageURL = nil
            self.prevPageURL = nil
            
            /// hide the LoadingView
            shouldShowLoadingView.onNext(false)
            
            /// show the No Results View
            shouldShowNoResultsView.onNext(true)
            
            /// print the error
            print("error \(error.localizedDescription)")
            
         }
      }
   }
   
   /// This method is called if the user scrolls to the bottom of the table view
   func fetchMorePhotosIfNeeded(paginationType: PaginationType) {
   
      Task.init {
         do {
            
            print("nextPage: \(String(describing: self.nextPageURL))")
            print("prevPage: \(String(describing: self.prevPageURL))")
            
            /// check and assign the paginationURL
            var paginationURL: String
            if paginationType == .next {
               guard let nextPage = self.nextPageURL else {
                  return
               }
               paginationURL = nextPage
            } else { /// prev
               guard let prevPage = self.prevPageURL else {
                  return
               }
               paginationURL = prevPage
            }
            
            /// show the LoadingView
            shouldShowLoadingView.onNext(true)
            
            /// fetch next photos from API
            let response = try await self.apiService.fetchNextOrPrevPhotos(paginationURL: paginationURL)
            
            /// hide the LoadingView
            shouldShowLoadingView.onNext(false)
            
            /// scroll to top or bottom after retrieving data from API
            if paginationType == .next {
               shouldScrollToTop.onNext(true)
               pageNumber = pageNumber + 1
            } else {  /// prev
               shouldScrollToBottom.onNext(true)
               pageNumber = pageNumber - 1
            }
            
            /// update the currertPageNumber (updates the label on View)
            currentPageNumber.onNext(pageNumber)
            
            /// update photos (updates the tableView)
            self.photos.onNext(response.photos)
            
            /// set the next page and prev page  (if available)
            self.prevPageURL = response.prev_page
            self.nextPageURL = response.next_page
            
         } catch {
            /// print the error
            print("error \(error.localizedDescription)")
         }
      }
      
   }
   
}
