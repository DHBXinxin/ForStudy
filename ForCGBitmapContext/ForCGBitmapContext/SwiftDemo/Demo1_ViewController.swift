//
//  Demo1_ViewController.swift
//  AFBitMap
//
//  Created by DHSD on 2019/6/4.
//  Copyright © 2019 DHSD. All rights reserved.
//

import UIKit

class Demo1_ViewController: UIViewController {

    var resultView:UIButton?
    var imgView:UIImageView?
    var pointView:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "ColorPicker"
        
        // 图片view
        let img = UIImage(named: "cat")
        let imgFrame = CGRect.init(x: 0, y: 64, width: view.frame.size.width, height: view.frame.size.height - 114 - 20)// CGRectMake(0, 64, view.frame.size.width, view.frame.size.height-114)
        imgView = UIImageView(frame: imgFrame)
        imgView!.image = img
        view.addSubview(imgView!)
        
        // 结果view
        let resultFrame = CGRect.init(x: 0, y: view.frame.size.height-50, width: view.frame.size.width, height: 50)//CGRectMake(0, view.frame.size.height-50, view.frame.size.width, 50)
        resultView = UIButton(frame: resultFrame)
        resultView!.backgroundColor = UIColor.white
        view.addSubview(resultView!)
        // 结果view的颜色
        resultView!.setTitle("Color", for: .normal)
//        resultView!.setTitle("Current Color ", forState: .Normal)
        resultView!.titleEdgeInsets = UIEdgeInsets.init(top: 20, left: 0, bottom: 0, right: 0)//UIEdgeInsetsMake(20, 0, 0, 0)
        resultView!.setTitleColor(UIColor.black, for: .normal)
        resultView!.titleLabel!.font = UIFont(name: "Zapfino", size: 18)
        // 结果view的边框
        resultView!.layer.bounds = resultView!.bounds
        resultView!.layer.borderWidth = 3
        resultView!.layer.borderColor = UIColor.cyan.cgColor
        
        // 当前选中位置的view
        pointView = UIView(frame: CGRect.init(x: 0, y: 0, width: 20, height: 20))
        let showLayer = CAShapeLayer()
        let path = UIBezierPath(roundedRect: CGRect.init(x: 0, y: 0, width: 20, height: 20), cornerRadius: 10)
        showLayer.path = path.cgPath
        showLayer.fillColor = UIColor.clear.cgColor
        showLayer.strokeColor = UIColor.blue.cgColor
        showLayer.lineWidth = 2
        pointView!.layer.addSublayer(showLayer)
        imgView!.addSubview(pointView!)
        
        // 根据起始位置设置颜色
        changeCurrentColor(point: pointView!.center)
    }
    func  changeCurrentColor(point:CGPoint){
        
        // 获取图片大小
        let imgWidth = CGFloat(imgView!.image!.cgImage!.width)//CGFloat(CGImageGetWidth(imgView!.image!.CGImage))
        let imgHeight = CGFloat(imgView!.image!.cgImage!.height)//CGFloat(CGImageGetHeight(imgView!.image!.CGImage))
        
        // 当前点在图片中的相对位置
        let pInImage = CGPoint.init(x: point.x * imgWidth / imgView!.bounds.size.width, y: point.y * imgHeight / imgView!.bounds.size.height)//CGPointMake(point.x * imgWidth / imgView!.bounds.size.width,
                                   //point.y * imgHeight / imgView!.bounds.size.height)
        
        // 获取并设置颜色
        resultView!.backgroundColor = Demo1_ColorPicker.getColor(point: pInImage, image: imgView!.image!)// Demo1_ColorPicker.getColor(pInImage, image: imgView!.image!)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 根据手指位置设置颜色
        let touch = touches.first
        let p = touch!.location(in: imgView!)
        pointView!.center = p
        changeCurrentColor(point: p)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 根据手指位置设置颜色
        let touch = touches.first
        let p = touch!.location(in: imgView!)
        pointView!.center = p
        changeCurrentColor(point: p)
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
