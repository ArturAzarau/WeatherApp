//
//  WeatherClient.swift
//  Weather
//
//  Created by Artur Azarov on 06.04.17.
//  Copyright © 2017 Artur Azarov. All rights reserved.
//

import Foundation

struct Coordinate {
    let latitude: Double
    let longitude: Double
}

enum Forecast: Endpoint {
    case current(token: String, coordinate: Coordinate)
    
    var baseURL: URL {
        return URL(string: "https://api.darksky.net")!
    }
    
    var path: String {
        switch self {
        case .current(let token, let coordinate):
            return "/forecast/\(token)/\(coordinate.latitude),\(coordinate.longitude)"
        }
    }
    
    var request: URLRequest {
        let url = URL(string: path, relativeTo: baseURL)!
        return URLRequest(url: url)
    }
}

final class WeatherClient: APIClient {
    var configuration: URLSessionConfiguration
    lazy var session: URLSession = {
        return URLSession(configuration: self.configuration)
    }()
    
    fileprivate let token: String
    
    required init(config: URLSessionConfiguration, APIKey: String ) {
        self.configuration = config
        self.token = APIKey
    }
    
    convenience init(APIKey: String){
        self.init(config: URLSessionConfiguration.default, APIKey: APIKey)
    }
    
    func fetchCurrentWeather(_ coordinate: Coordinate, completion: @escaping  (APIResult<CurrentWeather>) -> Void) {
        let request = Forecast.current(token: self.token, coordinate: coordinate).request
        print(request)
        fetch(with: request, parse: { json -> CurrentWeather? in
            // Parse from JSON response to CurrentWeather
            print(json)
            if let currentWeatherDictionary = json["currently"] as? [String : AnyObject] {
                return CurrentWeather(JSON: currentWeatherDictionary)
            } else {
                return nil
            }
            
        }, completion: completion)
    }

}
