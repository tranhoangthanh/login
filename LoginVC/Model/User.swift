//
//  User.swift
//  LoginVC
//
//  Created by apple on 10/21/19.
//  Copyright © 2019 thanh. All rights reserved.
//

import Foundation
//MARK: - STRUCT
struct User {
    let uid : String
    let name : String
    let profileImageUrl : String
    init(uid : String , dictionary : [String : Any]) {
        self.uid = uid
        self.name = dictionary["name"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
}

