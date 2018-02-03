//
//  ViewController.swift
//  bnuzgpa
//
//  Created by zl on 2017/12/22.
//  Copyright © 2017年 zl. All rights reserved.
//
import Alamofire
import UIKit
import SwiftyJSON

class ViewController: UIViewController, UITextFieldDelegate {
    //教务系统头部数据
    var accept:String = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8"
    //登录时需要的参数
    var VIEWSTATE = ""
    var PREVIOUSPAGE = ""
    var EVENTVALIDATION = ""
    //登录按钮
    @IBAction func loginButton(_ sender: Any) {
        getParamater()
        //login()
    }
    //用户密码输入框
    var txtUser:UITextField!
    var txtPwd:UITextField!
    
    //左手离脑袋的距离
    var offsetLeftHand:CGFloat = 60
    
    //左手图片,右手图片(遮眼睛的)
    var imgLeftHand:UIImageView!
    var imgRightHand:UIImageView!
    
    //左手图片,右手图片(圆形的)
    var imgLeftHandGone:UIImageView!
    var imgRightHandGone:UIImageView!
    
    //登录框状态
    var showType:LoginShowType = LoginShowType.none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //获取屏幕尺寸
        let mainSize = UIScreen.main.bounds.size
        
        //猫头鹰头部
        let imgLogin =  UIImageView(frame:CGRect(x: mainSize.width/2-211/2, y: 100, width: 211, height: 109))
        imgLogin.image = UIImage(named:"owl-login")
        imgLogin.layer.masksToBounds = true
        self.view.addSubview(imgLogin)
        
        //猫头鹰左手(遮眼睛的)
        let rectLeftHand = CGRect(x: 61 - offsetLeftHand, y: 90, width: 40, height: 65)
        imgLeftHand = UIImageView(frame:rectLeftHand)
        imgLeftHand.image = UIImage(named:"owl-login-arm-left")
        imgLogin.addSubview(imgLeftHand)
        
        //猫头鹰右手(遮眼睛的)
        let rectRightHand = CGRect(x: imgLogin.frame.size.width / 2 + 60, y: 90, width: 40, height: 65)
        imgRightHand = UIImageView(frame:rectRightHand)
        imgRightHand.image = UIImage(named:"owl-login-arm-right")
        imgLogin.addSubview(imgRightHand)
        
        //登录框背景
        let vLogin =  UIView(frame:CGRect(x: 15, y: 200, width: mainSize.width - 30, height: 160))
        vLogin.layer.borderWidth = 0.5
        vLogin.layer.borderColor = UIColor.lightGray.cgColor
        vLogin.backgroundColor = UIColor.white
        self.view.addSubview(vLogin)
        
        //猫头鹰左手(圆形的)
        let rectLeftHandGone = CGRect(x: mainSize.width / 2 - 100,
                                      y: vLogin.frame.origin.y - 22, width: 40, height: 40)
        imgLeftHandGone = UIImageView(frame:rectLeftHandGone)
        imgLeftHandGone.image = UIImage(named:"icon_hand")
        self.view.addSubview(imgLeftHandGone)
        
        //猫头鹰右手(圆形的)
        let rectRightHandGone = CGRect(x: mainSize.width / 2 + 62,
                                       y: vLogin.frame.origin.y - 22, width: 40, height: 40)
        imgRightHandGone = UIImageView(frame:rectRightHandGone)
        imgRightHandGone.image = UIImage(named:"icon_hand")
        self.view.addSubview(imgRightHandGone)
        
        //用户名输入框
        txtUser = UITextField(frame:CGRect(x: 30, y: 30, width: vLogin.frame.size.width - 60, height: 44))
        txtUser.delegate = self
        txtUser.layer.cornerRadius = 5
        txtUser.layer.borderColor = UIColor.lightGray.cgColor
        txtUser.layer.borderWidth = 0.5
        txtUser.leftView = UIView(frame:CGRect(x: 0, y: 0, width: 44, height: 44))
        txtUser.leftViewMode = UITextFieldViewMode.always
        
        //用户名输入框左侧图标
        let imgUser =  UIImageView(frame:CGRect(x: 11, y: 11, width: 22, height: 22))
        imgUser.image = UIImage(named:"iconfont-user")
        txtUser.leftView!.addSubview(imgUser)
        vLogin.addSubview(txtUser)
        
        //密码输入框
        txtPwd = UITextField(frame:CGRect(x: 30, y: 90, width: vLogin.frame.size.width - 60, height: 44))
        txtPwd.delegate = self
        txtPwd.layer.cornerRadius = 5
        txtPwd.layer.borderColor = UIColor.lightGray.cgColor
        txtPwd.layer.borderWidth = 0.5
        txtPwd.isSecureTextEntry = true
        txtPwd.leftView = UIView(frame:CGRect(x: 0, y: 0, width: 44, height: 44))
        txtPwd.leftViewMode = UITextFieldViewMode.always
        
        //密码输入框左侧图标
        let imgPwd =  UIImageView(frame:CGRect(x: 11, y: 11, width: 22, height: 22))
        imgPwd.image = UIImage(named:"iconfont-password")
        txtPwd.leftView!.addSubview(imgPwd)
        vLogin.addSubview(txtPwd)
        
        txtUser.text = ""
        txtPwd.text = ""
    }
    //得到同学名字
    func getName(webText:String,user:String)->(String){
        let startRange = webText.range(of: "id=\"xhxm\">\(user)  ")
        let endRange = webText.range(of: "同学")
        let searchRange = (startRange?.upperBound)! ..< (endRange?.lowerBound)!
        let result = webText.substring(with: searchRange)
        print("名字是：\(result)")
        return result
    }
    
    func getParamater(){
        let url = "http://es.bnuz.edu.cn/"
        //头部数据
        let headers: HTTPHeaders = [
            "Upgrade-Insecure-Requests":"1",
            "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84 Safari/537.36"
        ]
        Alamofire.request(url, encoding: URLEncoding.default,headers:headers)
            .responseString  { response in
                debugPrint(response)
                if (response.result.isSuccess) {
                    let data = response.result.value
                    print("Data: \(String(describing: data))") // original server data as UTF8 string
                    //得到VIEWSTATE
                    var startRange = data?.range(of: "id=\"__VIEWSTATE\" value=\"")
                    var searchRange = (startRange?.upperBound)! ..< (data?.endIndex)!
                    self.VIEWSTATE = (data?.substring(with: searchRange))!
                    var startRange1 = self.VIEWSTATE.range(of: "\" />")
                    var searchRange1 =  self.VIEWSTATE.startIndex ..< (startRange1?.lowerBound)!
                    self.VIEWSTATE = self.VIEWSTATE.substring(with: searchRange1)
                    print("aa\(self.VIEWSTATE)aa")
                    //得到PREVIOUSPAGE
                    startRange = data?.range(of: "id=\"__PREVIOUSPAGE\" value=\"")
                    searchRange = (startRange?.upperBound)! ..< (data?.endIndex)!
                    self.PREVIOUSPAGE = (data?.substring(with: searchRange))!
                    startRange1 = self.PREVIOUSPAGE.range(of: "\" />")
                    searchRange1 =  self.PREVIOUSPAGE.startIndex ..< (startRange1?.lowerBound)!
                    self.PREVIOUSPAGE = self.PREVIOUSPAGE.substring(with: searchRange1)
                    print("aa\(self.PREVIOUSPAGE)aa")
                    //得到EVENTVALIDATION
                    startRange = data?.range(of: "id=\"__EVENTVALIDATION\" value=\"")
                    searchRange = (startRange?.upperBound)! ..< (data?.endIndex)!
                    self.EVENTVALIDATION = (data?.substring(with: searchRange))!
                    startRange1 = self.EVENTVALIDATION.range(of: "\" />")
                    searchRange1 =  self.EVENTVALIDATION.startIndex ..< (startRange1?.lowerBound)!
                    self.EVENTVALIDATION = self.EVENTVALIDATION.substring(with: searchRange1)
                    print("aa\(self.EVENTVALIDATION)aa")
                    self.login()
                }
                else
                {
                    let message = "网络请求失败"
                    self.view.makeToast(message: message, duration: 0.5, position: "center" as AnyObject)
                }
        }
    }
    
    func login(){
        //账号密码
        let user = txtUser.text!
        let password = txtPwd.text!
        //登陆成功失败提示信息
        var message:String = ""
        //登录参数
        let parameters: Parameters = [
            "__EVENTTARGET": "",
            "__EVENTARGUMENT": "",
            "__VIEWSTATE":
            "\(self.VIEWSTATE)",
            "__VIEWSTATEGENERATOR": "09394A33",
            "__PREVIOUSPAGE": "\(self.PREVIOUSPAGE)",
            "__EVENTVALIDATION": "\(self.EVENTVALIDATION)",
            "TextBox1": user ,
            "TextBox2": password,
            "RadioButtonList1": "学生",
            "Button4_test": ""
        ]
        //模拟登录
        Alamofire.request("http://es.bnuz.edu.cn/default2.aspx", method: .post, parameters: parameters, encoding: URLEncoding.default)
            .responseData  { response in
                debugPrint(response)
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)") // original server data as UTF8 string
                    if(utf8Text.contains("欢迎您：<span id=\"xhxm\">\(user)")){
                        let name:String = self.getName(webText: utf8Text,user: user)
                        message = "登陆成功!\n欢迎\n\(name)同学"
                        self.view.makeToast(message: message, duration: 0.5, position: "center" as AnyObject)
                        //设置延时1秒执行
                        let time:TimeInterval = 1.0
                        DispatchQueue.main.asyncAfter(deadline:DispatchTime.now() + time) {
                            let sb = UIStoryboard(name: "Main", bundle:nil)
                            let vc = sb.instantiateViewController(withIdentifier: "Menu") as! MenuViewController
                            vc.username = Int(user)!
                            vc.name = name
                            let si = SingleInstance.defaultSingleInstance()
                            si.datas[0] = user
                            si.datas[1] = name
                            si.datas[2] = password
                            self.present(vc, animated: true, completion: nil)
                        }
                        
                    }
                    else{
                        message = "登陆失败"
                        self.view.makeToast(message: message, duration: 0.5, position: "center" as AnyObject)
                    }
                }
        }
    }
    //输入框获取焦点开始编辑
    func textFieldDidBeginEditing(_ textField:UITextField)
    {
        //如果当前是用户名输入
        if textField.isEqual(txtUser){
            if (showType != LoginShowType.pass)
            {
                showType = LoginShowType.user
                return
            }
            showType = LoginShowType.user
            
            //播放不遮眼动画
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.imgLeftHand.frame = CGRect(
                    x: self.imgLeftHand.frame.origin.x - self.offsetLeftHand,
                    y: self.imgLeftHand.frame.origin.y + 30,
                    width: self.imgLeftHand.frame.size.width, height: self.imgLeftHand.frame.size.height)
                self.imgRightHand.frame = CGRect(
                    x: self.imgRightHand.frame.origin.x + 48,
                    y: self.imgRightHand.frame.origin.y + 30,
                    width: self.imgRightHand.frame.size.width, height: self.imgRightHand.frame.size.height)
                self.imgLeftHandGone.frame = CGRect(
                    x: self.imgLeftHandGone.frame.origin.x - 70,
                    y: self.imgLeftHandGone.frame.origin.y, width: 40, height: 40)
                self.imgRightHandGone.frame = CGRect(
                    x: self.imgRightHandGone.frame.origin.x + 30,
                    y: self.imgRightHandGone.frame.origin.y, width: 40, height: 40)
            })
        }
            //如果当前是密码名输入
        else if textField.isEqual(txtPwd){
            if (showType == LoginShowType.pass)
            {
                showType = LoginShowType.pass
                return
            }
            showType = LoginShowType.pass
            
            //播放遮眼动画
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.imgLeftHand.frame = CGRect(
                    x: self.imgLeftHand.frame.origin.x + self.offsetLeftHand,
                    y: self.imgLeftHand.frame.origin.y - 30,
                    width: self.imgLeftHand.frame.size.width, height: self.imgLeftHand.frame.size.height)
                self.imgRightHand.frame = CGRect(
                    x: self.imgRightHand.frame.origin.x - 48,
                    y: self.imgRightHand.frame.origin.y - 30,
                    width: self.imgRightHand.frame.size.width, height: self.imgRightHand.frame.size.height)
                self.imgLeftHandGone.frame = CGRect(
                    x: self.imgLeftHandGone.frame.origin.x + 70,
                    y: self.imgLeftHandGone.frame.origin.y, width: 0, height: 0)
                self.imgRightHandGone.frame = CGRect(
                    x: self.imgRightHandGone.frame.origin.x - 30,
                    y: self.imgRightHandGone.frame.origin.y, width: 0, height: 0)
            })
        }
    }

    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//登录框状态枚举
enum LoginShowType {
    case none
    case user
    case pass
}


