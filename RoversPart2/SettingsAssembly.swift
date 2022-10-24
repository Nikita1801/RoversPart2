//
//  SettingsAssembly.swift
//  RoversPart2
//
//  Created by Никита Макаревич on 24.10.2022.
//

import Foundation

final class SettingsAssembly {
    static func make() -> SettingsPresenterProtocol {
        let presenter = SettingsPresenter()
        let viewController = SettingsViewController()
        viewController.presenter = presenter
        presenter.viewController = viewController
        
        return presenter
    }
}
