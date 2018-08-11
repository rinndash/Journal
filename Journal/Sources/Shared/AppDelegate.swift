//
//  AppDelegate.swift
//  Journal
//
//  Created by JinSeo Yoon on 2018. 7. 21..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
        if let navigationController = window?.rootViewController as? UINavigationController {
            navigationController.navigationBar.prefersLargeTitles = true
            navigationController.navigationBar.barStyle = .black
            navigationController.navigationBar.tintColor = .white
            
            let bgImage = UIImage.gradientImage(with: [.gradientStart, .gradientEnd], size: CGSize(width: UIScreen.main.bounds.width, height: 1))
            navigationController.navigationBar.barTintColor = UIColor(patternImage: bgImage!)
        }
        
        return true
    }
}

