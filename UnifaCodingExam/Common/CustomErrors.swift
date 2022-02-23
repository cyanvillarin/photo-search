//
//  CustomError.swift
//  UnifaCodingExam
//
//  Created by CYAN on 2022/02/23.
//

import Foundation

/// Custom errors that is used all throughout the app
enum CustomError: Error {
   case failedToCreateUrlComponents
   case failedToGetUrl
   case failedToGetData
}
