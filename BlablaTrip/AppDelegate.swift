//
//  AppDelegate.swift
//  BlablaTrip
//
//  Created by Mathis Detourbet on 19/2/20.
//  Copyright © 2020 Mathis Detourbet. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let configuration = Configuration()
        let networkService: NetworkLayer = NetworkService(configuration: configuration)
        let dataAccess: SearchResultsDataAccessInterface = SearchResultsDataAccess(configuration: configuration, networkLayer: networkService)
        let businessService = SearchResultsBusinessService(dataAccess: dataAccess)
        let viewModel = SearchResultsViewModel(businessService: businessService)
        let viewController = SearchResultsViewController.instantiate(with: viewModel)
        
        let navigationController = UINavigationController(rootViewController: viewController)
        
        // Window setup
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}

