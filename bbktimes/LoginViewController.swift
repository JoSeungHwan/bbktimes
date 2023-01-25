//
//  loginView.swift
//  bbktimes
//
//  Created by 조승환 on 2023/01/02.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var IDText: UITextField!
    @IBOutlet weak var PasswordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        imgView.layer.cornerRadius = 30
        imgView.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMinYCorner]
        loginBtn.layer.cornerRadius = 30
        loginBtn.layer.maskedCorners = [.layerMaxXMaxYCorner]
        IDText.placeholder = "ID"
        PasswordText.placeholder = "Password"
        
    }
    
   
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    @IBAction func LoginBtn(_ sender: UIButton) {
        let push = self.storyboard?.instantiateViewController(withIdentifier: "joinViewController")
        self.navigationController?.pushViewController(push!, animated: true)
        print("로그인 버튼 클릭")
    }
    
    @IBAction func joinBtn(_ sender: UIButton) {
//        guard let push = self.storyboard?.instantiateViewController(withIdentifier: "joinView") else { return }
//        self.navigationController?.pushViewController(push, animated: true)
        print("회원가입 버튼 클릭")
        guard let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "joinView") as? joinViewController else { return }
                // 화면 전환 애니메이션 설정
                secondViewController.modalTransitionStyle = .coverVertical
                // 전환된 화면이 보여지는 방법 설정 (fullScreen)
                secondViewController.modalPresentationStyle = .fullScreen
                self.present(secondViewController, animated: true, completion: nil)
    }
    
}

