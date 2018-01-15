//
//  AppDelegate.swift
//  美容师
//
//  Created by 江东 on 2017/12/3.
//  Copyright © 2017年 江东. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import AVFoundation
import MediaPlayer
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    //多线程
    let queue = DispatchQueue(label: "创建并行队列", attributes: .concurrent)
    var player:AVPlayer?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //请求通知权限
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) {
                (accepted, error) in
                if !accepted {
                    print("用户不允许消息通知。")
                }
        }
        // 注册后台播放
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(true)
            try session.setCategory(AVAudioSessionCategoryPlayback)
        } catch {
            print(error)
        }
        
        queue.async {
            print("1 秒后输出")
            //播放器相关
            //var playerItem:AVPlayerItem?
            //var player:AVPlayer?
            // Do any additional setup after loading the view, typically from a nib.
            //初始化播放器
            //_ = Bundle.main
            let path = Bundle.main.path(forResource: "12345", ofType: "mp3")
            guard path != nil else { return }
            let asset = AVAsset(url: URL(fileURLWithPath: path!))
            let item = AVPlayerItem(asset: asset)
            self.player = AVPlayer(playerItem: item)
            //playerLayer = AVPlayerLayer(player: player)
            //playerContainer.layer.addSublayer(playerLayer)
            
            //let url = URL(string: "http://mxd.766.com/sdo/music/data/3/m10.mp3")
            //playerItem = AVPlayerItem(url: url!)
            //player = AVPlayer(playerItem: playerItem!)
            self.player!.play()
            
            while(true){
                sleep(10)
                self.player!.seek(to: CMTimeMake(1, 1))
                
                //获取数据  顾客的消息推送,
                if ((UserDefaults.standard.string(forKey: "cosid")) != nil){
                    let urlmessage:String!="http://47.96.173.116/cosmetologistajax/unreadjsoncosmetologist/\(String(describing: UserDefaults.standard.string(forKey: "cosid")!))"
                    print(urlmessage)
                    let messagenote=Messagenote()
                    messagenote.httpGet(request: URLRequest(url: URL(string: urlmessage)!))
                    
                }
            }
        }
        return true
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        player?.play()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "___")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

