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

        self.chartType = chartType

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

        imageBoundaryLine = ChartLines.PV_CHART_LINE

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

        imageBoundaryLine = ChartLines.PH_CHART_LINE

    }

    func pointFrom(xValue: Double,
                   yValue: Double,
                   viewWidth: Double,
                   viewHeight: Double) -> CGPoint? {

        if let xAxis = xAxis, let yAxis = yAxis {

            var xPoint = 0.0, yPoint = 0.0

            switch xAxis.scaleType {
                case .linear:
                    let xScale = (xAxis.max - xAxis.min) / viewWidth
                    xPoint = (xValue - xAxis.min) / xScale
                case .log:
                    let xScale = (log10(xAxis.max) - log10(xAxis.min)) / viewWidth
                    xPoint = (log10(xValue) - log10(xAxis.min)) / xScale
            }

            // y on iOS screen and y on graph point in opposite directions, hence height - y
            switch yAxis.scaleType {
                case .linear:
                    let yScale = (yAxis.max - yAxis.min) / viewHeight
                    yPoint = viewHeight - (yValue - yAxis.min) / yScale
                case .log:
                    let yScale = (log10(yAxis.max) - log10(yAxis.min)) / viewHeight
                    yPoint = viewHeight - (log10(yValue) - log10(yAxis.min)) / yScale
            }

            return CGPoint(x: xPoint, y: yPoint)

        }

        return nil

    }

    func valuesFrom(point: CGPoint,
                    viewWidth: Double,
                    viewHeight: Double) -> (Double, Double)? {

        if let xAxis = xAxis, let yAxis = yAxis {

            var xValue = 0.0, yValue = 0.0

            // The following 2 switch statements convert the x and y values from their
            // pixel values to their property values (on T-s, x because s, y becomes T).
            // Some values are logarithmic rather than linear, so the values are converted
            // by scaling logarithmically rather than linearly when appropriate
            switch xAxis.scaleType {
                case .linear:
                    let xScale = (xAxis.max - xAxis.min) / viewWidth
                    xValue = xAxis.min + xScale * point.x
                case .log:
                    let xScale = (log10(xAxis.max) - log10(xAxis.min)) / viewWidth
                    xValue = pow(10.0, log10(xAxis.min) + xScale * point.x)
            }

            // NOTE: y on iOS screen and y on graph point are in opposite directions, hence height - y
            //       positive y on iOS is from top to bottom
            switch yAxis.scaleType {
                case .linear:
                    let yScale = (yAxis.max - yAxis.min) / viewHeight
                    yValue = yAxis.min + yScale * (viewHeight - point.y)
                case .log:
                    let yScale = (log10(yAxis.max) - log10(yAxis.min)) / viewHeight
                    yValue = pow(10.0, log10(yAxis.min) + yScale * (viewHeight - point.y))
            }

            return (xValue, yValue)

        }

        return nil

    }

}
