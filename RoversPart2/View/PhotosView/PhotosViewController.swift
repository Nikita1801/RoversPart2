//
//  PhotosViewController.swift
//  RoversPart2
//
//  Created by Никита Макаревич on 24.10.2022.
//

import UIKit

protocol PhotosViewControllerProtocol: AnyObject {
    /// getting data and displaying it
    func updatePhotos()
    //    func showAlert(isGet: Bool)
}

final class PhotosViewController: UIViewController {
    
    var presenter: PhotosPresenterProtocol?
    private var photos: [RoverData]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        configureView()
    }
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = true
        collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: "photocell")
        
        return collectionView
    }()
    
    private var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "23.08.2021"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.customGrey
        label.font = UIFont(name: "Helvetica Bold", size: 12)
        
        return label
    }()
    
    private lazy var leftArrowButton: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: "arrowleft.png"),
                               style: .plain,
                               target: self,
                               action: #selector(increaseDate))
    }()
    
    private lazy var rightArrowButton: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: "arrowright.png"),
                               style: .plain,
                               target: self,
                               action: #selector(decreaseDate))
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

// MARK: - PhotosViewControllerProtocol extenstion
extension PhotosViewController: PhotosViewControllerProtocol {
    func updatePhotos() {
        collectionView.reloadData()
    }
}

// MARK: UICollectionView extension
extension PhotosViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.getCameraPhotos().count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photocell", for: indexPath) as? PhotosCollectionViewCell else { return UICollectionViewCell() }

        guard let photo = presenter?.getCameraPhotos()[indexPath.row] else { return UICollectionViewCell() }
        cell.setValues(photo: photo)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 2.25, height: view.frame.height / 5.7)
    }
}

// MARK: Configuring view extension
private extension PhotosViewController {
    func configureView() {
        view.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        setNavigationBar()
        setLabels()

        view.addSubview(collectionView)
        
        setConstraints()
    }
    
    /// Convert date and set value to dateLabel
    func setLabels() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        if let date = dateFormatter.date(from: presenter?.getCameraPhotos()[0].earth_date ?? "") {
            dateFormatter.dateFormat = "dd.MM.YYYY"
            dateLabel.text = dateFormatter.string(from: date)
        }
    }
    
    /// Setting up navigation bar items with rover name, date and arrows
    func setNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        let backButton = UIBarButtonItem()
        backButton.title = "back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = UIColor.customBlack
        
        // setting rover name
        navigationItem.title = presenter?.getCameraPhotos()[0].rover.name
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // setting arrows and date
        navigationItem.rightBarButtonItems = [rightArrowButton, leftArrowButton, UIBarButtonItem.init(customView: dateLabel)]

    }

    func setConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
