//
//  SaturatedRegionLine.swift
//  ClausiusSwift
//
//  Created by Austin Carrig on 5/23/22.
//

struct SaturatedRegionLine {

    let t: Double
    let p: Double
    let v_f: Double
    let v_g: Double
    let u_f: Double
    let u_g: Double
    let h_f: Double
    let h_g: Double
    let s_f: Double
    let s_g: Double

    init?(with temperature: Double) {

        if temperature >= SaturatedRegionLineConstants.TEMPERATURE.last! || temperature <= SaturatedRegionLineConstants.TEMPERATURE.first! {
            return nil
        }

        var i = 0

        for t in SaturatedRegionLineConstants.TEMPERATURE {
            if t > temperature {
                break
            }

            i += 1
        }

        let low_temp = SaturatedRegionLineConstants.TEMPERATURE[(i - 1)]
        let high_temp = SaturatedRegionLineConstants.TEMPERATURE[i]

        let weight = (temperature - low_temp) / (high_temp - low_temp)

        t = temperature
        p = Interpolator.interpolate1D(with: SaturatedRegionLineConstants.PRESSURE, and: weight, at: i)
        v_f = Interpolator.interpolate1D(with: SaturatedRegionLineConstants.SPECIFIC_VOLUME_FLUID, and: weight, at: i)
        v_g = Interpolator.interpolate1D(with: SaturatedRegionLineConstants.SPECIFIC_VOLUME_GAS, and: weight, at: i)
        u_f = Interpolator.interpolate1D(with: SaturatedRegionLineConstants.INTERNAL_ENERGY_FLUID, and: weight, at: i)
        u_g = Interpolator.interpolate1D(with: SaturatedRegionLineConstants.INTERNAL_ENERGY_GAS, and: weight, at: i)
        h_f = Interpolator.interpolate1D(with: SaturatedRegionLineConstants.ENTHALPY_FLUID, and: weight, at: i)
        h_g = Interpolator.interpolate1D(with: SaturatedRegionLineConstants.ENTHALPY_GAS, and: weight, at: i)
        s_f = Interpolator.interpolate1D(with: SaturatedRegionLineConstants.ENTROPY_FLUID, and: weight, at: i)
        s_g = Interpolator.interpolate1D(with: SaturatedRegionLineConstants.ENTROPY_GAS, and: weight, at: i)

    }

}
