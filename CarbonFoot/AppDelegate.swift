//
//  AppDelegate.swift
//  CarbonFoot
//
//  Created by Aleksandra Korolczuk on 2017-11-28.
//  Copyright © 2017 Aleksandra Korolczuk. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       // UINavigationBar.appearance().tintColor = .white
       // UINavigationBar.appearance().barTintColor = .white
        let locationManager = LocationManager.shared
        locationManager.requestWhenInUseAuthorization()
        return true

    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        CoreDataStack.saveContext()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataStack.saveContext()
    }
    
}
