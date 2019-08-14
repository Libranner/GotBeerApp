//
//  AsyncImageView.swift
//  GotBeerApp
//
//  Created by Libranner Leonel Santos Espinal on 12/08/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit

class AsyncImageView: UIImageView {
  var lastMark : UUID? = nil
  
  func fillWithURL(_ url: URL, placeholder: String?, completion: ((_ success: Bool) -> Void)? = nil) {
    self.image = placeholder != nil ? UIImage(named: placeholder!) : nil
    
    lastMark = UUID()
    let mark = lastMark
    
    ImageCacheManager.shared.imageWithURL(url) {
      [weak self] (image) in
      
      guard self?.lastMark == mark else {
        return
      }
      
      guard let unWrappedImage = image else {
        if let completion = completion {
          completion(false)
        }
        return
      }

      if Thread.isMainThread {
        self?.image = unWrappedImage
        if let completion = completion {
          completion(true)
        }
      }
      else {
        DispatchQueue.main.async {
          self?.image = unWrappedImage
          if let completion = completion {
            completion(true)
          }
        }
      }
    }
  }
}
