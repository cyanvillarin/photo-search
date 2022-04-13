//
//  UIApplicationExtensions.swift
//  PhotoSearch
//
//  Created by CYAN on 2022/02/23.
//

import Foundation
import UIKit

extension UIApplication {
   
   /// This function retrieves the top view controller
   /// - Parameter controller: the controller which you want to know which top view controller it has
   /// - Returns: the top view controller
   class func topViewController(controller: UIViewController? = UIApplication
                                 .shared
                                 .connectedScenes
                                 .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                                 .first { $0.isKeyWindow }?.rootViewController) -> UIViewController? {
      
      if let navigationController = controller as? UINavigationController {
         return topViewController(controller: navigationController.visibleViewController)
      }
      
      if let tabController = controller as? UITabBarController {
         if let selected = tabController.selectedViewController {
            return topViewController(controller: selected)
         }
      }
      
      if let presented = controller?.presentedViewController {
         return topViewController(controller: presented)
      }
      
      return controller
   }
   
}
