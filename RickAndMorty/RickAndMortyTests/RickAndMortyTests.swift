//
//  RickAndMortyTests.swift
//  RickAndMortyTests
//
//  Created by Matthew Tyler on 9/8/20.
//  Copyright © 2020 Matt Tyler. All rights reserved.
//

import XCTest
@testable import RickAndMorty

class RickAndMortyTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testJSONDecodingError() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let url = try XCTUnwrap (Bundle.main.url(forResource: "ErrorJSONResponse", withExtension:"json"))
        let json = try Data(contentsOf: url)
        
        let apiResponse = try JSONDecoder().decode(ApiResponse.self, from: json)
        
        XCTAssertEqual(apiResponse.error ,"There is nothing here")
        XCTAssertNil(apiResponse.info )
        XCTAssertNil(apiResponse.results )

    }
    
    func testJSONDecodingAll() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let url = try XCTUnwrap (Bundle.main.url(forResource: "AllJSONResponse", withExtension: "json"))
        let json = try Data(contentsOf: url)
        
        let apiResponse = try JSONDecoder().decode(ApiResponse.self, from: json)
        
        let results = try XCTUnwrap(apiResponse.results)
        let info = try XCTUnwrap(apiResponse.info)
        XCTAssertEqual(results.count, 20 )
        XCTAssertEqual(info.count, 41 )


    }


}
