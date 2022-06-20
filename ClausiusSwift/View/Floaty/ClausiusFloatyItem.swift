//
//  ClausiusFloatyItem.swift
//  ClausiusSwift
//
//  Created by Austin Carrig on 6/15/22.
//

import UIKit

class ClausiusFloatyItem : FloatyItem {

    var isSelected: Bool = false {
        didSet {
            if isSelected {
                self.shouldDrawInnerCircle = true
                self.innerTitleLabel.textColor = .white
                self.setNeedsDisplay()
            } else {
                self.shouldDrawInnerCircle = false
                self.innerTitleLabel.textColor = .clausiusOrange
                self.setNeedsDisplay()
            }
        }
    }

    public override init() {
        super.init()

        innerTitleFont = UIFont(name: "HelveticaNeue-LightItalic", size: 16.0)
        innerTitleLabel.textColor = .clausiusOrange
        primaryColor = .clausiusOrange
        hasShadow = false
    }

    public convenience init(innerTitle: String) {
        self.init()

        self.innerTitle = innerTitle
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}

extension ClausiusFloatyItem {
    static func ==(lhs: ClausiusFloatyItem, rhs: ClausiusFloatyItem) -> Bool {
        return lhs.innerTitle == rhs.innerTitle
    }
}
