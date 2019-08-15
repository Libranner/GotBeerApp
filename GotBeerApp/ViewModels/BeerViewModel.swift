//
//  BeerViewModel.swift
//  GotBeerApp
//
//  Created by Libranner Leonel Santos Espinal on 14/08/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation

struct BeerViewModel {
  let name: String
  let tagline: String
  let beerDescription: String
  let abv: Float
  let brewerTips: String?
  let imageUrl: URL?
  
  init(beer: Beer){
    name = beer.name
    tagline = beer.tagline
    abv = beer.abv
    beerDescription = beer.beerDescription
    imageUrl = beer.imageUrl
    brewerTips = beer.brewerTips
  }
  
  var abvString: String {
    return "ABV: \(abv)%"
  }
}
