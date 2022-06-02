//
//  DisplayViewRow.swift
//  ClausiusSwift
//
//  Created by Austin Carrig on 6/2/22.
//

import UIKit
import SnapKit

// display view
// height 350.0
// width 225.0

// CSS
// row 36 pixels high
// row width name 14%
// row width spacing1 9%
// row width value 35%
// row width spacing2 7%
// row width units 35%

class DisplayViewRow : UIView {

    var nameLabel = UILabel(frame: CGRect.zero)
    var spacingView1 = UIView(frame: CGRect.zero)
    var valueLabel = UILabel(frame: CGRect.zero)
    var spacingView2 = UIView(frame: CGRect.zero)
    var unitsLabel = UILabel(frame: CGRect.zero)

    override func didMoveToSuperview() {

        self.addSubview(nameLabel)
        self.addSubview(spacingView1)
        self.addSubview(valueLabel)
        self.addSubview(spacingView2)
        self.addSubview(unitsLabel)

        nameLabel.backgroundColor = .red
        valueLabel.backgroundColor = .orange
        unitsLabel.backgroundColor = .yellow

        nameLabel.snp.makeConstraints { make in
            make.top.bottom.left.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.14)
        }

        spacingView1.snp.makeConstraints { make in
            make.top.bottom.equalTo(nameLabel)
            make.left.equalTo(nameLabel.snp.right)
            make.width.equalToSuperview().multipliedBy(0.09)
        }

        valueLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(spacingView1)
            make.left.equalTo(spacingView1.snp.right)
            make.width.equalToSuperview().multipliedBy(0.35)
        }

        spacingView2.snp.makeConstraints { make in
            make.top.bottom.equalTo(valueLabel)
            make.left.equalTo(valueLabel.snp.right)
        }

        unitsLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(spacingView2)
            make.left.equalTo(spacingView2.snp.right)
            make.width.equalToSuperview().multipliedBy(0.35)
            make.right.equalToSuperview()
        }

    }

}
