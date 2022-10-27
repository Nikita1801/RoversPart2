//
//  SettingsPresenter.swift
//  RoversPart2
//
//  Created by Никита Макаревич on 20.10.2022.
//

import Foundation


protocol SettingsPresenterProtocol: AnyObject {
    var viewController: SettingsViewControllerProtocol? { get }
    var delegate: SettingsHandle? { get set }
    /// Getting rovers array from model
    func getRovers() -> [String]
    /// Get selected rover from model
    func getSelectedRover() -> String
    /// set selected rover to model
    func setSelectedRover(index: Int)
}

protocol SettingsHandle: AnyObject {
    func getSelectedRover(_ rover: String)
}

final class SettingsPresenter {
    private let model: SettingsModelProtocol
    weak var viewController: SettingsViewControllerProtocol?
    var delegate: SettingsHandle?
    
    init(model: SettingsModelProtocol = SettingsModel()) {
        self.model = model
    }
}

//MARK: - SettingsPresenterProtocol extension
extension SettingsPresenter: SettingsPresenterProtocol {
    func setSelectedRover(index: Int) {
        model.setSelectedRover(model.rovers[index])
        delegate?.getSelectedRover(model.getSelectedRover())
    }
    
    func getRovers() -> [String] {
        model.rovers
    }
    
    func getSelectedRover() -> String {
        model.getSelectedRover()
    }
}
