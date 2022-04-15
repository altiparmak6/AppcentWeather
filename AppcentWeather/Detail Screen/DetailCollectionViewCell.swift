//
//  DetailCollectionViewCell.swift
//  AppcentWeather
//
//  Created by Mustafa Altıparmak on 15.04.2022.
//

import UIKit
import Kingfisher

class DetailCollectionViewCell: UICollectionViewCell {
    

    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let weatherImageView: UIImageView = {
        let weatherImageView = UIImageView()
        weatherImageView.translatesAutoresizingMaskIntoConstraints = false
        weatherImageView.contentMode = .scaleAspectFit
        weatherImageView.clipsToBounds = true
        return weatherImageView
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .regular)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(dateLabel)
        contentView.addSubview(weatherImageView)
        contentView.addSubview(temperatureLabel)
        
        layer.cornerRadius = 30
 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dateLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            dateLabel.heightAnchor.constraint(equalToConstant: 22),
            
            weatherImageView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5),
            weatherImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            weatherImageView.heightAnchor.constraint(equalToConstant: 50),
            weatherImageView.widthAnchor.constraint(equalToConstant: 50),
            
            temperatureLabel.topAnchor.constraint(equalTo: weatherImageView.bottomAnchor, constant: 5),
            temperatureLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            temperatureLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            temperatureLabel.heightAnchor.constraint(equalToConstant: 30)
            
        ])
        
    }
    
    
    func configure(with detail: ConsolidatedWeather?) {
        guard let detail = detail else {
            return
        }


        dateLabel.text = detail.applicableDate
        let url = URL(string: "https://www.metaweather.com/static/img/weather/png/\(detail.weatherStateAbbr).png")
        weatherImageView.kf.setImage(with: url)
        temperatureLabel.text = String(format:"%.1f°", detail.theTemp)
        
    }
    

}
