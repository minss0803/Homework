//
//  MainViewController.swift
//  Homework
//
//  Created by 민쓰 on 20/12/2019.
//  Copyright © 2019 민쓰. All rights reserved.
//

import UIKit
import Then
import SnapKit

protocol MainViewBindable {
    var requestBucketList:(() -> Void)? { get set }
    var updateFilter:(() -> Void)? { get set }
    var model: MainModel { get }
    var bucketList:[Bucket] { get set }
    var selectedFilter:(OrderType?,SpaceType?,ResidenceType?) { get set }
    var selectedFilterDidChange:((OrderType?,SpaceType?,ResidenceType?) -> ())? { get set}
}

class MainViewController: ViewController <MainViewBindable> {

    // MARK: - Property
    @IBOutlet weak var tableView: UITableView!

    var presenter: MainViewBindable?
    
    /// 유저가 선택한 테이블 셀의 인덱스를 임시 저장
    var selectedIndexPath: IndexPath!
    
    /// 테이블 뷰의 해더 영역에, 필터 뷰를 적용
    var headerFilterView = UINib(nibName: "FilterView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! FilterView
    
    /// 테이블뷰의 스크롤이 내려갔을 경우, 상단에 sticky하게 고정되어었는 필터뷰
    var floatingFilterView = UINib(nibName: "FilterView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! FilterView
 
    override func viewDidLoad() {
        super.viewDidLoad()

        if let handelr = presenter?.selectedFilterDidChange {
            handelr(presenter?.selectedFilter.0, presenter?.selectedFilter.1, presenter?.selectedFilter.2)
        }
        presenter?.requestBucketList?()
    }
    override func bind(_ binding: MainViewBindable) {
        self.presenter = binding
        
        // 오늘의 집 목록 불러오기
        presenter?.requestBucketList = { [weak self] in
            self?.presenter?.model.getBucketList(order: self?.presenter?.selectedFilter.0?.value ?? "",
                                                 space: self?.presenter?.selectedFilter.1?.value ?? "",
                                                 residence: self?.presenter?.selectedFilter.2?.value ?? "",
                                                 page: "1") { result in
                switch result {
                case .success(let list):
                    // API 연동 성공 시, 데이터 업데이트
                    self?.presenter?.bucketList = list
                case .failure(let error):
                    // 통신 실패 시, 기존 버킷리스트 초기화
                    self?.presenter?.bucketList = []
                    print(error.localizedDescription)
                }
                
                // 업데이트 된 결과를 TableView에 반영
                // UI를 업데이트하기 위해, Main Thread에서 실행되도록 지정함
                DispatchQueue.main.async {
                    self?.tableView?.reloadData()
                }
            }
        }
        
        presenter?.selectedFilterDidChange = { [unowned self] (order, space, residence) in
            self.headerFilterView.do {
                $0.updateSelectedFilter((order, space, residence))
                $0.updateFilterStatue((order, space, residence))
            }
            self.floatingFilterView.do {
                $0.updateSelectedFilter((order, space, residence))
                $0.updateFilterStatue((order, space, residence))
            }
            self.tableView.tableHeaderView = self.headerFilterView.sizeHeaderToFit()
            let _ = self.floatingFilterView.sizeHeaderToFit()
            
            //self.presenter?.requestBucketList?()
        }
        
        headerFilterView.filterButtonPressed = { [weak self] type in
            self?.showFilterView(of: type)
        }
        headerFilterView.removeButtonPressed = { [weak self] type in
            self?.removeFilterView(of: type)
        }
        floatingFilterView.filterButtonPressed = { [weak self] type in
            self?.showFilterView(of: type)
        }
        floatingFilterView.removeButtonPressed = { [weak self] type in
            self?.removeFilterView(of: type)
        }
        
    }
    
    override func attribute() {
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.estimatedRowHeight = 500
            $0.rowHeight = UITableView.automaticDimension
            $0.separatorStyle = .none
            $0.tableHeaderView = headerFilterView.sizeHeaderToFit()
        }
        
        floatingFilterView.do {
            $0.isHidden = true
            self.floatingFilterView = floatingFilterView.sizeHeaderToFit()
        }
    }
    
    override func layout() {
        view.addSubview(floatingFilterView)
        
        floatingFilterView.snp.makeConstraints {
            if #available(iOS 11.0, *) {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            } else {
                $0.top.equalTo(view)
            }
            $0.left.right.equalToSuperview()
            $0.height.equalTo(0).priority(250)
        }
        
    }

    /// 사용자가 삭제하고자 지정한 필터를 제거
    func removeFilterView(of type: FilterType) {
        switch type {
        case .order:
            self.presenter?.selectedFilter.0 = nil
        case .space:
            self.presenter?.selectedFilter.1 = nil
        case .residence:
            self.presenter?.selectedFilter.2 = nil
        }
    }
    
    /// 필터 선택 창 화면 띄우기
    func showFilterView(of type: FilterType) {
        let filterVC = UIStoryboard(name: "Filter", bundle: nil).instantiateViewController(withIdentifier: "FilterVC") as! FilterViewController
        
        var presenter = FilterPresenter()
        if let selected = self.presenter?.selectedFilter {
            switch type {
            case .order:
                presenter.selectedFilter = selected.0
            case .space:
                presenter.selectedFilter = selected.1
            case .residence:
                presenter.selectedFilter = selected.2
            }
        }
        filterVC.filterType = type
        filterVC.bind(presenter)
        filterVC.modalPresentationStyle = .overCurrentContext
        filterVC.confirmValue = { [weak self] value in
            switch type {
            case .order:
                self?.presenter?.selectedFilter.0 = value as? OrderType
            case .space:
                self?.presenter?.selectedFilter.1 = value as? SpaceType
            case .residence:
                self?.presenter?.selectedFilter.2 = value as? ResidenceType
            }
            filterVC.confirmValue = nil
        }
        self.present(filterVC, animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let list = self.presenter?.bucketList else {
            return 0
        }
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainListCell", for: indexPath) as? MainListCell  else {
            fatalError("The dequeued cell is not an instance of MainListCell")
        }
        guard let list = self.presenter?.bucketList, list.count > indexPath.row else {
            return cell
        }
        let data = list[indexPath.row]
        cell.setData(data)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        guard let list = self.presenter?.bucketList, list.count > indexPath.row else {
            return
        }
        let data = list[indexPath.row]
        
        let detailVC = UIStoryboard(name: "Detail", bundle: nil).instantiateViewController(withIdentifier: "ImageDetailVC") as! ImageDetailViewController
        detailVC.bind(ImageDetailPresenter())
        detailVC.view.layoutIfNeeded()
        detailVC.presenter?.bucket = data
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
        
        let scrollOffset = scrollView.contentOffset.y
        if scrollOffset > 0 {
            self.floatingFilterView.isHidden = false
        }else{
            self.floatingFilterView.isHidden = true
        }
    }
    
}

// MARK - ZoomingViewController
extension MainViewController : ZoomingViewController
{
    
    /// interactive 효과로 화면전환이 일어나는 동안, 실시간으로 offset값을 전달 받는 함수
    func animPanGesture(by percent: CGFloat) {}
    
    /// SnapShot으로 찍을 뷰 지정하기
    func zoomingImageView(for transition: ZoomTransitioningDelegate) -> UIImageView? {
       
        if let indexPath = selectedIndexPath {
            let cell = self.tableView.cellForRow(at: indexPath) as! MainListCell
            return cell.detailImageView
        }
        
        return nil
    }
}
