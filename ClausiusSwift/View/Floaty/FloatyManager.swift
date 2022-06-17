//
//  FloatyManager.swift
//
//  Created by LeeSunhyoup on 2015. 10. 13..
//  Copyright © 2015년 kciter. All rights reserved.
//

import UIKit

/**
 Floaty dependent on UIWindow.
 */
open class FloatyManager: NSObject {
    private static var __once: () = {
        StaticInstance.instance = FloatyManager()
    }()
    struct StaticInstance {
        static var dispatchToken: Int = 0
        static var instance: FloatyManager?
    }

    class func defaultInstance() -> FloatyManager {
        _ = FloatyManager.__once
        return StaticInstance.instance!
    }

    private let fontDescriptor: UIFontDescriptor
    private var _font: UIFont
    
    public override init() {
        fontDescriptor = UIFont.systemFont(ofSize: 20.0).fontDescriptor
        _font = UIFont(descriptor: fontDescriptor, size: 20)
    }

    open var font: UIFont {
        get {
            return _font
        }
        set {
            _font = newValue
        }
    }

    private var _rtlMode = false
    open var rtlMode: Bool {
        get {
            return _rtlMode
        }
        set{
            _rtlMode = newValue
        }
    }
}
