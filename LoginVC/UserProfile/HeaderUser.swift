//
//  HeaderUserCell.swift
//  LoginVC
//
//  Created by apple on 10/18/19.
//  Copyright © 2019 thanh. All rights reserved.
//

import UIKit
import Firebase

class HeaderUser: UICollectionViewCell {
    
    @IBOutlet weak var nameLbl: UILabel! 
        
    @IBOutlet weak var editProfile: UIButton! {
        didSet {
            self.editProfile.layer.borderWidth = 1
            self.editProfile.layer.borderColor = UIColor.lightGray.cgColor
            self.editProfile.layer.cornerRadius = 5
            
        }
    }
    
    @IBOutlet weak var profileImage: UIImageView! {
        didSet {
            self.profileImage.layer.cornerRadius = 40
            self.layer.masksToBounds = true
        }
    }
    
    override func awakeFromNib() {
       
    }
    
    var user : User? {
        didSet {
            
            setupProfileImage()
            self.nameLbl.text = self.user?.name
        }
    }
    
    fileprivate func setupProfileImage(){
        
        guard let profileImageUrl = user?.profileImageUrl else {return}
        //liên kết lấy ảnh về
        guard  let url = URL(string: profileImageUrl) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print("lỗi lấy ảnh về",err)
                return
            }
            print("data:",data ?? "")
            guard let data = data else {return}
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.profileImage.image = image
            }
        }.resume()
        
        
        
        
        
        //liên kết tới user
//        guard let uid = Auth.auth().currentUser?.uid else {return}
//        Database.database().reference().child("users").child(uid).observe(.value, with: { (snapshot) in
//            print("đây là gia trị users",snapshot.value ?? "")
//            let dictionary = snapshot.value as? [String : Any]
//            guard let profileImageUrl = dictionary?["profileImageUrl"] as? String else {return}
//        //liên kết lấy ảnh về
//            guard  let url = URL(string: profileImageUrl) else {return}
//            URLSession.shared.dataTask(with: url) { (data, response , err ) in
//                print("data:",data ?? "")
//                if let err = err {
//                    print("lỗi lấy ảnh về",err)
//                    return
//                }
//              //xử dụng data để gán vào imageView
//                guard let data = data else {return}
//                let image = UIImage(data: data)
//                DispatchQueue.main.async {
//                    self.profileImage.image = image
//                }
//            }.resume()
//        }) { (err) in
//            print("lỗi lấy user:",err)
//        }

        
    }
    @IBAction func EditProfileAction(_ sender: Any) {
    }
}
