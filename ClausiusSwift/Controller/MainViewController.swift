//
//  ViewController.swift
//  ClausiusSwift
//
//  Created by Austin Carrig on 5/22/22.
//

// TODO List:
// - Add infoView (T-s overlay to explain regions)
// - Add spaceController (for fine tuning) [DONE]
// - superscripting 3 in m3 unit label
// - move location indicator when screen size changes (Mac)

import UIKit
import SnapKit

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

    var tsButton = UIButton(frame: CGRect.zero)

    var pvButton = UIButton(frame: CGRect.zero)

    var phButton = UIButton(frame: CGRect.zero)

    // MARK: - VC Lifecycle

    override func viewDidLoad() {

        super.viewDidLoad()

        // use temporarily while we work on other features
        spaceController.enableFineTuning = false

        view.backgroundColor = .white

        view.addSubview(locationIndicatorImageView)
        view.addSubview(displayView)
        view.addSubview(tsButton)
        view.addSubview(pvButton)
        view.addSubview(phButton)

        tsButton.setTitle("T-s", for: .normal)
        tsButton.addTarget(self, action: #selector(pressTsButton), for: .touchUpInside)
        tsButton.setTitleColor(.clausiusOrange, for: .normal)

        pvButton.setTitle("P-v", for: .normal)
        pvButton.addTarget(self, action: #selector(pressPvButton), for: .touchUpInside)
        pvButton.setTitleColor(.clausiusOrange, for: .normal)

        phButton.setTitle("P-h", for: .normal)
        phButton.addTarget(self, action: #selector(pressPhButton), for: .touchUpInside)
        phButton.setTitleColor(.clausiusOrange, for: .normal)

        locationIndicatorImageView.delegate = self

        // locationIndicatorImageView should fill the screen
        locationIndicatorImageView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }

        alignViewsLeft()

    }

    @objc func pressTsButton() {

        if chart.displayOrientation! == .right {
            alignViewsLeft()
        }

        chart.updateChart(with: .Ts)

        locationIndicatorImageView.removeIndicators()

        do {
            try locationIndicatorImageView.changeImage(to: .Ts)
        } catch {
            print("Error thrown, unable to change image")
        }

    }

    @objc func pressPvButton() {

        if chart.displayOrientation! == .left {
            alignViewsRight()
        }

        chart.updateChart(with: .Pv)

        locationIndicatorImageView.removeIndicators()

        do {
            try locationIndicatorImageView.changeImage(to: .Pv)
        } catch {
            print("Error thrown, unable to change image")
        }

    }

    @objc func pressPhButton() {

        if chart.displayOrientation! == .right {
            alignViewsLeft()
        }

        chart.updateChart(with: .Ph)

        locationIndicatorImageView.removeIndicators()

        do {
            try locationIndicatorImageView.changeImage(to: .Ph)
        } catch {
            print("Error thrown, unable to change image")
        }

    }

    func alignViewsLeft() {

        displayView.snp.removeConstraints()
        tsButton.snp.removeConstraints()
        pvButton.snp.removeConstraints()
        phButton.snp.removeConstraints()

        displayView.snp.makeConstraints { make in
            make.height.equalTo(340.0)
            make.width.equalTo(190.0)
            make.top.equalToSuperview().offset(20.0)
            make.left.equalToSuperview().offset(40.0)
        }

        tsButton.snp.makeConstraints { make in
            make.left.equalTo(displayView.snp.right).offset(20.0)
            make.top.equalTo(displayView)
        }

        pvButton.snp.makeConstraints { make in
            make.left.equalTo(displayView.snp.right).offset(20.0)
            make.top.equalTo(tsButton.snp.bottom)
        }

        phButton.snp.makeConstraints { make in
            make.left.equalTo(displayView.snp.right).offset(20.0)
            make.top.equalTo(pvButton.snp.bottom)
        }

    }

    func alignViewsRight() {

        displayView.snp.removeConstraints()
        tsButton.snp.removeConstraints()
        pvButton.snp.removeConstraints()
        phButton.snp.removeConstraints()

        displayView.snp.makeConstraints { make in
            make.height.equalTo(340.0)
            make.width.equalTo(190.0)
            make.top.equalToSuperview().offset(20.0)
            make.right.equalToSuperview().offset(-40.0)
        }

        tsButton.snp.makeConstraints { make in
            make.right.equalTo(displayView.snp.left).offset(-20.0)
            make.top.equalTo(displayView)
        }

        pvButton.snp.makeConstraints { make in
            make.right.equalTo(displayView.snp.left).offset(-20.0)
            make.top.equalTo(tsButton.snp.bottom)
        }

        phButton.snp.makeConstraints { make in
            make.right.equalTo(displayView.snp.left).offset(-20.0)
            make.top.equalTo(pvButton.snp.bottom)
        }

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

        let yRatio = max(point.y, 0.0) / height
        let xRatio = chart.imageBoundaryLine![Int(floor(yRatio * CGFloat(chart.imageBoundaryLine!.count)))]

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
                condition = point.x < x
            case .left:
                condition = point.x > x
        }

        if condition {
            return point
        } else {
            return CGPoint(x: x, y: point.y)
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

            updateDisplayView(with: plotPoint)

        } else {
            print("Chart not properly initialized!! Should probably throw an exception here.")
        }

    }

    func updateDisplayView(with plotPoint: PlotPoint?) {

        if let plotPoint = plotPoint {
            displayView.updateRowValue(for: .t, with: plotPoint.t)
            displayView.updateRowValue(for: .p, with: plotPoint.p)
            displayView.updateRowValue(for: .v, with: plotPoint.v)
            displayView.updateRowValue(for: .u, with: plotPoint.u)
            displayView.updateRowValue(for: .h, with: plotPoint.h)
            displayView.updateRowValue(for: .s, with: plotPoint.s)
            displayView.updateRowValue(for: .x, with: plotPoint.x)
        } else {
            print("Got a nil plot point, might want to do something else here?...")
        }

    }

}
