//
//  WeatherManager.swift
//  Clima
//
//  Created by Ádám Marton on 10.03.2025.
//  Copyright © 2025 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid={WEATHER_API_KEY}"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String?, latitude: Double? = nil, longitude: Double? = nil) {
        
        if cityName == nil {
            let urlString = "\(weatherUrl)&lat=\(latitude ?? 0)&lon=\(longitude ?? 0)"
            performRequest(with: urlString)
        } else {
            let urlString = "\(weatherUrl)&q=\(cityName!)"
            performRequest(with: urlString)
        }
        
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
        task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let name = decodedData.name
            let temp = decodedData.main.temp
            
            let weather = WeatherModel(conditionId: id, cityName: name, temp: temp)
            return weather
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
