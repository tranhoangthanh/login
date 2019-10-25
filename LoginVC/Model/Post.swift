//
//  Post.swift
//  LoginVC
//
//  Created by apple on 10/21/19.
//  Copyright © 2019 thanh. All rights reserved.
//

import Foundation

struct Post {
    let user : User
    let imageUrl : String
    let caption : String
    init(user: User , dictionary : [String : Any]) {
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.user = user
        self.caption = dictionary["caption"] as? String ?? ""
    }
}
