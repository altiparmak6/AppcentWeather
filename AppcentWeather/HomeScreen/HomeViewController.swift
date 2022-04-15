//
//  ViewController.swift
//  AppcentWeather
//
//  Created by Mustafa Altıparmak on 13.04.2022.
//

import UIKit
import Network

class HomeViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = false
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorColor = .white
        return tableView
    }()
    
    
    private let networkStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "Network status: "
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Near Locations"
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 40)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let viewModel = HomeViewModel(networkManager: NetworkManagerAlamofire())
    
    let networkMonitor = NetworkMonitor()

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkMonitor.startMonitoring()
        networkMonitor.isConnected.bind { [weak self] isConnected in
            guard let isConnected = isConnected else {return}
            if isConnected {
                DispatchQueue.main.async {
                    self?.networkStatusLabel.backgroundColor = .systemGreen
                    self?.networkStatusLabel.text = "Network status: Connected"
                }
            } else {
                DispatchQueue.main.async {
                    self?.networkStatusLabel.backgroundColor = .systemRed
                    self?.networkStatusLabel.text = "Network status: Not Connected"
                }
            }
        }
        
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        view.addSubview(networkStatusLabel)
        view.addSubview(headerLabel)
        
        viewModel.getUserLocation()
        
        
        //MARK: - Bindings
        
        viewModel.nearLocations.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.coordinateString.bind { [weak self] coordinate in
            guard let coordinate = coordinate else {return}
            self?.viewModel.fetchNearLocations(with: coordinate)
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        
        
        
    }
    
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            tableView.bottomAnchor.constraint(equalTo: networkStatusLabel.topAnchor),
            
            networkStatusLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            networkStatusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            networkStatusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            networkStatusLabel.heightAnchor.constraint(equalToConstant: 30),
            
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            headerLabel.heightAnchor.constraint(equalToConstant: 50)
        ])

    }
    


}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.nearLocations.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier) as! HomeTableViewCell
        cell.configure(with: viewModel.nearLocations.value?[indexPath.row])
        cell.layer.borderColor = UIColor.darkGray.cgColor
        cell.layer.borderWidth = 3
        cell.layer.cornerRadius = 20
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let woeid = viewModel.nearLocations.value?[indexPath.row].woeid else {return}
        let detailViewControoler = DetailViewController(woeid: woeid)
        navigationController?.pushViewController(detailViewControoler, animated: true)
    }
    
    
    //MARK: - TableViewCell Animation
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 10, 0)
        cell.layer.transform = rotationTransform
        
        UIView.animate(withDuration: 1.0) {
            cell.layer.transform = CATransform3DIdentity
        }
    }
    
}


