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

//TODO: Clean this up

/*enum Result<T, U: Error> {
  case success(payload: T)
  case failure(U?)
}

enum EmptyResult<U: Error> {
  case success
  case failure(U?)
}

class AppServerClient {
  private let baseUrl = "https://api.punkapi.com/v2/beers?"
  
  enum FailureReason: Int, Error {
    case unAuthorized = 401
    case notFound = 404
  }

  typealias GetBeersResult = Result<[Beer], FailureReason>
  typealias GetBeersCompletion = (_ result: GetBeersResult) -> Void
  
  func getBeers(completion: @escaping GetBeersCompletion) {
    AF.request("https://api.punkapi.com/v2/beers?brewed_before=11-2012&abv_gt=6")
      .validate()
      .responseJSON { response in
        switch response.result {
        case .success:
          do {
            guard let data = response.data else {
              completion(.failure(nil))
              return
            }
            
            let beers = try JSONDecoder().decode([Beer].self, from: data)
            completion(.success(payload: beers))
          } catch {
            completion(.failure(nil))
          }
        case .failure(_):
          if let statusCode = response.response?.statusCode,
            let reason = FailureReason(rawValue: statusCode) {
            completion(.failure(reason))
          }
          completion(.failure(nil))
        }
    }
  }
}

//TODO: Use localization
extension AppServerClient.FailureReason {
  func getErrorMessage() -> String? {
    switch self {
    case .unAuthorized:
      return "Request not authorized"
    case .notFound:
      return "Not found."
    }
  }
}*/
