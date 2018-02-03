//
//  GPAController.swift
//  bnuzgpa
//
//  Created by zl on 2017/12/22.
//  Copyright © 2017年 zl. All rights reserved.
//

import UIKit
import Alamofire

class GPAController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var items:[String] = []
    //仍未经处理的成绩数据
    var gpa:[String] = []
    //处理好的课程名字，学分，成绩数组
    var perfectInfo:[String] = []
    //干净的课程名字
    var className:[String] = []
    //干净的学分
    var num:[String] = []
    //干净的成绩
    var score:[String] = []
    //成绩查询页面源码
    var utf8TextScore = ""
    //存储选中单元格的索引
    var selectedIndexs = [Int]()
    
    @IBOutlet weak var gpaitem: UITabBarItem!
    
    //var tableView:UITableView?
    
    @IBOutlet weak var selectGPA: UILabel!
    @IBOutlet weak var tv: UITableView!
    override func loadView() {
        super.loadView()
    }
    //viewstate
    var ViewState:String = ""
    //viewstate获取状态
    var status:Bool = false
    //学号账号
    var username:Int = 0
    //学生名字
    var name:String = ""
    //学生名字标签
    @IBOutlet weak var nameLabel: UILabel!

    override func viewDidLoad() {
        //super.viewDidLoad()
        let si = SingleInstance.defaultSingleInstance()
        let num1:Int = Int(si.datas[0])!
        username = num1
        name = si.datas[1]
        print("测试学生学号\(num1)")
        print("测试学生名字\(name)")
        nameLabel.text = "绩点："
        self.getViewState()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getScore(){
        //查询成绩网页
        let url:String = "http://es.bnuz.edu.cn/jwgl/xscjcx.aspx?xh=\(username)&xm=&gnmkdm=N121605"
        //头部数据
        let headers: HTTPHeaders = [
            "Accept": "*/*",
            "Accept-Encoding": "gzip, deflate",
            "Accept-Language": "zh-CN,zh;q=0.9",
            "Cache-Control": "no-cache",
            "Content-Length": "3475",
            "Connection":"keep-alive",
            "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
            "Host":"es.bnuz.edu.cn",
            "Origin": "http://es.bnuz.edu.cn",
            "Referer": url,
            "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84 Safari/537.36",
            "X-MicrosoftAjax":"Delta=true"
        ]
        //登录参数
        let parameters: Parameters = [
            "ScriptManager1":"ScriptManager1|Button6",
            "ScriptManager1_HiddenField":";;AjaxControlToolkit, Version=1.0.20229.20821, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e:el:c5c982cc-4942-4683-9b48-c2c58277700f:e2e86ef9:1df13a87:af22e781",
            "__EVENTTARGET": "",
            "__EVENTARGUMENT": "",
            "__VIEWSTATE":"\(ViewState)",
            "__VIEWSTATEGENERATOR": "0FF955E6",
            "__VIEWSTATEENCRYPTED": "",
            "ccd_xn_ClientState":"2016-2017:::2016-2017",
            "ccd_xq_ClientState":"2:::2",
            "ddlXN":"2016-2017",
            "ddlXQ":"2",
            "hiddenInputToUpdateATBuffer_CommonToolkitScripts":"1",
            "__ASYNCPOST": "true",
            "Button6": "主修专业最高成绩查询"
        ]
        //print(parameters) //调试参数
        //模拟获取成绩
        Alamofire.request(url, method : .post , parameters : parameters, encoding: URLEncoding.default,headers:headers).responseString { response in debugPrint(response)
             if response.result.isSuccess {
            let utf8Text = (String(describing: response.result.value))
            //var utf8Text:String = String(data: data!, encoding: .utf8)!
                
            //var utf8Text:String = String(describing: response.result.value)
            //得到总学分
            print("utf8Text:\(utf8Text)")
            let si = SingleInstance.defaultSingleInstance()
            let range1 = utf8Text.range(of: "【主修专业最高成绩】获得学分：")
            let range2 = utf8Text.range(of: "；学位加权平均分")
            let search1 = (range1?.upperBound)! ..< (range2?.lowerBound)!
            si.datas[6] = (utf8Text.substring(with: search1))
            //得到学位加权平均分
            let range3 = utf8Text.range(of: "学位加权平均分：")
            let range4 = utf8Text.range(of: "；历年加权平均分")
            let search2 = (range3?.upperBound)! ..< (range4?.lowerBound)!
            si.datas[7] = (utf8Text.substring(with: search2))
            //print("成绩查询页面: \(self.utf8TextScore)")
            print("成绩查询页面: \(String(describing: response.result.value))")
            let count = self.getClassCount(utf8TextViewState:(String(describing: response.result.value)))
            print("count测试\(count)")
            self.getTrueGPA()
            }
        }
    }
    func getTrueGPA(){
        var sum:Double = 0
        var classnum:Double = 0
        let length = self.gpa.count
        for i in 0...200{
            if (i == self.gpa.count){
                break
            }
            if (gpa[i].contains("target=\\\"kcxx\\\">")){
                let startRange = self.gpa[i].range(of: "target=\\\"kcxx\\\">")
                let searchRange = (startRange?.upperBound)! ..< self.gpa[i].endIndex
                let NewClass = self.gpa[i].substring(with: searchRange)
                self.gpa.append(NewClass)
                //print("名字是：\(ViewState)")
                self.gpa[i] = self.gpa[i].replacingOccurrences(of: NewClass, with: "")
                //print("这里是真正的成绩打印的时候\(self.gpa[i])\n")
            }
            
        }
        
        for i in 0...length-1{
            print("\(self.gpa[i])\n")
            items.append(self.gpa[i])
        }
        self.getMyGPA()
        for i in 0...gpa.count-1{
            print("干净的课程名字：\(self.className[i])\n")
            print("干净的成绩：\(self.score[i])\n")
            print("干净的学分：\(self.num[i])\n")
            let j=(self.score[i] as NSString).doubleValue
            let h=(self.num[i] as NSString).doubleValue
            if (j>=60){
            sum += Double(j*h)
            classnum += Double(h)
            //creditsum += h
            }
        }
        var truegpa1:Double = Double(sum/classnum)
        //let si = SingleInstance.defaultSingleInstance()
        //si.datas[6] = "\(creditsum)"
        //si.datas[7] = "\(truegpa1)"
        truegpa1 = (truegpa1-60)*0.1+1.0
        let gpamessage = String(format: "%.2f", truegpa1)
        
        truegpa.text = "\(gpamessage)"
        print(self.gpa.count)
        print(className.count)
        print(score.count)
        print(num.count)
        //创建表视图
        //self.tableView = UITableView(frame: CGRect(x: 0, y: 40, width:self.view.frame.size.width, height:self.view.frame.size.height - 20),style:.plain)
        //self.tableView!.delegate = self
        //self.tableView!.dataSource = self
        //创建一个重用的单元格
        self.tv.register(UITableViewCell.self,forCellReuseIdentifier: "GPA")
        //self.view.addSubview(self.tableView!)
        
    }
    //这里是真正，最牛逼的最后一步了
    func getMyGPA(){
        //得到干净的课程名字
        for i in 0...gpa.count{
            if (i == self.gpa.count){
                break
            }
            let startRange = self.gpa[i].range(of: "</a>")
            let searchRange =  self.gpa[i].startIndex ..< (startRange?.upperBound)!
            var NewClass = self.gpa[i].substring(with: searchRange)
            NewClass = NewClass.replacingOccurrences(of: "</a>", with: "")
            className.append(NewClass)
            //得到干净的学分,成绩
            //寻找第一个“<td>”
            let startRange1 = self.gpa[i].range(of: "<td>")
            let searchRange1 =  (startRange1?.upperBound)! ..< gpa[i].endIndex
            let NewClass1 = self.gpa[i].substring(with: searchRange1)
            //NewClass1 = NewClass1.replacingOccurrences(of: "<td>", with: "")
            //得到学分第一次处理
            let startRange2 = NewClass1.range(of: "<td>")
            let searchRange2 =  (startRange2?.upperBound)! ..< NewClass1.endIndex
            let NewClass2 = NewClass1.substring(with: searchRange2)
            //得到学分第二次处理
            let startRange3 = NewClass2.range(of: "</td>")
            let searchRange3 =   NewClass2.startIndex ..< (startRange3?.lowerBound)!
            let NewClass3 = NewClass2.substring(with: searchRange3)
            num.append(NewClass3)
            //得到成绩第一次处理
            let startRange4 = NewClass2.range(of: "<td>")
            let searchRange4 =  (startRange4?.upperBound)! ..< NewClass2.endIndex
            let NewClass4 = NewClass2.substring(with: searchRange4)
            //得到成绩第二次处理
            if (className[i].contains("大学生心理健康教育")==false){
                let startRange5 = NewClass4.range(of: "</td>")
                let searchRange5 = NewClass4.startIndex ..< (startRange5?.lowerBound)!
                let NewClass5 = NewClass4.substring(with: searchRange5)
                score.append(NewClass5)
            }
            else
            {
                score.append(NewClass4)
            }
        }
        for i in 0...gpa.count{
            if (i == self.gpa.count){
                break
            }
            let perfect:String = "学分:"+num[i]+"\t\t成绩:"+score[i]
            perfectInfo.append(perfect)
        }
        //注册表格
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "GPA")
        //去掉表格尾部空行
        tv.tableFooterView = UIView(frame: CGRect.zero)
        tv.alpha = 0.8
        tv.reloadData()

    }
    //从网页回应中初步得到课程信息，会出现一个数组单元有多门课的情况
    func getClassCount(utf8TextViewState:String) -> Int {
        var count = 0
        var endtarget = "</td><td>&nbsp"
        var endstatus = 0
        var error = ""
        var ViewText = utf8TextViewState
        for _ in 1...200{
        if(ViewText.contains("target=\\\"kcxx\\\">")) {
        let startRange = ViewText.range(of: "target=\\\"kcxx\\\">")
        //判断是不是最后一个成绩，最后一个成绩没有包含npsp
        if (ViewText.contains(endtarget)==false){
            endtarget = "|0|hiddenField|__EVENTTARGET|"
            endstatus = 1
        }
        let endRange = ViewText.range(of: endtarget)
        let searchRange = (startRange?.upperBound)! ..< (endRange?.lowerBound)!
        self.ViewState = ViewText.substring(with: searchRange)
        print("名字是：\(ViewState)")
        gpa.append(ViewState)
        //坑爹教务处程序员不好好写代码，大学生心理健康这个成绩的格式多一个回车符！！！！！！
        if ViewState.contains("大学生心理健康教育"){
            error = ";</td><td>&nbsp"
        }
        //坑爹教务处程序员不好好写代码，最后一个成绩不写nbsp!
        if (endstatus==1){
            ViewState = "target=\\\"kcxx\\\">" + ViewState
        }
        else
        {
            ViewState = "target=\\\"kcxx\\\">" + ViewState + "</td><td>&nbsp" + error
        }
        ViewText = ViewText.replacingOccurrences(of: "\(ViewState)", with: "")
        print("数据是\(ViewText)")
        if (error == ";</td><td>&nbsp") {error = ""}
            self.status = true
            count += 1
        }
        else
        {
            break
        }
        }
        return count
    }
    
    //得到viewstate
    func getViewState(){
        //查询成绩网页
        let url:String = "http://es.bnuz.edu.cn/jwgl/xscjcx.aspx?"
        //get请求参数，为了获取viewstate
        let parameters: Parameters = ["xh":username,
                                       "xm":"",
                                       "gnmkdm":"N121605"
        ]
        //模拟获取viewstate
        Alamofire.request(url, parameters : parameters, encoding: URLEncoding.default).responseData { response in debugPrint(response)
            if response.result.isSuccess{
            if let data = response.data, let utf8TextViewState = String(data: data, encoding: .utf8) {
                print("ViewStateData: \(utf8TextViewState)")
                //self.ViewState = self.getViewState(webText: utf8Text)
                //得到学院
                let range1 = utf8TextViewState.range(of: "学院：")
                let range2 = utf8TextViewState.range(of: " 专业：")
                let search = (range1?.upperBound)! ..< (range2?.lowerBound)!
                let si = SingleInstance.defaultSingleInstance()
                si.datas[3] = utf8TextViewState.substring(with: search)
                //得到专业
                let range3 = utf8TextViewState.range(of: "专业：")
                let range4 = utf8TextViewState.range(of: " 班级：")
                let search1 = (range3?.upperBound)! ..< (range4?.lowerBound)!
                si.datas[4] = utf8TextViewState.substring(with: search1)
                //得到班级
                let range5 = utf8TextViewState.range(of: "班级：")
                let range6 = utf8TextViewState.range(of: " 专业方向")
                let search2 = (range5?.upperBound)! ..< (range6?.lowerBound)!
                si.datas[5] = utf8TextViewState.substring(with: search2)
                //ViewState
                let startRange = utf8TextViewState.range(of: "id=\"__VIEWSTATE\" value=\"")
                let endRange = utf8TextViewState.range(of: "<script src=\"/jwgl/ScriptResource.axd?", options: .backwards, range: nil, locale: nil)
                let searchRange = (startRange?.upperBound)! ..< (endRange?.lowerBound)!
                self.ViewState = utf8TextViewState.substring(with: searchRange)
                //print("名字是：\(ViewState)")
                self.ViewState = self.ViewState.replacingOccurrences(of: "\" />", with: "")
                self.ViewState = self.ViewState.replacingOccurrences(of: "\r\n\r\n\r\n", with: "")
                print("数据是\(self.ViewState)")
                self.status = true
                self.getScore()
            }
        }
            else
            {
                let message = "网络请求失败"
                self.view.makeToast(message: message, duration: 0.5, position: "center" as AnyObject)
            }
        }
        
        //if self.status == true{
        //    self.getScore()}
    
    }
    
    //在本例中，只有一个分区
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    //返回表格行数（也就是返回控件数）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.gpa.count
    }
    
    //创建各单元显示内容(创建参数indexPath指定的单元）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        
            let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle,reuseIdentifier: "GPA")
            cell.textLabel?.text = self.className[indexPath.row]
            cell.detailTextLabel!.text = self.perfectInfo[indexPath.row]
        
            if self.selectedIndexs.contains(indexPath.row) {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            
            return cell
        
        
    }
    
    // UITableViewDelegate 方法，处理列表项的选中事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //判断该行原先是否选中
        if let index = selectedIndexs.index(of: indexPath.row){
            selectedIndexs.remove(at: index) //原来选中的取消选中
        }else{
            selectedIndexs.append(indexPath.row) //原来没选中的就选中
        }
        
        ////刷新该行
        tv.reloadRows(at: [indexPath], with: .automatic)
    }
    
    //确定按钮点击
    @IBAction func btnGetScore(_ sender: Any) {
        print("选中项的索引为：", selectedIndexs)
        print("选中项的值为：")
        var classnum:Double = 0
        var realgpa:Double = 0
        var sum:Double = 0
        for index in selectedIndexs {
            print(gpa[index])
            print(perfectInfo[index])
            print(score[index])
            print(num[index])
            let j=(self.score[index] as NSString).doubleValue
            let h=(self.num[index] as NSString).doubleValue
            sum += Double(j*h)
            classnum += Double(h)
        }
        if (selectedIndexs==[]){
        }
        else
        {
            realgpa = Double(sum/classnum)
            print("绩点为",realgpa)
        }
        let perfectgpashow = String(format: "%.2f", realgpa)
        selectGPA.text = perfectgpashow
        let message = "\(name)同学\n绩点：\(perfectgpashow)"
        self.view.makeToast(message: message, duration: 0.5, position: "center" as AnyObject)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        //头部数据
        let headers: HTTPHeaders = [
            "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8",
            "Accept-Encoding": "gzip, deflate",
            "Accept-Language": "zh-CN,zh;q=0.9",
            "Cache-Control":"max-age=0",
            "Connection":"keep-alive",
            "Content-Length":"0",
            "Content-Type":"application/x-www-form-urlencoded",
            "Host":"tm.bnuz.edu.cn",
            "Origin":"http://tm.bnuz.edu.cn",
            "Referer":"http://tm.bnuz.edu.cn/",
            "Upgrade-Insecure-Requests":"1",
            "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84 Safari/537.36"
        ]
        Alamofire.request("http://tm.bnuz.edu.cn/logout", method : .post , encoding: URLEncoding.default,headers:headers).responseString { response in debugPrint(response)
            if response.result.isSuccess {
                print("退出成功")
            }
        }
        self.dismiss(animated: true, completion: nil)
    }

    @IBOutlet weak var truegpa: UILabel!

}
