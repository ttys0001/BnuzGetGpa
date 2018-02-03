//
//  ViewController.swift
//  tms
//
//  Created by zl on 2017/12/25.
//  Copyright © 2017年 zl. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class TMSController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //显示表格cell的总数
    var itemcount:Int = 0
    //存储选中单元格的索引
    var selectedIndexs = [Int]()
    var tableView:UITableView?
    var JSESSIONID:[String] = []
    var csrf_token = ""
    var xsrf_token = ""
    var teacher:[String] = []
    var course:[String] = []
    var dayOfWeek:[String] = []
    var week:[String] = []
    var freeListenFormId:[String] = []
    var type:[String] = []
    var startSection:[String] = []
    var totalSection:[String] = []
    var courseItem:[String] = []
    //显示的旷课名称，老师名称
    var classname:[String] = []
    //显示旷课类型，旷课具体时间
    var detailed:[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        getCsrf_token()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //在本例中，只有一个分区
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    //返回表格行数（也就是返回控件数）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemcount
    }
    
    //创建各单元显示内容(创建参数indexPath指定的单元）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            let cell = UITableViewCell(style: UITableViewCellStyle.subtitle,
                                       reuseIdentifier: "SwiftCell")
            cell.textLabel?.text = classname[indexPath.row]
            //print(cell.textLabel?.text)
            cell.detailTextLabel!.text = detailed[indexPath.row]
            //判断是否选中（选中单元格尾部打勾）
            if selectedIndexs.contains(indexPath.row) {
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
        self.tableView?.reloadRows(at: [indexPath], with: .automatic)
    }

    func login(){
        //头部数据
        let headers: HTTPHeaders = [
            "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8",
            "Accept-Encoding": "gzip, deflate",
            "Accept-Language": "zh-CN,zh;q=0.9",
            "Cache-Control":"max-age=0",
            "Connection":"keep-alive",
            "Content-Length": "79",
            "Content-Type": "application/x-www-form-urlencoded",
            //"Cookie":"JSESSIONID=\(self.JSESSIONID[1]); XSRF-TOKEN=\(self.xsrf_token); JSESSIONID=\(self.JSESSIONID[0])",
            "Host":"tm.bnuz.edu.cn",
            "Origin": "http://tm.bnuz.edu.cn",
            "Referer": "http://tm.bnuz.edu.cn/uaa/login",
            "Upgrade-Insecure-Requests":"1",
            "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84 Safari/537.36"
        ]
        
        let si = SingleInstance.defaultSingleInstance()
        let a = si.datas[0]
        let b = si.datas[2]
        let c = self.csrf_token
        //登录参数
        let parameters1: Parameters = [
            "username": "\(a)",
            "password": "\(b)",
            "_csrf":"\(c)"
        ]
        
        
        Alamofire.request("http://tm.bnuz.edu.cn/uaa/login", method: .post, parameters: parameters1,headers:headers)
            .responseData  { response in
                debugPrint(response)
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("post请求Data: \(utf8Text)") // original server
                    self.LoginAgain()
                }
        }
        
    }
    //得到csrf_token
    func getCsrf_token(){
        //头部数据
        let headers: HTTPHeaders = [
            "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8",
            "Accept-Encoding": "gzip, deflate",
            "Accept-Language": "zh-CN,zh;q=0.9",
            "Connection":"keep-alive",
            "Host":"tm.bnuz.edu.cn",
            "Upgrade-Insecure-Requests":"1",
            "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84 Safari/537.36"
        ]
        Alamofire.request("http://tm.bnuz.edu.cn",encoding: URLEncoding.default,headers:headers).responseData  { response in debugPrint(response)
            if (response.result.isSuccess){
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8
                let startRange = utf8Text.range(of: "id=\"csrf_token\" name=\"_csrf\" value=\"")
                let endRange  = utf8Text.range(of: "<script type=\"application/javascript\">", options: .backwards, range: nil, locale: nil)
                let searchRange = (startRange?.upperBound)! ..< (endRange?.lowerBound)!
                self.csrf_token = utf8Text.substring(with: searchRange)
                self.csrf_token = self.csrf_token.replacingOccurrences(of: "</div>", with: "")
                self.csrf_token = self.csrf_token.replacingOccurrences(of: "</form>", with: "")
                self.csrf_token = self.csrf_token.replacingOccurrences(of: "\"/>", with: "")
                self.csrf_token = self.csrf_token.replacingOccurrences(of: "\n", with: "")
                self.csrf_token = self.csrf_token.replacingOccurrences(of: "\r", with: "")
                self.csrf_token = self.csrf_token.replacingOccurrences(of: "\t", with: "")
                print("csrf测试\(self.csrf_token)asdasd")
                self.csrf_token = self.csrf_token.trimmingCharacters(in: .whitespaces)
                print("csrf测试\(self.csrf_token)aaa")
                self.login()
            }
        }
            else
            {
                let message = "网络请求失败"
                self.view.makeToast(message: message, duration: 0.5, position: "center" as AnyObject)
            }
        }
    }
    
    func LoginAgain(){
        let si = SingleInstance.defaultSingleInstance()
        let a = si.datas[0]
        
        let url = "http://tm.bnuz.edu.cn/web/here/students/\(a)/attendances"
        //头部数据
        let headers: HTTPHeaders = [
            "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8",
            "Accept-Encoding": "gzip, deflate",
            "Accept-Language": "zh-CN,zh;q=0.9",
            "Proxy-Connection:":"keep-alive",
            "Host":"tm.bnuz.edu.cn",
            "Referer":"http://tm.bnuz.edu.cn/",
            "Upgrade-Insecure-Requests":"1",
            "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84 Safari/537.36"
        ]
        
        
        
        
        Alamofire.request(url,encoding: URLEncoding.default,headers:headers).responseData  { response in debugPrint(response)
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("考勤Data: \(utf8Text)") // original server data as
                
                //最后一次get请求考勤数据
                Alamofire.request("http://tm.bnuz.edu.cn/api/here/students/\(a)/attendances",encoding: URLEncoding.default,headers:headers).responseJSON  { response in debugPrint(response)
                    if response.result.isSuccess{
                        let json = JSON(response.result.value!)
                        print(json)
                        let realjson = json["rollcalls"].array
                        let count:Int = (realjson!.count)
                        self.itemcount = count
                        for i in 0...count{
                            if (i==count){
                                break
                            }
                            self.teacher.append((realjson?[i]["teacher"].stringValue)!)
                            self.course.append((realjson?[i]["course"].stringValue)!)
                            self.dayOfWeek.append((realjson?[i]["dayOfWeek"].stringValue)!)
                            self.week.append((realjson?[i]["week"].stringValue)!)
                            self.freeListenFormId.append((realjson?[i]["freeListenFormId"].stringValue)!)
                            self.type.append((realjson?[i]["type"].stringValue)!)
                            self.startSection.append((realjson?[i]["startSection"].stringValue)!)
                            self.totalSection.append((realjson?[i]["totalSection"].stringValue)!)
                        }
                        for i in 0...count{
                            if (i==count){
                                break
                            }
                            let information = "teacher:\(self.teacher[i])\t"+"course:\(self.course[i])\t"+"dayOfWeek:\(self.dayOfWeek[i])\t"+"week:\(self.week[i])\t"+"freeListenFormId:\(self.freeListenFormId[i])\t"+"type:\(self.type[i])\t"+"startSection:\(self.startSection[i])\t"+"totalSection:\(self.totalSection[i])\t"
                            let info1 = self.course[i]+"\\"+self.teacher[i]
                            self.classname.append(info1)
                            var typename = ""
                            if (self.type[i] == "1"){
                                typename = "旷课"
                            }
                            else
                            {
                                typename = "迟到"
                            }
                            let total:Int = Int(self.totalSection[i])!
                            var end:Int = Int(self.startSection[i])!
                            for start in 1...total{
                                if (start == total){
                                    break
                                }
                                end += 1
                            }
                            let info2 = typename+"\t第\(self.week[i])周"+"星期\(self.dayOfWeek[i])"+"第\(self.startSection[i])"+"-\(end)节"
                            self.detailed.append(info2)
                            print("\(information)\n")
                            print(self.classname[i])
                            print(self.detailed[i])
                            //创建表视图
                            self.tableView = UITableView(frame: CGRect(x: 0, y: 40, width:self.view.frame.size.width, height:self.view.frame.size.height - 20),style:.plain)
                            self.tableView!.delegate = self
                            self.tableView!.dataSource = self
                            //创建一个重用的单元格
                            self.tableView!.register(UITableViewCell.self,
                                                     forCellReuseIdentifier: "SwiftCell")
                            self.view.addSubview(self.tableView!)
                            self.tableView?.alpha = 0.8
                            self.tableView?.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    
    
    
}

