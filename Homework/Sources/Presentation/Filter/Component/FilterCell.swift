//
//  FilterCell.swift
//  Homework
//
//  Created by 민쓰 on 24/12/2019.
//  Copyright © 2019 민쓰. All rights reserved.
//

import Foundation
import UIKit

class FilterCell: UITableViewCell {
    typealias Data = (FilterProtocol)
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
   
    func setData(_ data: Data) {
        titleLabel.do {
            $0.text = data.description
        }
    }

}
