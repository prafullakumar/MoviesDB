//
//  MoviesDataModel.swift
//  MoviesDB
//
//  Created by prafull kumar on 3/2/20.
//  Copyright © 2020 prafull kumar. All rights reserved.
//

import Foundation

// MARK: - MovieList
struct MovieList: Codable {
    let results: [Result]
    let page, totalResults: Int?
    let dates: Dates?
    let totalPages: Int?

    enum CodingKeys: String, CodingKey {
        case results, page
        case totalResults = "total_results"
        case dates
        case totalPages = "total_pages"
    }
    
    // MARK: - Result
    struct Result: Codable {
        let popularity: Double?
        let voteCount: Int?
        let video: Bool?
        let posterPath: String?
        let id: Int?
        let adult: Bool?
        let backdropPath: String?
        let originalLanguage: String?
        let originalTitle: String?
        let genreIDS: [Int]?
        let title: String?
        let voteAverage: Double?
        let overview, releaseDate: String?

        enum CodingKeys: String, CodingKey {
            case popularity
            case voteCount = "vote_count"
            case video
            case posterPath = "poster_path"
            case id, adult
            case backdropPath = "backdrop_path"
            case originalLanguage = "original_language"
            case originalTitle = "original_title"
            case genreIDS = "genre_ids"
            case title
            case voteAverage = "vote_average"
            case overview
            case releaseDate = "release_date"
        }
    }
    
    // MARK: - Dates
    struct Dates: Codable {
        let maximum, minimum: String
    }

}




struct ErrorModel: Codable {
    let statusMessage: String
    let statusCode: Int

    enum CodingKeys: String, CodingKey {
        case statusMessage = "status_message"
        case statusCode = "status_code"
    }
}
