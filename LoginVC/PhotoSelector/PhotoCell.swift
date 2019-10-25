//
//  PhotoSelectorCell.swift
//  LoginVC
//
//  Created by apple on 10/20/19.
//  Copyright © 2019 thanh. All rights reserved.
//

import UIKit

class PhotoCell : UICollectionViewCell {
    
    let imageView : UIImageView = {
        let img  = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    func layout(){
        addSubview(imageView)
        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
