//
//  PhotosPresenter.swift
//  RoversPart2
//
//  Created by Никита Макаревич on 24.10.2022.
//

import Foundation

protocol PhotosPresenterProtocol {
    /// call Model to make url with roverName & earthDate
    func getRoverPhotos()
    /// Increasing the date by 1 day
    func increaseDate()
    /// Decreasing the date by 1 day
    func decreaseDate()
    func getCameraPhotos() -> [Photos]
}

final class PhotosPresenter {
    
    weak var viewController: PhotosViewControllerProtocol?
    private var model: PhotosModel?
    private var date = Calendar.current.date(byAdding: .year, value: -1, to: Date())
    private var roverName = "curiosity"
    
    init(model: PhotosModel) {
        self.model = model
        
        let stringDate = "2021-08-23"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        date = dateFormatter.date(from: stringDate)
    }
    
}

extension PhotosPresenter: PhotosPresenterProtocol {
    
    func getCameraPhotos() -> [Photos] {
        return model?.getCameraPhoto() ?? [Photos(id: 1, sol: 1, camera: Camera(name: "1"), img_src: "1", earth_date: "1")]
    }
    
    func increaseDate() {
        guard let lastDate = date else { return }
        date = Calendar.current.date(byAdding: .day, value: +1, to: lastDate)
        getRoverPhotos()
    }
    
    func decreaseDate() {
        guard let lastDate = date else { return }
        date = Calendar.current.date(byAdding: .day, value: -1, to: lastDate)
        getRoverPhotos()
    }
    
    func getRoverPhotos() {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "YYYY-MM-dd"
        guard let date = date else { return }
        let earthDate = dateFormater.string(from: date)
        
//        model.getRoverPhotos(roverName: roverName, earthDate: earthDate) { [weak viewController] rover in
//            DispatchQueue.main.async {
//                guard let rover = rover else {
////                    viewController?.showAlert(isGet: false)
//                    return
//                }
//
//                viewController?.updatePhotos(rover)
//            }
//        }
    }
}
