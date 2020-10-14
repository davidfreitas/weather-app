//
//  FindLocationPresenter.swift
//  forecast
//
//  Created by Jakob Vinther-Larsen on 19/02/2019.
//  Copyright © 2019 SHAPE A/S. All rights reserved.
//

import Foundation
import Entities

protocol LocationDetailsPresenterOutput: class {
    func presentForecast(_ viewModel: LocationDetailsViewModel)
    func presentErrorMessage(withMessage message: String)
    func presentLoadingState()
    func dismissLoadingState()
}

final class LocationDetailsPresenter {
    weak var output: LocationDetailsPresenterOutput!

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        return formatter
    }()

    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        return formatter
    }()
}

extension LocationDetailsPresenter: LocationDetailsInteractorOutput {
    func forecastListDidStartLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.output.presentLoadingState()
        }
    }

    func forecastListDidStopLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.output.dismissLoadingState()
        }
    }

    func forecastListDidLoad(_ forecastList: ForecastList) {
        dateFormatter.timeZone = TimeZone(secondsFromGMT: forecastList.city.timezone)
        var viewModelForecastList: [LocationDetailsViewModel.Forecast] = []

        for forecast in forecastList.list {
            dateFormatter.dateFormat = "dd/MM\nHH:mm"
            numberFormatter.positiveSuffix = "°C"
            numberFormatter.negativeSuffix = "°C"

            let dateTime = dateFormatter.string(from: forecast.date)

            let temperature = numberFormatter.string(
                from: NSNumber(value: TemperatureConverter(withKelvinValue: forecast.temperature).celsiusValue)
            ) ?? "-"
            let maximumTemperature = numberFormatter.string(
                from: NSNumber(value: TemperatureConverter(withKelvinValue: forecast.maximumTemperature).celsiusValue)
            ) ?? "-"
            let minimumTemperature = numberFormatter.string(
                from: NSNumber(value: TemperatureConverter(withKelvinValue: forecast.minimumTemperature).celsiusValue)
            ) ?? "-"

            numberFormatter.positiveSuffix = "m/s"
            numberFormatter.negativeSuffix = ""
            let windSpeed = numberFormatter.string(from: NSNumber(value: forecast.windSpeed)) ?? "-"
            let windDirection = Float(forecast.windDirection) * Float.pi / 180 + Float.pi

            numberFormatter.positiveSuffix = "%"
            let humidity = numberFormatter.string(from: NSNumber(value: forecast.humidity)) ?? "-"

            let viewModelForecast = LocationDetailsViewModel.Forecast(dateTime: dateTime,
                                                                      temperature: temperature,
                                                                      maximumTemperature: maximumTemperature,
                                                                      minimumTemperature: minimumTemperature,
                                                                      humidity: humidity,
                                                                      windSpeed: windSpeed,
                                                                      windDirection: windDirection,
                                                                      icon: forecast.icon)
            viewModelForecastList.append(viewModelForecast)
        }

        dateFormatter.dateFormat = "HH:mm"
        let sunrise = dateFormatter.string(from: forecastList.city.sunrise)
        let sunset = dateFormatter.string(from: forecastList.city.sunset)
        let city = forecastList.city.name.isEmpty ? Localizable.LocationDetails.undefinedCity : "\(forecastList.city.name) (\(forecastList.city.country))"

        let viewModel = LocationDetailsViewModel(city: city,
                                                 sunrise: sunrise,
                                                 sunset: sunset,
                                                 forecastList: viewModelForecastList)

        DispatchQueue.main.async { [weak self] in
            self?.output.presentForecast(viewModel)
        }
    }

    func forecastListDidFailLoading(withError error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.output.presentErrorMessage(withMessage: error.localizedDescription)
        }
    }
}
