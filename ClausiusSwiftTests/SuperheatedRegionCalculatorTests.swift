//
//  SuperheatedRegionCalculatorTests.swift
//  ClausiusSwiftTests
//
//  Created by Austin Carrig on 5/23/22.
//

import XCTest
@testable import ClausiusSwift

class SuperheatedRegionCalculatorTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testClampHigh() {
        let maxValue = SuperheatedRegionCalculatorConstants.TEMPERATURE_T_S.last!
        let clampedValue = SuperheatedRegionCalculator.clamp(temperature: maxValue + 1.0)
        XCTAssertEqual(clampedValue, maxValue)
    }

    func testClampLow() {
        let minValue = SuperheatedRegionCalculatorConstants.TEMPERATURE_T_S.first!
        let clampedValue = SuperheatedRegionCalculator.clamp(temperature: minValue - 1.0)
        XCTAssertEqual(clampedValue, minValue)
    }

    func testClampMiddle() {
        let midValue = SuperheatedRegionCalculatorConstants.TEMPERATURE_T_S[SuperheatedRegionCalculatorConstants.TEMPERATURE_T_S.count / 2]
        let clampedValue = SuperheatedRegionCalculator.clamp(temperature: midValue)
        XCTAssertEqual(clampedValue, midValue)
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

        let calculatedValue = SuperheatedRegionCalculator.calculatePressure(
            with: SUPERHEATED_POINT_1_T,
            and: SUPERHEATED_POINT_1_S
        )
        XCTAssertLessThan(fabs(calculatedValue - SUPERHEATED_POINT_1_P), 25.0)
    }

}
