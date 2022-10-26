//
//  CameraPresenter.swift
//  RoversPart2
//
//  Created by Никита Макаревич on 20.10.2022.
//

import Foundation

protocol CameraPresenterProtocol: SettingsHandle {
    /// call Model to make url with roverName & earthDate
    func getRoverPhotos()
    /// Increasing the date by 1 day
    func increaseDate()
    /// Decreasing the date by 1 day
    func decreaseDate()
    
    var viewController: CameraViewControllerProtocol? { get }
}


final class CameraPresenter {
    
    var viewController: CameraViewControllerProtocol?
    private let model: CameraModelProtocol
    private var date = Calendar.current.date(byAdding: .year, value: -1, to: Date())
    private var roverName = "Curiosity"
    
    init(model: CameraModelProtocol = CameraModel()) {
        self.model = model
        
        let stringDate = "2021-08-23"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        date = dateFormatter.date(from: stringDate)
    }
}

extension CameraPresenter: CameraPresenterProtocol {
    
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
        
        model.getRoverPhotos(roverName: roverName, earthDate: earthDate) { [weak viewController] rover in
            DispatchQueue.main.async {
                guard let rover = rover else {
//                    viewController?.showAlert(isGet: false)
                    return
                }
                
                viewController?.updatePhotos(rover)
            }
        }
    }
}
 
extension CameraPresenter: SettingsHandle {
    func getSelectedRover(_ rover: String) {
        roverName = rover
        getRoverPhotos()
    }
}
