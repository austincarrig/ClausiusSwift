//
//  ThermodynamicCalculator.swift
//  ClausiusSwift
//
//  Created by Austin Carrig on 5/22/22.
//

import Foundation

enum ChartType {
    case Ts
    case Pv
    case Ph
}

class ThermodynamicCalculator {

    // Critical temperature of water (C)
    private static let T_CRITICAL: Double = 373.9

    // Critical pressure of water (kPa)
    // let P_CRITICAL = 22100.0

    // Minimum temperature to display on the T-s diagram (C)
    private static let T_SAT_MIN: Double = 1.0

    static func calculateProperties(with xValue: Double, and yValue: Double, for chartType: ChartType) -> PlotPoint? {
        switch chartType {
            case .Ts:
                return calculateTS(with: xValue, and: yValue)
            case .Pv:
                print("Not supported yet")
                return nil
            case .Ph:
                print("Not supported yet")
                return nil
        }
    }

    private static func calculateTS(with temperature: Double, and entropy: Double) -> PlotPoint? {
        var clampedTemp = temperature

        if clampedTemp < T_SAT_MIN {
            clampedTemp = T_SAT_MIN
        }

        if clampedTemp > T_CRITICAL {
            return calculateSuperheated(with: clampedTemp, and: entropy)
        } else {
            if clampedTemp == T_CRITICAL {
                // This was copied from Rust WASM code, not sure if it's invalid or...
                // Probably better to just return nil
                return PlotPoint(
                    t: clampedTemp,
                    p: -1.0,
                    v: -1.0,
                    h: -1.0,
                    u: -1.0,
                    s: entropy,
                    x: -1.0
                )
            } else {
                // get Saturated Region Line @ temperature

                if entropy < 1.0 { // if s < s_f ... calculate compressed
                    return calculateCompressed(with: true, and: entropy)
                } else if entropy > 1.0 && entropy < 2.0 { // else if s >= s_f && entropy <= s_g ... calculate saturated
                    return calculateSaturated(with: true, and: entropy)
                } else { // else ... calculate superheated
                    return calculateSuperheated(with: clampedTemp, and: entropy)
                }

            }
        }
    }

    private static func calculateSuperheated(with temperature: Double, and entropy: Double) -> PlotPoint? {

        // calculate pressure (SuperheatedRegionCalculator)

        // calculate temperature K
        // calculate pressure MPa
        // calculate density (WagnerPruss)

        // calculate specific volume (1/density)

        // calculate internal energy (WagnerPruss)
        // calculate enthalpy (WagnerPruss)

        // return PlotPoint

        return PlotPoint(
            t: temperature,
            p: -1.0,
            v: -1.0,
            h: -1.0,
            u: -1.0,
            s: entropy,
            x: -1.0
        )
    }

    private static func calculateCompressed(with saturatedRegionLine: Bool, and entropy: Double) -> PlotPoint? {
        // return PlotPoint (with v_f, u_f, h_f)

        return PlotPoint(
            t: -1.0,
            p: -1.0,
            v: -1.0,
            h: -1.0,
            u: -1.0,
            s: entropy,
            x: -1.0
        )
    }

    private static func calculateSaturated(with saturatedRegionLine: Bool, and entropy: Double) -> PlotPoint? {

        // pressure = satLine.p
        // interpolate quality, spec_volume, int_energy, enthalpy

        return PlotPoint(
            t: -1.0,
            p: -1.0,
            v: -1.0,
            h: -1.0,
            u: -1.0,
            s: entropy,
            x: -1.0
        )
    }

}
