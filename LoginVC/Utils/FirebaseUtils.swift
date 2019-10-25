//
//  FirebaseUtils.swift
//  LoginVC
//
//  Created by apple on 10/21/19.
//  Copyright © 2019 thanh. All rights reserved.
//

import Firebase


extension Database {
    static func fetchUserWithUID(uid : String , completion : @escaping (User) -> ()) {
//        print("fetch user with uid",uid)
        Database.database().reference().child("users").child(uid).observe(.value, with: { (snapshot) in
            guard let userdictionary = snapshot.value as? [String : Any] else {return}
            let user = User(uid: uid, dictionary: userdictionary)
//            print(user.name)
            completion(user)
        }) { (err) in
            print("fetchUser ERR :",err)
        }
    }
}
