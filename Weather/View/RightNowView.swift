//
//  RightNowView.swift
//  Weather
//
//  Created by Mohammad Shayan on 4/16/20.
//  Copyright © 2020 Mohammad Shayan. All rights reserved.
//

import UIKit

class RightNowView: FancyView {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    
    func clear() {
        dateLabel.text = ""
        cityLabel.text = ""
        weatherLabel.text = ""
        weatherImage.image = nil
    }
    
    func updateView(currentWeather: Current, city: String) {
        cityLabel.text = city
        dateLabel.text = Date.getTodaysDate()
        weatherLabel.text = currentWeather.weather[0].description.capitalized
        weatherImage.image = UIImage(named: currentWeather.weather[0].icon)
    }

}
