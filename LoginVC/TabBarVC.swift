//
//  TabBarVC.swift
//  LoginVC
//
//  Created by apple on 10/18/19.
//  Copyright © 2019 thanh. All rights reserved.
//

import UIKit
import  Firebase
class TabBarVC: UITabBarController , UITabBarControllerDelegate {
    //kế thừa bởi UITabBarControllerDelegate : nếu false hàm vô hiệu hoá chọn của tabbar
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
//        print(index)
        if index == 2 {
            let layout = UICollectionViewFlowLayout()
            let photoselector = PhotoSelectorVC(collectionViewLayout: layout)
            let nav = UINavigationController(rootViewController: photoselector)
            present(nav, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    //hiện nếu không được login thành công
        DispatchQueue.main.async {
            if Auth.auth().currentUser == nil {
                DispatchQueue.main.async { //waits until main tab bar controller is inside the UI, then presents it : // đợi cho đến khi bộ điều khiển thanh tab chính nằm trong UI, sau đó trình bày nó
                    let signinvc = SignInVC()
                    let navController = UINavigationController(rootViewController: signinvc)
                    self.present(navController, animated: true, completion: nil)
                }
        return
        }
        }
        setupvc()
    }
    func setupvc(){
     let homevc =  nav(unselectedImage: UIImage(named: "home_unselected")!, selectedImage: UIImage(named: "home_selected")!, rootViewController: HomeVC(collectionViewLayout: UICollectionViewFlowLayout()))
        let searchvc = nav(unselectedImage: UIImage(named: "search_unselected")!, selectedImage: UIImage(named: "search_selected")!, rootViewController: UserSearchVC(collectionViewLayout: UICollectionViewFlowLayout()))
        
     let plusvc = nav(unselectedImage: UIImage(named: "plus_unselected")!, selectedImage: UIImage(named: "plus_unselected")!, rootViewController: UIViewController())
     let likevc = nav(unselectedImage: UIImage(named: "like_unselected")!, selectedImage: UIImage(named: "like_selected")!, rootViewController: UIViewController())
     let uservc = nav(unselectedImage: UIImage(named: "profile_unselected")!, selectedImage: UIImage(named: "profile_selected")!, rootViewController: UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout()))
        tabBar.tintColor = .black
        viewControllers = [homevc,searchvc,plusvc,likevc,uservc]
        
        // sửa đổi các mục trong thanh tab
        guard let items = tabBar.items else {return}
        for item in items {
            //đẩy biểu tượng xuống 4 pixel từ trên xuống
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    fileprivate func nav(unselectedImage : UIImage ,selectedImage : UIImage , rootViewController: UIViewController) -> UINavigationController {
        let vc = rootViewController
        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        return navController
    }
    
    
}
