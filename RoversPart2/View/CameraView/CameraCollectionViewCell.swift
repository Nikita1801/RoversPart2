//
//  CameraCollectionViewCell.swift
//  RoversPart2
//
//  Created by Никита Макаревич on 20.10.2022.
//

import UIKit
import Nuke

final class CameraCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let photoImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 4
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        
        return image
    }()
    
    private let idLabel: UILabel = {
        let label = UILabel()
        label.text = "id #10212"
        label.font = UIFont(name: "Helvetica", size: 13)
        label.textColor = UIColor.customBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let solLabel: UILabel = {
        let label = UILabel()
        label.text = "СОЛ #1000"
        label.font = UIFont(name: "Helvetica Bold", size: 8)
        label.textColor = UIColor.customGrey
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    func setValues(photo: Photos) {
        idLabel.text = "id #\(photo.id)"
        solLabel.text = "СОЛ #\(photo.sol)"
        Nuke.loadImage(with: photo.img_src, into: photoImage)
    }

}

// MARK: Configuring view extension
private extension CameraCollectionViewCell {
    
    func configureView(){
        addSubview(photoImage)
        addSubview(idLabel)
        addSubview(solLabel)
        
        setConstraints()
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            photoImage.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            photoImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            photoImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            idLabel.topAnchor.constraint(equalTo: photoImage.bottomAnchor, constant: 12),
            idLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            solLabel.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 1),
            solLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            solLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
