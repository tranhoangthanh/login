//
//  HomeVC.swift
//  LoginVC
//
//  Created by apple on 10/20/19.
//  Copyright © 2019 thanh. All rights reserved.
//

import UIKit
import Firebase

class HomeVC: UICollectionViewController , UICollectionViewDelegateFlowLayout{
    let cellid = "cellid"
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(HomeCell.self, forCellWithReuseIdentifier: cellid)
        setupnav()
        fetchPost()
    }
    func setupnav(){
        navigationItem.titleView = UIImageView(image : UIImage(named: "logo2"))
        
    }
    var posts = [Post]()
    fileprivate func fetchPost(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.fetchPostWithUser(user: user)
        }
    }
    
    fileprivate func fetchPostWithUser(user : User){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child("post").child(uid)
        ref.observe(.value, with: { (snapshot) in
            //            print("snapshort :",snapshort)
            guard let dictionaries = snapshot.value as? [String : Any] else {return}
            dictionaries.forEach({ (key,value) in
                //                print("key : ",key)
                //                print("value" , value)
                guard let dictionary = value as? [String : Any] else {return}
                let post = Post(user: user, dictionary: dictionary)
                //                let post = Post(dictionary: dictionary)
                //                print(post)
                self.posts.insert(post, at: 0)
            })
            self.collectionView.reloadData()
        }) { (err) in
            print(err)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height : CGFloat = 40 + 8 + 8
        height += view.frame.width
        height += 50
        height += 60
        return CGSize(width: view.frame.width, height: height)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! HomeCell
        cell.post = posts[indexPath.item]
        return cell
    }
}
