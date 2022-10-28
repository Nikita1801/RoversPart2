//
//  CameraViewController.swift
//  RoversPart2
//
//  Created by Никита Макаревич on 20.10.2022.
//

import UIKit

protocol CameraViewControllerProtocol: UIViewController {
    /// getting data and displaying it
    func updatePhotos(name: String, date: String)
}

final class CameraViewController: UIViewController {
    
    weak var presenter: CameraPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        presenter?.getRoverPhotos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private let roverCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = true
        collectionView.register(CameraCollectionViewCell.self, forCellWithReuseIdentifier: "rovercell")
        collectionView.register(HeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "header")
        
        return collectionView
    }()
    
    private var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "22.08.2021"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.customGrey
        label.font = UIFont(name: "Helvetica Bold", size: 11)
        
        return label
    }()
    
    private let horizontalView: UIView = {
        let horizontalStackView = UIView()
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        
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
    func updatePhotos(name: String, date: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        if let date = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "dd.MM.YYYY"
            dateLabel.text = dateFormatter.string(from: date)
        }
        roverName.text = name
        if presenter?.getRoverData()  == [:] {
            showAlert()
        }
        roverCollectionView.reloadData()
    }
}

// MARK: - UICollcetionView extension
extension CameraViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return presenter?.getRoverData()?.keys.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "rovercell", for: indexPath) as? CameraCollectionViewCell,
              let roverData = presenter?.getRoverData()
        else { return UICollectionViewCell() }
        
        let key = Array(roverData.keys)[indexPath.section]

        guard let photos = roverData[key] else { return UICollectionViewCell() }
        cell.setPhotos(photo: photos)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "header",
            for: indexPath) as? HeaderCollectionReusableView,
              let roverData = presenter?.getRoverData()
        else { return UICollectionReusableView() }
        
        let key = Array(roverData.keys)[indexPath.section]
        header.configure(key)
        
        header.callback = { [weak self] in
            guard let self = self,
                  //let photos = self.roverData[key]
                  let photos = roverData[key]
            else { return }
            
            let viewController = PhotosAssembly.make(photos: photos)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height * 0.14)
    }
}

// MARK: - Configuring UI extension
private extension CameraViewController {
    /// Configuring UI
    func configureView() {
        view.backgroundColor = .white
        roverCollectionView.delegate = self
        roverCollectionView.dataSource = self
        
        horizontalView.addSubview(roverName)
        horizontalView.addSubview(leftArrowButton)
        horizontalView.addSubview(rightArrowButton)
        view.addSubview(dateLabel)
        view.addSubview(horizontalView)
        view.addSubview(roverCollectionView)
        
        setConstraints()
    }
    
    /// Show alert if 0 photos in this day
    func showAlert() {
        let alert = UIAlertController(title: "Нет доступных фото для выбранной даты",
                                      message: "",
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    /// Setting up constraints
    func setConstraints() {
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 58),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            horizontalView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor),
            horizontalView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            horizontalView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            horizontalView.heightAnchor.constraint(lessThanOrEqualToConstant: 70),
            
            roverName.topAnchor.constraint(equalTo: horizontalView.topAnchor, constant: 5),
            roverName.leadingAnchor.constraint(equalTo: horizontalView.leadingAnchor),
            
            leftArrowButton.topAnchor.constraint(equalTo: horizontalView.topAnchor),
            leftArrowButton.trailingAnchor.constraint(equalTo: rightArrowButton.leadingAnchor, constant: 0),
            leftArrowButton.widthAnchor.constraint(equalToConstant: 60),
            leftArrowButton.heightAnchor.constraint(equalToConstant: 60),
            
            rightArrowButton.topAnchor.constraint(equalTo: horizontalView.topAnchor),
            rightArrowButton.trailingAnchor.constraint(equalTo: horizontalView.trailingAnchor),
            rightArrowButton.widthAnchor.constraint(equalToConstant: 60),
            rightArrowButton.heightAnchor.constraint(equalToConstant: 60),
            
            roverCollectionView.topAnchor.constraint(equalTo: horizontalView.bottomAnchor),
            roverCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            roverCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            roverCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
