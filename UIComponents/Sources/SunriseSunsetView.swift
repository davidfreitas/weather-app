//
//  SunriseSunsetView.swift
//  UIComponents
//
//  Created by David Freitas on 13/10/20.
//  Copyright © 2020 SHAPE A/S. All rights reserved.
//

import UIKit

public struct SunriseSunsetViewModel {
    let sunriseTime: String
    let sunsetTime: String

    public init(sunriseTime: String, sunsetTime: String) {
        self.sunriseTime = sunriseTime
        self.sunsetTime = sunsetTime
    }
}

public final class SunriseSunsetView: UIView {
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let sunriseStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let sunsetStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let sunriseImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "sunrise")
        view.tintColor = .orange
        view.contentMode = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let sunriseTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = Localizable.SunrireSunsetView.sunriseTitle
        label.font = .preferredFont(forTextStyle: .caption2)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let sunriseTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .caption1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let sunsetImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "sunset")
        view.tintColor = .orange
        view.contentMode = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let sunsetTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = Localizable.SunrireSunsetView.sunsetTitle
        label.font = .preferredFont(forTextStyle: .caption2)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let sunsetTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
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
        sunriseStackView.addArrangedSubview(sunriseImageView)
        sunriseStackView.addArrangedSubview(sunriseTitleLabel)
        sunriseStackView.addArrangedSubview(sunriseTimeLabel)
        sunsetStackView.addArrangedSubview(sunsetImageView)
        sunsetStackView.addArrangedSubview(sunsetTitleLabel)
        sunsetStackView.addArrangedSubview(sunsetTimeLabel)
        containerStackView.addArrangedSubview(sunriseStackView)
        containerStackView.addArrangedSubview(sunsetStackView)
        addSubview(containerStackView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }

    public func configure(withViewModel viewModel: SunriseSunsetViewModel) {
        sunriseTimeLabel.text = viewModel.sunriseTime
        sunsetTimeLabel.text = viewModel.sunsetTime
    }
}
