//
//  TabBarController.swift
//  AppcentWeather
//
//  Created by Mustafa Altıparmak on 13.04.2022.
//

import UIKit

class TabBarController: UITabBarController {
    


    override func viewDidLoad() {
        super.viewDidLoad()

        let homeVC = HomeViewController()
        homeVC.title = "Home"
        let searchVC = SearchViewController()
        searchVC.title = "Search"

        
        let controllers = [
            UINavigationController(rootViewController: homeVC),
            UINavigationController(rootViewController: searchVC)
        ]
        setViewControllers(controllers, animated: true)
        
        tabBar.barTintColor = .black
        tabBar.isTranslucent = false
        
        
        //MARK: - Setting tab bar items' images
        guard let items = self.tabBar.items else {
            return
        }
        
        let systemImageStrings = ["house.circle", "magnifyingglass"]
        for i in 0..<items.count {
            items[i].image =  UIImage(systemName: systemImageStrings[i])
        }
    }

}
