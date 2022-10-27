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
    
    private lazy var leftArrowBarButton: UIBarButtonItem = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrowleft.png"), for: .normal)
        button.frame = CGRect(x: 0.0, y: 0.0, width: 50, height: 50)
        button.addTarget(self, action: #selector(decreaseDate), for: .touchUpInside)
        
        let arrowBarItem = UIBarButtonItem(customView: button)
        _ = arrowBarItem.customView?.widthAnchor.constraint(equalToConstant: 50).isActive = true
        _ = arrowBarItem.customView?.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        return arrowBarItem
    }()
    
    private lazy var rightArrowBarButton: UIBarButtonItem = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrowright.png"), for: .normal)
        button.frame = CGRect(x: 0.0, y: 0.0, width: 50, height: 50)
        button.addTarget(self, action: #selector(increaseDate), for: .touchUpInside)
        
        let arrowBarItem = UIBarButtonItem(customView: button)
        _ = arrowBarItem.customView?.widthAnchor.constraint(equalToConstant: 50).isActive = true
        _ = arrowBarItem.customView?.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        return arrowBarItem
    }()
    
    private let spacing: UIBarButtonItem = {
        let spacing = UILabel()
        spacing.frame = CGRect(x: 0.0, y: 0.0, width: 50, height: 50)
        
        let spacingItem = UIBarButtonItem(customView: spacing)
        _ = spacingItem.customView?.widthAnchor.constraint(equalToConstant: 50).isActive = true
        _ = spacingItem.customView?.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        return spacingItem
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
        if presenter?.getCameraPhotos() == [] {
            showAlert()
        }
        else {
            setLabels()
        }
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
        return CGSize(width: UIScreen.main.bounds.width * 0.44 , height: UIScreen.main.bounds.height * 0.15)
    }
}

// MARK: Configuring view extension
private extension PhotosViewController {
    func configureView() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        setNavigationBar()
        setLabels()
        
        setConstraints()
    }
    
    /// Show alert if 0 photos in this day
    func showAlert() {
        let alert = UIAlertController(title: "No photos available for this date",
                                      message: "",
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
        navigationItem.setRightBarButtonItems([rightArrowBarButton,
                                          leftArrowBarButton,
                                          spacing,
                                          UIBarButtonItem.init(customView: dateLabel)],
                                         animated: true)
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
