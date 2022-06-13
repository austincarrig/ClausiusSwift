//
//  LocationIndicatorImageView.swift
//  ClausiusSwift
//
//  Created by Austin Carrig on 5/26/22.
//

import CoreGraphics
import UIKit
import SnapKit

protocol LocationIndicatorImageViewDelegate {
    func touchDidBegin(at location: CGPoint, in locationView: LocationIndicatorImageView)
    func touchDidMove(to location: CGPoint, in locationView: LocationIndicatorImageView)
    func touchDidEnd(at location: CGPoint, in locationView: LocationIndicatorImageView)
}

class LocationIndicatorImageView : UIImageView {

    let innerRadius: CGFloat = 6.5
    let smallOuterRadius: CGFloat = 9.0
    let largeOuterRadius: CGFloat = 60.0

    let smallOuterLineWidth: CGFloat = 0.75
    let largeOuterLineWidth: CGFloat = 5.0

    let hitmarkerLength: CGFloat = 25.0
    let hitmarkerLineWidth: CGFloat = 1.0

    let imageRadius: CGFloat = 34.0

    var delegate: LocationIndicatorImageViewDelegate?

    lazy var locationIndicatorRingLayer: CAShapeLayer = {
        let _layer = CAShapeLayer()
        _layer.fillColor = UIColor.clear.cgColor
        _layer.strokeColor = UIColor.clausiusOrange.withAlphaComponent(0.8).cgColor
        _layer.rasterizationScale = 2.0 * UIScreen.screens.first!.scale
        _layer.shouldRasterize = true
        return _layer
    }()

    lazy var locationIndicatorCircleLayer: CAShapeLayer = {
        let _layer = CAShapeLayer()
        _layer.fillColor = UIColor.orange.withAlphaComponent(0.8).cgColor
        _layer.strokeColor = UIColor.clear.cgColor
        _layer.rasterizationScale = 2.0 * UIScreen.screens.first!.scale
        _layer.shouldRasterize = true
        return _layer
    }()

    lazy var locationIndicatorHitmarkerLayer: CAShapeLayer = {
        let _layer = CAShapeLayer()
        _layer.fillColor = UIColor.clear.cgColor
        _layer.strokeColor = UIColor.clausiusOrange.withAlphaComponent(0.8).cgColor
        _layer.lineWidth = hitmarkerLineWidth
        _layer.rasterizationScale = 2.0 * UIScreen.screens.first!.scale
        _layer.shouldRasterize = true
        return _layer
    }()

    init(frame: CGRect,
         chartType: ChartType) {

        super.init(frame: frame)

        do {
            try self.changeImage(to: chartType)
        } catch ClausiusError.invalidChartType {
            print("Attempted to initialize LocationIndicatorImageView with invalid ChartType")
        } catch {
            print("Unexpected error")
        }

        self.isUserInteractionEnabled = true

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func changeImage(to chartType: ChartType) throws {
        switch chartType {
            case .Ts:
                self.image = UIImage(imageLiteralResourceName: "Water_ts_chart")
            case .Pv:
                self.image = UIImage(imageLiteralResourceName: "Water_pv_chart")
            case .Ph:
                self.image = UIImage(imageLiteralResourceName: "Water_ph_chart")
        }
    }

    // MARK: - Responder Methods

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        // touches is only for this UIResponder
        // event.allTouches is all touches for the event, which can contain multiple UIResponders

        if touches.count == 1 {
            let touchLocation = touches.first?.location(in: self)

            if let delegate = delegate {
                delegate.touchDidBegin(at: touchLocation ?? CGPoint.zero, in: self)
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)

        if touches.count == 1 {
            let touchLocation = touches.first?.location(in: self)

            if let delegate = delegate {
                delegate.touchDidMove(to: touchLocation ?? CGPoint.zero, in: self)
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        if touches.count == 1 {
            let touchLocation = touches.first?.location(in: self)

            if let delegate = delegate {
                delegate.touchDidEnd(at: touchLocation ?? CGPoint.zero, in: self)
            }
        }
    }

    // MARK: - Drawing

    func drawLargeIndicator(at location: CGPoint) {
        clearLayers()

        drawInnerCircle(at: location)

        drawRing(
            at: location,
            with: largeOuterRadius,
            and: largeOuterLineWidth
        )

        drawHitmarkers(at: location)
    }

    func drawSmallIndicator(at location: CGPoint) {
        clearLayers()

        drawInnerCircle(at: location)

        drawRing(
            at: location,
            with: smallOuterRadius,
            and: smallOuterLineWidth
        )
    }

    func removeIndicators() {
        clearLayers()
    }

    private func clearLayers() {
        locationIndicatorRingLayer.removeFromSuperlayer()
        locationIndicatorCircleLayer.removeFromSuperlayer()
        locationIndicatorHitmarkerLayer.removeFromSuperlayer()
    }

    private func drawInnerCircle(at location: CGPoint) {

        let circle = UIBezierPath.init(arcCenter: location,
                                       radius: innerRadius,
                                       startAngle: 0.0,
                                       endAngle: 2.0*CGFloat.pi,
                                       clockwise: true)

        locationIndicatorCircleLayer.path = circle.cgPath

        self.layer.addSublayer(locationIndicatorCircleLayer)

    }

    private func drawRing(at location: CGPoint,
                          with radius: CGFloat,
                          and lineWidth: CGFloat) {

        let ring = UIBezierPath.init(arcCenter: location,
                                     radius: radius,
                                     startAngle: 0.0,
                                     endAngle: 2.0*CGFloat.pi,
                                     clockwise: true)

        locationIndicatorRingLayer.lineWidth = lineWidth
        locationIndicatorRingLayer.path = ring.cgPath

        self.layer.addSublayer(locationIndicatorRingLayer)

    }

    private func drawHitmarkers(at location: CGPoint) {

        let hitmarkers = CGMutablePath()

        // top hitmarker
        drawLine(
            from: CGPoint(x: location.x, y: location.y - largeOuterRadius),
            to: CGPoint(x: location.x, y: location.y - largeOuterRadius + hitmarkerLength),
            with: hitmarkers
        )

        // bottom hitmarker
        drawLine(
            from: CGPoint(x: location.x, y: location.y + largeOuterRadius),
            to: CGPoint(x: location.x, y: location.y + largeOuterRadius - hitmarkerLength),
            with: hitmarkers
        )

        // left hitmarker
        drawLine(
            from: CGPoint(x: location.x - largeOuterRadius, y: location.y),
            to: CGPoint(x: location.x - largeOuterRadius + hitmarkerLength, y: location.y),
            with: hitmarkers
        )

        // right hitmarker
        drawLine(
            from: CGPoint(x: location.x + largeOuterRadius, y: location.y),
            to: CGPoint(x: location.x + largeOuterRadius - hitmarkerLength, y: location.y),
            with: hitmarkers
        )

        locationIndicatorHitmarkerLayer.path = hitmarkers

        self.layer.addSublayer(locationIndicatorHitmarkerLayer)

    }

    private func drawLine(from point1: CGPoint,
                          to point2: CGPoint,
                          with path: CGMutablePath) {

        path.move(to: point1)
        path.addLine(to: point2)
        path.closeSubpath()

    }

}
