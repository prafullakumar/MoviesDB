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

    var completion: ((Bool) -> Void)?
    let networking = Networking.init(provider: MoyaProvider<MoviesAPI>(stubClosure: MoyaProvider.immediatelyStub))
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetSimilarMovies() {
        let expectation = self.expectation(description: "Stub should work")
        let viewmodel = MoviesViewModel.init(detailObject: MovieList.Result.init(popularity: 10, voteCount: 5, video: false, posterPath: "", id: 123, adult: true, backdropPath: nil, originalLanguage: nil, originalTitle: nil, genreIDS: nil, title: nil, voteAverage: nil, overview: nil, releaseDate: nil))
        viewmodel.delegate = self
        completion = { (isSucces) in
            XCTAssert(isSucces)
            expectation.fulfill()
        }
        viewmodel.fetchData()
        waitForExpectations(timeout: 45, handler: nil)
    }
    
    func testGetTrendingMovies() {
        let expectation = self.expectation(description: "Stub should work")
        let viewmodel = MoviesViewModel()
        viewmodel.delegate = self
        completion = { (isSucces) in
            XCTAssert(isSucces)
            expectation.fulfill()
        }
        viewmodel.fetchData()
        waitForExpectations(timeout: 45, handler: nil)
    }


}

extension ViewModelTest: MovieViewControllerUpdateDelegate {
    func viewModel(didUpdateState state: ViewModelState) {
        switch state {
        case .loading:
            break
        case .loadSuccess:
            completion?(true)
        case .loadFail:
            completion?(false)
        case .unknown:
            completion?(false)
        }
    }
    
}
