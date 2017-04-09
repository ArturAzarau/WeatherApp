//
//  CurrentWeather.swift
//  Weather
//
//  Created by Artur Azarov on 04.04.17.
//  Copyright © 2017 Artur Azarov. All rights reserved.
//

import Foundation
import UIKit

struct CurrentWeather: JSONDecodable{
    let summary: String
    let icon: UIImage
    let precipProbability: Double
    let temperature:Int
    let humidity: Double
    let windSpeed: Double
    
    init?(JSON: [String: AnyObject]){
        
        guard let temperature = JSON["temperature"] as? Int,
                let iconString = JSON["icon"] as? String,
                let precipProbability = JSON["precipProbability"] as? Double,
                let summary =  JSON["summary"] as? String,
                let humidity = JSON["humidity"] as? Double,
                let windSpeed = JSON["windSpeed"] as? Double
            else {
                
                return nil
        }
        
        let icon = WeatherIcon(rawValue: iconString)!.icon

        
        self.summary = summary
        self.precipProbability = precipProbability
        self.temperature = temperature
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.icon = icon
        
    }
}
