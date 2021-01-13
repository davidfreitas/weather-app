//
//  FindLocationViewController.swift
//  forecast
//
//  Created by Jakob Vinther-Larsen on 19/02/2019.
//  Copyright © 2019 SHAPE A/S. All rights reserved.
//

import UIKit
import UIComponents

protocol LocationDetailsViewControllerOutput: class {
    func viewIsReady()
    func backButtonTapped()
}

final class LocationDetailsViewController: UIViewController {
    private let locationDetailsView = LocationDetailsView()

    var output: LocationDetailsViewControllerOutput!

    override func loadView() {
        view = locationDetailsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewBinds()
        output.viewIsReady()
    }

    private func setupViewBinds() {
        locationDetailsView.closeButtonHandler = { [weak self] in
            self?.output.backButtonTapped()
        }
    }
}

extension LocationDetailsViewController: LocationDetailsPresenterOutput {
    func presentLoadingState() {
        locationDetailsView.presentLoadingState()
    }

    func dismissLoadingState() {
        locationDetailsView.dismissLoadingState()
    }

    func presentForecast(_ viewModel: LocationDetailsViewModel) {
        locationDetailsView.viewModel = viewModel
    }

    func presentErrorMessage(withMessage message: String) {
        let alertController = UIAlertController(title: Localizable.Alert.error, message: title, preferredStyle: .alert)

        let backAction = UIAlertAction(title: Localizable.Alert.back, style: .cancel) { [weak self] _ in
            self?.output.backButtonTapped()
        }
        alertController.addAction(backAction)

        present(alertController, animated: true)
    }
}
