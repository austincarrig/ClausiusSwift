//
//  Axes.swift
//  ClausiusSwift
//
//  Created by Austin Carrig on 5/26/22.
//

import Foundation

enum RUAxisDirection {
    case x
    case y
}

enum RUAxisValueType {
    case temperature
    case pressure
    case specificVolume
    case internalEnergy
    case enthalpy
    case entropy
}

enum RUAxisScaleType {
    case linear
    case log
}

struct RUAxis {

    let min: Double
    let max: Double

    let direction: RUAxisDirection
    let scaleType: RUAxisScaleType
    let valueType: RUAxisValueType

    lazy var range: Double = {
        return max - min
    }()

    lazy var valueTypeAsString: String = {
        switch valueType {
            case .temperature:
                return "t"
            case .pressure:
                return "p"
            case .specificVolume:
                return "v"
            case .internalEnergy:
                return "u"
            case .enthalpy:
                return "h"
            case .entropy:
                return "s"
        }
    }()

    lazy var scaleTypeAsString: String = {
        switch scaleType {
            case .linear:
                return "linear"
            case .log:
                return "log"
        }
    }()

}
