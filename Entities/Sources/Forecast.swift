//
//  CurrentWeather.swift
//  Entities
//
//  Created by Jakob Vinther-Larsen on 19/02/2019.
//  Copyright © 2019 SHAPE A/S. All rights reserved.
//

import Foundation

public struct Forecast: Codable {
    private struct Main: Codable {
        enum CodingKeys: String, CodingKey {
            case temperature = "temp"
            case feelsLike = "feels_like"
            case maximumTemperature = "temp_max"
            case minimumTemperature = "temp_min"
            case humidity
        }

        let temperature: Double
        let feelsLike: Double
        let maximumTemperature: Double
        let minimumTemperature: Double
        let humidity: Int
    }

    private struct Weather: Codable {
        let description: String
        let icon: String
    }

    private struct Wind: Codable {
        enum CodingKeys: String, CodingKey {
            case speed
            case direction = "deg"
        }

        let speed: Double
        let direction: Int
    }

    enum CodingKeys: String, CodingKey {
        case main, weather, wind
        case deltaTime = "dt"
    }

    private let main: Main
    private let weather: [Weather]
    private let wind: Wind
    public let deltaTime: TimeInterval
    public var temperature: Double { main.temperature }
    public var feelsLike: Double { main.feelsLike }
    public var maximumTemperature: Double { main.maximumTemperature }
    public var minimumTemperature: Double { main.minimumTemperature }
    public var humidity: Int { main.humidity }
    public var description: String { weather.first?.description ?? "" }
    public var icon: String { weather.first?.icon ?? "" }
    public var windSpeed: Double { wind.speed }
    public var windDirection: Int { wind.direction }
}
