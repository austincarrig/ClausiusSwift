//
//  SuperheatedRegionCalculator.swift
//  ClausiusSwift
//
//  Created by Austin Carrig on 5/23/22.
//

struct SuperheatedRegionCalculator {
    static func calculatePressure(with primaryValue: Double,
                                  and  secondaryValue: Double,
                                  for  chartType: ChartType) throws -> Double {
        switch chartType {
            case .Ts:
                return try Interpolator.interpolateY2D(
                    array2D: SuperheatedRegionCalculatorConstantsTS.ENTROPY,
                    xArray: SuperheatedRegionCalculatorConstantsTS.TEMPERATURE,
                    yArray: SuperheatedRegionCalculatorConstantsTS.PRESSURE,
                    xValue: primaryValue,
                    array2DValue: secondaryValue
                )
            case .Pv:
                return try Interpolator.interpolateY2D(
                    array2D: SuperheatedRegionCalculatorConstantsPV.SPECIFIC_VOLUME,
                    xArray: SuperheatedRegionCalculatorConstantsPV.PRESSURE,
                    yArray: SuperheatedRegionCalculatorConstantsPV.TEMPERATURE,
                    xValue: primaryValue,
                    array2DValue: secondaryValue
                )
            case .Ph:
                return try Interpolator.interpolateY2D(
                    array2D: SuperheatedRegionCalculatorConstantsPH.ENTHALPY,
                    xArray: SuperheatedRegionCalculatorConstantsPH.PRESSURE,
                    yArray: SuperheatedRegionCalculatorConstantsPH.TEMPERATURE,
                    xValue: primaryValue,
                    array2DValue: secondaryValue
                )
        }
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
