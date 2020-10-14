//
//  FindLocationInteractor.swift
//  forecast
//
//  Created by Jakob Vinther-Larsen on 19/02/2019.
//  Copyright © 2019 SHAPE A/S. All rights reserved.
//

import CoreLocation
import API
import Entities

protocol LocationDetailsInteractorOutput: class {
    func forecastListDidStartLoading()
    func forecastListDidStopLoading()
    func forecastListDidLoad(_ forecastList: ForecastList)
    func forecastListDidFailLoading(withError error: Error)
}

protocol LocationDetailsInteractorAction: class {
    func backButtonTapped()
}

final class LocationDetailsInteractor {
    var output: LocationDetailsInteractorOutput!
    var action: LocationDetailsInteractorAction!
    
    private let api: ForecastClient
    private let coordinate: CLLocationCoordinate2D
    
    init(api apiClient: ForecastClient, coordinate: CLLocationCoordinate2D) {
        self.api = apiClient
        self.coordinate = coordinate
    }
}

extension LocationDetailsInteractor: LocationDetailsViewControllerOutput {
    func viewIsReady() {
        output.forecastListDidStartLoading()

        let latitudeString = String(coordinate.latitude)
        let longitudeString = String(coordinate.longitude)
        api.perform(ForecastList.getForecast(forLatitude: latitudeString,
                                             longitude: longitudeString)) { [weak self] result in
            self?.output.forecastListDidStopLoading()
            
            switch result {
            case .success(let forecastList):
                self?.output.forecastListDidLoad(forecastList)
            case .failure(let error):
                self?.output.forecastListDidFailLoading(withError: error)
            }
        }
    }

    func backButtonTapped() {
        action.backButtonTapped()
    }
}
