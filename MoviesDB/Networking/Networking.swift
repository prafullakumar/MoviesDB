//
//  Networking.swift
//  MoviesDB
//
//  Created by prafull kumar on 2/2/20.
//  Copyright © 2020 prafull kumar. All rights reserved.
//

import UIKit
import Moya
protocol NetworkProtocol {
    func getMovies(page: Int, completion: @escaping MoviesResultCompletion)
    func getSimilerMovies(page: Int, movieId: String, completion: @escaping MoviesResultCompletion)
}

class Networking: NetworkProtocol {
    let provider: MoyaProvider<MoviesAPI>
    
    
    
    init(provider: MoyaProvider<MoviesAPI>) {
        self.provider = provider
    }
    
    func getMovies(page: Int, completion: @escaping MoviesResultCompletion) {
        provider.request(MoviesAPI.latest(page: page)) { (result) in
           switch result {
            case .success(let response):
                if 200..<300 ~= response.statusCode {
                    if let baseModel = try? JSONDecoder().decode(MovieList.self, from: response.data)  {
                       completion(.success(baseModel))
                    } else {
                        completion(.failure(Constants.parsingErrorMessage))
                    }
                } else {
                     let baseModel = try? JSONDecoder().decode(ErrorModel.self, from: response.data)
                    completion(.failure(baseModel?.statusMessage ?? Constants.parsingErrorMessage))
                    
                }
            case .failure(let error):
                 completion(.failure(error.localizedDescription))
          }
        }
    }
    
    func getSimilerMovies(page: Int, movieId: String, completion: @escaping MoviesResultCompletion) {
        provider.request(MoviesAPI.recommended(movieId: movieId, page: page)) { (result) in
            switch result {
                      case .success(let response):
                          if 200..<300 ~= response.statusCode {
                              if let baseModel = try? JSONDecoder().decode(MovieList.self, from: response.data)  {
                                 completion(.success(baseModel))
                              } else {
                                  completion(.failure(Constants.parsingErrorMessage))
                              }
                          } else {
                               let baseModel = try? JSONDecoder().decode(ErrorModel.self, from: response.data)
                              completion(.failure(baseModel?.statusMessage ?? Constants.parsingErrorMessage))
                              
                          }
                      case .failure(let error):
                           completion(.failure(error.localizedDescription))
                    }
       }
    }

}


extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}
