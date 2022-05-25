//
//  SuperheatedRegionCalculator.swift
//  ClausiusSwift
//
//  Created by Austin Carrig on 5/23/22.
//

import Foundation


struct SuperheatedRegionCalculator {
    static func calculatePressure(with temperature: Double, and entropy: Double) -> Double {
        /*
        let clampedTemp = SuperheatedRegionCalculator.clamp(temperature: temperature)

        var i = 0

        for t in SuperheatedRegionCalculatorConstants.TEMPERATURE_T_S {
            if fabs(clampedTemp - t) < Double.ulpOfOne {
                break
            } else if t > clampedTemp {
                i -= 1
                break
            }
            i += 1
        }

        var j = 0
        let entropyRow: [Double] = SuperheatedRegionCalculatorConstants.ENTROPY_T_S[i]
        for s in entropyRow {
            if s <= entropy {
                if j != 0 {
                    j -= 1
                }
                break
            }
            j += 1
        }

        if j == 0 || j == SuperheatedRegionCalculatorConstants.PRESSURE_T_S.count - 1 {
            return SuperheatedRegionCalculatorConstants.PRESSURE_T_S[j]
        } else {
            let high_entropy = entropyRow[j]
            let low_entropy = entropyRow[j - 1]

            let weight = (entropy - low_entropy) / (high_entropy - low_entropy)

            let high_pressure = SuperheatedRegionCalculatorConstants.PRESSURE_T_S[j]
            let low_pressure = SuperheatedRegionCalculatorConstants.PRESSURE_T_S[j - 1]

            return low_pressure + weight * (high_pressure - low_pressure)
        }
         */

        return Interpolator.interpolateY2D(
            array2D: SuperheatedRegionCalculatorConstants.ENTROPY_T_S,
            xArray: SuperheatedRegionCalculatorConstants.TEMPERATURE_T_S,
            yArray: SuperheatedRegionCalculatorConstants.PRESSURE_T_S,
            xValue: temperature,
            array2DValue: entropy
        )

    }

    static func clamp(temperature: Double) -> Double {
        if temperature < SuperheatedRegionCalculatorConstants.TEMPERATURE_T_S.first! {
            return SuperheatedRegionCalculatorConstants.TEMPERATURE_T_S.first!
        } else if temperature > SuperheatedRegionCalculatorConstants.TEMPERATURE_T_S.last! {
            return SuperheatedRegionCalculatorConstants.TEMPERATURE_T_S.last!
        } else {
            return temperature
        }
    }
}
