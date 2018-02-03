//
//  StudentInfo.swift
//  bnuzgpa
//
//  Created by zl on 2017/12/27.
//  Copyright © 2017年 zl. All rights reserved.
//

import UIKit
class SingleInstance: NSObject {
    
    //0:学号，1:姓名，2:密码,3:学院,4:专业，5:班级，6:总学分，7:学位加权平均分
    //在单例类中，有一个用来共享数据的数组
    var datas:[String] = []
    //创建一个静态或者全局变量，保存当前单例实例值
    private static let singleInstance = SingleInstance()
    //私有化构造方法
    private override init() {
        //给数组加一个原始数据
        //datas.append("SI")
        datas.append("")
        datas.append("")
        datas.append("")
        datas.append("")
        datas.append("")
        datas.append("")
        datas.append("")
        datas.append("")
        //datas[0] = ""
        //datas[1] = ""
        //datas[2] = ""
    }
    
    //提供一个公开的用来去获取单例的方法
    class func defaultSingleInstance() ->SingleInstance {
        //返回初始化好的静态变量值
        return singleInstance
    }
}

