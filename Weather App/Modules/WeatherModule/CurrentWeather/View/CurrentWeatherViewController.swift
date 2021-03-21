//
//  CurrentWeatherViewController.swift
//  Weather App
//
//  Created by Radek Herold on 19.03.2021.
//

import UIKit
import RxSwift
import RxCocoa
import RxCoreLocation
import CoreLocation

class CurrentWeatherViewController: UIViewController {
    
    @IBOutlet weak var errorView: ErrorView!
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.refreshControl = UIRefreshControl()
            scrollView.refreshControl?.addTarget(
                self,
                action: #selector(handleRefreshControl),
                for: .valueChanged
            )
        }
    }
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var topDividerImageView: UIImageView!
    @IBOutlet weak var humidityImageView: UIImageView!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var precipitationImageView: UIImageView!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var pressureImageView: UIImageView!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windImageView: UIImageView!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var windDirectionImageView: UIImageView!
    @IBOutlet weak var windDirectionLabel: UILabel!
    @IBOutlet weak var bottomDividerImageView: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    
    private var router: WeatherRouter?
    private let viewModel: CurrentWeatherViewModel
    private let disposeBag = DisposeBag()
    private let manager: CLLocationManager
    
    init(viewModel: CurrentWeatherViewModel) {
        self.viewModel = viewModel
        self.manager = CLLocationManager()
        super.init(nibName: String(describing: CurrentWeatherViewController.self), bundle: nil)
        
        
        rx.viewDidLoad
            .bind(to: viewModel.didLoad)
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.requestWhenInUseAuthorization()
        router = WeatherRouter(vc: self)
        checkAuthorizationStatus()
        setupBinding()
    }
    
    private func checkAuthorizationStatus() {
        if manager.authorizationStatus == .denied {
            unautorized()
        }
    }
    
    private func hideUI(with error: Error) {
        hideScroll()
        errorView.setupError(with: error)
    }
    
    private func unautorized() {
        hideScroll()
        errorView.setupWarning()
    }
    
    private func hideScroll() {
        scrollView.isHidden = true
        errorView.isHidden = false
    }
    
    private func showUI(if hidden: Bool) {
        scrollView.isHidden = hidden
        errorView.isHidden = !hidden
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.conditionImageView.isHidden = hidden
            self.locationLabel.isHidden = hidden
            self.temperatureLabel.isHidden = hidden
            self.humidityLabel.isHidden = hidden
            self.precipitationLabel.isHidden = hidden
            self.pressureLabel.isHidden = hidden
            self.windLabel.isHidden = hidden
            self.windDirectionLabel.isHidden = hidden
            self.locationImageView.isHidden = hidden
            self.topDividerImageView.isHidden = hidden
            self.bottomDividerImageView.isHidden = hidden
            self.humidityImageView.isHidden = hidden
            self.precipitationImageView.isHidden = hidden
            self.pressureImageView.isHidden = hidden
            self.windImageView.isHidden = hidden
            self.windDirectionImageView.isHidden = hidden
            self.shareButton.isHidden = hidden
        })
    }
    
    @objc private func handleRefreshControl() {
        updateLocation()
        DispatchQueue.main.async { [weak self] in
            self?.scrollView.refreshControl?.endRefreshing()
        }
    }
    
    private func updateLocation() {
        manager.startUpdatingLocation()
    }
    
    private func setupBinding() {
        
        shareButton.rx.tap
            .bind(to: viewModel.shareButtonPressed)
            .disposed(by: disposeBag)
        
        errorView.tryAgainButtonPressed
            .bind(to: viewModel.tryAgainButtonPressed)
            .disposed(by: disposeBag)
        
        errorView.settingsButtonPressed
            .bind(to: viewModel.settingsButtonPressed)
            .disposed(by: disposeBag)
        
        viewModel.authDenied
            .drive(onNext: { [weak self] in
                self?.unautorized()
            }).disposed(by: disposeBag)
        
        viewModel.show
            .drive(onNext: { [weak self] in
                self?.showUI(if: $0)
            }).disposed(by: disposeBag)
        
        viewModel.disableTracking
            .drive(onNext: { [weak self] in
                self?.manager.stopUpdatingLocation()
            }).disposed(by: disposeBag)
        
        viewModel.tryAgain
            .drive(onNext: { [weak self] in
                self?.updateLocation()
            }).disposed(by: disposeBag)
        
        viewModel.hide
            .drive(onNext: { [weak self] in
                self?.hideUI(with: $0)
            }).disposed(by: disposeBag)
        
        viewModel.humidity
            .drive(humidityLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.pressure
            .drive(pressureLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.windDirection
            .drive(windDirectionLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.windSpeed
            .drive(windLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.precipitation
            .drive(precipitationLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.city
            .drive(locationLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.icon
            .drive(conditionImageView.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.conditionsText
            .drive(temperatureLabel.rx.text)
            .disposed(by: disposeBag)
        
        manager.rx.location
            .bind(to: viewModel.location)
            .disposed(by: disposeBag)
        
        manager.rx.didChangeAuthorization
            .bind(to: viewModel.authorizationState)
            .disposed(by: disposeBag)
        
        viewModel.title
            .drive(rx.title)
            .disposed(by: disposeBag)
        
        viewModel.showAllert
            .drive(onNext: {[weak self] _ in self?.router?.showAlert()})
            .disposed(by: disposeBag)
        
        viewModel.showSettings
            .drive(onNext: {[weak self] _ in self?.router?.showSettings()})
            .disposed(by: disposeBag)
        
        viewModel.share
            .drive(onNext: {[weak self] message in self?.router?.share(message: message)})
            .disposed(by: disposeBag)
        
        ProgressHud.rx
            .observe(status: viewModel.hud)
            .disposed(by: disposeBag)
        
    }
}
