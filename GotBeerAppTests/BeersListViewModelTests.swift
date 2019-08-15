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
