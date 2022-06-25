//
//  ViewController.swift
//  ClausiusSwift
//
//  Created by Austin Carrig on 5/22/22.
//

// TODO List:
// - Add infoView (T-s overlay to explain regions)
// - Add spaceController (for fine tuning) [DONE]
// - superscripting 3 in m3 unit label [DONE]
// - move location indicator when screen size changes (Mac)

import UIKit
import SnapKit
import SwiftyBeaver

class MainViewController: UIViewController {

    // Flags and Indicators

    // tracks if a touch has EVER been registered on the current chart
    var touchHadRegistered = false

    // keeps track of the last point received from the LocationIndicator delegate
    // we need this so we can place the small indicator at the last calculated point
    // we could calculate at the "end" point, but this is how it worked in legacy...
    var lastTouchLocation: CGPoint?

    // Model Objects
    var chart = Chart(with: .Ts)

    // use for fine tuning, could probably re-name...
    let spaceController = SpaceController()

    // Views
    var locationIndicatorImageView = LocationIndicatorImageView(frame: CGRect.zero, chartType: .Ts)

    // for displaying calculated thermodynamic values
    var displayView = DisplayView(frame: CGRect.zero)

    var floaty = ClausiusFloaty(frame: CGRect(x: 0.0, y: 0.0, width: 48.0, height: 48.0))

    let log = SwiftyBeaver.self

    // MARK: - VC Lifecycle

    override func viewDidLoad() {

        super.viewDidLoad()

        // use temporarily while we work on other features
        spaceController.enableFineTuning = false

        view.backgroundColor = .white

        view.addSubview(locationIndicatorImageView)
        view.addSubview(displayView)
        view.addSubview(floaty)

        floaty.addSelectedItem(innerTitle: "T-s") { item in
            self.switchChart(to: .Ts)
            self.floaty.makeItemSelected((item as! ClausiusFloatyItem))
        }
        floaty.addItem(innerTitle: "P-h") { item in
            self.switchChart(to: .Ph)
            self.floaty.makeItemSelected((item as! ClausiusFloatyItem))
        }
        floaty.addItem(innerTitle: "P-v") { item in
            self.switchChart(to: .Pv)
            self.floaty.makeItemSelected((item as! ClausiusFloatyItem))
        }

        floaty.verticalDirection = .down
        floaty.horizontalDirection = .right
        floaty.openAnimationType = .slideDown

        locationIndicatorImageView.delegate = self

        // locationIndicatorImageView should fill the screen
        locationIndicatorImageView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }

        alignViewsLeft()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        drawLineOfConstantSpecificVolume()
    }

    func switchChart(to chartType: ChartType) {

        chart.updateChart(with: chartType)

        switch chart.displayOrientation! {
            case .left:
                alignViewsLeft()
            case .right:
                alignViewsRight()
        }

        locationIndicatorImageView.removeIndicators()

        do {
            try locationIndicatorImageView.changeImage(to: chartType)
        } catch {
            log.error("Unable to change locationIndicationImageView image with chartType \(chartType)")
        }

    }

    func alignViewsLeft() {

        displayView.snp.removeConstraints()
        floaty.snp.removeConstraints()

        displayView.snp.makeConstraints { make in
            make.height.equalTo(340.0)
            make.width.equalTo(190.0)
            make.top.equalToSuperview().offset(20.0)
            make.left.equalToSuperview().offset(40.0)
        }

        floaty.snp.makeConstraints { make in
            make.left.equalTo(displayView.snp.right).offset(20.0)
            make.lastBaseline.equalTo(displayView.titleLabel)
            make.height.width.equalTo(48.0)
        }

    }

    func alignViewsRight() {

        displayView.snp.removeConstraints()
        floaty.snp.removeConstraints()

        displayView.snp.makeConstraints { make in
            make.height.equalTo(340.0)
            make.width.equalTo(190.0)
            make.top.equalToSuperview().offset(20.0)
            make.right.equalToSuperview().offset(-40.0)
        }

        floaty.snp.makeConstraints { make in
            make.right.equalTo(displayView.snp.left).offset(-20.0)
            make.top.equalTo(displayView)
            make.height.width.equalTo(48.0)
        }

    }

    func drawLineOfConstantSpecificVolume() {

        let specVols = [0.003, 0.004, 0.005, 0.006, 0.007, 0.008, 0.009,
                        0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09,
                        0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9,
                        1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0,
                        10.0, 15.0, 20.0, 25.0, 30.0, 35.0]
        var points : [[CGPoint]] = []

        for specVol in specVols {

            var setOfPoints: [CGPoint] = []

            for t in stride(from: 0, to: 701, by: 2) {

                let plotPoint = ThermodynamicCalculator.calculatePropertiesSpecVol(with: specVol, and: Double(t))

                if let plotPoint = plotPoint, let xAxis = chart.xAxis, let yAxis = chart.yAxis {

                    var xPoint = 0.0, yPoint = 0.0

                    let xValue = plotPoint.s, yValue = plotPoint.t

                    switch xAxis.scaleType {
                        case .linear:
                            let xScale = (xAxis.max - xAxis.min) / locationIndicatorImageView.bounds.width
                            xPoint = (xValue - xAxis.min) / xScale
                        case .log:
                            let xScale = (log10(xAxis.max) - log10(xAxis.min)) / locationIndicatorImageView.bounds.width
                            xPoint = (log10(xValue) - log10(xAxis.min)) / xScale
                    }

                    // y on iOS screen and y on graph point in opposite directions, hence height - y
                    switch yAxis.scaleType {
                        case .linear:
                            let yScale = (yAxis.max - yAxis.min) / locationIndicatorImageView.bounds.height
                            yPoint = locationIndicatorImageView.bounds.height - (yValue - yAxis.min) / yScale
                        case .log:
                            let yScale = (log10(yAxis.max) - log10(yAxis.min)) / locationIndicatorImageView.bounds.height
                            yPoint = locationIndicatorImageView.bounds.height - (log10(yValue) - log10(yAxis.min)) / yScale
                    }

                    setOfPoints.append(CGPoint(x: xPoint, y: yPoint))

                }
            }

            points.append(setOfPoints)
        }

        locationIndicatorImageView.drawLines(using: points)

    }

}

// MARK: - LocationIndicatorImageViewDelegate

extension MainViewController: LocationIndicatorImageViewDelegate {

    func touchDidBegin(at location: CGPoint, in locationView: LocationIndicatorImageView) {

        touchHadRegistered = true

        // get the touch location clipped to the bounds of the chart
        let clippedPoint = clipToChartBoundary(
            point: location,
            width: locationView.bounds.width,
            height: locationView.bounds.height
        )

        // add large indicator at point to locationView
        locationView.drawLargeIndicator(at: clippedPoint)

        touchDidRegister(at: clippedPoint, in: locationView)

        lastTouchLocation = clippedPoint

    }

    func touchDidMove(to location: CGPoint, in locationView: LocationIndicatorImageView) {

        let fineTunedPoint = spaceController.fineTunedWithLatest(point: location)

        // get the touch location clipped to the bounds of the chart
        let clippedPoint = clipToChartBoundary(
            point: fineTunedPoint,
            width: locationView.bounds.width,
            height: locationView.bounds.height
        )

        locationView.drawLargeIndicator(at: clippedPoint)

        touchDidRegister(at: clippedPoint, in: locationView)

        lastTouchLocation = clippedPoint

    }

    func touchDidEnd(at location: CGPoint, in locationView: LocationIndicatorImageView) {

        // add small indicator to locationView
        locationView.drawSmallIndicator(at: lastTouchLocation ?? CGPoint(x: -20.0, y: -20.0))

        // reset spaceController
        spaceController.reset()

    }

    func clipToChartBoundary(point: CGPoint,
                             width: CGFloat,
                             height: CGFloat) -> CGPoint {

        let boundedPoint = CGPoint(x: min(max(point.x, 0.0), width), y: min(max(point.y, 0.0), height))

        let yRatio = min(max(boundedPoint.y, 0.0), height) / height

        var index = Int(floor(yRatio * CGFloat(chart.imageBoundaryLine!.count)))

        if index >= chart.imageBoundaryLine!.count {
            index = chart.imageBoundaryLine!.count - 1
        } else if index < 0 {
            index = 0
        }

        let xRatio = chart.imageBoundaryLine![index]

        var adjustment = 0.0

        switch chart.displayOrientation! {
            case .right:
                adjustment = -5.0
            case .left:
                adjustment = 5.0
        }

        let x = xRatio * width + adjustment

        var condition = false

        switch chart.displayOrientation! {
            case .right:
                condition = boundedPoint.x < x
            case .left:
                condition = boundedPoint.x > x
        }

        if condition {
            return boundedPoint
        } else {
            return CGPoint(x: x, y: boundedPoint.y)
        }

    }

    func touchDidRegister(at location: CGPoint,
                          in locationView: LocationIndicatorImageView) {

        if let xAxis = chart.xAxis, let yAxis = chart.yAxis {

            var xValue = 0.0, yValue = 0.0

            switch xAxis.scaleType {
                case .linear:
                    let xScale = (xAxis.max - xAxis.min) / locationView.bounds.width
                    xValue = xAxis.min + xScale * location.x
                case .log:
                    let xScale = (log10(xAxis.max) - log10(xAxis.min)) / locationView.bounds.width
                    xValue = pow(10.0, log10(xAxis.min) + xScale * location.x)
            }

            // y on iOS screen and y on graph point in opposite directions, hence height - y
            switch yAxis.scaleType {
                case .linear:
                    let yScale = (yAxis.max - yAxis.min) / locationView.bounds.height
                    yValue = yAxis.min + yScale * (locationView.bounds.height - location.y)
                case .log:
                    let yScale = (log10(yAxis.max) - log10(yAxis.min)) / locationView.bounds.height
                    yValue = pow(10.0, log10(yAxis.min) + yScale * (locationView.bounds.height - location.y))
            }

            let plotPoint = ThermodynamicCalculator.calculateProperties(
                with: xValue,
                and: yValue,
                for: chart.chartType
            )

            if let plotPoint = plotPoint {
                updateDisplayView(with: plotPoint)
            } else {
                log.error("Nil plot point! -- chartType: \(chart.chartType) -- xValue \(xValue) -- yValue \(yValue)")
            }

        } else {
            log.error("Chart not properly initialized!")
        }

    }

    func updateDisplayView(with plotPoint: PlotPoint) {

        displayView.updateRowValue(for: .t, with: plotPoint.t)
        displayView.updateRowValue(for: .p, with: plotPoint.p)
        displayView.updateRowValue(for: .v, with: plotPoint.v)
        displayView.updateRowValue(for: .u, with: plotPoint.u)
        displayView.updateRowValue(for: .h, with: plotPoint.h)
        displayView.updateRowValue(for: .s, with: plotPoint.s)
        displayView.updateRowValue(for: .x, with: plotPoint.x)

    }

}
