//
//  CurrentWeather.swift
//  Entities
//
//  Created by Jakob Vinther-Larsen on 19/02/2019.
//  Copyright © 2019 SHAPE A/S. All rights reserved.
//

import Foundation

public struct City: Codable {
    public let name: String
    public let country: String
    public let sunrise: Date
    public let sunset: Date
    public let timezone: Int
}
