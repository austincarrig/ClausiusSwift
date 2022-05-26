//
//  SuperheatedRegionCalculator.swift
//  ClausiusSwift
//
//  Created by Austin Carrig on 5/23/22.
//

import Foundation


struct SuperheatedRegionCalculator {
    static func calculatePressure(with temperature: Double, and entropy: Double) throws -> Double {
        return try Interpolator.interpolateY2D(
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
