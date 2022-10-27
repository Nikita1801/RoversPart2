//
//  CollectionViewCell.swift
//  RoversPart2
//
//  Created by Никита Макаревич on 26.10.2022.
//

import UIKit

final class CameraCollectionViewCell: UICollectionViewCell {
    
    private var photos: [Photos] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let roverCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = true
        collectionView.register(CameraPhotosCollectionViewCell.self, forCellWithReuseIdentifier: "roverphotocell")

        
        return collectionView
    }()
    
    /// Setting up values
    func setPhotos(photo: [Photos]) {
        photos = photo
        roverCollectionView.reloadData()
    }
    
    private func configureView() {
        addSubview(roverCollectionView)
        roverCollectionView.dataSource = self
        roverCollectionView.delegate = self
        
        NSLayoutConstraint.activate([
            roverCollectionView.topAnchor.constraint(equalTo: topAnchor),
            roverCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            roverCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            roverCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: - UICollectionView extension
extension CameraCollectionViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "roverphotocell", for: indexPath) as? CameraPhotosCollectionViewCell else { return UICollectionViewCell() }
        
        let photo = photos[indexPath.row]
        cell.setValues(photo: photo)

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width * 0.35, height: frame.height)
    }
}
