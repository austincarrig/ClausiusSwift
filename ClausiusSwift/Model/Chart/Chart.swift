//
//  Chart.swift
//  ClausiusSwift
//
//  Created by Austin Carrig on 5/26/22.
//

import Foundation

class Chart {

    var xAxis: Axis?
    var yAxis: Axis?

    var chartType: ChartType
    var substanceType: SubstanceType
    var displayOrientation: DisplayOrientation?

    var imageBoundaryLine: [Double]?

    init(with chartType: ChartType) {

        self.chartType = chartType
        self.substanceType = .Water

        updateChart(with: chartType)

    }

    func updateChart(with chartType: ChartType) {

        switch chartType {
            case .Ts:
                updateChartForTs()
            case .Pv:
                updateChartForPv()
            case .Ph:
                updateChartForPh()
        }

    }

    func updateChartForTs() {

        xAxis = Axis(
            min: 0.0,
            max: 9.3,
            direction: .x,
            scaleType: .linear,
            valueType: .entropy
        )

        yAxis = Axis(
            min: 0.0,
            max: 700.0,
            direction: .y,
            scaleType: .linear,
            valueType: .temperature
        )

        displayOrientation = .left

        imageBoundaryLine = ChartLines.TS_CHART_LINE

    }

    func updateChartForPv() {

        xAxis = Axis(
            min: 0.001,
            max: 35.6,
            direction: .x,
            scaleType: .log,
            valueType: .specificVolume
        )

        yAxis = Axis(
            min: 10.0,
            max: 50000.0,
            direction: .y,
            scaleType: .log,
            valueType: .pressure
        )

        displayOrientation = .right

    }

    func updateChartForPh() {

        xAxis = Axis(
            min: 0.0,
            max: 4444.0,
            direction: .x,
            scaleType: .linear,
            valueType: .enthalpy
        )

        yAxis = Axis(
            min: 10.0,
            max: 1000000.0,
            direction: .y,
            scaleType: .log,
            valueType: .pressure
        )

        displayOrientation = .left

    }

}
