//
//  ViewController.swift
//  ClausiusSwift
//
//  Created by Austin Carrig on 5/22/22.
//

// TODO List:
// - Add infoView (T-s overlay to explain regions)

import UIKit
import SnapKit

class MainViewController: UIViewController {

    var locationIndicatorImageView = LocationIndicatorImageView(frame: CGRect.zero, chartType: .Ts)

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

