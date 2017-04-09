//
//  ViewController.swift
//  Weather
//
//  Created by Artur Azarov on 04.04.17.
//  Copyright © 2017 Artur Azarov. All rights reserved.
//

import UIKit
import CoreLocation

extension CurrentWeather {
    var temperatureString: String {
        let celsiumTemperature = (temperature - 32) * 5 / 9
        return "\(celsiumTemperature)º"
    }
    
    var humidityString: String {
        let percentageValue = Int(humidity * 100)
        return "\(percentageValue)%"
    }
    
    var precipitationProbabilityString: String {
        let percentageValue = Int(precipProbability * 100)
        return "\(percentageValue)%"
    }
    
    var windSpeedString: String {
        return "\(Int(0.44704 * windSpeed)) м/с"
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var temperatureText: UILabel!
    @IBOutlet weak var precipProbabilityText: UILabel!
    @IBOutlet weak var humidityText: UILabel!
    @IBOutlet weak var windSpeedText: UILabel!
    @IBOutlet weak var summaryText: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var refreshButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCurrentWeather()
    }
    
    lazy var forecastAPIClient = WeatherClient(APIKey: "acb128d9b1a62649095180577ffca505")
    let coordinate = Coordinate(latitude: 59.940888, longitude: 30.281091)
    
    
    func fetchCurrentWeather() {
        forecastAPIClient.fetchCurrentWeather(coordinate) { result in
            self.toggleRefreshAnimation(false)
            
            switch result {
            case .success(let currentWeather):
                self.display(currentWeather)
            case .failure(let error as NSError):
                self.showAlert("Unable to retrieve forecast", message: error.localizedDescription)
            default: break
            }
        }
        
    }
    
    func display(_ weather: CurrentWeather) {
        temperatureText.text = weather.temperatureString
        precipProbabilityText.text = weather.precipitationProbabilityString
        humidityText.text = weather.humidityString
        //summaryText.text = weather.summary
        icon.image = weather.icon
        windSpeedText.text = weather.windSpeedString
    }
    
    func showAlert(_ title: String, message: String?, style: UIAlertControllerStyle = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(dismissAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func refreshWeather(_ sender: AnyObject) {
        toggleRefreshAnimation(true)
        fetchCurrentWeather()
    }
    
    func toggleRefreshAnimation(_ on: Bool) {
        refreshButton.isHidden = on
        if on {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }

}

