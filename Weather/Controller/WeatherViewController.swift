//
//  WeatherViewController.swift
//  Weather
//
//  Created by Mohammad Shayan on 4/16/20.
//  Copyright © 2020 Mohammad Shayan. All rights reserved.
//

import UIKit
import MapKit

class WeatherViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var rightNowView: RightNowView!
    @IBOutlet weak var weatherDetailView: WeatherDetailView!
    
    var city = ""
    var weatherResult: Result?
    var locationManger: CLLocationManager!
    var currentlocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearAll()
        getLocation()
    }
    
    func clearAll() {
        rightNowView.clear()
        weatherDetailView.clear()
    }
    
    func getWeather() {
        NetworkService.shared.getWeather(onSuccess: { (result) in
            self.weatherResult = result
            
            self.weatherResult?.sortDailyArray()
            self.weatherResult?.sortHourlyArray()
            
            self.updateViews()
            
        }) { (errorMessage) in
            debugPrint(errorMessage)
        }
    }
    
    func updateViews() {
        updateTopView()
        updateBottomView()
    }
    
    func updateTopView() {
        guard let weatherResult = weatherResult else {
            return
        }
        
        rightNowView.updateView(currentWeather: weatherResult.current, city: city)
    }
    
    func updateBottomView() {
        guard let weatherResult = weatherResult else {
            return
        }
        
        let title = weatherDetailView.getSelectedTitle()
        
        if title == "Today" {
            weatherDetailView.updateViewForToday(weatherResult.hourly)
        } else if title == "Weekly" {
            weatherDetailView.updateViewForWeekly(weatherResult.daily)
        }
    }
    
    func getLocation() {
       
        if (CLLocationManager.locationServicesEnabled()) {
            locationManger = CLLocationManager()
            locationManger.delegate = self
            locationManger.desiredAccuracy = kCLLocationAccuracyBest
            locationManger.requestWhenInUseAuthorization()
            locationManger.requestLocation()
        }
        
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.currentlocation = location
            
            let latitude: Double = self.currentlocation!.coordinate.latitude
            let longitude: Double = self.currentlocation!.coordinate.longitude
            
            NetworkService.shared.setLatitude(latitude)
            NetworkService.shared.setLongitude(longitude)
            
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let error = error {
                    debugPrint(error.localizedDescription)
                }
                if let placemarks = placemarks {
                    if placemarks.count > 0 {
                        let placemark = placemarks[0]
                        if let city = placemark.locality {
                            self.city = city
                        }
                    }
                }
            }
            
            getWeather()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint(error.localizedDescription)
    }
    
    @IBAction func getWeatherTapped(_ sender: UIButton) {
        clearAll()
        getLocation()
    }
    
    @IBAction func todayWeeklyValueChanged(_ sender: UISegmentedControl) {
        clearAll()
        updateViews()
    }
}
