//
//  HomeTableViewCell.swift
//  AppcentWeather
//
//  Created by Mustafa Altıparmak on 14.04.2022.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    static let identifier = "HomeTableViewCell"
    
    private let cityImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "city_scape")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 50
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let locationTypeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let distanceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .systemOrange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(cityImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(locationTypeLabel)
        contentView.addSubview(distanceLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with location: NearLocationModel?) {
        guard let location = location else {
            return
        }
        titleLabel.text = location.title
        locationTypeLabel.text = location.location_type
        distanceLabel.text = "Distance: \(location.distance) m"
        
//        cityImageView.sd_setImage(with: URL(string: "https://www.metaweather.com/static/img/weather/png/c.png"))

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            cityImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            cityImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            cityImageView.widthAnchor.constraint(equalToConstant: 150),
            cityImageView.heightAnchor.constraint(equalToConstant: 150),
            
            titleLabel.topAnchor.constraint(equalTo: cityImageView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: cityImageView.leadingAnchor),
            
            locationTypeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            locationTypeLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            locationTypeLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            distanceLabel.topAnchor.constraint(equalTo: locationTypeLabel.bottomAnchor, constant: 10),
            distanceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            distanceLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
        

//        contentView.layer.cornerRadius = 20
//        contentView.backgroundColor = .systemGray
//        contentView.layer.masksToBounds = true
        
        layer.cornerRadius = 30
    }
    
}
