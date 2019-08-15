//
//  Provider.swift
//  GotBeerApp
//
//  Created by Libranner Leonel Santos Espinal on 15/08/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation
import CoreData

protocol LocalProvider {
  func getSearchHistory(forCriteria criteria: String) -> [Int64]
  
  func saveBeers(_ beers: [Beer], forCriteria criteria: String)
  
  func getBeers(withIds ids:[Int64]) -> [Beer]
}

protocol RemoteProvider {
  func getBeers(food: String, completion: @escaping (_ beers: [Beer],
  _ error: Error?) -> Void)
}
