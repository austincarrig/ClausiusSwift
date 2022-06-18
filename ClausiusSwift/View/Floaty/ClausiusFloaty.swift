//
//  ClausiusFloaty.swift
//  ClausiusSwift
//
//  Created by Austin Carrig on 6/15/22.
//

import UIKit

class ClausiusFloaty : Floaty {

    override init(frame: CGRect) {
        super.init(frame: frame)

        buttonColor = .clausiusOrange
        hasShadow = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /**
     Add item with innerTitle and handler.
     */
    @discardableResult
    @objc open func addItem(innerTitle: String, handler: @escaping ((FloatyItem) -> Void)) -> FloatyItem {
        let item = ClausiusFloatyItem(innerTitle: innerTitle)
        itemDefaultSet(item)
        item.handler = handler
        addItem(item: item)
        return item
    }

}
