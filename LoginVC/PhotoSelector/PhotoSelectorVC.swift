//
//  PhotoSelectorVC.swift
//  LoginVC
//
//  Created by apple on 10/19/19.
//  Copyright © 2019 thanh. All rights reserved.
//

import UIKit
import Photos //thư viên ảnh của apple
class PhotoSelectorVC : UICollectionViewController , UICollectionViewDelegateFlowLayout {
    
    let cellid = "cellid"
    let cellheader = "cellheader"
    
    //MARK: -viewdidload
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: cellid)
        collectionView.register(HeaderPhoto.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: cellheader)
        setupnav()
        fetchphoto()
    }
    
    
    //MARK: PHOTOS
    var images = [UIImage]()
    var selectedImage: UIImage?
    var assets = [PHAsset]()
    func fetchphoto(){
       
        
        let fetchOption = PHFetchOptions() //thuộc tính lấy ảnh
        fetchOption.fetchLimit = 4 //lấy số ảnh hiển thị
        let stortDesciptor = NSSortDescriptor(key: "creationDate", ascending: false)//sắp xếp theo date
        fetchOption.sortDescriptors = [stortDesciptor]
        
//allphoto
        
        // luồng background để UI không bị treo
        DispatchQueue.global(qos: .background).async {
            let allphoto = PHAsset.fetchAssets(with: .image, options: fetchOption)
            allphoto.enumerateObjects { (asset, count, stop) in
                //print(asset)
                print(count)
                let imageManager = PHImageManager.default() //// giữ hình ảnh thu nhỏ tốt hơn để hiển thị bên trong lưới
                let options = PHImageRequestOptions()
                options.isSynchronous = true //cái này sẽ cho về đúng size của ảnh
                let targetSize = CGSize(width: 350, height: 350)
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options, resultHandler: { (img, info) in
                    if let image = img {
                        self.images.append(image)
                        self.assets.append(asset)
                        if self.selectedImage == nil {
                            self.selectedImage = image
                        }
                    }
                    if count == allphoto.count - 1 {

                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }
           })
       }
}
//
//
    
//
//        let allphoto = PHAsset.fetchAssets(with: .image, options: fetchOption)
//                allphoto.enumerateObjects { (asset, count, stop) in
//                    //        print(asset)
//                    print(count)
//                    let imageManager = PHImageManager.default()
//                    let options = PHImageRequestOptions()
//                    options.isSynchronous = true //cái này sẽ cho về đúng size của ảnh
//                    let targetSize = CGSize(width: 350, height: 350)
//                    imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options, resultHandler: { (img, info) in
//                        if let image = img {
//                            self.images.append(image)
//                            if self.selectedImage == nil {
//                                self.selectedImage = image
//                            }
//                        }
//                        if count == allphoto.count - 1 {
//                            self.collectionView.reloadData()
//                        }
//                    })
//        }
//
//
        
        
        
        
        
    }
    
    
    
    //cell cách so với header
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    //MARK: - HEADER
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }
    var header : HeaderPhoto?
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: cellheader, for: indexPath) as! HeaderPhoto
        
        self.header = header
       
        header.imageView.image = selectedImage
        
        
//
    if let selectedImage = selectedImage {
//        print("selectImage:",selectedImage)
        if  let index = self.images.firstIndex(of: selectedImage) {
//            print("index:",index)
            let selectedAsset = self.assets[index]
//            print("selectedAsset :",selectedAsset)
            //request larger image for header : gủi ảnh lớn hơn cho tiêu đề
            let imageMannager = PHImageManager.default()
            let targetSize = CGSize(width: 600, height: 600)
            imageMannager.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .default, options: nil) { (image, info) in
                header.imageView.image = image
            }
        }
    }
        
        return header
}
    //MARK: - CELL
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3) / 4
        return CGSize(width: width, height: width)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! PhotoCell
        cell.imageView.image = images[indexPath.item]
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
//        print(slectedImage)
        self.selectedImage = images[indexPath.item]
        self.collectionView?.reloadData()
      //lien quan den che do cuộn ảnh trong collection view
        let indexPatch = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: indexPatch, at: .bottom, animated: true)
//        print("indexPatch:",indexPatch)
    }
    
    //ẩn thanh pin
    override var prefersStatusBarHidden: Bool {
        return true
    }
    fileprivate func setupnav(){
        navigationController?.navigationBar.tintColor = .black //màu chữ nav
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelAction))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextAction))
    }
    @objc func cancelAction(){
        dismiss(animated: true, completion: nil)
    }
    @objc func nextAction(){
        let sharephoto = SharePhoTo()
        sharephoto.selectedImage = header?.imageView.image
        navigationController?.pushViewController(sharephoto, animated: true)
    }
}
