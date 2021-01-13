
//
//  FindLocationRouter.swift
//  forecast
//
//  Created by Jakob Vinther-Larsen on 19/02/2019.
//  Copyright © 2019 SHAPE A/S. All rights reserved.
//

import UIKit

final class LocationDetailsRouter {
    weak var presentingViewController: UIViewController?
    
    init(presentingViewController: UIViewController?) {
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
