//
//  ClausiusFloatyItem.swift
//  ClausiusSwift
//
//  Created by Austin Carrig on 6/15/22.
//

import UIKit

class ClausiusFloatyItem : FloatyItem {

    public override init() {
        super.init()

        innerTitleFont = UIFont(name: "HelveticaNeue-LightItalic", size: 16.0)
        innerTitleLabel.textColor = .clausiusOrange
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
