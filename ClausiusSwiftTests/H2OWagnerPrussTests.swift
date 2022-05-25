//
//  H2OWagnerPrussTests.swift
//  ClausiusSwiftTests
//
//  Created by Austin Carrig on 5/25/22.
//

import XCTest
@testable import ClausiusSwift

// The compared epsilon in many of these test cases is Float.ulpOfOne, rather than Double.ulpOfOne
// The reason for this is that these tests were originally written with 32-bit floating point
// values in Rust, and there's little utility to changed the calculated values to have higher precision.

class H2OWagnerPrussTests: XCTestCase {

    let SUPERHEATED_POINT_1_T: Double = 570.01 + ClausiusConstants.C_TO_K
    let SUPERHEATED_POINT_1_D: Double = 9.96015936255

    let SUPERHEATED_POINT_2_T: Double = 420.38 + ClausiusConstants.C_TO_K
    let SUPERHEATED_POINT_2_D: Double = 270.27027027

    let SUPERHEATED_POINT_3_T: Double = 393.16 + ClausiusConstants.C_TO_K
    let SUPERHEATED_POINT_3_D: Double = 0.82155767334

    let SUPERHEATED_POINT_4_T: Double = 334.99 + ClausiusConstants.C_TO_K
    let SUPERHEATED_POINT_4_D: Double = 27.7777777778

    let SUPERHEATED_POINT_5_T: Double = 245.84 + ClausiusConstants.C_TO_K
    let SUPERHEATED_POINT_5_D: Double = 0.07614812332

    let SUPERHEATED_POINT_6_T: Double = 160.46 + ClausiusConstants.C_TO_K
    let SUPERHEATED_POINT_6_D: Double = 2.75406224181

    let SUPERHEATED_POINT_7_T: Double = 260.68 + ClausiusConstants.C_TO_K
    let SUPERHEATED_POINT_7_D: Double = 19.9600798403

    // Above Critical Point
    let SUPERHEATED_POINT_8_T: Double = 389.41 + ClausiusConstants.C_TO_K
    let SUPERHEATED_POINT_8_D: Double = 625.0

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDelta() {
        let SUPERHEATED_POINT_1_DELTA: Double = 0.030932170807453
        let calc = H2OWagnerPruss.calculate_delta(density: SUPERHEATED_POINT_1_D)
        XCTAssertLessThan(fabs(calc - SUPERHEATED_POINT_1_DELTA), Double(Float.ulpOfOne))
    }

    func testDensity() {
        let SUPERHEATED_POINT_1_PRESSURE: Double = 3.796165343768067
        let calc = H2OWagnerPruss.calculate_density(
            temperature: SUPERHEATED_POINT_1_T,
            pressure: SUPERHEATED_POINT_1_PRESSURE
        )
        XCTAssertLessThan(fabs(calc - SUPERHEATED_POINT_1_D), Double(Float.ulpOfOne))
    }

    func testInternalEnergy() {
        let SUPERHEATED_POINT_1_INT_ENERGY: Double = 3226.7724234968214
        let calc = H2OWagnerPruss.calculate_internal_energy(
            temperature: SUPERHEATED_POINT_1_T,
            density: SUPERHEATED_POINT_1_D
        )
        XCTAssertLessThan(fabs(calc - SUPERHEATED_POINT_1_INT_ENERGY), 0.0001)
    }

    func testEnthalpy() {
        let SUPERHEATED_POINT_1_ENTHALPY: Double = 3607.9074378844493
        let calc = H2OWagnerPruss.calculate_enthalpy(
            temperature: SUPERHEATED_POINT_1_T,
            density: SUPERHEATED_POINT_1_D
        )
        XCTAssertLessThan(fabs(calc - SUPERHEATED_POINT_1_ENTHALPY), 0.0001)
    }

    func testEnthalpyWithInternalEnergy() {
        let SUPERHEATED_POINT_1_ENTHALPY: Double = 3607.9074378844493
        let u = H2OWagnerPruss.calculate_internal_energy(
            temperature: SUPERHEATED_POINT_1_T,
            density: SUPERHEATED_POINT_1_D
        )
        let calc = H2OWagnerPruss.calculate_enthalpy_with_u(
            temperature: SUPERHEATED_POINT_1_T,
            density: SUPERHEATED_POINT_1_D,
            internal_energy: u
        )
        XCTAssertLessThan(fabs(calc - SUPERHEATED_POINT_1_ENTHALPY), 0.0001)
    }

    func testPhi0Tau() {
        let SUPERHEATED_POINT_1_PHI_0_TAU: Double = 10.887587170062671
        let calc = H2OWagnerPruss.calculate_phi_0_tau(
            temperature: SUPERHEATED_POINT_1_T,
            density: SUPERHEATED_POINT_1_D
        )
        XCTAssertLessThan(fabs(calc - SUPERHEATED_POINT_1_PHI_0_TAU), Double(Float.ulpOfOne))
    }

    func testPhiRDelta() {
        let SUPERHEATED_POINT_1_PHI_R_DELTA: Double = -0.664511760770514
        let calc = H2OWagnerPruss.calculate_phi_r_delta(
            temperature: SUPERHEATED_POINT_1_T,
            density: SUPERHEATED_POINT_1_D
        )
        XCTAssertLessThan(fabs(calc - SUPERHEATED_POINT_1_PHI_R_DELTA), Double(Float.ulpOfOne))
    }

    func testPhiRDeltaDelta() {
        let SUPERHEATED_POINT_1_PHI_R_DELTA_DELTA: Double = 0.127586340316874
        let calc = H2OWagnerPruss.calculate_phi_r_delta_delta(
            temperature: SUPERHEATED_POINT_1_T,
            density: SUPERHEATED_POINT_1_D
        )
        XCTAssertLessThan(fabs(calc - SUPERHEATED_POINT_1_PHI_R_DELTA_DELTA), Double(Float.ulpOfOne))
    }

    func testPhiRTau() {
        let SUPERHEATED_POINT_1_PHI_R_TAU: Double = -0.082931693508678
        let calc = H2OWagnerPruss.calculate_phi_r_tau(
            temperature: SUPERHEATED_POINT_1_T,
            density: SUPERHEATED_POINT_1_D
        )
        XCTAssertLessThan(fabs(calc - SUPERHEATED_POINT_1_PHI_R_TAU), Double(Float.ulpOfOne))
    }

    func testTau() {
        let SUPERHEATED_POINT_1_TAU: Double = 0.76746522246791
        let calc = H2OWagnerPruss.calculate_tau(
            temperature: SUPERHEATED_POINT_1_T
        )
        XCTAssertLessThan(fabs(calc - SUPERHEATED_POINT_1_TAU), Double(Float.ulpOfOne))
    }

}
