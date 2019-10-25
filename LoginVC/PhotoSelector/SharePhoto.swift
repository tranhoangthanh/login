//
//  SharePhoto.swift
//  LoginVC
//
//  Created by apple on 10/20/19.
//  Copyright © 2019 thanh. All rights reserved.
//

import UIKit
import Firebase

class SharePhoTo : UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var selectedImage : UIImage? {
        didSet {
            //            print(self.selectedImage)
            self.imageView.image = self.selectedImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .rgb(red: 240, green: 240, blue: 240)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(shareAction))
        setupImageandTextView()
    }
    
    let imageView : UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.purple
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let textview : UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        return tv
    }()
    func setupImageandTextView(){
        let containerView = UIView()
        containerView.backgroundColor = .white
        view.addSubview(containerView)
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
        containerView.addSubview(imageView)
        imageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 84, height: 0)
        containerView.addSubview(textview)
        textview.anchor(top: imageView.topAnchor, left: imageView.rightAnchor, bottom: imageView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    //MARK: post : cập nhật dữ liệu
    @objc func shareAction(){
        guard let caption = textview.text , caption.count > 0 else {return}
        guard let image = selectedImage else {return}
        guard let uploadData = image.jpegData(compressionQuality: 0.5) else {return}
        //quyết định tên tệp nào sẽ thay folder "profdle_image" trên firebase
        navigationItem.rightBarButtonItem?.isEnabled = false
        let filename = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("post").child(filename)
        
        storageRef.putData(uploadData, metadata: nil) { (_, err) in
            if let err = err {
                print("lưu vào Storage lỗi",err)
            }
            storageRef.downloadURL(completion: { (url, err) in
                if let err = err {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    print(err)
                    return
                }
                print("lưu ảnh thành công")
                guard let url = url else { return }
                self.saveDatabase(imageUrl: url.absoluteString)
            })
        }
    }
    
    fileprivate func saveDatabase(imageUrl : String){
        guard let postImage = selectedImage else {return}
        guard let caption = textview.text else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let userPostRer = Database.database().reference().child("post").child(uid)
        let ref = userPostRer.childByAutoId()
        let values = [ "imageUrl":imageUrl , "caption": caption , "imagewith": postImage.size.width , "imageheight": postImage.size.height , "creationDate": Date().timeIntervalSince1970] as [String : Any]
        ref.updateChildValues(values) { (err, ref) in
            if let err = err {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("lỗi save post db",err)
            }
            print("lưu thành công db")
            self.dismiss(animated: true, completion: nil)
        }
    }
}
