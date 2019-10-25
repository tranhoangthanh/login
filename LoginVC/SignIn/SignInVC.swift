//
//  SignInVC.swift
//  LoginVC
//
//  Created by tranthanh on 10/17/19.
//  Copyright © 2019 thanh. All rights reserved.
//

import UIKit
import Firebase
class SignInVC: UIViewController {
    
    @IBOutlet weak var signInBtn: UIButton!{
        didSet {
            self.signInBtn.layer.cornerRadius = 10
            self.signInBtn.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var emailTf: UITextField! {
        didSet{
            self.emailTf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        }
    }
    
    @IBOutlet weak var passwordTf: UITextField! {
        didSet{
            self.passwordTf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        }
    }
    
    @objc func handleTextInputChange() {
        // nếu đầu vào input bị thiếu thay đổi màu trở lại màu ban đầu
        let isFormValid = emailTf.text?.count ?? 0 > 0 &&  passwordTf.text?.count ?? 0 > 0
        if isFormValid {
           signInBtn.isEnabled = true //enable sign up button
           signInBtn.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        } else {
           signInBtn.isEnabled = false //disable sign up button
            signInBtn.backgroundColor = UIColor.red
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    
  

    @IBAction func textBtn(_ sender: Any) {
        navigationController?.pushViewController(SignUpVC(), animated: true)
    }
    
    
    @IBAction func signInAction(_ sender: Any) {
        //b1 : khai báo các trường tf
        //phải điền cả hai mới dăng kí được
        guard let email = emailTf.text , email.count > 0 else {return}
        guard let password = passwordTf.text , password.count > 0 else {return}
        //b2 : liên kêt tới signin tài khoản trên firebase
        Auth.auth().signIn(withEmail: email, password: password) { (user, err) in
            if let err = err {
                print("lỗi SignIn",err)
                return
            }
            //cái này để truy cập lại cả màn user nếu đăng nhập thành công
            guard let tabbarvc = UIApplication.shared.keyWindow?.rootViewController as? TabBarVC else {return}
            tabbarvc.setupvc()
            print("SignIn thành công :",user?.user.email ?? "" )
            self.dismiss(animated: true, completion: nil)
        }
        
    }

}
