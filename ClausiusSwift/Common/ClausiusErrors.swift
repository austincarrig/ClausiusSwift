//
//  ClausiusErrors.swift
//  ClausiusSwift
//
//  Created by Austin Carrig on 5/27/22.
//

import Foundation

enum ClausiusError: Error {
    // Throw when we attempt to use a chart type which is unsupported
    // For a while, this will be .Pv and .Ph, but eventually these charts
    // will become supported, at which point this error will only be for
    // invalid enumerated cases
    case invalidChartType
}
