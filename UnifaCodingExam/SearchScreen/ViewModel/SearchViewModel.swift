//
//  SearchViewModel.swift
//  UnifaCodingExam
//
//  Created by CYAN on 2022/02/22.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel {
   
   public var photos: PublishSubject<[Photo]> = PublishSubject()
   public var shouldShowLoadingView: PublishSubject<Bool> = PublishSubject()
   public var shouldShowNoResultsView: PublishSubject<Bool> = PublishSubject()
   
   var apiService: ApiService!
   
   init(apiService: ApiService) {
      self.apiService = apiService
   }
   
   func fetchPhotos(queryKeyword: String) {
      Task.init {
         do {
            shouldShowLoadingView.onNext(true)
            let retrievedPhotos = try await self.apiService.fetchPhotos(queryKeyword: queryKeyword)
            
            shouldShowNoResultsView.onNext(false)
            shouldShowLoadingView.onNext(false)
            
            self.photos.onNext(retrievedPhotos)
         } catch {
            self.photos.onNext([])
            shouldShowLoadingView.onNext(false)
            shouldShowNoResultsView.onNext(true)
            print("error \(error.localizedDescription)")
         }
      }
   }
   
}
