//
//  MenuViewController.swift
//  bnuzgpa
//
//  Created by zl on 2017/12/27.
//  Copyright © 2017年 zl. All rights reserved.
//

import UIKit

class MenuViewController: UITabBarController {
    //学号账号
    var username:Int = 0
    //学生名字
    var name:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        print("主界面测试学生学号\(username)")
        print("主界面测试学生名字\(self.name)")
        

        // Do any additional setup after loading the view.
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
