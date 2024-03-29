//
//  ThermodynamicCalculatorTests.swift
//  ClausiusSwiftTests
//
//  Created by Austin Carrig on 5/25/22.
//

import XCTest
@testable import Clausius

class ThermodynamicCalculatorTests: XCTestCase {

    let topTBound = 700.0
    let bottomTBound = 0.0
    let maxSBound = 9.30
    let minSBounds = (3.00, 5.68)

    let topPBound_PH = 1000000.0
    let bottomPBound = 10.0
    let maxHBound = 4400.0
    let minHBound = 0.0

    let topPBound_PV = 50000.0
    let minVBound = 0.001
    let maxVBound = 35.6

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
    let point1P = 1554.672
    let point1V = 0.058516
    let point1H = 1736.7981385534822
    let point1S = 4.2

    let point2T = 250.0
    let point2P = 64.50704225395404
    let point2V = 3.7346344
    let point2H = 2975.6753384544436
    let point2S = 8.24

    let point3T = 523.59
    let point3P = 3290.5672268868357
    let point3V = 0.10923792
    let point3H = 3507.264790490782
    let point3S = 7.26

    let point4T = 348.97
    let point4P = 16322.23
    let point4V = 0.0017278
    let point4H = 1662.5
    let point4S = 3.7654

    let point5T = 373.9
    let point5P = 21366.04797723749
    let point5V = 0.005736274
    let point5H = 2439.993624552725
    let point5S = 4.532841

    func testPointTs1() throws {

        let plotPoint = ThermodynamicCalculator.calculateProperties(
            with: point1S,
            and: point1T,
            for: .Ts
        )

        XCTAssertNotNil(plotPoint)

        if plotPoint != nil {
            XCTAssertGreaterThan(plotPoint!.p, 0.0)
            XCTAssertGreaterThan(plotPoint!.v, 0.0)
            XCTAssertGreaterThan(plotPoint!.u, 0.0)
            XCTAssertGreaterThan(plotPoint!.h, 0.0)
        }

    }

    func testPointTs2() throws {

        let plotPoint = ThermodynamicCalculator.calculateProperties(
            with: point2S,
            and: point2T,
            for: .Ts
        )

        XCTAssertNotNil(plotPoint)

        if plotPoint != nil {
            XCTAssertGreaterThan(plotPoint!.p, 0.0)
            XCTAssertGreaterThan(plotPoint!.v, 0.0)
            XCTAssertGreaterThan(plotPoint!.u, 0.0)
            XCTAssertGreaterThan(plotPoint!.h, 0.0)
        }

    }

    func testPointTs3() throws {

        let plotPoint = ThermodynamicCalculator.calculateProperties(
            with: point3S,
            and: point3T,
            for: .Ts
        )

        XCTAssertNotNil(plotPoint)

        if plotPoint != nil {
            XCTAssertGreaterThan(plotPoint!.p, 0.0)
            XCTAssertGreaterThan(plotPoint!.v, 0.0)
            XCTAssertGreaterThan(plotPoint!.u, 0.0)
            XCTAssertGreaterThan(plotPoint!.h, 0.0)
        }

    }

    func testPointTs4() throws {

        let plotPoint = ThermodynamicCalculator.calculateProperties(
            with: point4S,
            and: point4T,
            for: .Ts
        )

        XCTAssertNotNil(plotPoint)

        if plotPoint != nil {
            XCTAssertGreaterThan(plotPoint!.p, 0.0)
            XCTAssertGreaterThan(plotPoint!.v, 0.0)
            XCTAssertGreaterThan(plotPoint!.u, 0.0)
            XCTAssertGreaterThan(plotPoint!.h, 0.0)
        }

    }

    func testPointTs5() throws {

        let plotPoint = ThermodynamicCalculator.calculateProperties(
            with: point5S,
            and: point5T,
            for: .Ts
        )

        XCTAssertNotNil(plotPoint)

        if plotPoint != nil {
            XCTAssertGreaterThan(plotPoint!.p, 0.0)
            XCTAssertGreaterThan(plotPoint!.v, 0.0)
            XCTAssertGreaterThan(plotPoint!.u, 0.0)
            XCTAssertGreaterThan(plotPoint!.h, 0.0)
        }

    }

    func testTsTopLeft() throws {

        let plotPoint = ThermodynamicCalculator.calculateProperties(
            with: 5.66,
            and: 700.0,
            for: .Ts
        )

        XCTAssertNotNil(plotPoint)

        if plotPoint != nil {
            XCTAssertGreaterThan(plotPoint!.p, 0.0)
            XCTAssertGreaterThan(plotPoint!.v, 0.0)
            XCTAssertGreaterThan(plotPoint!.u, 0.0)
            XCTAssertGreaterThan(plotPoint!.h, 0.0)
        }

    }

    func testPointPh1() throws {

        let plotPoint = ThermodynamicCalculator.calculateProperties(
            with: point1H,
            and: point1P,
            for: .Ph
        )

        XCTAssertNotNil(plotPoint)

        if plotPoint != nil {
            XCTAssertGreaterThan(plotPoint!.t, 0.0)
            XCTAssertGreaterThan(plotPoint!.v, 0.0)
            XCTAssertGreaterThan(plotPoint!.u, 0.0)
            XCTAssertGreaterThan(plotPoint!.s, 0.0)
        }

    }

    func testPointPh2() throws {

        let plotPoint = ThermodynamicCalculator.calculateProperties(
            with: point2H,
            and: point2P,
            for: .Ph
        )

        XCTAssertNotNil(plotPoint)

        if plotPoint != nil {
            XCTAssertGreaterThan(plotPoint!.t, 0.0)
            XCTAssertGreaterThan(plotPoint!.v, 0.0)
            XCTAssertGreaterThan(plotPoint!.u, 0.0)
            XCTAssertGreaterThan(plotPoint!.s, 0.0)
        }

    }

    func testPointPh3() throws {

        let plotPoint = ThermodynamicCalculator.calculateProperties(
            with: point3H,
            and: point3P,
            for: .Ph
        )

        XCTAssertNotNil(plotPoint)

        if plotPoint != nil {
            XCTAssertGreaterThan(plotPoint!.t, 0.0)
            XCTAssertGreaterThan(plotPoint!.v, 0.0)
            XCTAssertGreaterThan(plotPoint!.u, 0.0)
            XCTAssertGreaterThan(plotPoint!.s, 0.0)
        }

    }

    func testPointPh4() throws {

        let plotPoint = ThermodynamicCalculator.calculateProperties(
            with: point4H,
            and: point4P,
            for: .Ph
        )

        XCTAssertNotNil(plotPoint)

        if plotPoint != nil {
            XCTAssertGreaterThan(plotPoint!.t, 0.0)
            XCTAssertGreaterThan(plotPoint!.v, 0.0)
            XCTAssertGreaterThan(plotPoint!.u, 0.0)
            XCTAssertGreaterThan(plotPoint!.s, 0.0)
        }

    }

    func testPointPh5() throws {

        let plotPoint = ThermodynamicCalculator.calculateProperties(
            with: point5H,
            and: point5P,
            for: .Ph
        )

        XCTAssertNotNil(plotPoint)

        if plotPoint != nil {
            XCTAssertGreaterThan(plotPoint!.t, 0.0)
            XCTAssertGreaterThan(plotPoint!.v, 0.0)
            XCTAssertGreaterThan(plotPoint!.u, 0.0)
            XCTAssertGreaterThan(plotPoint!.s, 0.0)
        }

    }

    func testPhTopRight() throws {

        let plotPoint = ThermodynamicCalculator.calculateProperties(
            with: maxHBound - 10.0,
            and: bottomPBound + 1.0,
            for: .Ph
        )

        XCTAssertNotNil(plotPoint)

        if plotPoint != nil {
            XCTAssertGreaterThan(plotPoint!.t, 0.0)
            XCTAssertGreaterThan(plotPoint!.v, 0.0)
            XCTAssertGreaterThan(plotPoint!.u, 0.0)
            XCTAssertGreaterThan(plotPoint!.s, 0.0)
        }

    }

    func testPhBottomRight() throws {

        let plotPoint = ThermodynamicCalculator.calculateProperties(
            with: maxHBound - 10.0,
            and: topPBound_PH - 1000.0,
            for: .Ph
        )

        XCTAssertNotNil(plotPoint)

        if plotPoint != nil {
            XCTAssertGreaterThan(plotPoint!.t, 0.0)
            XCTAssertGreaterThan(plotPoint!.v, 0.0)
            XCTAssertGreaterThan(plotPoint!.u, 0.0)
            XCTAssertGreaterThan(plotPoint!.s, 0.0)
        }

    }

    func testPhSuperheated() throws {

        let plotPoint = ThermodynamicCalculator.calculateProperties(
            with: 1346.4,
            and: 34200.0,
            for: .Ph
        )

        XCTAssertNotNil(plotPoint)

        if plotPoint != nil {
            XCTAssertGreaterThan(plotPoint!.t, 0.0)
            XCTAssertGreaterThan(plotPoint!.v, 0.0)
            XCTAssertGreaterThan(plotPoint!.u, 0.0)
            XCTAssertGreaterThan(plotPoint!.s, 0.0)
        }

    }

    func testPointPv1() throws {

        let plotPoint = ThermodynamicCalculator.calculateProperties(
            with: point1V,
            and: point1P,
            for: .Pv
        )

        XCTAssertNotNil(plotPoint)

        if plotPoint != nil {
            XCTAssertGreaterThan(plotPoint!.t, 0.0)
            XCTAssertGreaterThan(plotPoint!.h, 0.0)
            XCTAssertGreaterThan(plotPoint!.u, 0.0)
            XCTAssertGreaterThan(plotPoint!.s, 0.0)
        }

    }

    func testPointPv2() throws {

        let plotPoint = ThermodynamicCalculator.calculateProperties(
            with: point2V,
            and: point2P,
            for: .Pv
        )

        XCTAssertNotNil(plotPoint)

        if plotPoint != nil {
            XCTAssertGreaterThan(plotPoint!.t, 0.0)
            XCTAssertGreaterThan(plotPoint!.h, 0.0)
            XCTAssertGreaterThan(plotPoint!.u, 0.0)
            XCTAssertGreaterThan(plotPoint!.s, 0.0)
        }

    }

    func testPointPv3() throws {

        let plotPoint = ThermodynamicCalculator.calculateProperties(
            with: point3V,
            and: point3P,
            for: .Pv
        )

        XCTAssertNotNil(plotPoint)

        if plotPoint != nil {
            XCTAssertGreaterThan(plotPoint!.t, 0.0)
            XCTAssertGreaterThan(plotPoint!.h, 0.0)
            XCTAssertGreaterThan(plotPoint!.u, 0.0)
            XCTAssertGreaterThan(plotPoint!.s, 0.0)
        }

    }

    func testPointPv4() throws {

        let plotPoint = ThermodynamicCalculator.calculateProperties(
            with: point4V,
            and: point4P,
            for: .Pv
        )

        XCTAssertNotNil(plotPoint)

        if plotPoint != nil {
            XCTAssertGreaterThan(plotPoint!.t, 0.0)
            XCTAssertGreaterThan(plotPoint!.h, 0.0)
            XCTAssertGreaterThan(plotPoint!.u, 0.0)
            XCTAssertGreaterThan(plotPoint!.s, 0.0)
        }

    }

    func testPointPv5() throws {

        let plotPoint = ThermodynamicCalculator.calculateProperties(
            with: point5V,
            and: point5P,
            for: .Pv
        )

        XCTAssertNotNil(plotPoint)

        if plotPoint != nil {
            XCTAssertGreaterThan(plotPoint!.t, 0.0)
            XCTAssertGreaterThan(plotPoint!.h, 0.0)
            XCTAssertGreaterThan(plotPoint!.u, 0.0)
            XCTAssertGreaterThan(plotPoint!.s, 0.0)
        }

    }

    func testPvBottomRight() throws {

        let plotPoint = ThermodynamicCalculator.calculateProperties(
            with: maxVBound - 0.1,
            and: bottomPBound + 1.0,
            for: .Pv
        )

        XCTAssertNotNil(plotPoint)

        if plotPoint != nil {
            XCTAssertGreaterThan(plotPoint!.t, 0.0)
            XCTAssertGreaterThan(plotPoint!.h, 0.0)
            XCTAssertGreaterThan(plotPoint!.u, 0.0)
            XCTAssertGreaterThan(plotPoint!.s, 0.0)
        }

    }

    func testPvTopLeft() throws {

        let plotPoint = ThermodynamicCalculator.calculateProperties(
            with: minVBound + 0.0001,
            and: topPBound_PV - 1000.0,
            for: .Pv
        )

        XCTAssertNotNil(plotPoint)

        if plotPoint != nil {
            XCTAssertGreaterThan(plotPoint!.t, 0.0)
            XCTAssertGreaterThan(plotPoint!.h, 0.0)
            XCTAssertGreaterThan(plotPoint!.u, 0.0)
            XCTAssertGreaterThan(plotPoint!.s, 0.0)
        }

    }

    func testPvSuperheated() throws {

        let plotPoint = ThermodynamicCalculator.calculateProperties(
            with: 0.3528,
            and: 944.2,
            for: .Pv
        )

        XCTAssertNotNil(plotPoint)

        if plotPoint != nil {
            XCTAssertGreaterThan(plotPoint!.t, 0.0)
            XCTAssertGreaterThan(plotPoint!.h, 0.0)
            XCTAssertGreaterThan(plotPoint!.u, 0.0)
            XCTAssertGreaterThan(plotPoint!.s, 0.0)
        }

    }

    func testPvSuperheated2() throws {

        let plotPoint = ThermodynamicCalculator.calculateProperties(
            with: 6.3141322,
            and: 74.9047873,
            for: .Pv
        )

        XCTAssertNotNil(plotPoint)

        if plotPoint != nil {
            XCTAssertGreaterThan(plotPoint!.t, 0.0)
            XCTAssertGreaterThan(plotPoint!.h, 0.0)
            XCTAssertGreaterThan(plotPoint!.u, 0.0)
            XCTAssertGreaterThan(plotPoint!.s, 0.0)
        }

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
