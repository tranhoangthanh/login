//
//  UserProfileVC.swift
//  LoginVC
//
//  Created by apple on 10/18/19.
//  Copyright © 2019 thanh. All rights reserved.
//

import UIKit
import Firebase
class UserProfileVC: UICollectionViewController , UICollectionViewDelegateFlowLayout {
    
    
    let cellheader = "cellheader"
    let cellid = "cellid"
    var userid : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        navigationItem.title = Auth.auth().currentUser?.uid
        fetchUser()
        //đăng kí headercell
        let nib = UINib(nibName: "HeaderUser", bundle: nil)
        collectionView.register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: cellheader)
        //đăng kí cell
        collectionView.register(UserPhotoCell.self, forCellWithReuseIdentifier: cellid)
        logoutsetup()
//        fetchpost()
       
    }
    
    
    //MARK : GET : lay du lieu ve
    var posts = [Post]()
    fileprivate func fetchOrderPosts(){
        guard let uid = self.user?.uid else { return }
        
        let ref = Database.database().reference().child("post").child(uid)
        //order by creation data
        ref.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            
            guard let user = self.user else { return }
            
            let post = Post(user: user, dictionary: dictionary)
            
            //fix ordered - newest images are in first cell of collection view grid
            self.posts.insert(post, at: 0)
            self.collectionView?.reloadData()
            
        }) { (err) in
            print("Failed to fetch ordered posts:", err)
        }
    
    }
    
    
    fileprivate func logoutsetup(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "gear")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(logoutAction))
        
    }
    
    @objc func logoutAction(){
        //b1 : khaibao 1 alert
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        //b2 : thêm các hành động
        alert.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { (_) in
            //ta sẽ thoát firebase ở đây
            do{
                //chúng ta sẽ trở về màn login
                try Auth.auth().signOut()
                //cần chuyển về màn login
                let signinVC = SignInVC()
                let navigation = UINavigationController(rootViewController: signinVC)
                self.present(navigation,animated: true,completion: nil)
            }
            catch let err {
                print("lỗi :",err)
            }
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        //b3 present
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: -liên kết user
    var user : User?
    func fetchUser(){
        
         let uid = self.userid ?? Auth.auth().currentUser?.uid ?? ""
//        guard let uid = Auth.auth().currentUser?.uid else {return}
            Database.fetchUserWithUID(uid: uid) { (users) in
            self.user = users
            self.navigationItem.title = self.user?.name
            self.collectionView.reloadData()
              self.fetchOrderPosts()
        }
    }
    
    //header uicolectionview
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: cellheader, for: indexPath) as! HeaderUser
        header.user = self.user
        return header
    }
    //quản lý bởi UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    //số cell
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    //hiển thị trong cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! UserPhotoCell
        
//    cell.imageView.image = UIImage(named: posts[indexPath.item].imageUrl)
        cell.post = posts[indexPath.item]
        
        return cell
    }
    //chỉnh size cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    //khoảng cách dọc cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    //khoảng cách ngang cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
}


