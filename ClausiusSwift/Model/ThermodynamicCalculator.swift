//
//  ThermodynamicCalculator.swift
//  ClausiusSwift
//
//  Created by Austin Carrig on 5/22/22.
//

import Foundation

class ThermodynamicCalculator {

    // Minimum temperature to display on the T-s diagram (C)
    private static let T_SAT_MIN: Double = 1.0

    static func calculateProperties(with xValue: Double,
                                    and  yValue: Double,
                                    for  chartType: ChartType) -> PlotPoint? {

        switch chartType {
            case .Ts:
                do {
                    return try calculateTs(with: yValue, and: xValue)
                } catch {
                    return nil
                }
            case .Pv:
                do {
                    return try calculatePv(with: yValue, and: xValue)
                } catch {
                    return nil
                }
            case .Ph:
                do {
                    return try calculatePh(with: yValue, and: xValue)
                } catch {
                    return nil
                }
        }
    }

    private static func calculateTs(with temperature: Double,
                                    and  entropy: Double) throws -> PlotPoint? {

        var clampedTemp = temperature

        if clampedTemp < T_SAT_MIN {
            clampedTemp = T_SAT_MIN
        }

        if let saturatedRegionLine = SaturatedRegionLine(with: clampedTemp) {
            if entropy < saturatedRegionLine.s_f { // calculate compressed
                return calculateCompressed(with: saturatedRegionLine)
            } else if entropy >= saturatedRegionLine.s_f && entropy <= saturatedRegionLine.s_g { // calculate saturated
                return calculateSaturatedTs(with: saturatedRegionLine, and: entropy)
            } else { // calculate superheated
                return try calculateSuperheatedTs(with: clampedTemp, and: entropy)
            }
        } else {
            // if we don't have a SaturatedRegionLine, then we're in the superheated region...
            return try calculateSuperheatedTs(with: clampedTemp, and: entropy)
        }
    }

    private static func calculatePv(with pressure: Double,
                                    and  specificVolume: Double) throws -> PlotPoint? {

        let pressureMPa = pressure / 1000.0

        if let temperatureK = H2OWagnerPruss.temperatureVapourLiquid(with: pressureMPa) {

            let temperatureC = temperatureK - ClausiusConstants.C_TO_K

            guard let saturatedRegionLine = SaturatedRegionLine(with: temperatureC) else {
                print("Unable to create SaturatedRegionLine with temperature \(temperatureC)")
                return nil
            }

            if specificVolume < saturatedRegionLine.v_f { // calculate compressed
                return calculateCompressed(with: saturatedRegionLine)
            } else if specificVolume >= saturatedRegionLine.v_f && specificVolume <= saturatedRegionLine.v_g { // calculate saturated
                return calculateSaturatedPv(with: saturatedRegionLine, and: specificVolume)
            } else { // calculate superheated
                return try calculateSuperheatedPv(with: pressure, and: specificVolume)
            }
        } else {
            return try calculateSuperheatedPv(with: pressure, and: specificVolume)
        }
    }

    private static func calculatePh(with pressure: Double,
                                    and  enthalpy: Double) throws -> PlotPoint? {

        let pressureMPa = pressure / 1000.0

        if let temperatureK = H2OWagnerPruss.temperatureVapourLiquid(with: pressureMPa) {

            let temperatureC = temperatureK - ClausiusConstants.C_TO_K

            guard let saturatedRegionLine = SaturatedRegionLine(with: temperatureC) else {
                print("Unable to create SaturatedRegionLine with temperature \(temperatureC)")
                return nil
            }

            if enthalpy < saturatedRegionLine.h_f { // calculate compressed
                return calculateCompressed(with: saturatedRegionLine)
            } else if enthalpy >= saturatedRegionLine.h_f && enthalpy <= saturatedRegionLine.h_g { // calculate saturated
                return calculateSaturatedPh(with: saturatedRegionLine, and: enthalpy)
            } else { // calculate superheated
                return try calculateSuperheatedPh(with: pressure, and: enthalpy)
            }
        } else {
            return try calculateSuperheatedPh(with: pressure, and: enthalpy)
        }
    }

    private static func calculateSuperheatedTs(with temperature: Double,
                                               and  entropy: Double) throws -> PlotPoint? {

        // calculate pressure (SuperheatedRegionCalculator)
        let pressure = try SuperheatedRegionCalculator.calculateTertiaryValue(
            with: temperature,
            and: entropy,
            for: .Ts
        )

        // calculate temperature K
        let temperatureKelvin = temperature + ClausiusConstants.C_TO_K // temperature (C -> K)

        // calculate pressure MPa
        let pressureMPa = pressure / 1000.0 // pressure (kPa -> MPA)

        // calculate density (WagnerPruss)
        let density = H2OWagnerPruss.calculate_density(
            temperature: temperatureKelvin,
            pressure: pressureMPa
        )

        // calculate specific volume (1/density)
        let specificVolume = 1.0 / density

        // calculate internal energy (WagnerPruss)
        let internalEnergy = H2OWagnerPruss.calculate_internal_energy(
            temperature: temperatureKelvin,
            density: density
        )

        // calculate enthalpy (WagnerPruss)
        let enthalpy = H2OWagnerPruss.calculate_enthalpy_with_u(
            temperature: temperatureKelvin,
            density: density,
            internal_energy: internalEnergy
        )

        // return PlotPoint
        return PlotPoint(
            t: temperature,
            p: pressure,
            v: specificVolume,
            u: internalEnergy,
            h: enthalpy,
            s: entropy,
            x: -1.0
        )
    }

    private static func calculateSuperheatedPv(with pressure: Double,
                                               and  specificVolume: Double) throws -> PlotPoint? {

        // calculate temperature
        let temperature = try SuperheatedRegionCalculator.calculateTertiaryValue(
            with: pressure,
            and: specificVolume,
            for: .Pv
        )

        // calculate temperature K
        let temperatureKelvin = temperature + ClausiusConstants.C_TO_K // temperature (C -> K)

        // calculate density
        let density = 1.0 / specificVolume

        // calculate internal energy (WagnerPruss)
        let internalEnergy = H2OWagnerPruss.calculate_internal_energy(
            temperature: temperatureKelvin,
            density: density
        )

        // calculate enthalpy (WagnerPruss)
        let enthalpy = H2OWagnerPruss.calculate_enthalpy_with_u(
            temperature: temperatureKelvin,
            density: density,
            internal_energy: internalEnergy
        )

        // calculate entropy
        let entropy = H2OWagnerPruss.calculate_entropy(
            temperature: temperatureKelvin,
            density: density
        )

        // return PlotPoint
        return PlotPoint(
            t: temperature,
            p: pressure,
            v: specificVolume,
            u: internalEnergy,
            h: enthalpy,
            s: entropy,
            x: -1.0
        )
    }

    private static func calculateSuperheatedPh(with pressure: Double,
                                               and  enthalpy: Double) throws -> PlotPoint? {

        // calculate temperature
        let temperature = try SuperheatedRegionCalculator.calculateTertiaryValue(
            with: pressure,
            and: enthalpy,
            for: .Ph
        )

        // calculate temperature K
        let temperatureKelvin = temperature + ClausiusConstants.C_TO_K // temperature (C -> K)

        // calculate pressure MPa
        let pressureMPa = pressure / 1000.0 // pressure (kPa -> MPA)

        // calculate density (WagnerPruss)
        let density = H2OWagnerPruss.calculate_density(
            temperature: temperatureKelvin,
            pressure: pressureMPa
        )

        // calculate specific volume (1/density)
        let specificVolume = 1.0 / density

        // calculate internal energy (WagnerPruss)
        let internalEnergy = H2OWagnerPruss.calculate_internal_energy(
            temperature: temperatureKelvin,
            density: density
        )

        // calculate entropy
        let entropy = H2OWagnerPruss.calculate_entropy(
            temperature: temperatureKelvin,
            density: density
        )

        // return PlotPoint
        return PlotPoint(
            t: temperature,
            p: pressure,
            v: specificVolume,
            u: internalEnergy,
            h: enthalpy,
            s: entropy,
            x: -1.0
        )
    }

    private static func calculateCompressed(with saturatedRegionLine: SaturatedRegionLine) -> PlotPoint? {
        return PlotPoint(
            t: saturatedRegionLine.t,
            p: saturatedRegionLine.p,
            v: saturatedRegionLine.v_f,
            u: saturatedRegionLine.u_f,
            h: saturatedRegionLine.h_f,
            s: saturatedRegionLine.s_f,
            x: -1.0
        )
    }

    private static func calculateSaturatedTs(with saturatedRegionLine: SaturatedRegionLine,
                                             and  entropy: Double) -> PlotPoint? {
        let quality = (entropy - saturatedRegionLine.s_f) / (saturatedRegionLine.s_g - saturatedRegionLine.s_f)

        return calculateSaturated(
            with: saturatedRegionLine,
            and: quality
        )
    }

    private static func calculateSaturatedPv(with saturatedRegionLine: SaturatedRegionLine,
                                             and  specificVolume: Double) -> PlotPoint? {
        let quality = (specificVolume - saturatedRegionLine.v_f) / (saturatedRegionLine.v_g - saturatedRegionLine.v_f)

        return calculateSaturated(
            with: saturatedRegionLine,
            and: quality
        )
    }

    private static func calculateSaturatedPh(with saturatedRegionLine: SaturatedRegionLine,
                                             and  enthalpy: Double) -> PlotPoint? {
        let quality = (enthalpy - saturatedRegionLine.h_f) / (saturatedRegionLine.h_g - saturatedRegionLine.h_f)

        return calculateSaturated(
            with: saturatedRegionLine,
            and: quality
        )
    }

    private static func calculateSaturated(with saturatedRegionLine: SaturatedRegionLine,
                                           and  quality: Double) -> PlotPoint? {
        let specVolume = saturatedRegionLine.v_f + quality * (saturatedRegionLine.v_g - saturatedRegionLine.v_f)
        let intEnergy = saturatedRegionLine.u_f + quality * (saturatedRegionLine.u_g - saturatedRegionLine.u_f)
        let enthalpy = saturatedRegionLine.h_f + quality * (saturatedRegionLine.h_g - saturatedRegionLine.h_f)
        let entropy = saturatedRegionLine.s_f + quality * (saturatedRegionLine.s_g - saturatedRegionLine.s_f)

        return PlotPoint(
            t: saturatedRegionLine.t,
            p: saturatedRegionLine.p,
            v: specVolume,
            u: intEnergy,
            h: enthalpy,
            s: entropy,
            x: quality * 100.0
        )
    }

}
