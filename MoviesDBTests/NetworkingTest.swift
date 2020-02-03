//
//  NetworkingTest.swift
//  MoviesDBTests
//
//  Created by prafull kumar on 3/2/20.
//  Copyright © 2020 prafull kumar. All rights reserved.
//

import Foundation
import XCTest
import Moya
@testable import MoviesDB

class NetworkingTest: XCTestCase {

    
    let networking = Networking.init(provider: MoyaProvider<MoviesAPI>())
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAPIFail() {
        let expectation = self.expectation(description: "Api should fail")
        networking.getMovies(page: 9999999) { (result) in
            switch result {
            case .success:
                XCTAssert(false)
            case .failure:
                XCTAssert(true)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 45, handler: nil)
    }

    func testAPISuccess() {
        let expectation = self.expectation(description: "Api should pass")
        networking.getMovies(page: 1) { (result) in
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
