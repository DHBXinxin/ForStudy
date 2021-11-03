//
//  AddExtention.swift
//  RecordSwift
//
//  Created by 李欣欣 on 2021/11/3.
//

import Foundation
import QuartzCore
import UIKit


public extension CALayer {

    //只能这么添加属性
    private struct AssociatedKey {

        static var shadowUIColor:String = "shadowUIColor"

        static var borderUIColor:String = "borderUIColor"
    }
    var borderUIColor:UIColor {
        get {
            return UIColor.init(cgColor: self.borderColor!)
//            return objc_getAssociatedObject(self, &AssociatedKey.borderUIColor) as? UIColor ?? UIColor.white
        }
        set {
            self.borderColor = newValue.cgColor
//            objc_setAssociatedObject(self, &AssociatedKey.borderUIColor, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    var shadowUIColor:UIColor {
        get {
            return UIColor.init(cgColor: self.shadowColor!)
//            return objc_getAssociatedObject(self, &AssociatedKey.shadowUIColor) as? UIColor ?? UIColor.white
        }
        set {
            self.shadowColor = newValue.cgColor
//            objc_setAssociatedObject(self, &AssociatedKey.shadowUIColor, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
}
