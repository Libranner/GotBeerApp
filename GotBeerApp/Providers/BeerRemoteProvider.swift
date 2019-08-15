//
//  BeerRemoteProvider.swift
//  GotBeerApp
//
//  Created by Libranner Leonel Santos Espinal on 15/08/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation

struct BeerRemoteProvider: RemoteProvider {
  func getBeers(food: String, completion: @escaping (_ beers: [Beer],
    _ error: Error?) -> Void) {
    ApiClient.getBeers(food: food) { data,  error in
      completion(data, error)
    }
  }
}
