//
//  API.swift
//  MoviesDB
//
//  Created by prafull kumar on 2/2/20.
//  Copyright © 2020 prafull kumar. All rights reserved.
//

import Foundation
import Moya

enum Result<A> {
    case success(A)
    case failure(String)
}

typealias MoviesResult = Result<MovieList>
typealias MoviesResultCompletion = (MoviesResult) -> Void


enum MoviesAPI {
    case recommended(movieId: String, page: Int)
    case latest(page: Int)
    
    private var apiKey: String {
        return "81ade256a9dee0269f5f707bd7861af8"
    }
}

extension MoviesAPI: TargetType {
    var baseURL: URL {
        guard let baseURL = URL.init(string: "https://api.themoviedb.org/3/movie") else {
            fatalError("Base URL Configuration Error")
        }
        return baseURL
    }
    
    var path: String {
        switch self {
        case .recommended(let movieId, _):
            return "/\(movieId)/similar"
        case .latest:
            return "/now_playing"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .recommended:
            return .get
        case .latest:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .recommended, .latest:
            if let filepath = Bundle.main.path(forResource: "stub", ofType: "json") {
                return try! Data(contentsOf: URL(fileURLWithPath: filepath)) // stub shold crash on exection for better debugability
            } else {
                return Data()
            }
        }
    }
    
    var task: Task {
        var requestParm: [String: Any] = ["api_key": apiKey]
        switch self {
        case .recommended(_, let page):
            requestParm["page"] = page
            return .requestParameters(parameters: requestParm, encoding: URLEncoding.default)
        case .latest(let page):
            requestParm["page"] = page
            return .requestParameters(parameters: requestParm, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}

