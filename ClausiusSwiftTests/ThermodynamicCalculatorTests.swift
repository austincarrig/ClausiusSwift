//
//  ThermodynamicCalculatorTests.swift
//  ClausiusSwiftTests
//
//  Created by Austin Carrig on 5/25/22.
//

import XCTest
@testable import ClausiusSwift

class ThermodynamicCalculatorTests: XCTestCase {

    let topTBound = 700.0
    let bottomTBound = 0.0
    let maxSBound = 9.30
    let minSBounds = (3.00, 5.68)

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTSReliability() throws {

        // sets the random seed, necessary to make this test repeatable
        srand48(1)

        for _ in 0..<100 {
            // must use drand48 for repeatability purposes
            let temperature = bottomTBound + drand48() * (topTBound - bottomTBound)

            let scaling = (temperature - bottomTBound) / (topTBound - bottomTBound)

            let minSBound = minSBounds.0 + scaling * (minSBounds.1 - minSBounds.0)

            let entropy = minSBound + drand48() * (maxSBound - minSBound)

            let plotPoint = ThermodynamicCalculator.calculateProperties(
                with: entropy,
                and: temperature,
                for: .Ts
            )

            XCTAssertNotNil(plotPoint)

            if plotPoint == nil {
                print((temperature, entropy))
            }
        }

    }

}
