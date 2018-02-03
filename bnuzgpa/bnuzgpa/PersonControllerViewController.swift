//
//  PersonControllerViewController.swift
//  bnuzgpa
//
//  Created by zl on 2017/12/29.
//  Copyright © 2017年 zl. All rights reserved.
//

import UIKit

class PersonControllerViewController: UIViewController {


    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var logo: EkoImage!
    
    @IBOutlet weak var gpa: UILabel!
    @IBOutlet weak var credit: UILabel!
    @IBOutlet weak var stuid: UILabel!
    @IBOutlet weak var classname: UILabel!
    @IBOutlet weak var major: UILabel!
    @IBOutlet weak var institute: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let si = SingleInstance.defaultSingleInstance()
        stuid.text = si.datas[0]
        name.text = si.datas[1]
        institute.text = si.datas[3]
        major.text = si.datas[4]
        classname.text = si.datas[5]
        credit.text = si.datas[6]
        gpa.text = si.datas[7]
        //logo.onRotation()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
