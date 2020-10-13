//
//  WindView.swift
//  UIComponents
//
//  Created by David Freitas on 13/10/20.
//  Copyright © 2020 SHAPE A/S. All rights reserved.
//

import UIKit

public struct WindViewModel {
    let windDirection: Float
    let windSpeed: String
}

public final class WindView: UIView {

    private struct Constants {
        static let directionIconHeight: CGFloat = 15
    }

    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let windDirectionImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "arrow.up")
        view.contentMode = .scaleAspectFit
        view.tintColor = .systemGray2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let windSpeedValueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = Localizable.WindView.windSpeedTitle
        label.font = .preferredFont(forTextStyle: .caption1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
    }

    private func setupView() {
        containerStackView.addArrangedSubview(windDirectionImageView)
        containerStackView.addArrangedSubview(windSpeedValueLabel)
        addSubview(containerStackView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            windDirectionImageView.heightAnchor.constraint(equalToConstant: Constants.directionIconHeight),
        ])
    }

    public func configure(withViewModel viewModel: WindViewModel) {
        windSpeedValueLabel.text = viewModel.windSpeed
        windDirectionImageView.transform = CGAffineTransform(rotationAngle: CGFloat(viewModel.windDirection))
    }
}
