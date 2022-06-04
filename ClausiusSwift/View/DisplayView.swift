//
//  DisplayView.swift
//  ClausiusSwift
//
//  Created by Austin Carrig on 6/2/22.
//

import UIKit
import SnapKit

class DisplayView : UIView {

    lazy var titleLabel: UILabel = {
        let _label = UILabel(frame: CGRect.zero)
        _label.font = UIFont(name: "HelveticaNeue-UltraLight", size: 80.0)
        _label.textColor = UIColor.black.withAlphaComponent(0.5)
        _label.textAlignment = .center
        _label.numberOfLines = 1
        _label.text = "Water"
        return _label
    }()

    lazy var stackView: UIStackView = {
        let _stackView = UIStackView()
        _stackView.alignment = .fill
        _stackView.axis = .vertical
        _stackView.distribution = .fillEqually
        _stackView.spacing = 0.0

        _stackView.addArrangedSubview(DisplayViewRow(valueType: .t))
        _stackView.addArrangedSubview(DisplayViewRow(valueType: .p))
        _stackView.addArrangedSubview(DisplayViewRow(valueType: .v))
        _stackView.addArrangedSubview(DisplayViewRow(valueType: .u))
        _stackView.addArrangedSubview(DisplayViewRow(valueType: .h))
        _stackView.addArrangedSubview(DisplayViewRow(valueType: .s))
        _stackView.addArrangedSubview(DisplayViewRow(valueType: .x))

        return _stackView
    }()

    override func didMoveToSuperview() {

        self.addSubview(titleLabel)
        self.addSubview(stackView)

        let size = (titleLabel.text! as NSString).size(withAttributes: [NSAttributedString.Key.font:self.titleLabel.font!])

        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(size.height)
        }

        stackView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
        }

    }

}
