//
//  ApiConstants.swift
//  GotBeerApp
//
//  Created by Libranner Leonel Santos Espinal on 14/08/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation


struct ApiConstants {
  //The api base URL
  static let baseUrl = "https://api.punkapi.com/v2/"
  static let defaultContentType = "application/json"
  
  //The header fields
  enum HttpHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
  }
  
  struct Parameters {
    static let food = "food"
  }
  
  //Endpoints
  enum Endpoint: String {
    case beer = "beers"
  }
}
