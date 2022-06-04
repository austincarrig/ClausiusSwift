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

    let rows : [ValueType:DisplayViewRow] = [
        .t : DisplayViewRow(valueType: .t),
        .p : DisplayViewRow(valueType: .p),
        .v : DisplayViewRow(valueType: .v),
        .u : DisplayViewRow(valueType: .u),
        .h : DisplayViewRow(valueType: .h),
        .s : DisplayViewRow(valueType: .s),
        .x : DisplayViewRow(valueType: .x)
    ]

    lazy var stackView: UIStackView = {
        let _stackView = UIStackView()
        _stackView.alignment = .fill
        _stackView.axis = .vertical
        _stackView.distribution = .fillEqually
        _stackView.spacing = 0.0

        _stackView.addArrangedSubview(rows[.t]!)
        _stackView.addArrangedSubview(rows[.p]!)
        _stackView.addArrangedSubview(rows[.v]!)
        _stackView.addArrangedSubview(rows[.u]!)
        _stackView.addArrangedSubview(rows[.h]!)
        _stackView.addArrangedSubview(rows[.s]!)
        _stackView.addArrangedSubview(rows[.x]!)

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
            make.top.equalTo(titleLabel.snp.bottom) //.offset(10.0) <- if adding this, change displayview height from 340 to 350
        }

        for (_valueType, _row) in rows {
            switch _valueType {
                case .t:
                    continue
                case .p, .v, .u, .h, .s, .x:
                    _row.addBorders(edges: [.top], color: UIColor.clausiusOrange)
            }
        }

    }

    func updateRowValue(for valueType: ValueType, with value: Double) {

        if let row = rows[valueType] {
            row.setValueLabel(to: value)
        }

    }

}
