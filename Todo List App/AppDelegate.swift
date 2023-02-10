//
//  AppDelegate.swift
//  Todo List App
//
//  Created by Arpan Bhowmik on 16/1/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
        
        let nav = UINavigationController(rootViewController: TodoListViewController())
        window?.rootViewController = nav
        
        return true
    }
}
