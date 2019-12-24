//
//  FilterPresenter.swift
//  Homework
//
//  Created by 민쓰 on 24/12/2019.
//  Copyright © 2019 민쓰. All rights reserved.
//

import Foundation

struct FilterPresenter: FilterViewBindable {
    
    /// View -> Presenter
    var selectedFilter:FilterProtocol? = nil {
        didSet {
            self.selectedFilterDidChange?(selectedFilter)
        }
    }
    var selectedFilterDidChange:((FilterProtocol?) -> ())?
    
}
