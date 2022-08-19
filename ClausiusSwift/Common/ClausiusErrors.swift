//
//  ClausiusErrors.swift
//  ClausiusSwift
//
//  Created by Austin Carrig on 5/27/22.
//

import Foundation

enum ClausiusError: Error {
    // Throw when we attempt to use a chart type which is unsupported
    case invalidChartType

    // Throw when we attempt to provide a function or calculator with an
    // unsupported valueType (such as using .t to attempt to calculate
    // superheated pressure in the SuperheatedRegionCalculator, for which
    // temperature is already the primary input)
    case invalidValueType
}
