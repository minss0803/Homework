//
//  ImageDetailPresenter.swift
//  Homework
//
//  Created by 민쓰 on 21/12/2019.
//  Copyright © 2019 민쓰. All rights reserved.
//

import Foundation

struct ImageDetailPresenter: ImageDetailBindable {
    var dataChanged: ((Bucket) -> Void)?
    var bucket: Bucket? {
        didSet {
            if let handler = dataChanged, let bucket = bucket {
                handler(bucket)
            }
        }
    }
    
    func scrollInsetForCenter(imageSize:(width: Float, height: Float),
                              scrollSize:(width: Float, height: Float),
                              contentSize:(width: Float, height: Float)) -> (top:Float, left:Float) {
        if imageSize.height <= scrollSize.height {
            let shiftHeight = scrollSize.height/2.0 - contentSize.height/2.0
            return (shiftHeight, 0)
        }
        if imageSize.width <= scrollSize.width {
            let shiftWidth = scrollSize.width/2.0 - contentSize.width/2.0
            return (0, shiftWidth)
        }else{
            return (0, 0)
        }
    }
    
}
