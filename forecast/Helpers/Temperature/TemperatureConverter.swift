//
//  TemperatureConverter.swift
//  forecast
//
//  Created by David Freitas on 13/10/20.
//  Copyright © 2020 SHAPE A/S. All rights reserved.
//

import Foundation

struct TemperatureConverter {
    let kelvinValue: Double

    var celsiusValue: Double {
        round((kelvinValue - 273.15) * 100) / 100
    }

    var fahrenheitValue: Double {
        round((celsiusValue * 1.8 + 32) * 100) / 100
    }

    init(withKelvinValue value: Double) {
        kelvinValue = value
    }

    init(withCelsiusValue value: Double) {
        kelvinValue = round((value + 273.15) * 100) / 100
    }

    init(withFahrenheitValue value: Double) {
        kelvinValue = round(((value - 32) / 1.8 + 273.15) * 100) / 100
    }
}
