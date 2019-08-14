//
//  ApiClient.swift
//  GotBeerApp
//
//  Created by Libranner Leonel Santos Espinal on 14/08/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import Alamofire
import RxSwift

class ApiClient {
  static func getBeers(food: String, completion: @escaping (_ beers: [Beer],
    _ error: Error?) -> Void) {
    
    if let urlRequest = try? ApiRouter.getBeers(food: food).asURLRequest() {
      request(urlRequest, completion: completion)
      return
    }
    completion([], nil)
  }
  
  private static func request(_ urlConvertible: URLRequestConvertible,
                              completion: @escaping (_ beers: [Beer], _ error: Error?) -> Void) {
    
    AF.request(urlConvertible).responseDecodable { (response: DataResponse<[Beer]>) in
      switch response.result {
      case .success(let value):
        completion(value, nil)
      case .failure(let error):
        completion([], error)
      }
    }
  }
}
