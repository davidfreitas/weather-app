//
//  LocationDetailsView.swift
//  UIComponents
//
//  Created by David Freitas on 12/01/21.
//  Copyright © 2021 SHAPE A/S. All rights reserved.
//

import UIKit
import UIComponents

public class LocationDetailsView: UIView {

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

        struct SunriseSunsetView {
            static let height: CGFloat = 60
        }
    }

    enum Section {
        case main
    }

    typealias DataSource = UICollectionViewDiffableDataSource<Section, ForecastCollectionViewCellViewModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ForecastCollectionViewCellViewModel>

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
        layout.sectionInset = UIEdgeInsets(top: 0, left: Constants.padding, bottom: 0, right: Constants.padding)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ForecastCollectionViewCell.self, forCellWithReuseIdentifier: Constants.ForecastCell.reuseIdentifier)
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

    private lazy var forecastDataSource = makeForecastDataSource()

    var viewModel: LocationDetailsViewModel? {
        didSet {
            populateViews()
        }
    }

    var closeButtonHandler: (() -> Void)?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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

    @objc
    private func closeButtonTapped(_ sender: UIButton) {
        closeButtonHandler?()
    }

    private func populateViews() {
        guard let viewModel = viewModel else { return }
        cityLabel.text = viewModel.city
        sunriseSunsetView.configure(withViewModel: viewModel.sunriseSunsetViewModel)
        applyForecastSnapshot()
    }

    private func makeForecastDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, viewModel) -> UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: Constants.ForecastCell.reuseIdentifier,
                    for: indexPath) as? ForecastCollectionViewCell
                cell?.configure(withViewModel: viewModel)
                return cell
            })
        return dataSource
    }

    private func applyForecastSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel!.forecastCellViewModels())
        forecastDataSource.apply(snapshot)
    }

    private func setupView() {
        backgroundColor = Constants.backgroundColor
        titleStackView.addArrangedSubview(cityLabel)
        titleStackView.addArrangedSubview(closeButton)
        stackView.addArrangedSubview(titleStackView)
        stackView.addArrangedSubview(forecastTitleLabel)
        scrollView.addSubview(stackView)
        scrollView.addSubview(collectionView)
        scrollView.addSubview(sunriseSunsetView)
        addSubview(backgroundImageView)
        addSubview(scrollView)
        addSubview(activityIndicator)
        addSubview(disclaimarerLabel)
        cityLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        cityLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: Constants.BackgroundImage.multiplier),
            backgroundImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: Constants.BackgroundImage.multiplier),
            backgroundImageView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            backgroundImageView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: Constants.CloseButton.size.width),
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scrollView.widthAnchor.constraint(equalTo: widthAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: Constants.padding),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Constants.padding),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -Constants.padding),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: Constants.padding * -2),
            collectionView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: Constants.StackView.spacing),
            collectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: Constants.ForecastCell.size.height),
            sunriseSunsetView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: Constants.StackView.spacing),
            sunriseSunsetView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Constants.padding),
            sunriseSunsetView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -Constants.padding),
            sunriseSunsetView.heightAnchor.constraint(equalToConstant: Constants.SunriseSunsetView.height),
            disclaimarerLabel.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: Constants.StackView.spacing),
            disclaimarerLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -Constants.padding),
            disclaimarerLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            disclaimarerLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}
