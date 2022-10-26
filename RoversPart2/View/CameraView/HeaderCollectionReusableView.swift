//
//  CameraCollectionReusableView.swift
//  RoversPart2
//
//  Created by Никита Макаревич on 26.10.2022.
//

import UIKit

final class HeaderCollectionReusableView: UICollectionReusableView {
    
    private lazy var cameraName: UIButton = {
        let button = UIButton()
        button.setTitle("RHAZ", for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica Bold", size: 16)
        
        return button
    }()
    
    func congigure() {
        backgroundColor = .white
        addSubview(cameraName)
        
        setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            cameraName.leadingAnchor.constraint(equalTo: leadingAnchor),
            cameraName.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
}
