//
//  PhotosAssembly.swift
//  RoversPart2
//
//  Created by Никита Макаревич on 26.10.2022.
//

import UIKit

final class PhotosAssembly {
    static func make(photos: [Photos]) -> UIViewController {
        let model = PhotosModel(photos: photos)
        let presenter = PhotosPresenter(model: model)
        let viewController = PhotosViewController()
        viewController.presenter = presenter
        presenter.viewController = viewController
        
        return viewController
    }
}
