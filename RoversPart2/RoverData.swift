//
//  RoverData.swift
//  RoversPart2
//
//  Created by Никита Макаревич on 20.10.2022.
//

import Foundation

struct RoverData: Codable{
    let photos: [Photos]
}

struct Photos: Codable, Equatable {
    let id: Int
    let sol: Int
    let camera: Camera
    let img_src: String
    let earth_date: String
}

struct Camera: Codable, Equatable {
    let name: String
}
