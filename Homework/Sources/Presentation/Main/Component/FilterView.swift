//
//  FilterView.swift
//  Homework
//
//  Created by 민쓰 on 20/12/2019.
//  Copyright © 2019 민쓰. All rights reserved.
//

import Foundation
import UIKit

protocol FilterProtocol {
    var value: String { get }
    var description: String { get }
}

enum FilterType: CaseIterable {
    case order, space, residence
    
    public var description: String {
        switch self {
        case .order: return "정렬"
        case .space: return "공간"
        case .residence: return "주거형태"
        }
    }
}
/**
 * order: 정렬
 * 최신순(recent), 베스트(best), 인기순(popular)
 */
enum OrderType: CaseIterable, FilterProtocol {
    case recent, best, popular
    
    public var name: String {
        return "정렬"
    }
    public var value: String {
        switch self {
        case .recent: return "recent"
        case .best: return "best"
        case .popular: return "popular"
        }
    }
    public var description: String {
        switch self {
        case .recent: return "최신순"
        case .best: return "베스트"
        case .popular: return "인기순"
        }
    }
}
/**
 * space: 공간
 * 거실(1), 침실(2), 주방(3), 욕실(4)
 */
enum SpaceType: FilterProtocol, CaseIterable {
    case living,bedroom,kitchen,bathroom

    public var value: String {
        switch self {
        case .living: return "1"
        case .bedroom: return "2"
        case .kitchen: return "3"
        case .bathroom: return "4"
        }
    }
    public var description: String {
        switch self {
        case .living: return "거실"
        case .bedroom: return "침실"
        case .kitchen: return "주방"
        case .bathroom: return "욕실"
        }
    }
}
/**
 * residence: 주거형태
 * 아파트(1), 빌라&연립(2), 단독주택(3), 사무공간(4)
 */
enum ResidenceType: FilterProtocol, CaseIterable {
    case apartment,villa,house,office
    
    public var value: String {
        switch self {
        case .apartment: return "1"
        case .villa: return "2"
        case .house: return "3"
        case .office: return "4"
        }
    }
    public var description: String {
        switch self {
        case .apartment: return "아파트"
        case .villa: return "빌라&연립"
        case .house: return "단독주택"
        case .office: return "사무공간"
        }
    }
}

protocol FilterDelegate {
    func filterSelected(of type: Any)
}
class FilterView: UIView {
    
    // MARK: - UI Setting
    private struct UI {
        static let lightBlueColor = UIColor(red: 232/255.0, green: 244/255.0, blue: 251/255.0, alpha: 1.0)
        static let bucketBlueColor = UIColor(red: 53/255.0, green: 197/255.0, blue: 240/255.0, alpha: 1.0)
        static let inactiveButtonColor = UIColor(white: 0.9, alpha: 1.0)
        static let buttonFont = UIFont.systemFont(ofSize: 15, weight: .bold)
    }
    
    // MARK: - Properties
    @IBOutlet weak var resultScrollView: UIScrollView!
    @IBOutlet weak var filterStackView: UIStackView! // 필터 항목 (ex. 정렬, 주거형태, 공간)을 담는 StackView
    @IBOutlet weak var sortingButton: UIButton!
    @IBOutlet weak var spaceButton: UIButton!
    @IBOutlet weak var residenceButton: UIButton!
    @IBOutlet weak var resultStackView: UIStackView! // 현재 활성화되어 있는 필터링을 화면에 노출하는 영역

    var filterButtonPressed:((FilterType) -> Void)?
    var removeButtonPressed:((FilterType) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        attribute()
        layout()
    }
    
    func attribute() {
        sortingButton.do {
            $0.layer.cornerRadius = 10
            if let titleWidth = $0.titleLabel?.frame.width {
                let spacing = titleWidth + 5
                $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing);
            }
        }
        residenceButton.do {
            $0.layer.cornerRadius = 10
            if let titleWidth = $0.titleLabel?.frame.width {
                let spacing = titleWidth + 5
                $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing);
            }
        }
        spaceButton.do {
            $0.layer.cornerRadius = 10
            if let titleWidth = $0.titleLabel?.frame.width {
                let spacing = titleWidth + 5
                $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing);
            }
        }
    }
    
    func layout() {
        // xib에 확인용으로 그려놓은 임시 뷰들을 제거
        resultStackView.safelyRemoveArrangedSubviews()
        
        spaceButton.addTarget(self, action: #selector(actionWithParam(_:)), for: .touchUpInside)
        residenceButton.addTarget(self, action: #selector(actionWithParam(_:)), for: .touchUpInside)
        sortingButton.addTarget(self, action: #selector(actionWithParam(_:)), for: .touchUpInside)
    }
    
    @objc func actionWithParam(_ sender: UIButton){
        if let handler = filterButtonPressed {
            switch sender {
            case sortingButton:
                handler(.order)
            case spaceButton:
                handler(.space)
            case residenceButton:
                handler(.residence)
            default:
                break
            }
        }
    }
    
    @objc func actionWithDelete(_ sender: UIButton){
        if sender.tag == 0 {
            self.removeButtonPressed?(.order)
        }else if sender.tag == 1 {
            self.removeButtonPressed?(.space)
        }else if sender.tag == 2 {
            self.removeButtonPressed?(.residence)
            
        }
    }
}

// MARK: - UI/UX
extension FilterView {
    
    func updateFilterStatue(_ type:(OrderType?, SpaceType?, ResidenceType?)) {
        self.sortingButton.do {
            $0.backgroundColor = (type.0 != nil) ? UI.lightBlueColor : UI.inactiveButtonColor
            $0.setTitleColor((type.0 != nil) ? UI.bucketBlueColor : UIColor.lightGray, for: .normal)
        }
        self.spaceButton.do {
            $0.backgroundColor = (type.1 != nil) ? UI.lightBlueColor : UI.inactiveButtonColor
            $0.setTitleColor((type.1 != nil) ? UI.bucketBlueColor : UIColor.lightGray, for: .normal)
        }
        self.residenceButton.do {
            $0.backgroundColor = (type.2 != nil) ? UI.lightBlueColor : UI.inactiveButtonColor
            $0.setTitleColor((type.2 != nil) ? UI.bucketBlueColor : UIColor.lightGray, for: .normal)
        }
    }
    
    func updateSelectedFilter(_ type:(OrderType?, SpaceType?, ResidenceType?)) {
        
        func createButton(type: FilterProtocol, filterType:FilterType) -> UIButton {
            let button = UIButton()
            button.do {
                $0.titleLabel?.font = UI.buttonFont
                $0.setTitle(type.description, for: .normal)
                $0.setTitleColor(.white, for: .normal)
                $0.setImage(UIImage(named: "ico_delete"), for: .normal)
                $0.semanticContentAttribute = .forceRightToLeft
                $0.backgroundColor = UI.bucketBlueColor
                $0.contentEdgeInsets = UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8)
                $0.layer.cornerRadius = 15.0
                
                if let titleWidth = $0.titleLabel?.frame.width {
                    let spacing = titleWidth + 5
                    $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing);
                }
                
                switch filterType {
                case .order:
                    $0.tag = 0
                case .space:
                    $0.tag = 1
                case .residence:
                    $0.tag = 2
                }
                $0.addTarget(self, action: #selector(actionWithDelete(_:)), for: .touchUpInside)
            }
  
            return button
        }
        // 기존에 그려져있는 선택된 필터 뷰들을 화면에서 제거
        resultStackView.safelyRemoveArrangedSubviews()
        
        var buttons = [UIButton]()
        for caseName in FilterType.allCases {
            var buttonType: FilterProtocol?
            switch caseName {
            case .order:
                buttonType = type.0
            case .residence:
                buttonType = type.2
            case .space:
                buttonType = type.1
            }
            if buttonType != nil {
                buttons.append(createButton(type: buttonType!, filterType: caseName))
            }
        }
        for button in buttons {
            resultStackView.addArrangedSubview(button)
        }
        if buttons.count == 0 {
            self.resultScrollView.snp.makeConstraints {
                $0.height.equalTo(0)
            }
        }else{
            self.resultScrollView.snp.removeConstraints()
        }
        
    }
    /*
     * 필터뷰의 서브 뷰(label,uiview 등등..)들의 고유사이즈를 업데이트 하여,
     * 뷰를 높이를 컨텐츠의 최소 크기에 맞춰 뷰를 업데이트 함
     */
    func sizeHeaderToFit() -> FilterView {
        self.parseTreeWithView(subViews: self.subviews)
        let height = self.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        self.setNeedsLayout()
        self.layoutIfNeeded()

        var frame = self.frame
        frame.size.height = height
        self.frame = frame
        
        return self
    }
    
    func parseTreeWithView(subViews: [UIView]) {
        if subViews.count == 0 {
            return
        }
        
        for subview in subViews {
            if let label = subview as? UILabel {
                label.preferredMaxLayoutWidth = label.frame.size.width
            }
            if  subview.subviews.count > 0 {
                self.parseTreeWithView(subViews: subview.subviews)
            }
        }
    }
}
