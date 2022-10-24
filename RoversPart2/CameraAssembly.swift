//
//  CameraAssembly.swift
//  RoversPart2
//
//  Created by Никита Макаревич on 24.10.2022.
//

import Foundation

final class CameraAssembly {
    static func make() -> CameraPresenterProtocol {
        let presenter = CameraPresenter()
        let viewController = CameraViewController()
        viewController.presenter = presenter
        presenter.viewController = viewController
        
        return presenter
    }
}
