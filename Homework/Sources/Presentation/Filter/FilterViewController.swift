//
//  FilterViewController.swift
//  Homework
//
//  Created by 민쓰 on 24/12/2019.
//  Copyright © 2019 민쓰. All rights reserved.
//

import Foundation
import UIKit
import Then
import SnapKit

protocol FilterViewBindable {
    var selectedFilter:FilterProtocol? { get set }
}

class FilterViewController: ViewController <FilterViewBindable> {
    
    // MARK: - Property
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    var presenter: FilterViewBindable?
    var filterType: FilterType?
    lazy var list: [FilterProtocol] = []
    var confirmValue:((FilterProtocol?) -> ())?
    
    deinit {
        confirmValue = nil
    }
    
    override func bind(_ binding: FilterViewBindable) {
        self.presenter = binding
        
        if let type = filterType {
            switch type {
            case .order:
                list = OrderType.allCases
            case .space:
                list = SpaceType.allCases
            case .residence:
                list = ResidenceType.allCases
            }
        }
    }
    
    override func attribute() {
        tableView.do {
            $0.estimatedRowHeight = 40
            $0.rowHeight = 40
            $0.separatorStyle = .none
            $0.delegate = self
            $0.dataSource = self
        }
        titleLabel.do {
            $0.text = filterType?.description
        }
        bgView.do {
            let gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            gesture.numberOfTapsRequired = 1
            $0.addGestureRecognizer(gesture)
        }
        resetButton.do {
            let gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(clearButtonTap))
            gesture.numberOfTapsRequired = 1
            $0.addGestureRecognizer(gesture)
        }
        confirmButton.do {
            let gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(confirmButtonTap))
            gesture.numberOfTapsRequired = 1
            $0.addGestureRecognizer(gesture)
        }
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension FilterViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let type = filterType {
            switch type {
            case .order:
                return OrderType.allCases.count
            case .space:
                return SpaceType.allCases.count
            case .residence:
                return ResidenceType.allCases.count
            }
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath) as? FilterCell  else {
            fatalError("The dequeued cell is not an instance of FilterCell")
        }
        guard list.count > indexPath.row else {
            return cell
        }
        let data = list[indexPath.row]
        cell.setData(data)

        if presenter?.selectedFilter != nil {
            if data.value == presenter?.selectedFilter?.value {
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            }else{
                tableView.deselectRow(at: indexPath, animated: false)
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard list.count > indexPath.row else {
            return
        }
        let data = list[indexPath.row]
        self.presenter?.selectedFilter = data
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
}

// MARK - Tap Gesture
extension FilterViewController {
    @objc func handleTap(sender: UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }
    @objc func clearButtonTap(sender: UITapGestureRecognizer) {
        if let selectedIndex = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndex, animated: true)
            presenter?.selectedFilter = nil
        }
    }
    @objc func confirmButtonTap(sender: UITapGestureRecognizer) {
        self.confirmValue?(presenter?.selectedFilter)
        self.dismiss(animated: true)
    }
}
