//
//  SwiftObject.swift
//  AnalyzeObjC
//
//  Created by DHSD on 2018/5/19.
//  Copyright © 2018年 DHSD. All rights reserved.
//

import Foundation
public class ClassA: NSObject{
    public func classLog() {
        print("classlog")
    }
}

class Shape {
    var numberOfSides = 0
    func simpleDescription() -> String {
        return "A shape with \(numberOfSides) sides"
    }
}
//Shape在oc中不能用、会报错、而ClassA就完全可以用
