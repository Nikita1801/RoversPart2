//
//  SettingsViewController.swift
//  RoversPart2
//
//  Created by Никита Макаревич on 20.10.2022.
//

import UIKit

protocol SettingsViewControllerProtocol: UIViewController { }

final class SettingsViewController: UIViewController {
    
    var presenter: SettingsPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark // TODO: - Check on first launch
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
        
    }
    
    private let headLableFirst: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ВЫБИРАЕМ"
        label.textColor = UIColor.customGrey
        label.font = UIFont(name: "Helvetica Bold", size: 11)
        
        return label
    }()
    
    private let headLableSecond: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Марсоходы"
        label.textColor = UIColor.customBlack
        label.font = UIFont(name: "Helvetica Bold", size: 34)
        
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 50
        
        return tableView
    }()
    
}

// MARK: - UITableView extension
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = presenter?.getRovers().count ?? 0
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? SettingsTableViewCell,
              let rovers = presenter?.getRovers()
        else { return UITableViewCell() }
        cell.accessoryView = CheckMarkView.init()
        cell.accessoryView?.isHidden = true
        
        let roverName = rovers[indexPath.row]
        cell.setRover(roverName: roverName)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        tableView.cellForRow(at: indexPath)?.accessoryView?.isHidden = false
        
        presenter?.setSelectedRover(index: indexPath.row)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryView?.isHidden = true
    }
}

// MARK: Configuring view extension
private extension SettingsViewController {
    /// Configuring UI
    func configureView() {
        
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: true)
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(headLableFirst)
        view.addSubview(headLableSecond)
        view.addSubview(tableView)
        
        setConstraints()
    }
    
    /// Setting up constraints
    func setConstraints() {
        NSLayoutConstraint.activate([
            headLableFirst.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 22),
            headLableFirst.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headLableFirst.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            headLableSecond.topAnchor.constraint(equalTo: headLableFirst.bottomAnchor, constant: 8),
            headLableSecond.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headLableSecond.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: headLableSecond.bottomAnchor, constant: 41),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension SettingsViewController: SettingsViewControllerProtocol { }
