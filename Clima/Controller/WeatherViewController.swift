//
//  ViewController.swift
//  Clima
//
//  Created by Harry Wright on 05/10/2020.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var unitType: UILabel!
    @IBOutlet weak var windDirectionIcon: UIImageView!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    var temperatureNow: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherManager.delegate = self
        searchTextField.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
    }

    func searchForData() {
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
    }
    
    func searchForDataWithCoordinates(lat: String, lon:String) {
        weatherManager.fetchWeatherWithCoordinates(lat: lat, lon: lon)
    }
    
    //Degrees Celcius/Degrees Farenheit Switch
    @IBAction func unitChangePressed(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            temperatureLabel.text = String(format: "%.1f", temperatureNow)
            unitType.text = "C"
        } else {
            temperatureLabel.text = String(format: "%.1f", ((temperatureNow * 1.8+32)))
            unitType.text = "F"
        }
    }
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
}

//MARK: Text Field Delegate
extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        searchForData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something here"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
       searchForData()
    }
    
}

//MARK: Weather Manager Delegate
extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(weather: WeatherModel) { 
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage.init(systemName: weather.conditionName)
            self.temperatureNow = weather.temperature
            self.windDirectionIcon.image = UIImage(systemName: weather.windDirectionAverage)
            self.windSpeedLabel.text = "\(weather.windSpeedString) m/s"
        }
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }
    
}

//MARK: GetLocationData

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = String(location.coordinate.latitude)
            let lon = String(location.coordinate.longitude)
            searchForDataWithCoordinates(lat: lat, lon: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
