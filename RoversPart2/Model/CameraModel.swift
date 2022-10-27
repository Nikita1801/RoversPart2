//
//  CameraModel.swift
//  RoversPart2
//
//  Created by Никита Макаревич on 20.10.2022.
//

import Foundation

protocol CameraModelProtocol {
    /// creating URL with roverName & earthDate and call RoverService to make request
    func getRoverPhotos(roverName: String, earthDate: String, completed: @escaping ([String: [Photos]]?) -> Void)
}

final class CameraModel {
    private var network: RoverServiceProtocol
    private var sortedCamerasDict: [String: [Photos]] = [:]
    private let nasaURL = "https://api.nasa.gov/mars-photos/api/v1/rovers/"
    private let apiKey = "Uls3MlNWdgwJ9Vzmw8kXbdUdvRixsSz72ulUD3AL"
    
    init(network: RoverServiceProtocol = RoverService()) {
        self.network = network
    }
    
    private func createCamsModelDict(camsInfoArray: [Photos?]) {
        sortedCamerasDict = [:]
        for photo in camsInfoArray {
            guard let photo = photo else { continue }
            let camName = photo.camera.name
            if var photosArray = sortedCamerasDict[camName]{
                photosArray.append(Photos(id: photo.id,
                                          sol: photo.id,
                                          camera: photo.camera,
                                          img_src: photo.img_src,
                                          earth_date: photo.earth_date,
                                          rover: photo.rover))
                sortedCamerasDict[camName] = photosArray
            }else {
                var photosArray : [Photos] = []
                photosArray.append(Photos(id: photo.id,
                                          sol: photo.id,
                                          camera: photo.camera,
                                          img_src: photo.img_src,
                                          earth_date: photo.earth_date,
                                          rover: photo.rover))
                sortedCamerasDict[camName] = photosArray
            }
        }
        
        print(sortedCamerasDict.keys)
        for key in sortedCamerasDict.keys {
            print("\(key): \(String(describing: sortedCamerasDict[key]?.count))")
        }
    }
    
}

extension CameraModel: CameraModelProtocol {

    func getRoverPhotos(roverName: String, earthDate: String, completed: @escaping ([String: [Photos]]?) -> Void) {
        
        let url = "\(nasaURL)\(roverName)/photos?&earth_date=\(earthDate)&api_key=\(apiKey)"
        print(url)
        
        network.getRoverPhotos(url: url) { roverData in
            guard let photos = roverData?.photos else { return }
            self.createCamsModelDict(camsInfoArray: photos)
            completed(self.sortedCamerasDict)
        }
        
    }
}
