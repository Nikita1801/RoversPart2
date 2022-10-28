//
//  CameraCollectionReusableView.swift
//  RoversPart2
//
//  Created by Никита Макаревич on 26.10.2022.
//

import UIKit

final class HeaderCollectionReusableView: UICollectionReusableView {
    
    var callback: (() -> Void)?
    
    private lazy var cameraName: UIButton = {
        let button = UIButton()
        button.setTitle("RHAZ", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica Bold", size: 16)
        button.addTarget(self, action: #selector(openPhotos), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var arrow: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.lightGrey
        button.layer.cornerRadius = 10
        button.setImage(UIImage(named: "indicator"), for: .normal)
        button.addTarget(self, action: #selector(openPhotos), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    @objc private func openPhotos() {
        callback?()
    }
    
    func configure(_ camera: String) {
        backgroundColor = .white
        cameraName.setTitle(camera, for: .normal)
        
        addSubview(cameraName)
        addSubview(arrow)
        
        setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            cameraName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            cameraName.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            arrow.heightAnchor.constraint(equalToConstant: 20),
            arrow.widthAnchor.constraint(equalToConstant: 20),
            arrow.leadingAnchor.constraint(equalTo: cameraName.trailingAnchor, constant: 10),
            arrow.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
