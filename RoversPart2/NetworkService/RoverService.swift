//
//  RoverService.swift
//  RoversPart2
//
//  Created by Никита Макаревич on 20.10.2022.
//

import Foundation

protocol RoverServiceProtocol {
    
    /// requesting data and decoding into RoverData
    func getRoverPhotos(url: String, completionHandler: @escaping (RoverData?) -> Void)
}

final class RoverService: RoverServiceProtocol {
    
    func getRoverPhotos(url: String, completionHandler: @escaping (RoverData?) -> Void) {
        guard let url = URL(string: url) else {
            completionHandler(nil)
            return
        }
        
        getRequest(url: url) { data in
            guard let data = data,
                  let model = try? JSONDecoder().decode(RoverData.self, from: data)
            else {
                print("Error while decoding")
                completionHandler(nil)
                return
            }
            
            completionHandler(model)
        }
    }
}

private extension RoverService {
    
    /// requesting data by url
    func getRequest(url: URL, completion: @escaping (Data?)->Void) {
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil
            else {
                completion(nil)
                return
            }
            completion(data)
        }
        task.resume()
    }
}
