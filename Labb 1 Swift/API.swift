//
//  API.swift
//  Labb 1 Swift
//
//  Created by Nicklas Pekkarinen on 2020-02-10.
//  Copyright © 2020 Nicklas Pekkarinen. All rights reserved.
//

import Foundation

struct WeatherAPI {
    let baseURL = "https://api.openweathermap.org/data/2.5/weather?q="
    let apiKEY = "fb98fb6feb228f4136e06b490168f4a8"
    
    func getWeatherData(cityName: String, completion: @escaping (Result<Forecast, Error>) -> Void) {
        
        let formattedString = cityName.replacingOccurrences(of: " ", with: "+")
        let urlString = baseURL + formattedString + "&units=metric" + "&appid=" + apiKEY
        guard let url: URL = URL(string: urlString) else {return}
        
        // Request
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let unwrappedError = error {
                print("Error: \(unwrappedError)")
                completion(.failure(unwrappedError))
                return
            }
            if let unwrappedData = data {
                do{
                    let forecast = try JSONDecoder().decode(Forecast.self, from: unwrappedData)
                    completion(.success(forecast))
                } catch {
                    print("Error: \(error)")
                }
            }
        }
        // Start
        task.resume()
    }
}

struct CityParse {
    
    func parse() -> [String]? {
        guard let url = Bundle.main.url(forResource: "citylist", withExtension: "json") else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        guard let jsonData = try? JSONDecoder().decode([String].self, from: data) else { return nil }
        return jsonData
    }
    
}
