//
//  ForecastWeatherViewController.swift
//  Weather App
//
//  Created by Radek Herold on 19.03.2021.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxCoreLocation
import CoreLocation

class ForecastWeatherViewController: UIViewController {
    
    private struct Cells {
        static let forecastCell = ReusableCell<ForecastTableViewCell>(nibName: "ForecastTableViewCell")
        static let sectionCell = ReusableCell<SectionTableViewCell>(nibName: "SectionTableViewCell")
    }
    
    @IBOutlet weak var errorView: ErrorView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.refreshControl = UIRefreshControl()
            tableView.refreshControl?.addTarget(
                self,
                action: #selector(handleRefreshControl),
                for: .valueChanged
            )
            
            tableView.register(Cells.forecastCell)
            tableView.register(Cells.sectionCell)
            tableView.tableFooterView = UIView()
            
            viewModel
                .sections
                .drive(tableView.rx.items(dataSource: dataSource))
                .disposed(by: disposeBag)
        }
    }
    
    private var router: WeatherRouter?
    
    private let viewModel: ForecastWeatherViewModel
    private let disposeBag = DisposeBag()
    private let manager: CLLocationManager
    private let dataSource: RxTableViewSectionedReloadDataSource<ForecastWeatherViewModel.Sections>
    
    init(viewModel: ForecastWeatherViewModel) {
        self.viewModel = viewModel
        self.manager = CLLocationManager()
        self.dataSource = .init(configureCell: { (ds, tableView, indexPath, item) -> UITableViewCell in
            switch ds[indexPath] {
            case .daySection(let dto):
                let cell = tableView.dequeue(Cells.sectionCell, for: indexPath)
                cell.setupUI(with: dto.title)
                return cell
            case .weatherItem(let item):
                let cell = tableView.dequeue(Cells.forecastCell, for: indexPath)
                cell.setupUI(with: item)
                return cell
            }
        })
        super.init(nibName: String(describing: ForecastWeatherViewController.self), bundle: nil)
        
        rx.viewDidLoad
            .bind(to: viewModel.didLoad)
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkAuthorizationStatus()
        router = WeatherRouter(vc: self)
        setupBinding()
    }
    
    @objc private func handleRefreshControl() {
        manager.startUpdatingLocation()
        DispatchQueue.main.async { [weak self] in
            self?.tableView.refreshControl?.endRefreshing()
        }
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
        tableView.isHidden = true
        errorView.isHidden = false
    }
    
    private func showUI(if hidden: Bool) {
        tableView.isHidden = hidden
        errorView.isHidden = !hidden
    }
    
    private func updateLocation() {
        manager.startUpdatingLocation()
    }
    
    private func setupBinding() {
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
        
        manager.rx.didChangeAuthorization
            .bind(to: viewModel.authorizationState)
            .disposed(by: disposeBag)
        
        manager.rx.location
            .bind(to: viewModel.location)
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
        
         ProgressHud.rx
         .observe(status: viewModel.hud)
         .disposed(by: disposeBag)
    }
}
