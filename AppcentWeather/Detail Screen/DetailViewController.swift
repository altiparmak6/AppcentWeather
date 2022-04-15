//
//  DetailViewController.swift
//  AppcentWeather
//
//  Created by Mustafa Altıparmak on 15.04.2022.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {
    
    private let containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    private let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .regular)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 80, weight: .regular)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let weatherStateNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .regular)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let humidityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .light)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let networkStatusLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let woeid: Int
    
    let detailViewModel = NewDetailViewModel(networkManager: NetworkManagerAlamofire())
    let networkMonitor = NetworkMonitor()
    
    init(woeid: Int) {
        self.woeid = woeid
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(temperatureLabel)
        containerView.addSubview(weatherStateNameLabel)
        containerView.addSubview(humidityLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(weatherImageView)
        view.addSubview(collectionView)
        view.addSubview(networkStatusLabel)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        networkMonitor.startMonitoring()
        networkMonitor.isConnected.bind {[weak self] isConnected in
            guard let isConnected = isConnected else {
                return
            }

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
        

        //MARK: - Get details and
        
        detailViewModel.getDetails(woeid: woeid)
        
        
        detailViewModel.details.bind { [weak self] _ in

            guard let self = self else {
                return
            }

            
            //detailModel her güncellendiğinde(binding ile haberim oluyor) viewModel'den propertyleri alacağım.
            //Otomatik güncellenmesini istediklerim data binding yapmalıyım (viewModel da observable property olmalı)
            self.titleLabel.text = self.detailViewModel.title
            self.temperatureLabel.text = self.detailViewModel.temperature
            self.weatherStateNameLabel.text = self.detailViewModel.weatherState
            self.dateLabel.text = self.detailViewModel.dateString
            self.humidityLabel.text = self.detailViewModel.humidity
            
                        
            let url = URL(string: self.detailViewModel.weatherImageLink)
            self.weatherImageView.kf.setImage(with: url)
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            containerView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.4),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            temperatureLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            temperatureLabel.heightAnchor.constraint(equalToConstant: 90),
            temperatureLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            weatherStateNameLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 5),
            weatherStateNameLabel.heightAnchor.constraint(equalToConstant: 28),
            weatherStateNameLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            humidityLabel.topAnchor.constraint(equalTo: weatherStateNameLabel.bottomAnchor, constant: 5),
            humidityLabel.heightAnchor.constraint(equalToConstant: 28),
            humidityLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            dateLabel.heightAnchor.constraint(equalToConstant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5),
            
            collectionView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.heightAnchor.constraint(equalToConstant: 150),
            
            weatherImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            weatherImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            weatherImageView.heightAnchor.constraint(equalToConstant: 80),
            weatherImageView.widthAnchor.constraint(equalToConstant: 80),
            
            networkStatusLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            networkStatusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            networkStatusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            networkStatusLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    
}





extension DetailViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailViewModel.details.value?.consolidated_weather.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DetailCollectionViewCell
        
        cell.backgroundColor = UIColor(red: 231/255, green: 251/255, blue: 190/255, alpha: 1)
        
        if indexPath.row == 0 {
            //diffrent background color indicating current day
            cell.backgroundColor = UIColor(red: 255/255, green: 188/255, blue: 209/255, alpha: 1)
        }
        let weather = detailViewModel.details.value?.consolidated_weather[indexPath.row]
        cell.configure(with: weather)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 150)
    }
    
}
