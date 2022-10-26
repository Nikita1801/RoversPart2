//
//  PhotosModel.swift
//  RoversPart2
//
//  Created by Никита Макаревич on 26.10.2022.
//

import Foundation

protocol PhotosModelProtocol {
    func getCameraPhoto() -> [Photos]
}

final class PhotosModel {
    private let photos: [Photos]
    
    init(photos: [Photos]) {
        self.photos = photos
    }
    
}

extension PhotosModel: PhotosModelProtocol {
    func getCameraPhoto() -> [Photos] {
        photos
    }
}
