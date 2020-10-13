//
//  Localizable.swift
//  forecast
//
//  Created by David Freitas on 13/10/20.
//  Copyright © 2020 SHAPE A/S. All rights reserved.
//

import Foundation

struct Localizable {
    struct Alert {
        static var back: String {
            "Alert-Back".localized
        }
        static var error: String {
            "Alert-Error".localized
        }
    }

    struct LocationDetails {
        static var disclaimer: String {
            "LocationDetails-Disclaimer".localized
        }
        static var fiveDayForecastTitle: String {
            "LocationDetails-FiveDayForecast-Title".localized
        }
        static var undefinedCity: String {
            "LocationDetails-UndefinedCity".localized
        }
    }
}

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
