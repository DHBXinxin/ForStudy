//
//  Demo2_ViewController.swift
//  AFBitMap
//
//  Created by DHSD on 2019/6/4.
//  Copyright © 2019 DHSD. All rights reserved.
//

import UIKit

class Demo2_ViewController: UIViewController {
    var shapeImageView:Demo2_ShapeImageView?
    var views:[UIView]?
    var selectedView:UIView?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "ShapeImageView"
        view.backgroundColor = UIColor.white
        
        // 设置图片view
        let img = UIImage(named: "cat")
        shapeImageView = Demo2_ShapeImageView()
        shapeImageView!.frame = CGRect.init(x: 0, y: 64, width: view.frame.size.width, height: view.frame.size.height - 64)//CGRectMake(0, 64, view.frame.size.width, view.frame.size.height-64)
        shapeImageView!.basicImage = img
        view.addSubview(shapeImageView!)
        
        // 设置可拖动的按钮
        let v0 = UIView(frame: CGRect.init(x: 50, y: 150, width: 20, height: 20))
        let v1 = UIView(frame: CGRect.init(x: 200, y: 150, width: 20, height: 20))
        let v2 = UIView(frame: CGRect.init(x: 200, y: 400, width: 20, height: 20))
        let v3 = UIView(frame: CGRect.init(x: 50, y: 400, width: 20, height: 20))
        views = [v0,v1,v2,v3]
        
        for v in views! {
            v.backgroundColor = UIColor.blue
            view!.addSubview(v)
        }
        
        let arr = [views![0].center,views![1].center,views![2].center,views![3].center]
        shapeImageView!.changeShape(points: arr)
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let t = touches.first
        let p = t!.location(in: view)
        
        // 检测选中的“可拖动按钮”
        for v in views! {
            if v.frame.contains(p) {
                selectedView = v
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let t = touches.first
        let p = t!.location(in: view)
        
        // 更新图片
        selectedView?.center = p
        let arr = [views![0].center,views![1].center,views![2].center,views![3].center]
        shapeImageView!.changeShape(points: arr)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectedView = nil
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
