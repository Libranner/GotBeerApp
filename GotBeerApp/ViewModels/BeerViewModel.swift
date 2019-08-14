//
//  BeerViewModel.swift
//  GotBeerApp
//
//  Created by Libranner Leonel Santos Espinal on 14/08/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit
import RxSwift

class BeerViewModel: NSObject {
  var filteredBeers = BehaviorSubject<[Beer]>(value: [])
  var noResultsAvailable = BehaviorSubject<Bool>(value: false)
  
  private let disposeBag = DisposeBag()
}
