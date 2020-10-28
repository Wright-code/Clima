//
//  WeatherManager.swift
//  Clima
//
//  Created by Harry Wright on 06/10/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    
    func didUpdateWeather(weather: WeatherModel)
    func didFailWithError(_ error: Error)
    
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=8a5d1ecf925fa9dc6bbfa4d9c698a241&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
        
    func fetchWeatherWithCoordinates(lat: String, lon: String) {
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(lon)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        //Create a URL
        
        if let url = URL(string: urlString) {
            //Create a URL session
            
            let session = URLSession(configuration: .default)
            //Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(weatherData: safeData) {
                        self.delegate?.didUpdateWeather(weather: weather)
                    }
                }
            }
            //Start the task
            task.resume()
        }
    }

    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temperature = decodedData.main.temp
            let cityName = decodedData.name
            let windSpeed = decodedData.wind.speed
            let windDirection = decodedData.wind.deg
            
            let weather = WeatherModel(conditionId: id, cityName: cityName, temperature: temperature, windSpeed: windSpeed, windDirection: windDirection)
            
            return weather
            
        } catch {
            delegate?.didFailWithError(error)
            return nil
        }
        
    }

}
