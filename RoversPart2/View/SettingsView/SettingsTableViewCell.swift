//
//  SettingsTableViewCell.swift
//  RoversPart2
//
//  Created by Никита Макаревич on 20.10.2022.
//

import UIKit

final class SettingsTableViewCell: UITableViewCell {
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(roverNameLable)
        setConstraints()
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let roverNameLable: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica", size: 16)
        label.highlightedTextColor = UIColor.customPurple
        
        return label
    }()
    
    func setRover(roverName: String){
        roverNameLable.text = roverName
    }
    
    func setConstraints(){
        roverNameLable.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            roverNameLable.topAnchor.constraint(equalTo: topAnchor),
            roverNameLable.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            roverNameLable.trailingAnchor.constraint(equalTo: trailingAnchor),
            roverNameLable.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
