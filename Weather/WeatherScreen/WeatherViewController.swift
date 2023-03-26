//
//  WeatherViewController.swift
//  Weather
//
//  Created by Zaur on 07.12.2022.
//

import UIKit
import SnapKit
import SDWebImage

class WeatherViewController: UIViewController {
    
    var presenter: WeatherViewPresnterProtocol!
    let network = NetworkDataFetcher()
    private var timer: Timer?
    
    lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mainImage")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // search view
    lazy var searchView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.placeholder = "Enter a city in English .."
        //textField.addTarget(self, action: #selector(searchCity), for: .editingChanged)
        return textField
    }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "searchIcon")
        button.setBackgroundImage(image, for: .normal)
        button.addTarget(self, action: #selector(showCity), for: .touchUpInside)
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "cancelIcon")
        button.setBackgroundImage(image, for: .normal)
        button.addTarget(self, action: #selector(clearSearchText), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    // labels to display region
    lazy var showCountryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 40)
        label.textAlignment = .center
        label.text = "-"
        return label
    }()
    
    lazy var showRegionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 30)
        label.textAlignment = .center
        label.text = "-"
        return label
    }()
    
    lazy var showCityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 25)
        label.textAlignment = .center
        label.text = "-"
        return label
    }()
    
    // labels to display temp
    lazy var tempView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    lazy var showTempLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 35)
        label.textAlignment = .center
        label.text = "-"
        return label
    }()
    
    lazy var iconCelsiusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "celsius")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var iconWeatherImageView: UIImageView = {
        let imageView = UIImageView()
        //imageView.image = UIImage(named: "cancel")
        //imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // weather description and last updated
    lazy var descriptionWeatherLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.text = "-"
        return label
    }()
    
    lazy var lastUpdatedWeatherLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.text = "-"
        return label
    }()
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        hideKeyboard()
        searchTextFieldAction(#selector(searchCity), with: self)
    }
    
    //MARK: - Hide keyboard setting
    
    private func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleHideKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    // handlres
    @objc private func handleHideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func clearSearchText() {
        self.searchTextField.text = ""
    }
    
    @objc func showCity() {

    }
    
    //MARK: - setting views
    
    private func addViews() {
        view.addSubviews([backgroundImageView, searchView,
                          showCountryLabel, showRegionLabel,
                          showCityLabel, tempView, spinner,
                          descriptionWeatherLabel, lastUpdatedWeatherLabel, iconWeatherImageView])
        searchView.addSubviews([searchTextField, searchButton, cancelButton])
        tempView.addSubviews([showTempLabel, iconCelsiusImageView])
        setLayout()
    }
    
    private func setLayout() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        // searchView
        searchView.snp.makeConstraints {
            $0.top.equalTo(100)
            $0.height.equalTo(40)
            $0.leading.equalTo(30)
            $0.trailing.equalTo(-30)
        }
        searchTextField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(40)
            $0.trailing.equalTo(-40)
        }
        searchButton.snp.makeConstraints {
            $0.top.equalTo(5)
            $0.leading.equalTo(5)
            $0.height.width.equalTo(30)
        }
        cancelButton.snp.makeConstraints {
            $0.trailing.equalTo(-10)
            $0.centerY.equalToSuperview()
            $0.height.width.equalTo(20)
        }
        // labels search
        showCountryLabel.snp.makeConstraints {
            $0.top.equalTo(searchView.snp.bottom).offset(50)
            $0.leading.equalTo(10)
            $0.trailing.equalTo(-10)
            $0.height.equalTo(50)
        }
        showRegionLabel.snp.makeConstraints {
            $0.top.equalTo(showCountryLabel.snp.bottom).offset(10)
            $0.leading.equalTo(10)
            $0.trailing.equalTo(-10)
            $0.height.equalTo(40)
        }
        showCityLabel.snp.makeConstraints {
            $0.top.equalTo(showRegionLabel.snp.bottom).offset(10)
            $0.leading.equalTo(10)
            $0.trailing.equalTo(-10)
            $0.height.equalTo(40)
        }
        tempView.snp.makeConstraints {
            $0.top.equalTo(showCityLabel.snp.bottom).offset(100)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(40)
        }
        showTempLabel.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.width.equalTo(50)
        }
        iconCelsiusImageView.snp.makeConstraints {
            $0.leading.equalTo(showTempLabel.snp.trailing).offset(0)
            $0.trailing.equalToSuperview().offset(-5)
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(50)
        }
        iconWeatherImageView.snp.makeConstraints {
            $0.leading.equalTo(tempView.snp.trailing).offset(5)
            $0.top.equalTo(showCityLabel.snp.bottom).offset(100)
            $0.width.height.equalTo(50)
        }
        // description and last updated
        descriptionWeatherLabel.snp.makeConstraints {
            $0.top.equalTo(tempView.snp.bottom).offset(30)
            $0.leading.equalTo(10)
            $0.trailing.equalTo(-10)
        }
        lastUpdatedWeatherLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionWeatherLabel.snp.bottom).offset(30)
            $0.leading.equalTo(10)
            $0.trailing.equalTo(-10)
        }
        // spiner
        spinner.snp.makeConstraints {
            $0.top.equalTo(lastUpdatedWeatherLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(40)
        }
    }

}


// Editing search TextField
extension WeatherViewController: WeatherViewProtocol {
    
    func searchTextFieldAction(_ action: Selector, with target: Any?) {
        self.searchTextField.addTarget(target, action: action, for: .editingChanged)
    }
    
    @objc func searchCity() {
        presenter.showCountry(with: self)
    }
}


