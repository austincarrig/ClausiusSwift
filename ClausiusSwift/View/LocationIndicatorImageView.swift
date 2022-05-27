//
//  LocationIndicatorImageView.swift
//  ClausiusSwift
//
//  Created by Austin Carrig on 5/26/22.
//

import UIKit

protocol LocationIndicatorImageViewDelegate {
    func touchDidBegin(at location: CGPoint, in locationView: LocationIndicatorImageView)
    func touchDidMove(to location: CGPoint, in locationView: LocationIndicatorImageView)
    func touchDidEnd(at location: CGPoint, in locationView: LocationIndicatorImageView)
}

class LocationIndicatorImageView : UIImageView {

    var delegate: LocationIndicatorImageViewDelegate?

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

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func changeImage(to chartType: ChartType) throws {
        switch chartType {
            case .Ts:
                self.image = UIImage(imageLiteralResourceName: "Water_ts_chart")
            case .Pv:
                throw ClausiusError.invalidChartType
            case .Ph:
                throw ClausiusError.invalidChartType
        }
    }

    // MARK: - Responder Methods

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
    }

}
