//
//  TabBarController.swift
//  RoversPart2
//
//  Created by Никита Макаревич on 20.10.2022.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        tabBar.tintColor = UIColor.customPurple
        setupTabBar()
    }
    
    /// Setting up tab bar items
    private func setupTabBar() {
        
        guard let cameraImage = UIImage(named: "камеры") else { return }
        guard let settingsImage = UIImage(named: "настройки") else { return }
        
        let cameraPresenter = CameraAssembly.make()
        let settingsPresenter = SettingsAssembly.make()
        settingsPresenter.delegate = cameraPresenter
        guard let settingViewControleer = settingsPresenter.viewController,
              let cameraViewController = cameraPresenter.viewController
        else { return }
        
        
        viewControllers = [
            createNavigationController(vc: cameraViewController, itemName: "Камеры", itemImage: cameraImage),
            createNavigationController(vc: settingViewControleer, itemName: "Настройки", itemImage: settingsImage)
        ]
    }
    
    /// Create navigation controller and return it
    private func createNavigationController(vc: UIViewController, itemName: String, itemImage: UIImage) -> UIViewController {
        
        let navigationViewController = UINavigationController(rootViewController: vc)
        navigationViewController.tabBarItem.title = itemName
        navigationViewController.tabBarItem.image = itemImage
        
        return navigationViewController
    }
    
}
