//
//  SearchView.swift
//  GotBeerApp
//
//  Created by Libranner Leonel Santos Espinal on 14/08/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit
import RxSwift

protocol SearchViewDelegate {
  func searchView(_ searchView: SearchView, didSearchFor text:String)
  func searchViewShouldDismiss()
}

class SearchView: UIView {
  private let disposeBag = DisposeBag()
  
  @IBOutlet private var criteriaTextField: UITextField!
  @IBOutlet private var searchButton: UIButton!
  var delegate: SearchViewDelegate?
  
  private func setupBinding() {
    searchButton.rx.tap.bind { [unowned self] in
      guard self.criteriaTextField.text?.isEmpty == false else {
        return
      }
      
      self.criteriaTextField.resignFirstResponder()
      self.delegate?.searchView(self, didSearchFor: self.criteriaTextField.text!)
      self.criteriaTextField.text = ""
      self.delegate?.searchViewShouldDismiss()
    }
    .disposed(by: disposeBag)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    searchButton.layer.cornerRadius = searchButton.frame.height/2
    searchButton.layer.borderColor = UIColor.white.cgColor
    searchButton.layer.borderWidth = 1
    
    setupBinding()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    layer.cornerRadius = frame.height/2
    layer.borderColor = UIColor.lightGray.cgColor
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.5
    layer.shadowOffset = CGSize(width: 0, height: 2.0)
    layer.shadowRadius = 2.0
    layer.masksToBounds = false
  }
}
