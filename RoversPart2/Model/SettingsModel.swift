//
//  SettingsModel.swift
//  RoversPart2
//
//  Created by Никита Макаревич on 24.10.2022.
//

import Foundation

protocol SettingsModelProtocol {
    var rovers: [String] { get }
    func getSelectedRover() -> String
    func setSelectedRover(_ rover: String)
}

final class SettingsModel {
    private var selectedRover = "Curiosity"
    let rovers: [String] = ["Spirit", "Opportunity", "Curiosity", "Perseverance"]
}

extension SettingsModel: SettingsModelProtocol {
    func getSelectedRover() -> String {
        selectedRover
    }
    
    func setSelectedRover(_ rover: String) {
        selectedRover = rover
    }
}
