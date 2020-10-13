//
//  Weather.swift
//  API
//
//  Created by Jakob Vinther-Larsen on 19/02/2019.
//  Copyright © 2019 SHAPE A/S. All rights reserved.
//

import Entities
import Client

extension ForecastList {
    public static func getForecast(forLatitude latitude: String, longitude: String) -> Request<ForecastList, APIError> {
        let parameters = [
            QueryParameters([
                URLQueryItem(name: "lat", value: latitude),
                URLQueryItem(name: "lon", value: longitude)
            ])
        ]
        return Request(
            url: URL(string: "forecast")!,
            method: .get,
            parameters: parameters,
            resource: decodeResource(ForecastList.self),
            error: APIError.init,
            needsAuthorization: true
        )
    }
}
