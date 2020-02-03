//
//  StoreTest.swift
//  MoviesDBTests
//
//  Created by prafull kumar on 3/2/20.
//  Copyright © 2020 prafull kumar. All rights reserved.
//

import Foundation
import XCTest
import Moya
@testable import MoviesDB

class StoreTest: XCTestCase {

    
    let networking = Networking.init(provider: MoyaProvider<MoviesAPI>(stubClosure: MoyaProvider.immediatelyStub))
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetSimilarMovies() {
        let store = MoviesStore.init(networking: networking)
        let expectation = self.expectation(description: "Stub should work")
        store.getSimilarMovies(page: 1, movieId: "1") { (result) in
            switch result {
            case .success:
                XCTAssert(true)
            case .failure:
                XCTAssert(false)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 45, handler: nil)
    }
    
    func testGetTrendingMovies() {
        let store = MoviesStore.init(networking: networking)
        let expectation = self.expectation(description: "Stub should work")
        store.getTrendingMovies(page: 1) { (result) in
            switch result {
            case .success:
                XCTAssert(true)
            case .failure:
                XCTAssert(false)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 45, handler: nil)
    }


}
