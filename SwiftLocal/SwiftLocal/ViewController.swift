//
//  ViewController.swift
//  SwiftLocal
//
//  Created by 李欣欣 on 2021/3/30.
//

import UIKit

class ViewController: UIViewController {

    var label: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        label?.center = self.view.center
        label?.textAlignment = NSTextAlignment.center
        self.view.addSubview(label!)
//        label?.text = NSLocalizedString("I love qiqi", tableName: "Name", bundle: Bundle.main, value: "", comment: "")
        //第一个关键字、第二个strings文件名字、第三个文件位置、第四个默认值--只有两个参数的情况下、默认值就是第一个参数、第五个是无关紧要的参数、或者是为了让自己更明白这个字符串是做什么用、不写关系不大
        label?.text = NSLocalizedString("I love qiqi", comment: "")//默认名字为Localizable
    }
//InfoPlist内如果不知道关键字是什么可以再info.plist内查看、查看方式为：
//右键点击--选择Raw Keys & Value

}

