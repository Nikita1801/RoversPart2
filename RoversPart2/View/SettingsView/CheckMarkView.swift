//
//  CheckMarkView.swift
//  RoversPart2
//
//  Created by Никита Макаревич on 21.10.2022.
//

import UIKit

final class CheckMarkView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let img = UIImage(named: "checkmark.png")
        let imageView: UIImageView = UIImageView(image: img)
        let width = UIScreen.main.bounds.width
        imageView.frame = CGRect(x: width - 40, y: 15, width: 20, height: 20)
        self.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
