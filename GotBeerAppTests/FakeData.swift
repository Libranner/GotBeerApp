//
//  FakeData.swift
//  GotBeerAppTests
//
//  Created by Libranner Leonel Santos Espinal on 15/08/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation
@testable import GotBeerApp

struct  FakeData {
  static let beers: [Beer] = [
    Beer(beerId: 1, name: "Beer 1", tagline: "This is a tagline",
         beerDescription: "This is a really great description",
         imageUrl: URL(string: "https://images.punkapi.com/v2/46.png")!,
         abv: 4.5, foodPairing: ["beans"], brewerTips: "This is a tip"),
    Beer(beerId: 2, name: "Beer 2", tagline: "This is a tagline 2",
         beerDescription: "This is a really great description 2",
         imageUrl: URL(string: "https://images.punkapi.com/v2/156.png")!,
         abv: 14.5, foodPairing: ["beans", "rice"], brewerTips: "This is a tip 2"),
    Beer(beerId: 3, name: "Beer 3", tagline: "This is a tagline 3",
         beerDescription: "This is a really great description 3",
         imageUrl: URL(string: "https://images.punkapi.com/v2/71.png")!,
         abv: 14.5, foodPairing: ["meat"], brewerTips: "This is a tip 3")
  ]
  
  static let beersRemote: [Beer] = [
    Beer(beerId: 1, name: "Beer 1", tagline: "This is a tagline",
         beerDescription: "This is a really great description",
         imageUrl: URL(string: "https://images.punkapi.com/v2/46.png")!,
         abv: 4.5, foodPairing: ["pizza"], brewerTips: "This is a tip")
  ]
}
