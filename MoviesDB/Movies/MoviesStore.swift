//
//  MoviesStore.swift
//  MoviesDB
//
//  Created by prafull kumar on 3/2/20.
//  Copyright © 2020 prafull kumar. All rights reserved.
//

import Foundation
import Moya


// can use for data caching etc --> not adding as not in requirment
final class MoviesStore {

    let networking: Networking
    

    init(networking: Networking) {
        self.networking = networking
    }
    
    func getTrendingMovies(page: Int, completion : @escaping MoviesResultCompletion) {
        self.networking.getMovies(page: page, completion: completion)
    }

    func getSimilarMovies(page: Int, movieId: String, completion : @escaping MoviesResultCompletion) {
        self.networking.getSimilerMovies(page: page, movieId: movieId, completion: completion)
    }
}
