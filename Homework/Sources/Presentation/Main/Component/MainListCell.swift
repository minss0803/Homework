//
//  MainListCell.swift
//  Homework
//
//  Created by 민쓰 on 20/12/2019.
//  Copyright © 2019 민쓰. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class MainListCell: UITableViewCell {
    typealias Data = (Bucket)

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        shrink(down: highlighted)
    }
    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        attribute()
        layout()
    }
    
   
    func setData(_ data: Data) {
        detailImageView.do {
            $0.kf.setImage(with: URL(string: data.imageUrl))
        }
        descriptionLabel.do {
            $0.text = data.description
        }
    }
    
    func attribute() {
        self.do {
            $0.selectionStyle = .none
        }
        detailImageView.do {
            $0.layer.cornerRadius = 10.0
            $0.clipsToBounds = true
        }
    }
    
    func layout() {}
}

extension MainListCell {
    func shrink(down: Bool) {
        UIView.animate(withDuration: 0.2,
                       delay: 0.0,
                       options: [.allowUserInteraction, .curveEaseInOut], animations: {
            if down {
                self.detailImageView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            } else {
                self.detailImageView.transform = .identity
            }
        })
    }
}
