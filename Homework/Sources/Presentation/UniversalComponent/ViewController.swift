//
//  ViewController.swift
//  Homework
//
//  Created by 민쓰 on 20/12/2019.
//  Copyright © 2019 민쓰. All rights reserved.
//

import Foundation
import UIKit

class ViewController<ViewBindable> : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attribute()
        layout()
        
    }
    
    deinit {
        print("\(ViewBindable.self) 메모리 할당 해제됨")
    }
    
    func bind(_ binding: ViewBindable) {}
    
    func attribute() {}
    
    func layout() {}
    
    
    
    
}
