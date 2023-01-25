//
//  ViewController.swift
//  bbktimes
//
//  Created by 조승환 on 2022/11/23.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseMessaging
import UserNotifications
import WebKit
import Security
import Alamofire
import SwiftKeychainWrapper
import Network

class WebViewController: UIViewController {
   
//    private var saveToken = [Token]()
//    @IBOutlet var containerView: UIView!
    @IBOutlet var webView: WKWebView!
    
    var jsonString = String()
    let preferences = WKPreferences()
    var fcmtoken: String = "THIS IS TOKEN"
    var test: String = "test"
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let monitor = NWPathMonitor()
    let getToken  = UserDefaults.standard.string(forKey: "FCMToken")
    let contents = UNMutableNotificationContent()
    let url = URL(string: "http://bbktimes.co.kr")
    let cookie_domain = "http://bbktimes.co.kr"
    private var wkWebView: WKWebView? = nil
    
//    override func loadView() {
//        super.loadView()
//
//        let contentController = WKUserContentController()
//        let config = WKWebViewConfiguration()
//        let userScript = WKUserScript(source: "callAlert()", injectionTime: .atDocumentEnd, forMainFrameOnly: true)
//        contentController.addUserScript(userScript)
//        contentController.add(self, name: "complete")
//        config.userContentController = contentController
//        webView = WKWebView(frame: webView.frame, configuration: config)
//        webView.uiDelegate = self
//        webView.navigationDelegate = self
//        saveToken()
//        self.view.addSubview(webView)
//
//    }
    override func loadView() {
        super.loadView()
        
        let contentController = WKUserContentController()
        let config = WKWebViewConfiguration()
        let userScript = WKUserScript(source: "callAlert()", injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        contentController.addUserScript(userScript)
        contentController.add(self, name: "complete")
        config.userContentController = contentController
        webView = WKWebView(frame: CGRect.init(x: view.safeAreaInsets.left, y: view.safeAreaInsets.top, width: self.view.bounds.width, height: self.view.bounds.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom), configuration: config)
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        saveToken()
        self.view.addSubview(webView)
    }
        override func viewSafeAreaInsetsDidChange() {
            if #available(iOS 11.0, *) {
                webView.translatesAutoresizingMaskIntoConstraints = false
                view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":webView]))
                view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(\(self.view.safeAreaInsets.top))-[v0]-(\(self.view.safeAreaInsets.bottom))-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":webView]))
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow,Error in print(didAllow)})
        
        UNUserNotificationCenter.current().delegate = self
        requestNotificationAuthorization()
//        sendNotification()
        webViewInit()
//        setConfig()
        saveToken()
        print("저장된 토큰값 : \(getToken)")
//        print("제이슨 데이터 : \(jsonString)")
         
        //        Messaging.messaging().delegate = self
        
        //        HTTPCookieStorage.restore()
        //        HTTPCookieStorage.save()
        //        HTTPCookieStorage.clear()
        
        
            
            // Here is important point!!!
            // Place where sending data from Swift -> JS
            // Have to write (javascript:window.NativeInterface.) before JS Function name helloWorld() and inside function add your data to pass
        
//        webView.evaluateJavaScript("setIos_FcmToken(\(self.jsonString)", completionHandler: nil)
        //        webView.evaluateJavaScript("javascript:window.NativeInterface.setIos_FcmToken('\(jsonString)')") { (result, error) in
    }
    
//    func setConfig() {
//
//    }
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           
           guard Reachability.networkConnected() else {
               let alert = UIAlertController(title: "NetworkError", message: "네트워크가 연결되어있지 않습니다.", preferredStyle: .alert)
               let okAction = UIAlertAction(title: "종료", style: .default) { (action) in
                   exit(0)
               }
               alert.addAction(okAction)
               self.present(alert, animated: true, completion: nil)
               return
           }
    }
    func saveToken() {
        Messaging.messaging().token { token, error in
            if let error = error {
                print("ERROR FCM 등록토큰 가져오기 : \(error.localizedDescription)")
            } else if let token: String = token {
                print("FCM 등록토큰 이건가? : \(token)")
                UserDefaults.standard.set("\(token)", forKey: "FCMToken")
            }
        }
    }
    
    func webViewInit() {
        WKWebsiteDataStore.default().removeData(ofTypes: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache],modifiedSince: Date(timeIntervalSince1970: 0)) {
        }
//                webView.uiDelegaㅛㅛonDelegate = self

        webView.allowsBackForwardNavigationGestures = true

        if let url = URL(string: "https://bbktimes.co.kr"){
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
        if #available(iOS 11.0, *) {
            WKWebsiteDataStore.default().httpCookieStore.getAllCookies { (cookies) in
                for cookie in cookies{
                    print("@@@ cookie ==> \(cookie.name) : \(cookie.value)")
                    if cookie.name == "PHPSESSID" {
                        UserDefaults.standard.set(cookie.value, forKey:"PHPSESSID")
                        print("@@@ PHPSESSID  저장하기: \(cookie.value)")
                    }
                }
            }
        } else {
            // Fallback on earlier versions
        }
        
        
        
//            let alert = UIAlertController(title: "인터넷 연결이 원활하지 않습니다.", message: "Wifi 또는 셀룰러를 활성화 해주세요.", preferredStyle: .alert)
//            let confirm = UIAlertAction(title: "확인", style: .default, handler: nil)
//            alert.addAction(confirm)
//
//            monitor.start(queue: .global())
//            monitor.pathUpdateHandler = { path in
//                if path.status == .satisfied {
//                    // 인터넷 연결 O
//                    let url = URL(string: "http://ercorp.sanggong.net/member/login.php")
//                    let request = URLRequest(url: url!)
//                    self.webView.load(request)
//                    // 연결이 끊겼다가 다시 연결될 경우 웹뷰 페이지 reload
//                    DispatchQueue.main.async {
//                        self.webView.load(request)
//                    }
//                    return
//
//                } else {
//                    DispatchQueue.main.async {
//                        self.present(alert, animated: true, completion: nil)
//                    }
//                }
//
//            }

        }

    
    let notificationCenter = UNUserNotificationCenter.current()
    
//    @IBAction func touchBack(_ sender: Any) {
//        webView.goBack()
//    }
//
//    @IBAction func touchForward(_ sender: Any) {
//        webView.goForward()
//    }
//    @IBAction func touchHome(_ sender: Any) {
//        let url = URL(string: "https://erservice.kr/index.php")
//        let request = URLRequest(url: url!)
//        webView.load(request)
//    }
//
//    @IBAction func touchRefresh(_ sender: Any) {
//        webView.reload()
//    }
//    @IBAction func touchStop(_ sender: Any) {
//        webView.stopLoading()
//    }
    
    func requestNotificationAuthorization() {
        let authOptions: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        notificationCenter.requestAuthorization(options: authOptions) { success, error in
            if let error = error {
                print(error)
                
            }
        }
    }
    

    // MARK: - Making type of Data to pass to JS
    
    func createJsonToPass(name : String , token : String = "") {
        
        let data = ["name": name ,"token": token] as [String : Any]
        self.jsonString = createJsonForJavaScript(for: data)
        
    }
    
    // MARK: - Creating Json for JS
    func createJsonForJavaScript(for data: [String : Any]) -> String {
        var jsonString : String?
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            
            jsonString = String(data: jsonData, encoding: .utf8)!
            jsonString = jsonString?.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\\", with: "")
            
        } catch {
            print(error.localizedDescription)
        }
        print(jsonString!)
        return jsonString!
    }
    
    func Center() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            guard (settings.authorizationStatus == .authorized) ||
                    (settings.authorizationStatus == .provisional) else { return }
            
            if settings.alertSetting == .enabled {
                // Schedule an alert-only notification.
            } else {
                
                // Schedule a notification with a badge and sound.
            }
        }
    }
    
//    func webViewInit() {
//
//        WKWebsiteDataStore.default().removeData(ofTypes: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache],modifiedSince: Date(timeIntervalSince1970: 0)) {
//        }
////                webView.uiDelegaㅛㅛonDelegate = self
//
//        webView.allowsBackForwardNavigationGestures = true
//
//        if let url = URL(string: "http://ercorp.sanggong.net/member/login.php"){
//            let request = URLRequest(url: url)
//            webView.load(request)
//        }
//    }
    
    func showToast(message: String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
//        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut,
           animations: { toastLabel.alpha = 0.0 },
           completion: {(isCompleted) in toastLabel.removeFromSuperview() }
        )
      }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Swift.Void){
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let otherAction = UIAlertAction(title: "OK", style: .default, handler: {action in completionHandler()})
            alert.addAction(otherAction)
                
            self.present(alert, animated: true, completion: nil)
        }
    }

   
extension WebViewController : UNUserNotificationCenterDelegate {
        //To display notifications when app is running  inforeground
    

        
        //앱이 foreground에 있을 때. 즉 앱안에 있어도 push알림을 받게 해줍니다.
        //viewDidLoad()에 UNUserNotificationCenter.current().delegate = self를 추가해주는 것을 잊지마세요.
    func userNotificationCenter(_ center: UNUserNotificationCenter,willPresent notification: UNNotification,withCompletionHandler completionHandler: @escaping
    (UNNotificationPresentationOptions) -> Void) {
         completionHandler([.alert, .badge, .sound])
        }
        func userNotificationCenter(_ center: UNUserNotificationCenter,didReceive response: UNNotificationResponse,withCompletionHandler completionHandler: @escaping () -> Void) {
            completionHandler()
        }
    }
    //extension ViewController : MessagingDelegate {
    //    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    //      print("토큰값: \(String(describing: fcmToken))")
    //
    //      let dataDict: [String: String] = ["token": fcmToken ?? ""]
    //      NotificationCenter.default.post(
    //        name: Notification.Name("FCMToken"),
    //        object: nil,
    //        userInfo: dataDict
    //      )
    //      // TODO: If necessary send token to application server.
    //      // Note: This callback is fired at each app startup and whenever a new token is generated.
    //    }
    //}

extension WebViewController : WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler
{
    //    webView.evaluateJavaScript
    func userContentController(_ userContentController: WKUserContentController,didReceive message: WKScriptMessage) {
        if (message.name == "complete"){
            print("메세지 : \(message.body)")
            print("호출완료")
            if let getT = getToken {
                print("보낼 토큰값 : \(getT)")
                webView.evaluateJavaScript("setIos_FcmToken('\(getT)')", completionHandler: { (result, error) in
                    if let result = result {
                        print(result)
                    } else {
                        print("Error : \(error?.localizedDescription ?? "")")
                    }
                })
            } else {
                print("호출안댐")
            }
        }
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
            completionHandler(false)
        }
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            completionHandler(true)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
   //load cookie of current domain
        webView.writeDiskCookies(for: (webView.url?.host!)!){
            decisionHandler(.allow)
        }
    }
    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
   //write cookie for current domain
        webView.writeDiskCookies(for: (webView.url?.host!)!){
            decisionHandler(.allow)
        }
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let loadedSessid = UserDefaults.standard.value(forKey: "PHPSESSID") as! String?
        if let temp = loadedSessid{
            print("@@@ PHPSESSID  저장~~: \(temp)")
            // 이게 정상동작하는듯.. 자동로그인 됨
            let cookieString : String = "document.cookie='PHPSESSID=\(temp);path=/;domain=\(cookie_domain);'"
            webView.evaluateJavaScript(cookieString)
        }
    }    
    
}
    
extension WKWebView {
    enum PrefKey {
        static let cookie = "cookies"
    }
    
    func writeDiskCookies(for domain: String, completion: @escaping () -> ()) {
        fetchInMemoryCookies(for: domain) { data in
            print("write data", data)
            UserDefaults.standard.setValue(data, forKey: PrefKey.cookie + domain)
            completion();
        }
    }
    
    
    func loadDiskCookies(for domain: String, completion: @escaping () -> ()) {
        if let diskCookie = UserDefaults.standard.dictionary(forKey: (PrefKey.cookie + domain)){
            fetchInMemoryCookies(for: domain) { freshCookie in
                
                let mergedCookie = diskCookie.merging(freshCookie) { (_, new) in new }
                
                for (cookieName, cookieConfig) in mergedCookie {
                    let cookie = cookieConfig as! Dictionary<String, Any>
                    
                    var expire : Any? = nil
                    
                    if let expireTime = cookie["Expires"] as? Double{
                        expire = Date(timeIntervalSinceNow: expireTime)
                    }
                    
                    let newCookie = HTTPCookie(properties: [
                        .domain: cookie["Domain"] as Any,
                        .path: cookie["Path"] as Any,
                        .name: cookie["Name"] as Any,
                        .value: cookie["Value"] as Any,
                        .secure: cookie["Secure"] as Any,
                        .expires: expire as Any
                    ])
                    
                    self.configuration.websiteDataStore.httpCookieStore.setCookie(newCookie!)
                }
                
                completion()
            }
            
        }
        else{
            completion()
        }
    }
    
    func fetchInMemoryCookies(for domain: String, completion: @escaping ([String: Any]) -> ()) {
        var cookieDict = [String: AnyObject]()
        WKWebsiteDataStore.default().httpCookieStore.getAllCookies { (cookies) in
            for cookie in cookies {
                if cookie.domain.contains(domain) {
                    cookieDict[cookie.name] = cookie.properties as AnyObject?
                }
            }
            completion(cookieDict)
        }
    }
}


//
//function send_gcm_notify($reg_id, $title, $message ,$url , $deviceType) {
//
//   $fields;
//   if($deviceType == 'android'){
//      //android
//      $fields = array(
//         'registration_ids'  => array( $reg_id ),
//         'data'              => array( "msg" => $message ,"title" => $title , "url" => $url ),
//      );
//   }else{
//      //ios
//      $fields = array(
//          'registration_ids'  => array( $reg_id ),
//          'mutable_content'=> true,
//          'url'=> $url,
//          'notification' => array( "subtitle" => $message ,
//                             "title" => "알림"  ,
//                             "url" => $url  ,
//                             'push_message'=> $message,
//                             'sound'=>'Default',
//                             "body" => $message )
//      );
//   }
