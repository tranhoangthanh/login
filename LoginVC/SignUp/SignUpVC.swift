//
//  SignUpVC.swift
//  LoginVC
//
//  Created by tranthanh on 10/17/19.
//  Copyright © 2019 thanh. All rights reserved.
//

import UIKit
import Firebase
class SignUpVC: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    
    @IBOutlet weak var emailTf: UITextField! {
        didSet {
            self.emailTf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        }
    }
    @IBOutlet weak var usernameTf: UITextField! {
        didSet {
            self.usernameTf.addTarget(self, action: #selector(handleTextInputChange), for: .touchUpInside)
        }
    }
    @IBOutlet weak var passwordTf: UITextField! {
        didSet {
            self.passwordTf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        }
    }
    @objc func handleTextInputChange() {
        // nếu đầu vào input bị thiếu thay đổi màu trở lại màu ban đầu
        let isFormValid = emailTf.text?.count ?? 0 > 0 && usernameTf.text?.count ?? 0 > 0 && passwordTf.text?.count ?? 0 > 0
        if isFormValid {
            signupBtn.isEnabled = true //enable sign up button
            signupBtn.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        } else {
            signupBtn.isEnabled = false //disable sign up button
            signupBtn.backgroundColor = UIColor.red
        }
    }
    @IBOutlet weak var signupBtn: UIButton! {
        didSet{
            signupBtn.layer.cornerRadius = 10
            signupBtn.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var selectImage: UIButton! {
        didSet {
            self.selectImage.layer.cornerRadius = 5
            self.selectImage.layer.masksToBounds = true
        }
    }
    //hàm này sử lý sau khi chọn đk ảnh
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if  let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = originalImage
        }
        if let editImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageView.image = editImage
        }
        dismiss(animated: true, completion: nil)
    }
    @IBAction func selectImageAction(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    @IBOutlet weak var imageView: UIImageView!{
        didSet{
            self.imageView.layer.cornerRadius = 50
            self.imageView.layer.masksToBounds = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func textBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func signupBtnAction(_ sender: Any) {
        //b1 : khai báo các tf
        //phải điền cả 3 mới đăng kí được
        guard let email = emailTf.text , email.count > 0  else {return}
        guard let username = usernameTf.text , username.count > 0 else {return}
        guard let password = passwordTf.text , password.count > 0  else {return}
        //b2 : liên kết tạo tài khoản với firebase
        Auth.auth().createUser(withEmail: email, password: password) { (user , err) in
            if let err = err {
            print("lỗi tạo user :",err)
            }
            print("tạo thành công user :",user?.user.email ?? "")
          //b3 : post dữ liệu lên
            // upload ảnh
            //quyết định tên tệp nào sẽ thay folder "profdle_image" trên firebase
            guard let profileImage = self.imageView.image else {return}
            //nén 30% hình ảnh của bạn
            guard let uploadData = profileImage.jpegData(compressionQuality: 0.3) else {return}
            //quyết định tên tệp nào sẽ thay folder "profdle_image" trên firebase
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
            storageRef.putData(uploadData, metadata: nil, completion: { (_, err) in
                if let err = err {print("lưu vào Storage lỗi",err)}
                storageRef.downloadURL(completion: { (url, err) in
                    if let err = err {
                        print(err)
                        return
                    }
                    print("lưu ảnh thành công")
            // b4 : lưu trên database
                    guard let url = url else { return }
                    guard let uid = user?.user.uid else {return}
                    let ref = Database.database().reference().child("users").child(uid)
                    let values = ["name": username , "email": email , "profileImageUrl": url.absoluteString]
                    ref.updateChildValues(values, withCompletionBlock: { (err, ref) in
                        if let err = err {print("lưu vào db lỗi :",err)}
                        print("lưu db thành công")
                        //cái này để truy cập lại cả màn user nếu đăng kí thành công
                        guard let tabbarvc = UIApplication.shared.keyWindow?.rootViewController as? TabBarVC else {return}
                        tabbarvc.setupvc()
                        print("SignIn thành công :",user?.user.email ?? "" )
                        self.dismiss(animated: true, completion: nil)
                })
            })
        })
    }
  }
}
