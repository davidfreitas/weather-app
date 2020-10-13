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

    private struct Constants {
        static let backgroundColor: UIColor = .systemBackground
        static let padding: CGFloat = 32
        static let animationDuration: TimeInterval = 0.3

        struct BackgroundImage {
            static let multiplier: CGFloat = 0.85
        }

        struct Title {
            static let spacing: CGFloat = 10
        }

        struct CloseButton {
            static let size: CGSize = CGSize(width: 44, height: 44)
        }

        struct ForecastCell {
            static let reuseIdentifier: String = "ForecastCell"
            static let size: CGSize = CGSize(width: 120, height: 240)
            static let spacing: CGFloat = 10
        }

        struct StackView {
            static let spacing: CGFloat = 20
        }
    }

    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "cloud.fill")
        imageView.tintColor = .secondaryBackground
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let disclaimarerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.textAlignment = .center
        label.text = Localizable.LocationDetails.disclaimer
        label.font = UIFont.systemFont(ofSize: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.isHidden = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alpha = 0
        scrollView.isHidden = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.StackView.spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Constants.StackView.spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .systemGray2
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(closeButtonTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let cityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let forecastTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Localizable.LocationDetails.fiveDayForecastTitle
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = Constants.ForecastCell.size
        layout.minimumLineSpacing = Constants.ForecastCell.spacing
        layout.minimumInteritemSpacing = Constants.ForecastCell.spacing

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ForecastCollectionViewCell.self, forCellWithReuseIdentifier: Constants.ForecastCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    private lazy var sunriseSunsetView: SunriseSunsetView = {
        let view = SunriseSunsetView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var output: LocationDetailsViewControllerOutput!
    private var viewModel: LocationDetailsViewModel? {
        didSet {
            populateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        output.viewIsReady()
    }

    private func setupView() {
        view.backgroundColor = Constants.backgroundColor
        titleStackView.addArrangedSubview(cityLabel)
        titleStackView.addArrangedSubview(closeButton)
        stackView.addArrangedSubview(titleStackView)
        stackView.addArrangedSubview(forecastTitleLabel)
        stackView.addArrangedSubview(collectionView)
        stackView.addArrangedSubview(sunriseSunsetView)
        scrollView.addSubview(stackView)
        view.addSubview(backgroundImageView)
        view.addSubview(scrollView)
        view.addSubview(activityIndicator)
        view.addSubview(disclaimarerLabel)
        cityLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        cityLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Constants.BackgroundImage.multiplier),
            backgroundImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: Constants.BackgroundImage.multiplier),
            backgroundImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            backgroundImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: Constants.CloseButton.size.width),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: Constants.padding),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -Constants.padding),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Constants.padding),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -Constants.padding),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: Constants.padding * -2),
            collectionView.heightAnchor.constraint(equalToConstant: Constants.ForecastCell.size.height),
            disclaimarerLabel.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: Constants.StackView.spacing),
            disclaimarerLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.padding),
            disclaimarerLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            disclaimarerLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }

    private func populateViews() {
        guard let viewModel = viewModel else { return }
        cityLabel.text = viewModel.city
        sunriseSunsetView.configure(withViewModel: viewModel.sunriseSunsetViewModel)
        collectionView.reloadData()
    }

    @objc
    private func closeButtonTapped(_ sender: UIButton) {
        output.backButtonTapped()
    }
}

extension LocationDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.forecastList.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let viewModel = viewModel,
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.ForecastCell.reuseIdentifier,
                                                            for: indexPath) as? ForecastCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.configure(withViewModel: viewModel.forecastCellViewModel(forCellAtIndexPath: indexPath))
        return cell
    }
}

extension LocationDetailsViewController: LocationDetailsPresenterOutput {
    func presentLoadingState() {
        scrollView.isHidden = true
        scrollView.alpha = 0
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    func dismissLoadingState() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        scrollView.isHidden = false
        UIView.animate(withDuration: Constants.animationDuration) {
            self.scrollView.alpha = 1
        }
    }

    func presentForecast(_ viewModel: LocationDetailsViewModel) {
        self.viewModel = viewModel
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
