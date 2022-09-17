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
// - move location indicator when screen size changes (Mac) [DONE]

import UIKit
import SnapKit

// CONSTANTS
let DISPLAY_VIEW_HEIGHT: CGFloat = 340.0
let DISPLAY_VIEW_WIDTH: CGFloat = 190.0
let DISPLAY_VIEW_TOP_OFFSET: CGFloat = 20.0
let DISPLAY_VIEW_SIDE_OFFSET: CGFloat = 40.0
let FLOATY_WIDTH_HEIGHT: CGFloat = 48.0
let FLOATY_SIDE_OFFSET: CGFloat = 20.0

class MainViewController: UIViewController {

    //////////////////////////
    // Flags and Indicators //
    //////////////////////////

    // tracks if a touch has EVER been registered on the current chart
    var touchHadRegistered = false

    // keeps track of the last point received from the LocationIndicator delegate
    // we need this so we can place the small indicator at the last calculated point
    // we could calculate at the "end" point, but this is how it worked in legacy...
    var lastTouchLocation: CGPoint?

    // Used to track the most recent size of the locationIndicatorImageView
    // This field is utitlized to re-draw the location indicator if it is currently on screen
    var previousSize: CGSize = .zero

    ///////////////////
    // Model Objects //
    ///////////////////

    var chart = Chart(with: .Ts)

    // use for fine tuning, could probably re-name...
    let spaceController = SpaceController()

    ///////////
    // Views //
    ///////////

    // primary view, used for receive user touch and to display touch location
    var locationIndicatorImageView = LocationIndicatorImageView(frame: CGRect.zero, chartType: .Ts)

    // for displaying calculated thermodynamic values
    var displayView = DisplayView(frame: CGRect.zero)

    // ClausiusFloaty is the floating button menu, which provides
    // the capability to swap between different charts
    var floaty = ClausiusFloaty(frame: CGRect(x: 0.0, y: 0.0, width: FLOATY_WIDTH_HEIGHT, height: FLOATY_WIDTH_HEIGHT))

    // MARK: - VC Lifecycle

    override func viewDidLoad() {

        super.viewDidLoad()

        // Fine tuning disabled temporarily while other features are developed
        spaceController.enableFineTuning = false

        // Set up primary view
        view.backgroundColor = .white

        view.addSubview(locationIndicatorImageView)
        view.addSubview(displayView)
        view.addSubview(floaty)

        // Set up Floaty menu
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

        // Set up LocationIndicatorImageView
        locationIndicatorImageView.delegate = self

        // locationIndicatorImageView should fill the screen
        locationIndicatorImageView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }

        // set constraints on load for T-s, which is to the left
        alignViewsLeft()

    }

    override func viewDidLayoutSubviews() {

        let newSize = locationIndicatorImageView.bounds.size

        // If the size of the view changed...
        if previousSize != newSize {
            // ...and the locationIndicator is on screen...
            if lastTouchLocation != nil {
                // ...then scale lastTouchLocation to newSize...
                let scaleX = newSize.width / previousSize.width
                let scaleY = newSize.height / previousSize.height

                lastTouchLocation!.x = lastTouchLocation!.x * scaleX
                lastTouchLocation!.y = lastTouchLocation!.y * scaleY

                // ...and draw a smallIndicator at the scaled location
                locationIndicatorImageView.drawSmallIndicator(at: lastTouchLocation!)
            }

            previousSize = newSize
        }

        super.viewDidLayoutSubviews()

    }

    func switchChart(to chartType: ChartType) {

        // This updates the model for the chartType so that we can get fields like
        // displayOrientation and the axis bounds specific to the new chartType
        chart.updateChart(with: chartType)

        // When resetting that chart, we need to both change the image (done below)
        // and align the diplayTable and associated views to the proper side of the
        // screen.
        switch chart.displayOrientation! {
            case .left:
                alignViewsLeft()
            case .right:
                alignViewsRight()
        }

        // This removes the drawn smallIndicator from the locationIndicatorImageView
        // if one has been drawn. An improvement could be made in the future to
        // re-draw the indicator at the same thermodynamic state on the new chart,
        // but for now it's necessary to remove the indicator to not confuse the user
        locationIndicatorImageView.removeIndicators()

        // This is necessary because we re-draw the locationIndicator if the
        // screen size changes (see viewDidLayoutSubviews()). If the chart is
        // switched using this function, and the widnow is then re-sized, a
        // smallIndicator will be drawn at lastTouchLocation unless
        // lastTouchLocation is nil
        lastTouchLocation = nil

        do {
            try locationIndicatorImageView.changeImage(to: chartType)
        } catch {
            print("Unable to change locationIndicationImageView image with chartType \(chartType)")
        }

    }

    /*
     * Align the DisplayView and Floaty menu to the left of the screen,
     * by deleting and resetting their constraints to the top-left corner
     */
    func alignViewsLeft() {

        displayView.snp.removeConstraints()
        floaty.snp.removeConstraints()

        displayView.snp.makeConstraints { make in
            make.height.equalTo(DISPLAY_VIEW_HEIGHT)
            make.width.equalTo(DISPLAY_VIEW_WIDTH)
            make.top.equalToSuperview().offset(DISPLAY_VIEW_TOP_OFFSET)
            make.left.equalToSuperview().offset(DISPLAY_VIEW_SIDE_OFFSET)
        }

        floaty.snp.makeConstraints { make in
            make.left.equalTo(displayView.snp.right).offset(FLOATY_SIDE_OFFSET)
            make.lastBaseline.equalTo(displayView.titleLabel)
            make.height.width.equalTo(FLOATY_WIDTH_HEIGHT)
        }

    }

    /*
     * Align the DisplayView and Floaty menu to the right of the screen,
     * by deleting and resetting their constraints to the top-right corner
     */
    func alignViewsRight() {

        displayView.snp.removeConstraints()
        floaty.snp.removeConstraints()

        displayView.snp.makeConstraints { make in
            make.height.equalTo(DISPLAY_VIEW_HEIGHT)
            make.width.equalTo(DISPLAY_VIEW_WIDTH)
            make.top.equalToSuperview().offset(DISPLAY_VIEW_TOP_OFFSET)
            make.right.equalToSuperview().offset(-DISPLAY_VIEW_SIDE_OFFSET)
        }

        floaty.snp.makeConstraints { make in
            make.right.equalTo(displayView.snp.left).offset(-FLOATY_SIDE_OFFSET)
            make.lastBaseline.equalTo(displayView.titleLabel)
            make.height.width.equalTo(FLOATY_WIDTH_HEIGHT)
        }

    }

}

// MARK: - LocationIndicatorImageViewDelegate

extension MainViewController: LocationIndicatorImageViewDelegate {

    /*
     * Delegate method called when the LocationIndicatorImageView receives an initial touch event.
     */
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

        // Reset spaceController, which resets the parameters for fine-tuning. Every time a
        // new touch BEGINS within the LocationIndicatorImageView, the fine-tuning conditions
        // need to reset.
        spaceController.reset()

    }

    /*
     * Delegate method called when the LocationIndicatorImageView receives a moved touch event.
     */
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

    /*
     * Called when the touch within the LocationIndicatorImageView ends. This usually means
     * the user has stopped dragging the largeIndicator across the chart, and has lifted their
     * finger from the screen.
     */
    func touchDidEnd(at location: CGPoint, in locationView: LocationIndicatorImageView) {

        // Add small indicator to locationView
        locationView.drawSmallIndicator(at: lastTouchLocation ?? CGPoint(x: -20.0, y: -20.0))

    }

    /*
     * The purpose of this function is to take the user's touch location, and clip it to
     * the bounds of the actual chart lines. The purpose of this is two-fold:
     *   1. From a visual perspective, the indicator should not leave the bounds, as this
     *      indicates to the user that no information can be obtained for the user outside
     *      of those bounds.
     *   2. From a calculation perspective, the ThermodynamicCalculator is incapable of
     *      calculating thermodynamic properies outside the bounds of the chart, particularly
     *      in high-T or high-P parts of the superheated region. Calculations outside of the
     *      bounds could be done, but we as the app developer would need to expand the size
     *      of the superheated region tables. At this time, there's no reason to expand them
     *      beyond their current size.
     *
     * Functionally, this method takes in the point the user touched and the height and width
     * of the locationIndicatorImageView the point is located in, and it returns a point that is:
     *   1. Bounded to fall within the limits of the view itself (which is necessary for the Mac
     *      version of the app).
     *   2. Bounded on the x-axis to the limits of the outer bounds of the thermodynamic chart. This
     *      means that if the touch is outside the bounds of the chart, then the returned point will
     *      have the same y-value as the user's touch location, but a different x-value.
     *
     */
    func clipToChartBoundary(point: CGPoint,
                             width: CGFloat,
                             height: CGFloat) -> CGPoint {

        // Bounds the touched point to the bounds of the view the touch occurred within.
        // This is essential for the Mac app, because the touch can drag outside the edges of
        // the window if someone clicks within the chart, and then moves their mouse to outside
        // the bounds of the window
        let boundedPoint = CGPoint(x: min(max(point.x, 0.0), width), y: min(max(point.y, 0.0), height))

        let yRatio = boundedPoint.y / height

        // find the index to use with the imageBoundaryLine
        var index = Int(floor(yRatio * CGFloat(chart.imageBoundaryLine!.count)))

        // clamp the index so we don't cause an ArrayOutOfBounds error
        if index >= chart.imageBoundaryLine!.count {
            index = chart.imageBoundaryLine!.count - 1
        } else if index < 0 {
            index = 0
        }

        let xRatio = chart.imageBoundaryLine![index]

        var adjustment = 0.0

        // an adjustment is added to the clipped point which keeps the point within the bounds
        // of the chart, rather than exactly on the bounds of the chart. This is primarily for calculation
        // reasons. The tables don't quite run up to the bounds of the chart, and clipping it in a little
        // prevents nil plot point errors
        switch chart.displayOrientation! {
            case .right:
                adjustment = -5.5 * (width / 1366.0)
            case .left:
                adjustment = 5.5 * (width / 1366.0)
        }

        let x = xRatio * width + adjustment

        var shouldReturnClippedPoint = false

        // we always calculate what the clipped x should be, but we only clip if we're
        // at the bound of the chart. shouldReturnClippedPoint indicates that the point
        // is past the bound
        switch chart.displayOrientation! {
            case .right:
                shouldReturnClippedPoint = boundedPoint.x > x
            case .left:
                shouldReturnClippedPoint = boundedPoint.x < x
        }

        if shouldReturnClippedPoint {
            return CGPoint(x: x, y: boundedPoint.y)
        } else {
            return boundedPoint
        }

    }

    /*
     * This is a common function utilized by both touchDidBegin(:) and touchDidMove(:),
     * which performs logic relavant to all touches on screen. This function should
     * be provided the point where the largeIndicator is drawn on screen, because this
     * function calculates the relevant thermodynamic properties at that point. This means
     * that the point provided should be both clipped to the bounds of the chart as needed,
     * and should having fine-tuning already applied to it (if relevant).
     *
     */
    func touchDidRegister(at location: CGPoint,
                          in locationView: LocationIndicatorImageView) {

        if let xAxis = chart.xAxis, let yAxis = chart.yAxis {

            var xValue = 0.0, yValue = 0.0

            // The following 2 switch statements convert the x and y values from their
            // pixel values to their property values (on T-s, x because s, y becomes T).
            // Some values are logarithmic rather than linear, so the values are converted
            // by scaling logarithmically rather than linearly when appropriate
            switch xAxis.scaleType {
                case .linear:
                    let xScale = (xAxis.max - xAxis.min) / locationView.bounds.width
                    xValue = xAxis.min + xScale * location.x
                case .log:
                    let xScale = (log10(xAxis.max) - log10(xAxis.min)) / locationView.bounds.width
                    xValue = pow(10.0, log10(xAxis.min) + xScale * location.x)
            }

            // NOTE: y on iOS screen and y on graph point are in opposite directions, hence height - y
            //       positive y on iOS is from top to bottom
            switch yAxis.scaleType {
                case .linear:
                    let yScale = (yAxis.max - yAxis.min) / locationView.bounds.height
                    yValue = yAxis.min + yScale * (locationView.bounds.height - location.y)
                case .log:
                    let yScale = (log10(yAxis.max) - log10(yAxis.min)) / locationView.bounds.height
                    yValue = pow(10.0, log10(yAxis.min) + yScale * (locationView.bounds.height - location.y))
            }

            // Calculate the plotPoint using the ThermodynamicCalculator
            // This is the point of calculation for all values displayed in the DisplayView
            let plotPoint = ThermodynamicCalculator.calculateProperties(
                with: xValue,
                and: yValue,
                for: chart.chartType
            )

            if let plotPoint = plotPoint {
                updateDisplayView(with: plotPoint)
            } else {
                print("Nil plot point! -- chartType: \(chart.chartType) -- xValue \(xValue) -- yValue \(yValue)")
            }

        } else {
            print("Chart not properly initialized!")
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
