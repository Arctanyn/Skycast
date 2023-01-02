//
//  ForecastView.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 31.12.2022.
//

import UIKit
import Combine

final class ForecastView: BaseView, ViewModelable {
    
    typealias ViewModel = ForecastViewViewModel
    
    var viewModel: ViewModel! {
        didSet {
            configureWeatherSegments()
            setBindings()
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Views
    
    private lazy var currentWeatherView = CurrentWeatherView()
    
    private lazy var weatherInfoSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.selectedSegmentTintColor = .systemBlue
        
        segmentedControl.setTitleTextAttributes([
            .foregroundColor: UIColor.systemBlue,
            .font: Resources.Fonts.system()
        ], for: .normal)
        
        segmentedControl.setTitleTextAttributes([
            .foregroundColor: Resources.Colors.background,
            .font: Resources.Fonts.system(weight: .medium)
        ], for: .selected)
        
        segmentedControl.addTarget(self, action: #selector(weatherSegmentDidChange), for: .valueChanged)
        
        return segmentedControl
    }()
    
    private lazy var weatherInfoCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        
        collectionView.register(
            WeatherDetailsCollectionViewCell.self,
            forCellWithReuseIdentifier: WeatherDetailsCollectionViewCell.identifier
        )
        
        collectionView.register(
            HourlyForecastCollectionViewCell.self,
            forCellWithReuseIdentifier: HourlyForecastCollectionViewCell.identifier
        )
        
        collectionView.register(
            DailyForecastCollectionViewCell.self,
            forCellWithReuseIdentifier: DailyForecastCollectionViewCell.identifier
        )
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsSelection = false
        collectionView.backgroundColor = Resources.Colors.secondaryBackground
        return collectionView
    }()
    
    private lazy var weatherDetailsVStack = UIStackView(
        axis: .vertical,
        spacing: 20,
        arrangedSubviews: [
            weatherInfoSegmentedControl
                .padded(insets: .init(top: 0, left: 20, bottom: 0, right: 20)),
            weatherInfoCollectionView
        ]
    )

    private lazy var mainVStack = UIStackView(
        axis: .vertical,
        spacing: 40,
        arrangedSubviews: [
            currentWeatherView
                .padded(insets: .init(top: 0, left: 20, bottom: 0, right: 20)),
            weatherDetailsVStack
        ]
    )
    
    //MARK: - Methods

    override func setupViews() {
        weatherInfoCollectionView.dataSource = self
        weatherInfoCollectionView.delegate = self
        
        addSubview(mainVStack, useAutoLayout: true)
    }
    
    override func constraintViews() {
        NSLayoutConstraint.activate([
            mainVStack.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            mainVStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainVStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainVStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

//MARK: - Actions

@objc private extension ForecastView {
    func weatherSegmentDidChange() {
        let seletedIndex = weatherInfoSegmentedControl.selectedSegmentIndex
        viewModel.segmentSelectionSubject.send(seletedIndex)
    }
}

//MARK: - Private methods

private extension ForecastView {
    func setBindings() {
        viewModel.weatherInfoSelectionPublisher
            .sink { [weak self] segment in
                self?.weatherInfoCollectionView.scrollToItem(at: IndexPath(item: segment.rawValue, section: 0), at: .centeredHorizontally, animated: true)
            }
            .store(in: &cancellables)
        
        viewModel.weatherUpdatesPublisher
            .sink { [weak self] in
                self?.updateUI()
            }
            .store(in: &cancellables)
    }
    
    func updateUI() {
        currentWeatherView.viewModel = viewModel.viewModelForCurrentWeather()
        weatherInfoCollectionView.reloadData()
    }
    
    func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.visibleItemsInvalidationHandler = { [weak self] visibleItems, point, _ in
            guard let index = visibleItems.last?.indexPath.row else { return }
            
            self?.weatherInfoSegmentedControl.selectedSegmentIndex = index
            self?.viewModel.weatherSegmentSelected(at: index)
        }
    
        
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func configureWeatherSegments() {
        weatherInfoSegmentedControl.removeAllSegments()
        
        viewModel.segmentsTitles.enumerated().forEach { index, segmentTitle in
            weatherInfoSegmentedControl.insertSegment(withTitle: segmentTitle, at: index, animated: false)
        }
        
        weatherInfoSegmentedControl.selectedSegmentIndex = viewModel.segmentSelectionSubject.value
    }
}

//MARK: - UICollectionViewDataSource & UICollectionViewDelegate

extension ForecastView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel != nil ? viewModel.numberOfItems : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let weatherSegment = viewModel.weatherSegmentForCell(at: indexPath)
        
        switch weatherSegment {
        case .details:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherDetailsCollectionViewCell.identifier, for: indexPath) as! WeatherDetailsCollectionViewCell
            cell.viewModel = viewModel.viewModelForWeatherDetailsCell()
            return cell
        case .hourly:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyForecastCollectionViewCell.identifier, for: indexPath) as! HourlyForecastCollectionViewCell
            cell.viewModel = viewModel.viewModelForHourlyForecastCell()
            return cell
        case .forecast:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DailyForecastCollectionViewCell.identifier, for: indexPath) as! DailyForecastCollectionViewCell
            cell.viewModel = viewModel.viewModelForDailyForecastCell()
            return cell
        }
    }
}
