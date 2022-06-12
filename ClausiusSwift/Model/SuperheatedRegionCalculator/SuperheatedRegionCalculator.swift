//
//  SuperheatedRegionCalculator.swift
//  ClausiusSwift
//
//  Created by Austin Carrig on 5/23/22.
//

struct SuperheatedRegionCalculator {
    static func calculatePressure(with temperature: Double, and entropy: Double) throws -> Double {
        return try Interpolator.interpolateY2D(
            array2D: SuperheatedRegionCalculatorConstantsTS.ENTROPY,
            xArray: SuperheatedRegionCalculatorConstantsTS.TEMPERATURE,
            yArray: SuperheatedRegionCalculatorConstantsTS.PRESSURE,
            xValue: temperature,
            array2DValue: entropy
        )
    }

    static func clamp(temperature: Double) -> Double {
        if temperature < SuperheatedRegionCalculatorConstantsTS.TEMPERATURE.first! {
            return SuperheatedRegionCalculatorConstantsTS.TEMPERATURE.first!
        } else if temperature > SuperheatedRegionCalculatorConstantsTS.TEMPERATURE.last! {
            return SuperheatedRegionCalculatorConstantsTS.TEMPERATURE.last!
        } else {
            return temperature
        }
    }
}
