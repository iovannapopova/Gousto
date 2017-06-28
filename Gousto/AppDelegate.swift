//
//  AppDelegate.swift
//  Gousto
//
//  Created by i.popova on 04.03.17.
//  Copyright © 2017 i.popova. All rights reserved.
//

import UIKit
import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    private let dataStore: PlistDataStore
    private let controller: Controller
    private let networkClient: NetworkClient
    private let router: Router
    
    var window: UIWindow?

    override init() {
        dataStore = PlistDataStore()
        controller = Controller(store: dataStore)
        dataStore.observer = controller
        router = Router(controller: controller)
        networkClient = NetworkClient(dataStore: dataStore)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window =  UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = router.navigationController
        window?.makeKeyAndVisible()
        networkClient.refresh()
        return true
    }
}

