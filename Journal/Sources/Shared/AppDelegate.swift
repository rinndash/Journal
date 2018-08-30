//
//  AppDelegate.swift
//  Journal
//
//  Created by JinSeo Yoon on 2018. 7. 21..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase
import FirebaseDatabase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
        customizeNavigationBar()
        injectEnvironment()
        FirebaseApp.configure()
        
        return true
    }
    
    private func injectEnvironment() {
        if 
            let navigationController = window?.rootViewController as? UINavigationController,
            let timelineViewController = navigationController.topViewController as? TimelineViewController {
            
            let realm = try! Realm()
            let realmEntryRepo = RealmEntryRepository(realm: realm)
            
            let firebaseRef = Database.database().reference()
            let repo = FirebaseEntryRepository(reference: firebaseRef)
            
            let env = Environment(
                entryRepository: realmEntryRepo,
                entryFactory: RealmEntry.newEntry,
                settings: UserDefaults.standard
            )
            timelineViewController.viewModel = TimelineViewViewModel(environment: env)
            
            timelineViewController.viewModel = TimelineViewViewModel(environment: env) 
        }
    }
    
    private func customizeNavigationBar() {
        if let navigationController = window?.rootViewController as? UINavigationController {
            navigationController.navigationBar.prefersLargeTitles = true
            navigationController.navigationBar.barStyle = .black
            navigationController.navigationBar.tintColor = .white
            
            let bgImage = UIImage.gradientImage(with: [.gradientStart, .gradientEnd], size: CGSize(width: UIScreen.main.bounds.width, height: 1))
            navigationController.navigationBar.barTintColor = UIColor(patternImage: bgImage!)
        }
    }
}

