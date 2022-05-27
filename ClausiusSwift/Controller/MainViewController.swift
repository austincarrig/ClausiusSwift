//
//  ViewController.swift
//  ClausiusSwift
//
//  Created by Austin Carrig on 5/22/22.
//

// TODO List:
// - Add infoView (T-s overlay to explain regions)
// - Add spaceController (for fine tuning)

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

    // MARK: - VC Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        view.addSubview(locationIndicatorImageView)

        // locationIndicatorImageView should fill the screen
        locationIndicatorImageView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }

    }

}

// MARK: - LocationIndicatorImageViewDelegate

extension MainViewController: LocationIndicatorImageViewDelegate {

    func touchDidBegin(at location: CGPoint, in locationView: LocationIndicatorImageView) {
        touchHadRegistered = true

        // add large indicator at point to locationView

        // update spaceController

        // reset fine-tuning flag (should probably move this to a resetFlagsAndInds() function...)

        // set lastTouchLocation = location

        
    }

    func touchDidMove(to location: CGPoint, in locationView: LocationIndicatorImageView) {

    }

    func touchDidEnd(at location: CGPoint, in locationView: LocationIndicatorImageView) {

        // add small indicator at point to locationView

        // reset spaceController

    }

}
