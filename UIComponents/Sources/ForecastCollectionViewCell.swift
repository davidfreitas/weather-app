//
//  ForecastCollectionViewCell.swift
//  UIComponents
//
//  Created by David Freitas on 13/10/20.
//  Copyright © 2020 SHAPE A/S. All rights reserved.
//

import UIKit

public struct ForecastCollectionViewCellViewModel: Hashable {
    let dateTime: String
    let maximumTemperature: String
    let minimumTemperature: String
    let icon: String
    let windDirection: Float
    let windSpeed: String

    public init(dateTime: String,
                maximumTemperature: String,
                minimumTemperature: String,
                icon: String,
                windDirection: Float,
                windSpeed: String) {
        self.dateTime = dateTime
        self.maximumTemperature = maximumTemperature
        self.minimumTemperature = minimumTemperature
        self.icon = icon
        self.windDirection = windDirection
        self.windSpeed = windSpeed
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(dateTime)
    }

    public static func == (lhs: ForecastCollectionViewCellViewModel, rhs: ForecastCollectionViewCellViewModel) -> Bool {
        lhs.dateTime == rhs.dateTime
    }
}

final public class ForecastCollectionViewCell: UICollectionViewCell {

    private struct Constants {
        static let backgroundColor: UIColor = .secondaryBackground
        static let iconHeight: CGFloat = 60
        static let cornerRadius: CGFloat = 15
        static let horizontalPadding: CGFloat = 10
        static let verticalPadding: CGFloat = 20
        static let spacing: CGFloat = 10
        static let temperatureIconWidth: CGFloat = 45
    }

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let dateTimeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let maximumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "sun.max.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .orange
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let maximumTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let maximumStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let minimumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "snow")
        imageView.contentMode = .center
        imageView.tintColor = .cyan
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let minimumTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let minimumStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let windView: WindView = {
        let view = WindView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var iconDataTask: URLSessionDataTask?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
    }

    deinit {
        iconDataTask?.cancel()
    }

    private func setupView() {
        layer.cornerRadius = Constants.cornerRadius
        backgroundColor = Constants.backgroundColor
        maximumStackView.addArrangedSubview(maximumImageView)
        maximumStackView.addArrangedSubview(maximumTemperatureLabel)
        minimumStackView.addArrangedSubview(minimumImageView)
        minimumStackView.addArrangedSubview(minimumTemperatureLabel)
        stackView.addArrangedSubview(dateTimeLabel)
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(maximumStackView)
        stackView.addArrangedSubview(minimumStackView)
        stackView.addArrangedSubview(windView)
        contentView.addSubview(stackView)
        dateTimeLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.verticalPadding),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.verticalPadding),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
            iconImageView.heightAnchor.constraint(equalToConstant: Constants.iconHeight),
            maximumImageView.widthAnchor.constraint(equalToConstant: Constants.temperatureIconWidth),
            minimumImageView.widthAnchor.constraint(equalToConstant: Constants.temperatureIconWidth)
        ])
    }

    public func configure(withViewModel viewModel: ForecastCollectionViewCellViewModel) {
        dateTimeLabel.text = viewModel.dateTime
        maximumTemperatureLabel.text = viewModel.maximumTemperature
        minimumTemperatureLabel.text = viewModel.minimumTemperature

        iconImageView.image = nil
        iconDataTask?.cancel()
        iconDataTask = UIImage.owmImage(named: viewModel.icon) { [weak self] image in
            DispatchQueue.main.async {
                self?.iconImageView.image = image
            }
        }

        let windViewModel = WindViewModel(windDirection: viewModel.windDirection,
                                          windSpeed: viewModel.windSpeed)
        windView.configure(withViewModel: windViewModel)
    }
}
