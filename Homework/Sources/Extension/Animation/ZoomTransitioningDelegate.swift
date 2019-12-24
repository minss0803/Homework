//
//  ZoomTransitioningDelegate.swift
//  Photos-DucTran
//
//  Created by Duc Tran on 2/22/17.
//  Copyright © 2017 Developers Academy. All rights reserved.
//

import UIKit
import Then

protocol ZoomingViewController
{
    func zoomingImageView(for transition: ZoomTransitioningDelegate) -> UIImageView?
    func animPanGesture(by percent: CGFloat)
}

enum TransitionState {
    case start
    case end
}

class ZoomTransitioningDelegate: NSObject {
    
    private struct UI {
        static let transitionDuration = 0.5
        static let zoomScale = CGFloat(15)
        static let backgroundScale = CGFloat(1.0)
    }
    
    /// UINavigationController의 PUSH or POP Event 구분값
    var operation: UINavigationController.Operation = .none
    /// UIViewControllerContextTransitioning의 Context값
    var context: UIViewControllerContextTransitioning?
    
    private var interactionController: UIPercentDrivenInteractiveTransition?
    private var gestureRecognizer: UIPanGestureRecognizer?
    private var navigationController: UINavigationController?
    
    typealias ZoomingViews = (otherView: UIView, imageView: UIView)
    
    func configureViews(for state: TransitionState, containerView: UIView, backgroundViewController: UIViewController, viewsInBackground: ZoomingViews, viewsInForeground: ZoomingViews, snapshotViews: ZoomingViews)
    {
        switch state {
        case .start:
            backgroundViewController.view.transform = CGAffineTransform.identity
            backgroundViewController.view.alpha = 1
            
            snapshotViews.imageView.frame = containerView.convert(viewsInBackground.imageView.frame, from: viewsInBackground.imageView.superview)
            
        case .end:
            backgroundViewController.view.transform = CGAffineTransform(scaleX: UI.backgroundScale, y: UI.backgroundScale)
            backgroundViewController.view.alpha = 0
            
            snapshotViews.imageView.frame = containerView.convert(viewsInForeground.imageView.frame, from: viewsInForeground.imageView.superview)
        }
        
        snapshotViews.imageView.do {
            $0.layer.cornerRadius = 10.0
            $0.clipsToBounds = true
        }
    }
    
    @objc func handlePanGesutre(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        let percent = gestureRecognizer.translation(in: gestureRecognizer.view).y / (gestureRecognizer.view?.bounds.size.height ?? 1)
        
        let toViewController = context?.viewController(forKey: .to)
        let fromViewController = context?.viewController(forKey: .from)!
        
        if gestureRecognizer.state == .began {
            (toViewController as? ZoomingViewController)?.animPanGesture(by: 0)
            (fromViewController as? ZoomingViewController)?.animPanGesture(by: 0)
            interactionController = UIPercentDrivenInteractiveTransition()
            navigationController?.popViewController(animated: true)
            
        } else if gestureRecognizer.state == .changed {
            interactionController?.update(percent)
        } else if gestureRecognizer.state == .ended {
            if percent > 0.15 && gestureRecognizer.state != .cancelled {
                interactionController?.finish()
            } else {
                (toViewController as? ZoomingViewController)?.animPanGesture(by: 1)
                (fromViewController as? ZoomingViewController)?.animPanGesture(by: 1)
                interactionController?.cancel()
            }
            interactionController = nil
        }
    }
    
    func animZoom(for transitionContext: UIViewControllerContextTransitioning) {
        let duration = transitionDuration(using: transitionContext)
        let fromViewController = transitionContext.viewController(forKey: .from)!
        let toViewController = transitionContext.viewController(forKey: .to)!
        let containerView = transitionContext.containerView
        
        var backgroundViewController = fromViewController
        var foregroundViewController = toViewController
        
        if operation == .pop {
            backgroundViewController = toViewController
            foregroundViewController = fromViewController
        }
        
        let maybeBackgroundImageView = (backgroundViewController as? ZoomingViewController)?.zoomingImageView(for: self)
        let maybeForegroundImageView = (foregroundViewController as? ZoomingViewController)?.zoomingImageView(for: self)
        
        assert(maybeBackgroundImageView != nil, "Cannot find imageView in backgroundVC")
        assert(maybeForegroundImageView != nil, "Cannot find imageView in foregroundVC")
        
        let backgroundImageView = maybeBackgroundImageView!
        let foregroundImageView = maybeForegroundImageView!
        
        let imageViewSnapshot = UIImageView(image: backgroundImageView.image)
        imageViewSnapshot.contentMode = .scaleAspectFill
        imageViewSnapshot.layer.masksToBounds = true
        
        backgroundImageView.isHidden = true
        foregroundImageView.isHidden = true
        let foregroundViewBackgroundColor = foregroundViewController.view.backgroundColor
        foregroundViewController.view.backgroundColor = UIColor.clear
        containerView.backgroundColor = .black
        
        containerView.addSubview(backgroundViewController.view)
        containerView.addSubview(foregroundViewController.view)
        containerView.addSubview(imageViewSnapshot)
        
        var preTransitionState = TransitionState.start
        var postTransitionState = TransitionState.end
        
        if operation == .pop {
            preTransitionState = .end
            postTransitionState = .start
        }
        
        configureViews(for: preTransitionState, containerView: containerView, backgroundViewController: backgroundViewController, viewsInBackground: (backgroundImageView, backgroundImageView), viewsInForeground: (foregroundImageView, foregroundImageView), snapshotViews: (imageViewSnapshot, imageViewSnapshot))
        
        foregroundViewController.view.layoutIfNeeded()
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: {
            
            self.configureViews(for: postTransitionState, containerView: containerView, backgroundViewController: backgroundViewController, viewsInBackground: (backgroundImageView, backgroundImageView), viewsInForeground: (foregroundImageView, foregroundImageView), snapshotViews: (imageViewSnapshot, imageViewSnapshot))
            
        }) { (finished) in
            
            backgroundViewController.view.transform = CGAffineTransform.identity
            imageViewSnapshot.removeFromSuperview()
            backgroundImageView.isHidden = false
            foregroundImageView.isHidden = false
            foregroundViewController.view.backgroundColor = foregroundViewBackgroundColor
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
extension ZoomTransitioningDelegate : UIViewControllerAnimatedTransitioning {
    /*
     * Transition이 적용되는 시간
     */
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return UI.transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning)
    {
        context = transitionContext
        animZoom(for: transitionContext)
    }
}

extension ZoomTransitioningDelegate : UINavigationControllerDelegate
{
    /* FromVC & ToVC 둘 다 ZoomingViewController를 상속한 경우,
     * 화면 전환할때 Zoom Transition 적용하기
     */
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        self.navigationController = navigationController
        gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesutre(_:)))
        navigationController.view.addGestureRecognizer(gestureRecognizer!)
        
        if fromVC is ZoomingViewController && toVC is ZoomingViewController {
            self.operation = operation
            return self
        } else {
            return nil
        }
    }
    
    /*
     * 네비게이션 컨트롤러에 interactive effect 적용
     * 아래 방향(pan gesture)으로 제스쳐 동작을 할 경우, 상세화면 닫기 모션 실행됨
     */
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
           return interactionController
    }
}













