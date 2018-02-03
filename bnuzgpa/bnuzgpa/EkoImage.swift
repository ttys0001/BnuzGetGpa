//
//  EkoImage.swift
//  dbfm1
//
//  Created by zl on 2017/12/19.
//  Copyright © 2017年 zl. All rights reserved.
//

import UIKit

class EkoImage: UIImageView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //设置圆角
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.width/2
        
        //边框
        self.layer.borderWidth = 4
        self.layer.borderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.7).cgColor
        
    }


}
