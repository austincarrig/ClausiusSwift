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

    let labelFont = UIFont(name: "HelveticaNeue-Light", size: 16.0)
    let labelFontItalic = UIFont(name: "HelveticaNeue-LightItalic", size: 16.0)

    lazy var nameLabel : UILabel = {
        let _label = UILabel(frame: CGRect.zero)
        _label.font = labelFontItalic
        _label.textColor = .black
        _label.textAlignment = .center
        return _label
    }()

    lazy var valueLabel : UILabel = {
        let _label = UILabel(frame: CGRect.zero)
        _label.font = labelFont
        _label.textColor = .black
        _label.textAlignment = .left
        return _label
    }()

    lazy var unitsLabel : UILabel = {
        let _label = UILabel(frame: CGRect.zero)
        _label.font = labelFont
        _label.textColor = .black
        _label.textAlignment = .left
        return _label
    }()

    var spacingView1 = UIView(frame: CGRect.zero)
    var spacingView2 = UIView(frame: CGRect.zero)

    var valueType: ValueType

    init(valueType: ValueType) {

        self.valueType = valueType

        super.init(frame: CGRect.zero)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToSuperview() {

        // Add subviews
        self.addSubview(nameLabel)
        self.addSubview(spacingView1)
        self.addSubview(valueLabel)
        self.addSubview(spacingView2)
        self.addSubview(unitsLabel)

        // Set label text
        setNameLabelText()
        setValueLabel(to: nil)
        setDefaultUnitsLabelText()

        // Add subview constraints
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

    func setValueLabel(to value: Double?) {

        var valueStr = ""

        if let value = value {
            var finalValue: Double = value
            var formatString = "%.1f"

            switch valueType {
                case .t, .u, .h, .x:
                    break
                case .p:
                    if finalValue >= 1000.0 {
                        finalValue = finalValue / 1000.0
                        unitsLabel.text = "MPa"
                    } else {
                        unitsLabel.text = "kPa"
                    }
                case .v:
                    if finalValue < 10.0 {
                        formatString = "%.4f"
                    } else {
                        formatString = "%.3f"
                    }
                case .s:
                    formatString = "%.2f"
            }

            valueStr = String(format: formatString, finalValue)
        }

        valueLabel.text = valueStr

    }

    private func setNameLabelText() {

        var name = ""

        switch valueType {
            case .t:
                name = "T"
            case .p:
                name = "P"
            case .v:
                name = "v"
            case .u:
                name = "u"
            case .h:
                name = "h"
            case .s:
                name = "s"
            case .x:
                name = "x"
        }

        nameLabel.text = name

    }

    private func setDefaultUnitsLabelText() {

        var units = ""

        switch valueType {
            case .t:
                units = "℃"
            case .p:
                units = "kPa"
            case .v:
                units = "m3/kg"
            case .u, .h:
                units = "kJ/kg"
            case .s:
                units = "kJ/kg.K"
            case .x:
                units = "%"
        }

        switch valueType {
            case .t, .p, .u, .h, .s, .x:
                unitsLabel.text = units
            case .v:

                if let labelFont = labelFont {
                    let attrString: NSMutableAttributedString = NSMutableAttributedString(string: units,
                                                                                          attributes: [NSMutableAttributedString.Key.font : labelFont])

                    if let range = units.rangeOfCharacter(from: CharacterSet.decimalDigits) {
                        attrString.setAttributes([NSMutableAttributedString.Key.baselineOffset : 5,
                                                  NSMutableAttributedString.Key.font : labelFont.withSize(10.0)],
                                                 range: NSRange(range, in: units))
                    }
                    unitsLabel.attributedText = attrString
                } else {
                    unitsLabel.text = units
                }
        }

    }

    // Got this off StackOverflow... lots of unnecessary code, but on the other hand who cares
    @discardableResult
    func addBorders(edges: UIRectEdge,
                    color: UIColor,
                    inset: CGFloat = 0.0,
                    thickness: CGFloat = 1.0) -> [UIView] {

        var borders = [UIView]()

        @discardableResult
        func addBorder(formats: String...) -> UIView {
            let border = UIView(frame: .zero)
            border.backgroundColor = color
            border.translatesAutoresizingMaskIntoConstraints = false
            addSubview(border)
            addConstraints(formats.flatMap {
                NSLayoutConstraint.constraints(withVisualFormat: $0,
                                               options: [],
                                               metrics: ["inset": inset, "thickness": thickness],
                                               views: ["border": border]) })
            borders.append(border)
            return border
        }


        if edges.contains(.top) || edges.contains(.all) {
            addBorder(formats: "V:|-0-[border(==thickness)]", "H:|-inset-[border]-inset-|")
        }

        if edges.contains(.bottom) || edges.contains(.all) {
            addBorder(formats: "V:[border(==thickness)]-0-|", "H:|-inset-[border]-inset-|")
        }

        if edges.contains(.left) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:|-0-[border(==thickness)]")
        }

        if edges.contains(.right) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:[border(==thickness)]-0-|")
        }

        return borders
    }

}
