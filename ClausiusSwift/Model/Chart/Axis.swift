//
//  Axes.swift
//  ClausiusSwift
//
//  Created by Austin Carrig on 5/26/22.
//

import Foundation

enum AxisDirection {
    case x
    case y
}

enum AxisValueType {
    case temperature
    case pressure
    case specificVolume
    case internalEnergy
    case enthalpy
    case entropy
}

enum AxisScaleType {
    case linear
    case log
}

struct Axis {

    let min: Double
    let max: Double

    let direction: AxisDirection
    let scaleType: AxisScaleType
    let valueType: AxisValueType

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
