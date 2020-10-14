//
//  FindLocationConfig.swift
//  forecast
//
//  Created by Jakob Vinther-Larsen on 19/02/2019.
//  Copyright © 2019 SHAPE A/S. All rights reserved.
//

import UIKit
import API
import CoreLocation

struct LocationDetailsConfig {
    static func setup(api apiClient: ForecastClient,
                      coordinate: CLLocationCoordinate2D,
                      presentingViewController: UIViewController?) -> UIViewController {
        let viewController = LocationDetailsViewController()
        let interactor = LocationDetailsInteractor(api: apiClient, coordinate: coordinate)
        let presenter = LocationDetailsPresenter()
        let router = LocationDetailsRouter(api: apiClient, presentingViewController: presentingViewController)
        
        viewController.output = interactor
        interactor.action = router
        interactor.output = presenter
        presenter.output = viewController
        
        return viewController
    }
}
