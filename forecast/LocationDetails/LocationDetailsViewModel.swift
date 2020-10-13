//
//  LocationDetailsViewModel.swift
//  forecast
//
//  Created by David Freitas on 12/10/20.
//  Copyright © 2020 SHAPE A/S. All rights reserved.
//

import Foundation
import UIComponents

struct LocationDetailsViewModel {
    struct Forecast {
        let dateTime: String
        let temperature: String
        let maximumTemperature: String
        let minimumTemperature: String
        let humidity: String
        let windSpeed: String
        let windDirection: Float
        let icon: String
    }

    let city: String
    let sunrise: String
    let sunset: String
    let forecastList: [Forecast]

    var sunriseSunsetViewModel: SunriseSunsetViewModel {
        SunriseSunsetViewModel(sunriseTime: sunrise, sunsetTime: sunset)
    }
    
    func forecastCellViewModel(forCellAtIndexPath indexPath: IndexPath) -> ForecastCollectionViewCellViewModel {
        let forecast = forecastList[indexPath.row]
        let viewModel = ForecastCollectionViewCellViewModel(dateTime: forecast.dateTime,
                                                            maximumTemperature: forecast.maximumTemperature,
                                                            minimumTemperature: forecast.minimumTemperature,
                                                            icon: forecast.icon,
                                                            windDirection: forecast.windDirection,
                                                            windSpeed: forecast.windSpeed)
        return viewModel
    }
}
