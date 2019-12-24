//
//  AppDelegate.swift
//  Homework
//
//  Created by 민쓰 on 20/12/2019.
//  Copyright © 2019 민쓰. All rights reserved.
//

import UIKit
import Then

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var zoomDelegate = ZoomTransitioningDelegate()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)
        let naviController = UINavigationController()
        let mainVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "MainVC") as! MainViewController

        window.do {
            // Prevent Dark Theme
            if #available(iOS 13.0, *) {
                $0.overrideUserInterfaceStyle = .light
            }
            $0.rootViewController = naviController
            $0.makeKeyAndVisible()
            
            self.window = $0
        }
        
        naviController.do {
            $0.delegate = zoomDelegate
            $0.setViewControllers([mainVC], animated: false)
            $0.view.backgroundColor = .white
            $0.isNavigationBarHidden = true
        }
        
        mainVC.do {
            $0.bind(MainPresenter())
        }
        
    
        return true
    }

}

