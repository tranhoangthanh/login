//
//  UserPhotoCell.swift
//  LoginVC
//
//  Created by apple on 10/20/19.
//  Copyright © 2019 thanh. All rights reserved.
//

import UIKit

class UserPhotoCell: UICollectionViewCell {
   
    var post: Post? {
            didSet {
                //fetch external image data with a url
                guard let imageUrl = post?.imageUrl else { return }
                photoImageView.loadImage(urlString: imageUrl)
        }
    }
    
    let photoImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
