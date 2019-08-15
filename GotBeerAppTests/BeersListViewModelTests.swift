//
//  BeersListViewModelTests.swift
//  GotBeerAppTests
//
//  Created by Libranner Leonel Santos Espinal on 15/08/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import XCTest
@testable import GotBeerApp
@testable import Pods_GotBeerApp

class BeersListViewModelTests: XCTestCase {
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testBeersListViewModelLoadDataFromLocalProvider() {
    let viewModel = BeersListViewModel(localProvider: FakeLocalProvider(),
                                       remoteProvider: FakeRemoteProvider())
    
    viewModel.loadData(forCriteria: "beans")
    let resultCount = try? viewModel.filteredBeers.value().count
    let isLoading = try? viewModel.loading.value()
    let hasResults = try? viewModel.noResultsAvailable.value()
    
    XCTAssertEqual(resultCount ?? 0, 2)
    XCTAssertEqual(isLoading, false)
    XCTAssertEqual(hasResults, false)
  }
  
  func testBeersListViewModelLoadDataFromRemoteProvider() {
    let viewModel = BeersListViewModel(localProvider: FakeLocalProvider(),
                                       remoteProvider: FakeRemoteProvider())
    
    viewModel.loadData(forCriteria: "pizza")
    let resultCount = try? viewModel.filteredBeers.value().count
    
    XCTAssertEqual(resultCount ?? 0, 1)
  }
}

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
