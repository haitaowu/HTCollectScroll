//
//  CollectionCell.swift
//  HTCollectScroll
//
//  Created by taotao on 1/16/16.
//  Copyright © 2016 taotao. All rights reserved.
//
import Foundation
import UIKit


class CollectionCell: UICollectionViewCell{
    @IBOutlet weak var imageView: UIImageView!
    var imageName:String?
    
    var image:String{
        get{
            return self.imageName!
        }
        set(imageName){
            let img = UIImage.init(named: imageName)
            self.imageView.image = img
        }
    }
}
