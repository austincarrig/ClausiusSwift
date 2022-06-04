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

    // Model Objects
    var chart = Chart(with: .Ts)

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
            make.height.equalTo(350.0)
            make.width.equalTo(210.0)
            make.top.left.equalToSuperview().offset(20.0)
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

        // set lastTouchLocation = location

        

    }

    func touchDidMove(to location: CGPoint, in locationView: LocationIndicatorImageView) {

        // get the touch location clipped to the bounds of the chart
        let clippedPoint = clipToChartBoundary(
            point: location,
            width: locationView.bounds.width,
            height: locationView.bounds.height
        )

        locationView.drawLargeIndicator(at: clippedPoint)

    }

    func touchDidEnd(at location: CGPoint, in locationView: LocationIndicatorImageView) {

        // get the touch location clipped to the bounds of the chart
        let clippedPoint = clipToChartBoundary(
            point: location,
            width: locationView.bounds.width,
            height: locationView.bounds.height
        )

        // add small indicator to locationView
        locationView.drawSmallIndicator(at: clippedPoint)

        // reset spaceController

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

}
