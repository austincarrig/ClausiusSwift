//
//  H2OWagnerPruss.swift
//  ClausiusSwift
//
//  Created by Austin Carrig on 5/24/22.
//

import Foundation

struct H2OWagnerPruss {

    static func calculate_density(temperature: Double,
                                  pressure: Double) -> Double
    {
        var rho1: Double = -1.0
        var rho2: Double = -1.0

        let rho_min = pressure / (2.0 * (H2OWagnerPrussConstants.coVolume * pressure + H2OWagnerPrussConstants.R / 1000.0 * temperature))

        let rho_max = H2OWagnerPrussConstants.extrap_max_density

        let log_rho_increment = (log(rho_max) - log(rho_min)) / 200.0

        var log_rho = log(rho_min)

        var old_rho = rho_min

        var old_f_rho = rho_min / 1000.0 * H2OWagnerPrussConstants.R * temperature * (1.0 + rho_min / H2OWagnerPrussConstants.rho_c * H2OWagnerPruss.calculate_phi_r_delta(temperature: temperature, density: rho_min)) - pressure

        while log_rho < log(rho_max)
        {
            log_rho += log_rho_increment

            let rho = exp(log_rho)

            let f_rho = rho / 1000.0 * H2OWagnerPrussConstants.R * temperature * (1.0 + rho / H2OWagnerPrussConstants.rho_c * H2OWagnerPruss.calculate_phi_r_delta(temperature: temperature, density: rho)) - pressure

            let sign_f_rho = old_f_rho * f_rho

            if sign_f_rho < 0.0
            {
                let new_rho = H2OWagnerPruss.find_rho_with_estimated_density(temperature: temperature,
                                                                             pressure: pressure,
                                                                             density_estimate: (old_rho + rho) / 2.0)

                if rho1 == -1.0
                {
                    rho1 = new_rho
                }
                else
                {
                    rho2 = new_rho
                }
            }

            old_f_rho = f_rho
            old_rho = rho
        }

        // If there is only 1 root, then this is the solution
        if rho2 == -1.0
        {
            return rho1
        }

        // Temperature above critical point pressure above, at or below critical point
        if temperature > H2OWagnerPrussConstants.T_c
        {
            return rho2
        }

        let p_sat = H2OWagnerPruss.pressure_vapor_liquid(temperature: temperature)

        // Temperature below critical point pressure below vapor-liquid pressure
        if temperature <= H2OWagnerPrussConstants.T_c && pressure >= p_sat
        {
            return rho2
        }

        // Temperature below critical point pressure above vapor-liquid pressure
        if temperature <= H2OWagnerPrussConstants.T_c && pressure < p_sat
        {
            return rho1
        }

        print("Error")
        // Error return
        return -1.0
    }

    static func calculate_internal_energy(temperature: Double,
                                          density: Double) -> Double
    {
        let tau = H2OWagnerPruss.calculate_tau(temperature: temperature)

        let phi_0_tau = H2OWagnerPruss.calculate_phi_0_tau(temperature: temperature,
                                                           density: density)

        let phi_r_tau = H2OWagnerPruss.calculate_phi_r_tau(temperature: temperature,
                                                           density: density)

        return H2OWagnerPrussConstants.R * temperature * tau * (phi_0_tau + phi_r_tau) // kJ/kg
    }

    static func calculate_enthalpy(temperature: Double,
                                   density: Double) -> Double
    {
        let tau = H2OWagnerPruss.calculate_tau(temperature: temperature)
        let delta = H2OWagnerPruss.calculate_delta(density: density)

        let phi_r_delta = H2OWagnerPruss.calculate_phi_r_delta(temperature: temperature,
                                                               density: density)

        let phi_0_tau = H2OWagnerPruss.calculate_phi_0_tau(temperature: temperature,
                                                           density: density)

        let phi_r_tau = H2OWagnerPruss.calculate_phi_r_tau(temperature: temperature,
                                                           density: density)

        let extra = H2OWagnerPrussConstants.R * temperature * delta * phi_r_delta

        let internal_energy = H2OWagnerPrussConstants.R * temperature * tau * (phi_0_tau + phi_r_tau)

        return H2OWagnerPrussConstants.R * temperature + internal_energy + extra // kJ/kg
    }

    static func calculate_enthalpy_with_u(temperature: Double,
                                          density: Double,
                                          internal_energy: Double) -> Double
    {
        let delta = H2OWagnerPruss.calculate_delta(density: density)

        let phi_r_delta = H2OWagnerPruss.calculate_phi_r_delta(temperature: temperature,
                                                               density: density)

        let extra = H2OWagnerPrussConstants.R * temperature * delta * phi_r_delta

        return H2OWagnerPrussConstants.R * temperature + internal_energy + extra // kJ/kg
    }

    static func find_rho_with_estimated_density(temperature: Double,
                                                pressure: Double,
                                                density_estimate:Double) -> Double
    {
        var delta = 0.0

        var rho = density_estimate

        let iteration_goal = 1.0e-12
        let max_iteration = 20 // old value: 1000

        var i: Int = 1

        while(true)
        {
            let f_rho = H2OWagnerPrussConstants.rho_c / 1000.0 * H2OWagnerPrussConstants.R * temperature * (delta + pow(delta, 2.0) * H2OWagnerPruss.calculate_phi_r_delta(temperature: temperature, density: rho)) - pressure
            let d_f_rho = H2OWagnerPrussConstants.rho_c / 1000.0 * H2OWagnerPrussConstants.R * temperature * (1.0 + 2.0 * delta * H2OWagnerPruss.calculate_phi_r_delta(temperature: temperature, density: rho)
                                                                                                              + pow(delta, 2.0) * H2OWagnerPruss.calculate_phi_r_delta_delta(temperature: temperature, density: rho))

            let d_delta = -f_rho / d_f_rho
            delta += d_delta

            rho = delta * H2OWagnerPrussConstants.rho_c

            i += 1

            if i > max_iteration
            {
                // TODO: Output error
                break
            }

            if abs(d_delta) <= iteration_goal
            {
                break
            }
        }

        return rho
    }

    static func calculate_phi_r_delta(temperature: Double,
                                      density: Double) -> Double
    {
        var phi_r_delta = 0.0

        let tau = H2OWagnerPruss.calculate_tau(temperature: temperature)
        let delta = H2OWagnerPruss.calculate_delta(density: density)

        for i in 1...7
        {
            phi_r_delta += H2OWagnerPrussConstants.n[i] * H2OWagnerPrussConstants.d[i] * pow(delta, H2OWagnerPrussConstants.d[i] - 1.0) * pow(tau, H2OWagnerPrussConstants.t[i])
        }
        for i in 8...51
        {
            phi_r_delta += H2OWagnerPrussConstants.n[i] * exp(-pow(delta, H2OWagnerPrussConstants.c[i])) * (pow(delta, H2OWagnerPrussConstants.d[i] - 1.0) * pow(tau, H2OWagnerPrussConstants.t[i]) * (H2OWagnerPrussConstants.d[i] - H2OWagnerPrussConstants.c[i] * pow(delta, H2OWagnerPrussConstants.c[i])))
        }
        for i in 52...54
        {
            phi_r_delta += H2OWagnerPrussConstants.n[i] * pow(delta, H2OWagnerPrussConstants.d[i]) * pow(tau, H2OWagnerPrussConstants.t[i]) * exp(-H2OWagnerPrussConstants.alpha[i] * pow(delta - H2OWagnerPrussConstants.epsilon[i], 2.0) - H2OWagnerPrussConstants.beta[i] * pow(tau - H2OWagnerPrussConstants.gamma[i], 2.0))
            * (H2OWagnerPrussConstants.d[i] / delta - 2.0 * H2OWagnerPrussConstants.alpha[i] * (delta - H2OWagnerPrussConstants.epsilon[i]))
        }
        for i in 55...56
        {
            // definition of theta, gdelta, psi
            let theta = (1.0 - tau) + H2OWagnerPrussConstants.A[i] * pow((delta - 1.0) * (delta - 1.0), 1.0 / (2.0 * H2OWagnerPrussConstants.beta[i]))
            let gdelta = theta * theta + H2OWagnerPrussConstants.B[i] * pow((delta - 1.0) * (delta - 1.0), H2OWagnerPrussConstants.a[i])
            let psi = exp(-H2OWagnerPrussConstants.C[i] * (delta - 1.0) * (delta - 1.0) - H2OWagnerPrussConstants.D[i] * (tau - 1.0) * (tau - 1.0))
            // definition of gdelta_delta, gdelta_bi_delta
            let gdelta_delta = (delta - 1.0) * (H2OWagnerPrussConstants.A[i] * theta * 2.0 / H2OWagnerPrussConstants.beta[i] * pow((delta - 1.0) * (delta - 1.0), 1.0 / (2.0 * H2OWagnerPrussConstants.beta[i]) - 1.0)
                                                + 2.0 * H2OWagnerPrussConstants.B[i] * H2OWagnerPrussConstants.a[i] * pow((delta - 1.0) * (delta - 1.0), H2OWagnerPrussConstants.a[i] - 1.0))
            let gdelta_bi_delta = H2OWagnerPrussConstants.b[i] * pow(gdelta, H2OWagnerPrussConstants.b[i] - 1.0) * gdelta_delta
            // definition of psi_delta
            let psi_delta = -2.0 * H2OWagnerPrussConstants.C[i] * (delta - 1.0) * psi
            phi_r_delta += H2OWagnerPrussConstants.n[i] * (pow(gdelta, H2OWagnerPrussConstants.b[i]) * (psi + delta * psi_delta) + gdelta_bi_delta * delta * psi)
        }

        return phi_r_delta
    }

    static func calculate_phi_r_delta_delta(temperature: Double,
                                          density: Double) -> Double
    {
        var phi_r_delta_delta = 0.0

        let tau = H2OWagnerPruss.calculate_tau(temperature: temperature)
        let delta = H2OWagnerPruss.calculate_delta(density: density)

        for i in 1...7
        {
            phi_r_delta_delta += H2OWagnerPrussConstants.n[i] * H2OWagnerPrussConstants.d[i] * (H2OWagnerPrussConstants.d[i] - 1.0) * pow(delta, H2OWagnerPrussConstants.d[i] - 2.0) * pow(tau, H2OWagnerPrussConstants.t[i])
        }
        for i in 8...51
        {
            phi_r_delta_delta += H2OWagnerPrussConstants.n[i] * exp(-pow(delta, H2OWagnerPrussConstants.c[i])) * (pow(delta, H2OWagnerPrussConstants.d[i] - 2.0) * pow(tau, H2OWagnerPrussConstants.t[i])
                                                                                                   * ((H2OWagnerPrussConstants.d[i] - H2OWagnerPrussConstants.c[i] * pow(delta, H2OWagnerPrussConstants.c[i])) * (H2OWagnerPrussConstants.d[i] - 1.0 - H2OWagnerPrussConstants.c[i] * pow(delta, H2OWagnerPrussConstants.c[i])) - H2OWagnerPrussConstants.c[i] * H2OWagnerPrussConstants.c[i] * pow(delta, H2OWagnerPrussConstants.c[i])))
        }
        for i in 52...54
        {
            phi_r_delta_delta += H2OWagnerPrussConstants.n[i] * pow(tau, H2OWagnerPrussConstants.t[i]) * exp(-H2OWagnerPrussConstants.alpha[i] * pow(delta - H2OWagnerPrussConstants.epsilon[i], 2.0) - H2OWagnerPrussConstants.beta[i] * pow(tau - H2OWagnerPrussConstants.gamma[i], 2.0))
            * (-2.0 * H2OWagnerPrussConstants.alpha[i] * pow(delta, H2OWagnerPrussConstants.d[i])
                + 4.0 * H2OWagnerPrussConstants.alpha[i] * H2OWagnerPrussConstants.alpha[i] * pow(delta, H2OWagnerPrussConstants.d[i]) * (delta - H2OWagnerPrussConstants.epsilon[i]) * (delta - H2OWagnerPrussConstants.epsilon[i])
                - 4.0 * H2OWagnerPrussConstants.d[i] * H2OWagnerPrussConstants.alpha[i] * pow(delta, H2OWagnerPrussConstants.d[i] - 1.0) * (delta - H2OWagnerPrussConstants.epsilon[i])
                + H2OWagnerPrussConstants.d[i] * (H2OWagnerPrussConstants.d[i] - 1.0) * pow(delta, H2OWagnerPrussConstants.d[i] - 2.0))
        }
        for i in 55...56
        {
            // definition of theta, gdelta, psi
            let theta = (1.0 - tau) + H2OWagnerPrussConstants.A[i] * pow((delta - 1.0) * (delta - 1.0), 1.0 / (2.0 * H2OWagnerPrussConstants.beta[i]))
            let gdelta = theta * theta + H2OWagnerPrussConstants.B[i] * pow((delta - 1.0) * (delta - 1.0), H2OWagnerPrussConstants.a[i])
            let psi = exp(-H2OWagnerPrussConstants.C[i] * (delta - 1.0) * (delta - 1.0) - H2OWagnerPrussConstants.D[i] * (tau - 1.0) * (tau - 1.0))
            // definition of gdelta_delta, gdelta_bi_delta
            let gdelta_delta = (delta - 1.0) * (H2OWagnerPrussConstants.A[i] * theta * 2.0 / H2OWagnerPrussConstants.beta[i] * pow((delta - 1.0) * (delta - 1.0), 1.0 / (2.0 * H2OWagnerPrussConstants.beta[i]) - 1.0)
                                                + 2.0 * H2OWagnerPrussConstants.B[i] * H2OWagnerPrussConstants.a[i] * pow((delta - 1.0) * (delta - 1.0), H2OWagnerPrussConstants.a[i] - 1.0))
            let gdelta_delta_delta = 1.0 / (delta - 1.0) * gdelta_delta + (delta - 1.0) * (delta - 1.0)
            * (4.0 * H2OWagnerPrussConstants.B[i] * H2OWagnerPrussConstants.a[i] * (H2OWagnerPrussConstants.a[i] - 1.0) * pow((delta - 1.0) * (delta - 1.0), H2OWagnerPrussConstants.a[i] - 2.0)
               + 2.0 * H2OWagnerPrussConstants.A[i] * H2OWagnerPrussConstants.A[i] * (1.0 / H2OWagnerPrussConstants.beta[i]) * (1.0 / H2OWagnerPrussConstants.beta[i]) * (pow((delta - 1.0) * (delta - 1.0), 1.0 / (2.0 * H2OWagnerPrussConstants.beta[i]) - 1.0))
               * (pow((delta - 1.0) * (delta - 1.0), 1.0 / (2.0 * H2OWagnerPrussConstants.beta[i]) - 1.0))
               + H2OWagnerPrussConstants.A[i] * theta * 4.0 / H2OWagnerPrussConstants.beta[i] * (1.0 / (2.0 * H2OWagnerPrussConstants.beta[i]) - 1.0) * pow((delta - 1.0) * (delta - 1.0), 1.0 / (2.0 * H2OWagnerPrussConstants.beta[i]) - 2.0))
            let gdelta_bi_delta = H2OWagnerPrussConstants.b[i] * pow(gdelta, H2OWagnerPrussConstants.b[i] - 1.0) * gdelta_delta
            let gdelta_bi_delta_delta = H2OWagnerPrussConstants.b[i] * (pow(gdelta, H2OWagnerPrussConstants.b[i] - 1.0) * gdelta_delta_delta + (H2OWagnerPrussConstants.b[i] - 1.0) * pow(gdelta, H2OWagnerPrussConstants.b[i] - 2.0) * gdelta_delta * gdelta_delta)
            // definition of psi_delta
            let psi_delta = -2.0 * H2OWagnerPrussConstants.C[i] * (delta - 1.0) * psi
            let psi_delta_delta = (2.0 * H2OWagnerPrussConstants.C[i] * (delta - 1.0) * (delta - 1.0) - 1.0) * 2.0 * H2OWagnerPrussConstants.C[i] * psi
            phi_r_delta_delta += H2OWagnerPrussConstants.n[i] * (pow(gdelta, H2OWagnerPrussConstants.b[i])
                                                    * (2.0 * psi_delta + delta * psi_delta_delta) + 2.0 * gdelta_bi_delta
                                                    * (psi + delta * psi_delta) + gdelta_bi_delta_delta * delta * psi)
        }

        return phi_r_delta_delta
    }

    static func calculate_tau(temperature: Double) -> Double
    {
        return H2OWagnerPrussConstants.T_c / temperature
    }

    static func calculate_delta(density: Double) -> Double
    {
        return density / H2OWagnerPrussConstants.rho_c
    }

    static func pressure_vapor_liquid(temperature: Double) -> Double
    {
        let ALV1: Double =  -7.85951783
        let ALV2: Double =   1.84408259
        let ALV3: Double = -11.7866497
        let ALV4: Double =  22.6807411
        let ALV5: Double = -15.9618719
        let ALV6: Double =   1.80122502

        let theta = 1.0 - temperature / H2OWagnerPrussConstants.T_c

        let p_vl = H2OWagnerPrussConstants.P_c * exp(H2OWagnerPrussConstants.T_c / temperature * (ALV1 * theta + ALV2 * pow(theta, 1.5) + ALV3 * pow(theta, 3.0)
                                                                             + ALV4 * pow(theta, 3.5) + ALV5 * pow(theta, 4.0) + ALV6 * pow(theta, 7.5)))

        return p_vl
    }

    // Calcualte the ideal part of phi_0_tau with temp and density
    static func calculate_phi_0_tau(temperature: Double,
                                    density: Double) -> Double
    {
        let tau = H2OWagnerPruss.calculate_tau(temperature: temperature)

        var phi_0_tau = H2OWagnerPrussConstants.n_0[2] + H2OWagnerPrussConstants.n_0[3] / tau

        for i in 4...8
        {
            phi_0_tau += H2OWagnerPrussConstants.n_0[i] * H2OWagnerPrussConstants.gamma_0[i] * (1.0 / (1.0 - exp(-H2OWagnerPrussConstants.gamma_0[i] * tau)) - 1.0)
        }

        return phi_0_tau
    }

    // Calculate the residual part of phi_r_tau
    static func calculate_phi_r_tau(temperature: Double,
                                    density: Double) -> Double
    {
        var phi_r_tau = 0.0

        let tau = H2OWagnerPruss.calculate_tau(temperature: temperature)
        let delta = H2OWagnerPruss.calculate_delta(density: density)

        for i in 1...7
        {
            phi_r_tau += H2OWagnerPrussConstants.n[i] * H2OWagnerPrussConstants.t[i] * pow(delta, H2OWagnerPrussConstants.d[i]) * pow(tau, H2OWagnerPrussConstants.t[i] - 1.0)
        }
        for i in 8...51
        {
            phi_r_tau += H2OWagnerPrussConstants.n[i] * H2OWagnerPrussConstants.t[i] * pow(delta, H2OWagnerPrussConstants.d[i]) * pow(tau, H2OWagnerPrussConstants.t[i] - 1.0) * exp(-pow(delta, H2OWagnerPrussConstants.c[i]))
        }
        for i in 52...54
        {
            phi_r_tau += H2OWagnerPrussConstants.n[i] * pow(delta, H2OWagnerPrussConstants.d[i]) * pow(tau, H2OWagnerPrussConstants.t[i]) * exp(-H2OWagnerPrussConstants.alpha[i] * pow(delta - H2OWagnerPrussConstants.epsilon[i], 2.0) - H2OWagnerPrussConstants.beta[i] * pow(tau - H2OWagnerPrussConstants.gamma[i], 2.0))
            * (H2OWagnerPrussConstants.t[i] / tau - 2.0 * H2OWagnerPrussConstants.beta[i] * (tau - H2OWagnerPrussConstants.gamma[i]))
        }
        for i in 55...56
        {
            // definition of theta, gdelta, psi
            let theta = (1.0 - tau) + H2OWagnerPrussConstants.A[i] * pow((delta - 1.0) * (delta - 1.0), 1.0 / (2.0 * H2OWagnerPrussConstants.beta[i]))
            let gdelta = theta * theta + H2OWagnerPrussConstants.B[i] * pow((delta - 1.0) * (delta - 1.0), H2OWagnerPrussConstants.a[i])
            let psi = exp(-H2OWagnerPrussConstants.C[i] * (delta - 1.0) * (delta - 1.0) - H2OWagnerPrussConstants.D[i] * (tau - 1.0) * (tau - 1.0))
            // definition gdelta_bi_tau, psi_tau
            let gdelta_bi_tau = -2.0 * theta * H2OWagnerPrussConstants.b[i] * pow(gdelta, H2OWagnerPrussConstants.b[i] - 1.0)
            let psi_tau = -2.0 * H2OWagnerPrussConstants.D[i] * (tau - 1.0) * psi
            phi_r_tau += H2OWagnerPrussConstants.n[i] * delta * (gdelta_bi_tau * psi + pow(gdelta, H2OWagnerPrussConstants.b[i]) * psi_tau)
        }

        return phi_r_tau
    }

}