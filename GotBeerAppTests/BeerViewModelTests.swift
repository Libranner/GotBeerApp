//
//  BeerViewModelTests.swift
//  GotBeerAppTests
//
//  Created by Libranner Leonel Santos Espinal on 15/08/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import XCTest
@testable import GotBeerApp

class BeerViewModelTests: XCTestCase {
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testBeerViewModel() {
    let beer = Beer(beerId: 1,
                    name: "Beer",
                    tagline: "tagline",
                    beerDescription: "Long description",
                    imageUrl: nil, abv: 4.5,
                    foodPairing: [],
                    brewerTips: "")
    
    let beerViewModel = BeerViewModel(beer: beer)
    XCTAssertEqual(beer.name, beerViewModel.name)
    XCTAssertEqual(beer.tagline, beerViewModel.tagline)
    XCTAssertEqual(beer.beerDescription, beerViewModel.beerDescription)
    XCTAssertEqual(beer.brewerTips, beerViewModel.brewerTips)
    XCTAssertEqual(beer.abv, beerViewModel.abv)
  }
  
  func testBeerViewModelABVFormatting() {
    let beer = Beer(beerId: 1,
                    name: "Beer",
                    tagline: "tagline",
                    beerDescription: "Long description",
                    imageUrl: nil, abv: 4.5,
                    foodPairing: [],
                    brewerTips: "")
    
    let beerViewModel = BeerViewModel(beer: beer)
    XCTAssertEqual("ABV: \(beer.abv)%", beerViewModel.abvString)
  }
}
