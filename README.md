# bnuzgetgpa
北师珠正方教务系统获取成绩以及考勤记录

一．配置环境
====
开发环境：Xcode8.3  
开发语言：Swift3.0  
开发界面：iPhone7  
适配：iPhone7，iPhone7Plus  
引用第三方库：Alamofire，SwiftyJSON，HRToast + UIView  

二．项目介绍
====
本项目功能是实现北京师范大学珠海分校教务系统的模拟登陆，自动获取学生的全部成绩，可以计算选中的成绩绩点，并且可以查询学生的考勤记录，最后于个人页面显示个人姓名，学院，专业，班级，学号，获得学分，学位加权平均分。

三．使用说明
====
1.需要先安装好 CocoaPods 。
2.修改 Podfile 中的 xcodeproj '/Users/zl/Documents/大三上/ios/ios大作业/北师小助手/bnuzgpa/bnuzgpa.xcodeproj' 路径为项目当前的路径  
3.cd 到 bnuzgpa 的当前目录  
4.pod install #安装第三方库  

四.项目原理（ Word 开发文档）
====
在开发文档中有详细的说明，简单的原理说明如下：  
Alamofire完成网络的请求，模拟登陆教务系统（Get，Post请求)，模拟登陆的过程中要解决的问题是教务系统登陆参数的获取。  
然后再模拟成绩查询请求完成任务。  
SwiftyJSON用来解析JSON数据包。  

五.待改进地方
====
1.爬取成绩的方法没有使用正则表达式，用了我独创的傻瓜式方法，根据关键字查找，切割字符串。坏处就是代码重复的地方太多，有待修改。  
2.界面没有自适应，界面的UI比较丑。  
3.计算成绩没有取消全部当前选择的功能，没有选择某个学期的功能，日后可以添加。  
4.考勤这部分是学校另外一个系统，不是正方的系统。我还没有加入关于解析请假等特殊情况的解析，因为自己和身边的人都没有这个数据。  

六.README更新时间
====
2018.3.13 Tuesday 14:55
