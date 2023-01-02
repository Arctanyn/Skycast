//
//  MainTabBarController.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 29.12.2022.
//

import UIKit

enum Tabs: Int, CaseIterable {
    case forecast
    case myLocations
}

final class MainTabBarController: UITabBarController {
    
    //MARK: - View Controller Lyfecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
    }
    
    //MARK: - Methods
    
    func configureViewControllers(_ navigationControllers: [UINavigationController]) {
        navigationControllers.forEach { navController in
            guard let tab = Tabs(rawValue: navController.tabBarItem.tag) else {
                fatalError("The tab bar item has a non-existent tag for configuration")
            }
            
            switch tab {
            case .forecast:
                setupNavigationController(
                    navController,
                    title: Resources.Strings.TabBar.forecast,
                    tabBarIcon: Resources.Images.TabBar.forecast.icon,
                    tabBarSelectedIcon: Resources.Images.TabBar.forecast.selectedIcon
                )
            case .myLocations:
                setupNavigationController(
                    navController,
                    title: Resources.Strings.TabBar.myLocations,
                    tabBarIcon: Resources.Images.TabBar.myLocations.icon,
                    tabBarSelectedIcon: Resources.Images.TabBar.myLocations.selectedIcon
                )
            }
        }
        
        viewControllers = navigationControllers
    }
}

//MARK: - Private methods

private extension MainTabBarController {
    func configureAppearance() {
        tabBar.tintColor = Resources.Colors.blue
        tabBar.isTranslucent = false
        tabBar.backgroundColor = Resources.Colors.grayBlue
        tabBar.barTintColor = Resources.Colors.grayBlue
    }
    
    func setupNavigationController(_ navigationController: UINavigationController, title: String, tabBarIcon: UIImage?, tabBarSelectedIcon: UIImage? = nil) {
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = tabBarIcon
        navigationController.tabBarItem.selectedImage = tabBarSelectedIcon
    }
}
