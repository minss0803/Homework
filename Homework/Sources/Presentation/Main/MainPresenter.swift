//
//  MainPresenter.swift
//  Homework
//
//  Created by 민쓰 on 20/12/2019.
//  Copyright © 2019 민쓰. All rights reserved.
//

import Foundation

struct MainPresenter: MainViewBindable {
    
    /// Presenter -> Voew
    var requestBucketList: (() -> Void)?
    var updateFilter: (() -> Void)?
    
    /// View -> Presenter
    var model: MainModel
    var bucketList:[Bucket] = []
    
    var selectedFilter:(OrderType?,SpaceType?,ResidenceType?) = (nil,nil,nil) {
        didSet {
            self.selectedFilterDidChange?(selectedFilter.0,selectedFilter.1,selectedFilter.2)
        }
    }
    var selectedFilterDidChange:((OrderType?,SpaceType?,ResidenceType?) -> ())?
    
    init(model: MainModel = MainModel()) {
        self.model = model
    }
    
}

