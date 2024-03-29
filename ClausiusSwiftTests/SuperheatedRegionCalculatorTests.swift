//
//  SuperheatedRegionCalculatorTests.swift
//  ClausiusSwiftTests
//
//  Created by Austin Carrig on 5/23/22.
//

import XCTest
@testable import Clausius

class SuperheatedRegionCalculatorTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCalculatePressure() {
        // This test unveiled a major issue in the interpolation processing within this function
        // It used to just be a rudamentary 1D interpolation, rather than 2D
        // It also revealed that the pressure calculation is somewhat meaningless,
        // as it has a negligible effect on the entropy value at high pressures...
        // i.e. when you're at 10000 kPa, what's another 25 kPa added in, ya know?

        let SUPERHEATED_POINT_1_T: Double = 843.16003 - 273.15 // C
        let SUPERHEATED_POINT_1_S: Double = 7.316159284557199 // kJ / kg . K
        let SUPERHEATED_POINT_1_P: Double = 3796.165343768067 // kPa

        do {
            let calculatedValue = try SuperheatedRegionCalculator.calculateTertiaryValue(
                with: SUPERHEATED_POINT_1_T,
                and: SUPERHEATED_POINT_1_S,
                for: .Ts
            )

            XCTAssertLessThan(fabs(calculatedValue - SUPERHEATED_POINT_1_P), 25.0)
        } catch {
            XCTFail("calculatePressure threw an error")
        }
    }

}
