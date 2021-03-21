//
//  ForecastTableViewCell.swift
//  Weather App
//
//  Created by Radek Herold on 20.03.2021.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {

    @IBOutlet weak var forecastImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var predictionLabel: UILabel!
    @IBOutlet weak var dividerImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareForReuse()
    }
    
    func setupUI(with weatherItem: WeatherItem) {
        forecastImageView.image = UIImage(named: weatherItem.weather.first?.truncateDescription ?? "")
        timeLabel.text = weatherItem.time
        predictionLabel.text = weatherItem.weather.first?.description.capitalized
        temperatureLabel.text = weatherItem.main.temperatureInCelsius
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        timeLabel.text = nil
        predictionLabel.text = nil
        temperatureLabel.text = nil
        forecastImageView.image = nil
    }
}
