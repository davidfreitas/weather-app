//
//  FindLocationViewController.swift
//  forecast
//
//  Created by Jakob Vinther-Larsen on 19/02/2019.
//  Copyright © 2019 SHAPE A/S. All rights reserved.
//

import UIKit
import MapKit

protocol FindLocationViewControllerOutput: class {
    func locationSelected(at coordinate: CLLocationCoordinate2D)
}

final class FindLocationViewController: UIViewController {
    
    private lazy var mapView: MKMapView = MKMapView(frame: .zero)
    
    var output: FindLocationViewControllerOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(mapView)

        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(findLocation(_:)))
        mapView.addGestureRecognizer(gesture)
    }
    
    @objc
    private func findLocation(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: nil)
        output.locationSelected(at: coordinate)
    }
}

extension FindLocationViewController: FindLocationPresenterOutput {}
