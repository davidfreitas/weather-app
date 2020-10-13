//
//  forecastTests.swift
//  forecastTests
//
//  Created by David Freitas on 13/10/20.
//  Copyright © 2020 SHAPE A/S. All rights reserved.
//

import XCTest
@testable import forecast

class TemperatureConverterTests: XCTestCase {
    func test_initWithKelvin_willConvertCorrectly() {
        let converter = TemperatureConverter(withKelvinValue: 500)
        XCTAssertEqual(converter.kelvinValue, 500)
        XCTAssertEqual(converter.celsiusValue, 226.85)
        XCTAssertEqual(converter.fahrenheitValue, 440.33)
    }

    func test_initWithCelsius_willConvertCorrectly() {
        let converter = TemperatureConverter(withCelsiusValue: 226.85)
        XCTAssertEqual(converter.kelvinValue, 500)
        XCTAssertEqual(converter.celsiusValue, 226.85)
        XCTAssertEqual(converter.fahrenheitValue, 440.33)
    }

    func test_initWithFahrenheit_willConvertCorrectly() {
        let converter = TemperatureConverter(withFahrenheitValue: 440.33)
        XCTAssertEqual(converter.kelvinValue, 500)
        XCTAssertEqual(converter.celsiusValue, 226.85)
        XCTAssertEqual(converter.fahrenheitValue, 440.33)
    }
}
