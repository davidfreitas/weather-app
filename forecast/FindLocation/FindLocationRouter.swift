
//
//  FindLocationRouter.swift
//  forecast
//
//  Created by Jakob Vinther-Larsen on 19/02/2019.
//  Copyright © 2019 SHAPE A/S. All rights reserved.
//

import MapKit
import API

final class FindLocationRouter {
    private let api: ForecastClient
    private weak var viewController: UIViewController?
    
    init(api apiClient: ForecastClient, viewController: UIViewController) {
        self.api = apiClient
        self.viewController = viewController
    }
}

extension FindLocationRouter: FindLocationInteractorAction {
    func locationSelected(at coordinate: CLLocationCoordinate2D) {
        let detailsController = LocationDetailsConfig.setup(api: api, coordinate: coordinate, presentingViewController: viewController)
        viewController?.present(detailsController, animated: true)
    }
}
