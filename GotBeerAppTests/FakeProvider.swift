//
//  FakeProvider.swift
//  
//
//  Created by Libranner Leonel Santos Espinal on 15/08/2019.
//

import Foundation
@testable import GotBeerApp

struct FakeLocalProvider: LocalProvider {
  func getSearchHistory(forCriteria criteria: String) -> [Int64] {
    return FakeData.beers
      .filter { $0.foodPairing.contains(criteria) }
      .compactMap { $0.beerId }
  }
  
  func saveBeers(_ beers: [Beer], forCriteria criteria: String) {
  }
  
  func getBeers(withIds ids: [Int64]) -> [Beer] {
    return FakeData.beers.filter{ ids.contains($0.beerId) }
  }
}

struct FakeRemoteProvider: RemoteProvider {
  func getBeers(food: String, completion: @escaping ([Beer], Error?) -> Void) {
    let data = FakeData.beersRemote
      .filter { $0.foodPairing.contains(food) }
    completion(data, nil)
  }
}
