//
//  ViewController.swift
//  ClausiusSwift
//
//  Created by Austin Carrig on 5/22/22.
//

// TODO List:
// - Add infoView (T-s overlay to explain regions)
// - Add spaceController (for fine tuning)
// - superscripting 3 in m3 unit label

import UIKit
import SnapKit

class MainViewController: UIViewController {

    // Flags and Indicators

    // tracks if a touch has EVER been registered on the current chart
    var touchHadRegistered = false

    var lastTouchLocation: CGPoint?

    // Model Objects
    var chart = Chart(with: .Ts)

    let spaceController = SpaceController()

    // Views
    var locationIndicatorImageView = LocationIndicatorImageView(frame: CGRect.zero, chartType: .Ts)

    var displayView = DisplayView(frame: CGRect.zero)

    // MARK: - VC Lifecycle

    override func viewDidLoad() {

        super.viewDidLoad()

        view.backgroundColor = .white

        view.addSubview(locationIndicatorImageView)
        view.addSubview(displayView)

        locationIndicatorImageView.delegate = self

        // locationIndicatorImageView should fill the screen
        locationIndicatorImageView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }

        displayView.snp.makeConstraints { make in
            make.height.equalTo(340.0)
            make.width.equalTo(190.0)
            make.top.equalToSuperview().offset(20.0)
            make.left.equalToSuperview().offset(40.0)
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

        // update spaceController

        // reset fine-tuning flag (should probably move this to a resetFlagsAndInds() function...)

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
        locationView.drawSmallIndicator(at: lastTouchLocation!)

        // reset spaceController
        spaceController.reset()

    }

    func clipToChartBoundary(point: CGPoint,
                             width: CGFloat,
                             height: CGFloat) -> CGPoint {
        let yRatio = point.y / height
        let xRatio = chart.imageBoundaryLine![Int(floor(yRatio * CGFloat(chart.imageBoundaryLine!.count)))]

        var adjustment = 0.0

        switch chart.displayOrientation! {
            case .right:
                adjustment = -5.0
            case .left:
                adjustment = 5.0
        }

        let x = xRatio * width + adjustment

        if point.x > x {
            return point
        } else {
            return CGPoint(x: x, y: point.y)
        }
    }

    func touchDidRegister(at location: CGPoint,
                          in locationView: LocationIndicatorImageView) {

        if let xAxis = chart.xAxis, let yAxis = chart.yAxis {
            let xScale = (xAxis.max - xAxis.min) / locationView.bounds.width
            let yScale = (yAxis.max - yAxis.min) / locationView.bounds.height

            let xValue = xAxis.min + xScale * location.x
            // y on iOS screen and y on graph point in opposite directions, hence height - y
            let yValue = yAxis.min + yScale * (locationView.bounds.height - location.y)

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
