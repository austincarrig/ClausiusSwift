//
//  SaturatedRegionLineTests.swift
//  ClausiusSwiftTests
//
//  Created by Austin Carrig on 5/23/22.
//

import XCTest
@testable import ClausiusSwift

class SaturatedRegionLineTests: XCTestCase {

    let TEMPERATURE: Double = 200.5; // C
    let PRESSURE: Double = 1571.0645; // kPa
    let PRESSURE_SIG_DIG: Double = 0.001; // kPA
    let SPEC_VOL_FLUID: Double = 0.0011573; // m3/kg
    let SPEC_VOL_FLUID_SIG_DIG: Double = 0.00001; // m3/kg
    let SPEC_VOL_GAS: Double = 0.125943; // m3/kg
    let SPEC_VOL_GAS_SIG_DIG: Double = 0.0001; // m3/kg
    let INT_ENERGY_FLUID: Double = 852.82913712805; // kJ/kg
    let INT_ENERGY_FLUID_SIG_DIG: Double = 0.1; // kJ/kg
    let INT_ENERGY_GAS: Double = 2594.5058609568; // kJ/kg
    let INT_ENERGY_GAS_SIG_DIG: Double = 0.1; // kJ/kg
    let ENTHALPY_FLUID: Double = 854.647; // kJ/kg
    let ENTHALPY_FLUID_SIG_DIG: Double = 0.01; // kJ/kg
    let ENTHALPY_GAS: Double = 2792.36; // kJ/kg
    let ENTHALPY_GAS_SIG_DIG: Double = 0.01; // kJ/kg
    let ENTROPY_FLUID: Double = 2.3355224868653; // kJ/kg.K
    let ENTROPY_FLUID_SIG_DIG: Double = 0.0001; // kJ/kg.K
    let ENTROPY_GAS: Double = 6.4265656433297; // kJ/kg.K
    let ENTROPY_GAS_SIG_DIG: Double = 0.0001; // kJ/kg.K

    var sat_line: SaturatedRegionLine?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sat_line = SaturatedRegionLine(with: TEMPERATURE)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPressure() throws {
        XCTAssertLessThan(fabs(PRESSURE - sat_line!.p), PRESSURE_SIG_DIG)
    }

    func testSpecificVolumeFluid() throws {
        XCTAssertLessThan(fabs(SPEC_VOL_FLUID - sat_line!.v_f), SPEC_VOL_FLUID_SIG_DIG)
    }

    func testSpecificVolumeGas() throws {
        XCTAssertLessThan(fabs(SPEC_VOL_GAS - sat_line!.v_g), SPEC_VOL_GAS_SIG_DIG)
    }

    func testInternalEnergyFluid() throws {
        XCTAssertLessThan(fabs(INT_ENERGY_FLUID - sat_line!.u_f), INT_ENERGY_FLUID_SIG_DIG)
    }

    func testInternalEnergyGas() throws {
        XCTAssertLessThan(fabs(INT_ENERGY_GAS - sat_line!.u_g), INT_ENERGY_GAS_SIG_DIG)
    }

    func testEnthalpyFluid() throws {
        XCTAssertLessThan(fabs(ENTHALPY_FLUID - sat_line!.h_f), ENTHALPY_FLUID_SIG_DIG)
    }

    func testEnthalpyGas() throws {
        XCTAssertLessThan(fabs(ENTHALPY_GAS - sat_line!.h_g), ENTHALPY_GAS_SIG_DIG)
    }

    func testEntropyFluid() throws {
        XCTAssertLessThan(fabs(ENTROPY_FLUID - sat_line!.s_f), ENTROPY_FLUID_SIG_DIG)
    }

    func testEntropyGas() throws {
        XCTAssertLessThan(fabs(ENTROPY_GAS - sat_line!.s_g), ENTROPY_GAS_SIG_DIG)
    }

}
