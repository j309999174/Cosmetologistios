//
//  Notificationfunction.swift
//  ZZYQRCodeSwift
//
//  Created by 江东 on 2017/11/30.
//  Copyright © 2017年 zzy. All rights reserved.
//

import Foundation
import UserNotifications

class Messagenote{
    // 使用URLSession请求数据
    func httpGet(request: URLRequest) {
        let configuration = URLSessionConfiguration.default
        
        let session = URLSession(configuration: configuration,
                                 delegate: self as? URLSessionDelegate, delegateQueue:OperationQueue.main)
        
        let dataTask = session.dataTask(with: request,
                                        completionHandler: {(data, response, error) -> Void in
                                            if error != nil{
                                                
                                            }else{
                                                let jsonArr=try! JSONSerialization.jsonObject(with: data!) as! [[String: Any]]
                                                for json in jsonArr {
                                                    print("ID：", json["sendname"]!, "    Name：", json["lastword"]!)
                                                    //测试通知
                                                    //设置推送内容
                                                    let content = UNMutableNotificationContent()
                                                    content.title = "您有一条新消息"
                                                    content.body = "\(json["sendname"]! as! String): \(json["lastword"]! as! String)"
                                                    //json["lastword"]! as! String
                                                    
                                                    //设置通知触发器
                                                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
                                                    
                                                    //设置请求标识符
                                                    let requestIdentifier = json["lastword"]! as! String
                                                    
                                                    //判断identifier是否存在
                                                    var ifsend = 0
                                                    UNUserNotificationCenter.current().getDeliveredNotifications{(notifications) in
                                                        for notification in notifications{
                                                            if(notification.request.identifier == requestIdentifier){
                                                                print("已存在")
                                                                ifsend = 1
                                                            }
                                                        }
                                                        if(ifsend == 0){
                                                            //设置一个通知请求
                                                            let request = UNNotificationRequest(identifier: requestIdentifier,
                                                                                                content: content, trigger: trigger)
                                                            
                                                            //将通知请求添加到发送中心
                                                            UNUserNotificationCenter.current().add(request) { error in
                                                                if error == nil {
                                                                    print("Time Interval Notification scheduled: \(requestIdentifier)")
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                                let str = String(data: data!, encoding: String.Encoding.utf8)
                                                print("访问成功，获取数据如下：")
                                                print(str!)
                                            }
        })
        
        //使用resume方法启动任务
        dataTask.resume()
    }
}


