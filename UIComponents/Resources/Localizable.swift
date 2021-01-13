//
//  Localizable.swift
//  UIComponents
//
//  Created by David Freitas on 13/10/20.
//  Copyright © 2020 SHAPE A/S. All rights reserved.
//

import Foundation

struct Localizable {
    struct SunrireSunsetView {
        static var sunriseTitle: String {
            "SunriseSunsetView-Sunrise-Title".localized
        }
        static var sunsetTitle: String {
            "SunriseSunsetView-Sunset-Title".localized
        }
    }

    struct WindView {
        static var windDirectionTitle: String {
            "WindView-Direction-title".localized
        }
        static var windSpeedTitle: String {
            "WindView-Direction-title".localized
        }
    }
}

extension String {
    var localized: String {
        guard let bundle = Bundle(identifier: "dk.shape.UIComponents") else { return self }
        return NSLocalizedString(self, bundle: bundle, comment: "")
    }
}
