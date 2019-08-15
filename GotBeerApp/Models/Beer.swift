//
//  Beer.swift
//  GotBeerApp
//
//  Created by Libranner Leonel Santos Espinal on 12/08/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation

struct Beer: Codable {
  var beerId: Int64
  var name: String
  var tagline: String
  var beerDescription: String
  var imageUrl: URL?
  var abv: Float
  var foodPairing: [String]
  var brewerTips: String?
  
  enum CodingKeys: String, CodingKey {
    case beerId = "id"
    case name
    case tagline
    case beerDescription = "description"
    case imageUrl = "image_url"
    case abv
    case foodPairing = "food_pairing"
    case brewerTips = "brewers_tips"
  }
}
