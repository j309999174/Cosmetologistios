//
//  ViewController.swift
//  美容师
//
//  Created by 江东 on 2017/12/3.
//  Copyright © 2017年 江东. All rights reserved.
//

import UIKit
import WebKit
import JavaScriptCore
import UserNotifications
import AVFoundation
import MediaPlayer

class ViewController: UIViewController, WKUIDelegate, WKScriptMessageHandler {
    
    
    var webView: WKWebView!
    var myURL: URL!
    var passresut: String!="https://www.oushelun.cn/cosmetologist/customerlist/123"
    //打开音乐，播放音乐，为了保持后台
    let queue = DispatchQueue(label: "创建并行队列", attributes: .concurrent)
    override func loadView() {
        //创建配置
        let webConfiguration = WKWebViewConfiguration()
        //创建用户脚本，负责swift调js
        let userScript = WKUserScript(source: "redHeader()", injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        webConfiguration.userContentController.addUserScript(userScript)
        //内容控制，负责js调用swift
        
        webConfiguration.userContentController.add(self,name: "ioscosidsave")
        //webview加入配置
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true,animated: false)
        //链接改为扫描后的的值
        myURL = URL(string: passresut)
        //let myURL = URL(string: "http://172.114.10.238/customer/homepage/123")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        
        //self.musicplay()
    }
    //设一个方法，执行多线程
    func musicplay(){
        queue.async {
            print("1 秒后输出")
            //播放器相关
            //var playerItem:AVPlayerItem?
            var player:AVPlayer?
            // Do any additional setup after loading the view, typically from a nib.
            //初始化播放器
            //_ = Bundle.main
            let path = Bundle.main.path(forResource: "silence", ofType: "mp3")
            guard path != nil else { return }
            let asset = AVAsset(url: URL(fileURLWithPath: path!))
            let item = AVPlayerItem(asset: asset)
            player = AVPlayer(playerItem: item)
            //playerLayer = AVPlayerLayer(player: player)
            //playerContainer.layer.addSublayer(playerLayer)
            
            //let url = URL(string: "http://mxd.766.com/sdo/music/data/3/m10.mp3")
            //playerItem = AVPlayerItem(url: url!)
            //player = AVPlayer(playerItem: playerItem!)
            player!.play()
            
            while(true){
                sleep(10)
                player!.seek(to: CMTimeMake(1, 1))
                
                //获取数据  顾客的消息推送,
                if ((UserDefaults.standard.string(forKey: "cosid")) != nil){
                    let urlmessage:String!="https://www.oushelun.cn/cosmetologistajax/unreadjsoncosmetologist/\(String(describing: UserDefaults.standard.string(forKey: "cosid")!))"
                    print(urlmessage)
                    let messagenote=Messagenote()
                    messagenote.httpGet(request: URLRequest(url: URL(string: urlmessage)!))
                    
                }
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        //js调用储存美容师ID
        if(message.name == "ioscosidsave"){
            print("美容师ID\(message.body)")
            
            UserDefaults.standard.set(message.body, forKey: "cosid")
            print("储存的美容师id\(String(describing: UserDefaults.standard.string(forKey: "cosid")!))")
            
            //储存deviceToken
            if UserDefaults.standard.string(forKey: "deviceToken") != nil {
            let urlmessage:String!="https://www.oushelun.cn/decorateajax/cosmetologisttoken/\(message.body)/\(UserDefaults.standard.string(forKey: "deviceToken")!)"
            let toSearchword = CFURLCreateStringByAddingPercentEscapes(nil, urlmessage! as CFString, nil, "!*'();@&=+$,?%#[]" as CFString, CFStringBuiltInEncodings.UTF8.rawValue)
            print(toSearchword!)
            let request = URLRequest(url: URL(string: toSearchword! as String)!)
            let configuration = URLSessionConfiguration.default
            
            let session = URLSession(configuration: configuration,
                                     delegate: self as? URLSessionDelegate, delegateQueue:OperationQueue.main)
            
            let dataTask = session.dataTask(with: request,
                                            completionHandler: {(data, response, error) -> Void in
                                                if error != nil{}else{
                                                    print("数据")
                                                    print(data as Any)
                                                }})
            //使用resume方法启动任务
            dataTask.resume()
            }
            
        }
    }
}

