//
//  CameraViewController.swift
//  RoversPart2
//
//  Created by Никита Макаревич on 20.10.2022.
//

import UIKit

protocol CameraViewControllerProtocol: UIViewController {
    /// getting data and displaying it
    func updatePhotos(_ rovers: [String: [Photos]])
//    func showAlert(isGet: Bool)
}


final class CameraViewController: UIViewController {

    weak var presenter: CameraPresenterProtocol?
    private var roverData: [String: [Photos]] = [:]
//    private var cameraName = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()

        presenter?.getRoverPhotos()
    }
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = true
        collectionView.register(CameraCollectionViewCell.self, forCellWithReuseIdentifier: "rovercell")
        
        return collectionView
    }()
    
    private var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "23.08.2021"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.customGrey
        label.font = UIFont(name: "Helvetica Bold", size: 11)
        
        return label
    }()
    
    private let horizontalStackView: UIStackView = {
        let horizontalStackView = UIStackView()
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.axis = .horizontal
        
        return horizontalStackView
    }()
    
    private let roverName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Curiosity"
        label.textColor = UIColor.customBlack
        label.font = UIFont(name: "Helvetica Bold", size: 34)
        
        return label
    }()
    
    private lazy var leftArrowButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "arrowleft.png"), for: .normal)
        button.addTarget(self, action: #selector(decreaseDate), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var rightArrowButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "arrowright.png"), for: .normal)
        button.addTarget(self, action: #selector(increaseDate), for: .touchUpInside)
        
        return button
    }()
    
    /// Call presenter to increase date by 1 day and make request
    @objc private func increaseDate() {
        presenter?.increaseDate()
    }
    
    /// Call presenter to decrease date by 1 day and make request
    @objc private func decreaseDate() {
        presenter?.decreaseDate()
    }
    
}

// MARK: - CameraViewControllerProtocol extension
extension CameraViewController: CameraViewControllerProtocol {
    func updatePhotos(_ rovers: [String : [Photos]]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"

        if rovers.count > 0 {
            let date = dateFormatter.date(from: rovers["RHAZ"]?[0].earth_date ?? "")
            dateFormatter.dateFormat = "dd.MM.YYYY"
            guard let date = date else { return }

            dateLabel.text = dateFormatter.string(from: date)
        }

        roverData = rovers
    }
}

// MARK: - UICollcetionView extension
extension CameraViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        roverData.keys.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let key = Array(roverData.keys)[section]

        return roverData[key]?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "rovercell", for: indexPath) as? CameraCollectionViewCell else { return UICollectionViewCell() }
//        section = Array(roverData.keys)[indexPath.section]
        let key = Array(roverData.keys)[indexPath.section]
        guard let photos = roverData[key] else { return UICollectionViewCell() }
        let photo = photos[indexPath.row]
        cell.setValues(photo: photo)

        return cell
    }
}

// MARK: - Configuring UI extension
private extension CameraViewController {
    /// Configuring UI
    func configureView() {
        view.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        horizontalStackView.addSubview(roverName)
        horizontalStackView.addSubview(leftArrowButton)
        horizontalStackView.addSubview(rightArrowButton)
        view.addSubview(dateLabel)
        view.addSubview(horizontalStackView)
        view.addSubview(collectionView)
        
        setConstraints()
    }
    
    /// Setting up constraints
    func setConstraints() {
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 58),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            horizontalStackView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor),
            horizontalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            horizontalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            roverName.topAnchor.constraint(equalTo: horizontalStackView.topAnchor, constant: 5),
            roverName.leadingAnchor.constraint(equalTo: horizontalStackView.leadingAnchor),

            leftArrowButton.topAnchor.constraint(equalTo: horizontalStackView.topAnchor),
            leftArrowButton.trailingAnchor.constraint(equalTo: rightArrowButton.leadingAnchor, constant: 0),
            leftArrowButton.widthAnchor.constraint(equalToConstant: 60),
            leftArrowButton.heightAnchor.constraint(equalToConstant: 60),

            rightArrowButton.topAnchor.constraint(equalTo: horizontalStackView.topAnchor),
            rightArrowButton.trailingAnchor.constraint(equalTo: horizontalStackView.trailingAnchor),
            rightArrowButton.widthAnchor.constraint(equalToConstant: 60),
            rightArrowButton.heightAnchor.constraint(equalToConstant: 60),
            
            collectionView.topAnchor.constraint(equalTo: horizontalStackView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}
