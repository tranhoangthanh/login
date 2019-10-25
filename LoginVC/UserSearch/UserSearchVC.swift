//
//  UserSearchVC.swift
//  LoginVC
//
//  Created by apple on 10/21/19.
//  Copyright © 2019 thanh. All rights reserved.
//

import UIKit
import Firebase

class UserSearchVC: UICollectionViewController , UICollectionViewDelegateFlowLayout ,UISearchBarDelegate {
    
   lazy var  searchBar : UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Enter name"
        sb.tintColor = .gray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        sb.delegate = self //cần lazy var để tự truy cập, sử dụng let không cho phép bạn truy cập vào chính mình
        return sb
    }()
    
    //hàm tìm kiếm
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        print(searchText)
        if searchText.isEmpty {
            self.filteredUsers = users
        } else {
            self.filteredUsers =  self.users.filter { (user) -> Bool in
                return user.name.lowercased().contains(searchText.lowercased()) //chữ thường
            }
        }
    
        self.collectionView.reloadData()
    }
   
    
    let cellid = "cellid"
   
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        navigationController?.navigationBar.addSubview(searchBar)
        let navbar = navigationController?.navigationBar
        searchBar.anchor(top: navbar?.topAnchor, left: navbar?.leftAnchor, bottom: navbar?.bottomAnchor, right: navbar?.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        collectionView.register(UserSearchCell.self, forCellWithReuseIdentifier: "cellid")
        collectionView.alwaysBounceVertical = true //hiệu ứng trượt
        collectionView?.keyboardDismissMode = .onDrag //Bàn phím bị loại bỏ khi bắt đầu kéo.
        fetchUsers()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.searchBar.isHidden = false
    }
    var filteredUsers = [User]()
    var users = [User]()
    fileprivate func fetchUsers(){
        print("fetchUsers")
        let ref = Database.database().reference().child("users")
        ref.observe(.value, with: { (snapshot) in
//            print(snapshot)
            guard let dictionaries = snapshot.value as? [String : Any] else {return}
            dictionaries.forEach({ (key,value) in
                guard let userdictionary = value as? [String : Any] else {return}
                let user = User(uid: key, dictionary: userdictionary)
//                print(user.uid,user.profileImageUrl)
                
                if key == Auth.auth().currentUser?.uid {
//                 print("Tìm thấy chính mình, bỏ qua khỏi danh sách")
                return
            }
                
                self.users.append(user)
            })
            
            self.users.sort(by: { (u1, u2) -> Bool in
                //sắp xếp người dùng theo thứ tự ABC
                return u1.name.compare(u2.name) == .orderedAscending
            })
            
            self.filteredUsers = self.users
           self.collectionView.reloadData()
        }) { (err) in
            print(err)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! UserSearchCell
        cell.user = filteredUsers[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       self.searchBar.isHidden = true
        self.searchBar.resignFirstResponder() //ẩn bàn phím khi bạn chọn một row
        let user = filteredUsers[indexPath.row]
        print(user.name)
        let userProfile = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
        userProfile.userid = user.uid
        navigationController?.pushViewController(userProfile, animated: true)
        
    }
}
