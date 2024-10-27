//
//  AppDelegate.swift
//  Timer
//
//  Created by Maxim Boykin on 27.10.24..
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Создание и настройка окна приложения
        window = UIWindow(frame: UIScreen.main.bounds)
        let mainViewController = ViewController() // Установите ваш начальный ViewController
        window?.rootViewController = mainViewController
        window?.makeKeyAndVisible()
        
        return true
    }
}


