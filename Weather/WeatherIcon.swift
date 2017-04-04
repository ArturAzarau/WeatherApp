//
//  WeatherIcon.swift
//  Weather
//
//  Created by Artur Azarov on 04.04.17.
//  Copyright © 2017 Artur Azarov. All rights reserved.
//

import Foundation
import UIKit

enum WeatherIcon: String {
    case ClearDay = "clear-day"
    case ClearNight = "clear-night"
    case CloudyDay = "cloudy-day"
    case CloudyNight = "cloudy-night"
    case Cloudy = "cloudy"
    case Fog = "fog"
    case Rain = "rain"
    case Sleet = "sleet"
    case Snow = "snow"
    case Sunny = "sunny"
    case Wind = "wind"
    case Default = "default"
}

extension WeatherIcon {
    var icon: UIImage {
        return UIImage(named: self.rawValue)!
    }
}
