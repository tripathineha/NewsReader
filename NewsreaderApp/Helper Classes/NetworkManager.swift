//
//  NetworkManager.swift
//  NewsreaderApp
//
//  Created by Globallogic on 29/01/18.
//  Copyright © 2018 Globallogic. All rights reserved.
//

import Foundation
import UIKit

private let manager = NetworkManager()

class NetworkManager {
    class var sharedInstance: NetworkManager {
        return manager
    }
}


extension NetworkManager{
    func sendRequest(source : String, completion: @escaping ([String: Any]?, Error?) -> Void) {
        
        guard var components = URLComponents(string: APIData.APISource.rawValue) else {
            let err = NSError(domain: Values.improper_url.localised, code: 3, userInfo: nil)
            completion(nil, err)
            return
        }
        
        var value : String?
        switch (source){
        case  NewsCategory.business.rawValue :
            value =  Source.business.rawValue
        case  NewsCategory.topnews.rawValue :
            value =  nil
        case  NewsCategory.entertainment.rawValue :
            value =  Source.entertainment.rawValue
        case  NewsCategory.health.rawValue :
            value =  Source.health.rawValue
        case  NewsCategory.science.rawValue :
            value =  Source.science.rawValue
        case  NewsCategory.sports.rawValue :
            value =  Source.sports.rawValue
        case  NewsCategory.technology.rawValue :
            value =  Source.technology.rawValue
        default:
            value =  nil
        }
        
        if let value = value {
            components.queryItems = [
                URLQueryItem(name:  JsonKeys.country.rawValue ,value :  APIData.APICountry.rawValue),
                URLQueryItem(name: JsonKeys.sourcesKey.rawValue, value: value),
                URLQueryItem(name:  JsonKeys.apiKey.rawValue ,value :  APIData.APIKey.rawValue),
            ]
        } else {
            components.queryItems = [
                URLQueryItem(name:  JsonKeys.country.rawValue ,value :  APIData.APICountry.rawValue),
                URLQueryItem(name:  JsonKeys.apiKey.rawValue ,value :  APIData.APIKey.rawValue),
            ]
        }
        
        guard let url = components.url else {
            let err = NSError(domain: Values.improper_url.localised, code: 3, userInfo: nil)
            completion(nil, err)
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data,                            // is there data
                let response = response as? HTTPURLResponse,  // is there HTTP response
                (200 ..< 300) ~= response.statusCode,         // is statusCode 2XX
                error == nil else {                           // was there no error, otherwise ...
                    completion(nil, error)
                    return
            }
            
            let responseObject = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
            completion(responseObject, nil)
        }
        task.resume()
    }
}
