//
//  SuperheatedRegionCalculator.swift
//  ClausiusSwift
//
//  Created by Austin Carrig on 5/23/22.
//

import SwiftyBeaver

struct SuperheatedRegionCalculator {
    static func calculateTertiaryValue(with primaryValue: Double,
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

    static func calculateSuperheatedTemperature(with  pressure: Double,
                                                and   secondaryValue: Double,
                                                using valueType: ValueType) throws -> Double {

        switch valueType {
            case .v:
                return try Interpolator.interpolateY2D(
                    array2D: SuperheatedRegionCalculatorConstantsPV.SPECIFIC_VOLUME,
                    xArray: SuperheatedRegionCalculatorConstantsPV.PRESSURE,
                    yArray: SuperheatedRegionCalculatorConstantsPV.TEMPERATURE,
                    xValue: pressure,
                    array2DValue: secondaryValue
                )
            case .u:
                SwiftyBeaver.self.warning("Internal energy not currently supported")
                throw ClausiusError.invalidValueType
            case .h:
                return try Interpolator.interpolateY2D(
                    array2D: SuperheatedRegionCalculatorConstantsPH.ENTHALPY,
                    xArray: SuperheatedRegionCalculatorConstantsPH.PRESSURE,
                    yArray: SuperheatedRegionCalculatorConstantsPH.TEMPERATURE,
                    xValue: pressure,
                    array2DValue: secondaryValue
                )
            case .s:
                return try Interpolator.interpolateX2D(
                    array2D: SuperheatedRegionCalculatorConstantsTS.ENTROPY,
                    xArray: SuperheatedRegionCalculatorConstantsTS.TEMPERATURE,
                    yArray: SuperheatedRegionCalculatorConstantsTS.PRESSURE,
                    yValue: pressure,
                    array2DValue: secondaryValue
                )
            case .t, .p, .x:
                SwiftyBeaver.self.error("Attempted to use unsupported valueType \(valueType)")
                throw ClausiusError.invalidValueType
        }
    }

    static func calculateSuperheatedPressure(with  temperature: Double,
                                             and   secondaryValue: Double,
                                             using valueType: ValueType) throws -> Double {

        switch valueType {
            case .v:
                return try Interpolator.interpolateX2D(
                    array2D: SuperheatedRegionCalculatorConstantsPV.SPECIFIC_VOLUME,
                    xArray: SuperheatedRegionCalculatorConstantsPV.PRESSURE,
                    yArray: SuperheatedRegionCalculatorConstantsPV.TEMPERATURE,
                    yValue: temperature,
                    array2DValue: secondaryValue
                )
            case .u:
                SwiftyBeaver.self.warning("Internal energy not currently supported")
                throw ClausiusError.invalidValueType
            case .h:
                return try Interpolator.interpolateX2D(
                    array2D: SuperheatedRegionCalculatorConstantsPH.ENTHALPY,
                    xArray: SuperheatedRegionCalculatorConstantsPH.PRESSURE,
                    yArray: SuperheatedRegionCalculatorConstantsPH.TEMPERATURE,
                    yValue: temperature,
                    array2DValue: secondaryValue
                )
            case .s:
                return try Interpolator.interpolateY2D(
                    array2D: SuperheatedRegionCalculatorConstantsTS.ENTROPY,
                    xArray: SuperheatedRegionCalculatorConstantsTS.TEMPERATURE,
                    yArray: SuperheatedRegionCalculatorConstantsTS.PRESSURE,
                    xValue: temperature,
                    array2DValue: secondaryValue
                )
            case .t, .p, .x:
                SwiftyBeaver.self.error("Attempted to use unsupported valueType \(valueType)")
                throw ClausiusError.invalidValueType
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
