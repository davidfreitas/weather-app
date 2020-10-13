
//
//  FindLocationRouter.swift
//  forecast
//
//  Created by Jakob Vinther-Larsen on 19/02/2019.
//  Copyright © 2019 SHAPE A/S. All rights reserved.
//

import MapKit
import API

final class LocationDetailsRouter {
    let api: ForecastClient
    weak var presentingViewController: UIViewController?
    
    init(api apiClient: ForecastClient, presentingViewController: UIViewController) {
        self.api = apiClient
        self.presentingViewController = presentingViewController
    }
}

extension LocationDetailsRouter: LocationDetailsInteractorAction {
    func backButtonTapped() {
        DispatchQueue.main.async { [weak self] in
            self?.presentingViewController?.dismiss(animated: true)
        }
    }
}
