//
//  ViewModelTest.swift
//  MoviesDBTests
//
//  Created by prafull kumar on 3/2/20.
//  Copyright © 2020 prafull kumar. All rights reserved.
//

import Foundation
import XCTest
import Moya
@testable import MoviesDB


class ViewModelTest: XCTestCase {

    
    let networking = Networking.init(provider: MoyaProvider<MoviesAPI>(stubClosure: MoyaProvider.immediatelyStub))
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetSimilarMovies() {
        let viewmodel = MoviesViewModel.init(detailObject: MovieList.Result.init(popularity: 10, voteCount: 5, video: false, posterPath: "", id: 123, adult: true, backdropPath: nil, originalLanguage: nil, originalTitle: nil, genreIDS: nil, title: nil, voteAverage: nil, overview: nil, releaseDate: nil))
        viewmodel.delegate = self
        viewmodel.fetchData()
    }
    
    func testGetTrendingMovies() {
        let viewmodel = MoviesViewModel()
        viewmodel.delegate = self
        viewmodel.fetchData()
    }


}

extension ViewModelTest: MovieViewControllerUpdateDelegate {
    func viewModel(didUpdateState state: ViewModelState) {
        switch state {
        case .loading:
            break
        case .loadSuccess:
            XCTAssert(true)
        case .loadFail:
            XCTAssert(false)
        case .unknown:
            XCTAssert(true)
        }
    }
    
}
