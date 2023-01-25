//
//  AppDelegate.swift
//  bbktimes
//
//  Created by 조승환 on 2022/11/23.
//

import UIKit
import CoreData
import FirebaseCore
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseMessaging
import UserNotifications


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        // 세로방향 고정
        return UIInterfaceOrientationMask.portrait
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Thread.sleep(forTimeInterval: 2)
        FirebaseApp.configure()
        application.registerForRemoteNotifications()
        
        // [START set_messaging_delegate]
        Messaging.messaging().delegate = self
        Messaging.messaging().token { token, error in
            if let error = error {
                print("ERROR FCM 등록토큰 가져오기 : \(error.localizedDescription)")
            } else if let token: String? = token {
                print("FCM 등록토큰 : \(token)")
            }
//            func savetoken() {
////                let date = self.saveToken.map {
////                    ["\(token)": $0.token]
////                }
////                let userDefaults = UserDefaults.standard
////                userDefaults.set(date, forKey: "TokenList")
//
//
//            }
        }
            
            //        UNUserNotificationCenter.current().delegate = self
            // [END set_messaging_delegate]
            // Register for remote notifications. This shows a permission dialog on first run, to
            // show the dialog at a more appropriate time move this registration accordingly.
            // [START register_for_notifications]
            if #available(iOS 10.0, *) {
                // For iOS 10 display notification (sent via APNS)
                let notiConter = UNUserNotificationCenter.current()
                UNUserNotificationCenter.current().delegate = self
                
                
                let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                UNUserNotificationCenter.current().requestAuthorization(
                    options: authOptions,
                    completionHandler: { _, _ in }
                )
            } else {
                let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                application.registerUserNotificationSettings(settings)
            }
            
            application.registerForRemoteNotifications()
            
            // [END register_for_notifications]
            return true
        }
        //    func application(application: UIApplication,
        //                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //      Messaging.messaging().apnsToken = deviceToken
        //    }
        
        
        
        func application(_ application: UIApplication,
                         didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
            // If you are receiving a notification message while your app is in the background,
            // this callback will not be fired till the user taps on the notification launching the application.
            // TODO: Handle data of notification
            // With swizzling disabled you must let Messaging know about the message, for Analytics
            // Messaging.messaging().appDidReceiveMessage(userInfo)
            // Print message ID.
            if let messageID = userInfo[gcmMessageIDKey] {
                print("Message ID: \(messageID)")
            }
            
            // Print full message.
            print(userInfo)
        }
        
        func application(_ application: UIApplication,
                         didReceiveRemoteNotification userInfo: [AnyHashable: Any]) async
        -> UIBackgroundFetchResult {
            // If you are receiving a notification message while your app is in the background,
            // this callback will not be fired till the user taps on the notification launching the application.
            // TODO: Handle data of notification
            // With swizzling disabled you must let Messaging know about the message, for Analytics
            // Messaging.messaging().appDidReceiveMessage(userInfo)
            // Print message ID.
            if let messageID = userInfo[gcmMessageIDKey] {
                print("Message ID: \(messageID)")
            }
            
            // Print full message.
            print(userInfo)
            
            return UIBackgroundFetchResult.newData
        }
        
        // MARK: UISceneSession Lifecycle
        
        func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
            // Called when a new scene session is being created.
            // Use this method to select a configuration to create the new scene with.
            return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
        }
        
        func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
            // Called when the user discards a scene session.
            // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
            // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
        }
        
        // MARK: - Core Data stack
        
        lazy var persistentContainer: NSPersistentContainer = {
            /*
             The persistent container for the application. This implementation
             creates and returns a container, having loaded the store for the
             application to it. This property is optional since there are legitimate
             error conditions that could cause the creation of the store to fail.
             */
            let container = NSPersistentContainer(name: "bbktimes")
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

//extension AppDelegate: UNUserNotificationCenterDelegate {
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.list, .banner, .badge, .sound])
//    }
//}
extension AppDelegate: UNUserNotificationCenterDelegate {
  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification) async
    -> UNNotificationPresentationOptions {
    let userInfo = notification.request.content.userInfo

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)
    // [START_EXCLUDE]
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }
    // [END_EXCLUDE]
    // Print full message.
    print(userInfo)
    // Change this to your preferred presentation option
        return [[.alert, .sound, .badge]]
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse) async {
    let userInfo = response.notification.request.content.userInfo

    // [START_EXCLUDE]
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }
    // [END_EXCLUDE]
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)
    // Print full message.
    print(userInfo)
  }
}


extension AppDelegate: MessagingDelegate {
//     [START refresh_token]
      func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration tokenㅇㄹㅁㅇㄹㄴ: \(String(describing: fcmToken))")
          UserDefaults.standard.set("\(fcmToken)", forKey: "FCMToken")
        
          let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
          name: Notification.Name("FCMToken"),
          object: nil,
          userInfo: dataDict
        )
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
      }
    
      // [END refresh_token]
    
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        guard let token = fcmToken else { return }
//        print("FCM 등록토큰 갱신 : \(token)")
    }



//func login(account: String, passwd: String, success: (()->Void)? = nil, fail: ((String)->Void)? = nil) {
//
//
//    // 프로필 이미지 처리
//    if let path = user["profile_path"] as? String {
//        if let imageData = try? Data(contentsOf: URL(string: path)!) {
//            self.profile = UIImage(data: imageData)
//        }
//    }
//    // 인자값으로 입력된 클로저 블록 실행
//    // 토큰 정보 추출
//    let accessToken = jsonObject["access_token"] as! String
//    let refreshToken = jsonObject["refresh_token"] as! String
//
//    // 토큰 정보 저장
//    let tk = KeyChain()
//    tk.save("com.nanocode.MyMemory", account: "accessToken", value: accessToken)
//    tk.save("com.nanocode.MyMemory", account: "refreshToken", value: refreshToken)
//
//    success?()
//} else {
//    let msg = (jsonObject["error_msg"] as? String) ?? "로그인이 실패했습니다"
//    fail?(msg)
//}
