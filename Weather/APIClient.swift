//
//  APIClient.swift
//  Weather
//
//  Created by Artur Azarov on 05.04.17.
//  Copyright © 2017 Artur Azarov. All rights reserved.
//

import Foundation

public let AIANetworkingDomain = "ru.arturazarau.Weather.NetworkingError"
public let MissingHTTPResponseError = 10
public let UnexpectedResponseError = 20

typealias JSON = [String: AnyObject]
typealias JSONTaskCompletion = (JSON?, HTTPURLResponse?, Error?) -> Void
typealias JSONTask = URLSessionDataTask

enum APIResult<T>{
    case success(T)
    case failure(Error)
}
protocol APIClient {
    var configuration: URLSessionConfiguration { get }
    var session: URLSession { get }
    
    init(config: URLSessionConfiguration)
    
    func JSONTaskWithRequest(_ request: URLRequest, completion: JSONTaskCompletion) -> JSONTask
    
    func fetch<T>(_ request: URLRequest, parse: (JSON) -> T?, completion: (APIResult<T>) -> Void)
}

extension APIClient {
    func JSONTaskWithRequest(_ request: URLRequest, completion: @escaping JSONTaskCompletion) -> JSONTask {
        
        //creating data task
        let task = session.dataTask(with: request) { data, response, error in
            
            // check if there is a response
            guard let HTTPResponse = response as? HTTPURLResponse else {
                // if not then creating a userInfo dict about error and passing error to competion handler
                let userInfo = [ NSLocalizedDescriptionKey : NSLocalizedString("Missing HTTP Response", comment: "")]
                
                let error = NSError(domain: AIANetworkingDomain, code: MissingHTTPResponseError, userInfo: userInfo)
                completion(nil,nil,error)
                return
            }
            // if response exists, check for data
            if data == nil {
                //if data doesn't exist, then completion handler is called with error and response parametres
                if let error = error {
                    completion(nil, HTTPResponse, error as NSError?)
                }
            } else {
                // if data exists then switch for status code of response
                switch HTTPResponse.statusCode {
                // if response is successful ( status code = 200) then trying to convert data to json object
                case 200:
                    do {
                        let json = try
                        JSONSerialization.jsonObject(with: data!, options: []) as? JSON
                        completion(json,HTTPResponse,nil)
                    } catch let error as NSError {
                        completion(nil,HTTPResponse,error)
                    }
                default: print("Received HTTP Response: \(HTTPResponse.statusCode) - not handled")
                }
            }
            
        }
        return task
}
    
    func fetch<T>(_ request: URLRequest, parse: (JSON) -> T?, completion: (APIResult<T>) -> Void) {
        
        let task = JSONTaskWithRequest(request) { json,response, error in
            
            guard let json = json else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    // TODO: Implement Error Handling
                }
                return
            }
            
            if let value = parse(json) {
                completion(.success(value))
            } else {
                let error = NSError(domain: AIANetworkingDomain, code: UnexpectedResponseError, userInfo: nil)
                completion(.failure(error))
            }
            
        }
        task.resume()
    }
}


















