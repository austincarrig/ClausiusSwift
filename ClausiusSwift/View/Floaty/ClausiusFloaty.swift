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

        buttonColor = .white
        buttonBorderColor = .clausiusOrange
        menuButtonColor = .clausiusOrange
        hasShadow = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public func makeItemSelected(_ item: ClausiusFloatyItem) {

        for i in items {
            if let clausiusItem = i as? ClausiusFloatyItem {
                if item == clausiusItem {
                    clausiusItem.isSelected = true
                } else {
                    clausiusItem.isSelected = false
                }
            }
        }

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

    /**
     Add item with innerTitle and handler.
     */
    @discardableResult
    @objc open func addSelectedItem(innerTitle: String, handler: @escaping ((FloatyItem) -> Void)) -> FloatyItem {
        let item = addItem(innerTitle: innerTitle, handler: handler)
        (item as! ClausiusFloatyItem).isSelected = true
        return item
    }

}
