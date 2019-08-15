//
//  ApiServiceClient.swift
//  GotBeerApp
//
//  Created by Libranner Leonel Santos Espinal on 12/08/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire


import Foundation
import Alamofire

enum ApiRouter: URLRequestConvertible {
  
  //Endpoints
  case getBeers(food: String)
  
  //MARK: - URLRequestConvertible
  func asURLRequest() throws -> URLRequest {
    let url = try ApiConstants.baseUrl.asURL()
    
    var urlRequest = URLRequest(url: url.appendingPathComponent(path))
    
    //Http method
    urlRequest.httpMethod = method.rawValue
    
    // Common Headers
    urlRequest.setValue(ApiConstants.defaultContentType,
                        forHTTPHeaderField: ApiConstants.HttpHeaderField.acceptType.rawValue)
    urlRequest.setValue(ApiConstants.defaultContentType,
                        forHTTPHeaderField: ApiConstants.HttpHeaderField.contentType.rawValue)
    
    //Encoding
    let encoding: ParameterEncoding = {
      switch method {
      case .get:
        return URLEncoding.default
      default:
        return JSONEncoding.default
      }
    }()
    
    return try encoding.encode(urlRequest, with: parameters)
  }
  
  //MARK: - HttpMethod
  //This returns the HttpMethod type. It's used to determine the type if several endpoints are peresent
  private var method: HTTPMethod {
    switch self {
    case .getBeers:
      return .get
    }
  }
  
  //MARK: - Path
  //The path is the part following the base url
  private var path: String {
    switch self {
    case .getBeers:
      return ApiConstants.Endpoint.beer.rawValue
    }
  }
  
  //MARK: - Parameters
  private var parameters: Parameters? {
    switch self {
    case .getBeers(let food):
      let sanitazedString = food.replacingOccurrences(of: " ", with: "_")
      return [ApiConstants.Parameters.food : sanitazedString]
    }
  }
}
