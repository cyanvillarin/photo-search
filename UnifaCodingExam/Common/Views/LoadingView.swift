//
//  LoadingView.swift
//  UnifaCodingExam
//
//  Created by CYAN on 2022/02/23.
//  Copyright © 2019 Cyan Villarin. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

class LoadingView: UIView {
   
   private var contentBlurredEffectView = UIVisualEffectView()
   private var activityIndicator = NVActivityIndicatorView(frame: CGRect.zero)
   private var blurEffect = UIBlurEffect(style: .light)
   
   public class var sharedInstance: LoadingView {
      struct Singleton {
         static let instance = LoadingView(frame: CGRect.zero)
      }
      return Singleton.instance
   }
   
   public override init(frame: CGRect) {
      
      super.init(frame: frame)
      
      let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
      var statusBarHeight = CGFloat(0.0)
      if #available(iOS 13.0, *) {
         statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
      } else {
         statusBarHeight = UIApplication.shared.statusBarFrame.height
      }
      let statusBarYOrigin = -1 * statusBarHeight
      
      contentBlurredEffectView.effect = blurEffect
      contentBlurredEffectView.frame = CGRect(x: 0,
                                              y: statusBarYOrigin,
                                              width: UIScreen.main.bounds.width,
                                              height: UIScreen.main.bounds.height
                                              + statusBarHeight)
      
      activityIndicator.frame.size = CGSize(width: 70, height: 70)
      activityIndicator.color = UIColor(hexString: "4DB5B8")
      activityIndicator.type = NVActivityIndicatorType.ballClipRotatePulse
      activityIndicator.startAnimating()
      
      addSubview(contentBlurredEffectView)
      addSubview(activityIndicator)
   }
   
   required public init?(coder aDecoder: NSCoder) {
      fatalError("Not coder compliant")
   }
   
   public class func show() {
      let loadingView = LoadingView.sharedInstance
      
      UIView.animate(withDuration: 0.20, delay: 0.0, options: .curveEaseOut, animations: {
         
         loadingView.contentBlurredEffectView.contentView.alpha = 1
         loadingView.activityIndicator.alpha = 1
         loadingView.contentBlurredEffectView.effect = loadingView.blurEffect
         
         if let topController = UIApplication.topViewController() {
            loadingView.activityIndicator.center = topController.view.center
            topController.navigationController?.view.addSubview(loadingView)
         }
         
      }, completion: nil)
      
   }
   
   public class func hide() {
      let loadingView = LoadingView.sharedInstance
      
      UIView.animate(withDuration: 0.33, delay: 0.0, options: .curveEaseOut, animations: {
         
         loadingView.contentBlurredEffectView.contentView.alpha = 0
         loadingView.activityIndicator.alpha = 0
         loadingView.contentBlurredEffectView.effect = nil
         
      }, completion: {_ in
         loadingView.removeFromSuperview()
      })
   }
}


