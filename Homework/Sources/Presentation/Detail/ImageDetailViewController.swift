//
//  ImageDetailViewController.swift
//  Homework
//
//  Created by 민쓰 on 21/12/2019.
//  Copyright © 2019 민쓰. All rights reserved.
//

import Foundation
import UIKit

protocol ImageDetailBindable {
    var bucket: Bucket? { get set }
    var dataChanged: ((Bucket) -> Void)? { get set }
    
    func scrollInsetForCenter(imageSize:(width: Float, height: Float),
                              scrollSize:(width: Float, height: Float),
                              contentSize:(width: Float, height: Float)) -> (top:Float, left:Float)
}

class ImageDetailViewController: ViewController <ImageDetailBindable>, UIGestureRecognizerDelegate {
    
    // MARK: - Property
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var constImageHeight: NSLayoutConstraint!
    @IBOutlet weak var infoContainerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var presenter:ImageDetailBindable?

    override func bind(_ binding: ImageDetailBindable) {
        presenter = binding
  
        presenter?.dataChanged = { [weak self] data in
            self?.detailImageView.kf.setImage(with: URL(string: data.imageUrl)) { (image, error, _, _) in
                if let newImage = image {
                    let aspect = newImage.size.height / newImage.size.width
                    self?.detailImageView.image = newImage
                    let newImageHeight = (self?.view.bounds.width ?? 0) * aspect
                    self?.constImageHeight.constant = newImageHeight
                }
            }
            self?.profileImageView.kf.setImage(with: URL(string: data.profileImageUrl))
            self?.userNameLabel.text = data.nickname
            self?.descriptionLabel.text = data.description
        }
    }
    
    override func attribute() {
        self.do {
            $0.view.backgroundColor = .black
        }
        scrollView.do {
            $0.delegate = self
            $0.maximumZoomScale = 10
            $0.minimumZoomScale = 1
        }
        detailImageView.do {
            $0.layer.cornerRadius = 10.0
            $0.clipsToBounds = true
        }
    }
    
    func updateScrollInset() {
        
        let scrollInset = self.presenter?
            .scrollInsetForCenter(imageSize: (Float(detailImageView.bounds.width), Float(detailImageView.bounds.height)),
                                  scrollSize: (Float(self.scrollView.bounds.width), Float(self.scrollView.bounds.height)),
                                  contentSize: (Float(self.scrollView.contentSize.width), Float(self.scrollView.contentSize.height)))
        self.scrollView.contentInset = UIEdgeInsets(top: CGFloat(scrollInset?.top ?? 0),
                                                    left: CGFloat(scrollInset?.left ?? 0),
                                                    bottom: 0,
                                                    right: 0)
    }

}

extension ImageDetailViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.detailImageView
    }
}
extension ImageDetailViewController : ZoomingViewController
{
    func animPanGesture(by percent: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.infoContainerView.alpha = percent
        }
    }
    
    func zoomingImageView(for transition: ZoomTransitioningDelegate) -> UIImageView? {
        return detailImageView
    }
}
