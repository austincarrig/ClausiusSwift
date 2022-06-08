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

    /*         ---------
     *        /        |
     *       /    3    |
     *      _5_        |
     *   4 /   \       |
     *    /  1  \   2  |
     *   /_______\______
     *
     * 1 - Saturated Region
     * 2 - Superheated Region, T < T_CRITICAL
     * 3 - Superheated Region, T > T_CRITICAL
     * 4 - Compressed Liquid Region
     * 5 - Critical Point
     *
     */

    let point1T = 200.0
    let point1S = 4.2

    let point2T = 250.0
    let point2S = 8.24

    let point3T = 523.59
    let point3S = 7.26

    let point4T = 314.34
    let point4S = 3.25

    func testPoint1() throws {

        let plotPoint = ThermodynamicCalculator.calculateProperties(
            with: point1S,
            and: point1T,
            for: .Ts
        )

        XCTAssertNotNil(plotPoint)

    }

    func testPoint2() throws {

        let plotPoint = ThermodynamicCalculator.calculateProperties(
            with: point2S,
            and: point2T,
            for: .Ts
        )

        XCTAssertNotNil(plotPoint)

    }

    func testPoint3() throws {

        let plotPoint = ThermodynamicCalculator.calculateProperties(
            with: point3S,
            and: point3T,
            for: .Ts
        )

        XCTAssertNotNil(plotPoint)

    }

    /*
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
    */

}
