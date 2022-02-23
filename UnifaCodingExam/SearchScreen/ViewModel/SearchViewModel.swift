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
   
   var apiService: ApiService!
   
   init(apiService: ApiService) {
      self.apiService = apiService
   }
   
   func fetchPhotos(queryKeyword: String) {
      Task.init {
         do {
            let retrievedPhotos = try await self.apiService.fetchPhotos(queryKeyword: queryKeyword)
            self.photos.onNext(retrievedPhotos)
         } catch {
            print("error \(error.localizedDescription)")
         }
      }
   }
   
}
