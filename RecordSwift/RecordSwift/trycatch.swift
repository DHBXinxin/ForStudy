//
//  trycatch.swift
//  RecordSwift
//
//  Created by 李欣欣 on 2021/11/4.
//

import Foundation

class ForTry {
    let data:Data? = nil
    
    func handleData() {
        
        do {
            let anyObj = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
            print(anyObj)
        } catch {
            print(error)
        }
        
        
        guard let anyObj = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) else {
            return
        }
        //没有guard就需要自己if判断了
        let anyGo = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
        if anyGo == nil {
            return
        }
        //guard的一句可以代表if的两句，看习惯，不较真儿，爱怎么写就怎么写
        
        //第卅、告诉程序一定不会出现异常、但是出现了就会崩溃
        let anyOne = try! JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
    }
}
