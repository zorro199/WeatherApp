//
//  WeatherPresenter.swift
//  Weather
//
//  Created by Zaur on 11.12.2022.
//

import Foundation

protocol WeatherViewProtocol: AnyObject {
}

protocol WeatherViewPresnterProtocol: AnyObject {
    init(view: WeatherViewController)
    func showCountry(with view: WeatherViewController)
}

class WeatherPresenter: WeatherViewPresnterProtocol {
 
    private var timer: Timer?
    let network = NetworkDataFetcher()
    
    weak var view: WeatherViewProtocol?
    
    required init(view: WeatherViewController) {
        self.view = view
    }
    
    func showCountry(with view: WeatherViewController) {
        guard let city = view.searchTextField.text else { return }
        view.spinner.startAnimating()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            self.network.fetchCity(searchCity: city) { model in
                guard let data = model else { return }
                view.spinner.stopAnimating()
                let temp = Int(data.current?.temp_c ?? 0)
                view.showCountryLabel.text = data.location?.country
                view.showRegionLabel.text = data.location?.region
                view.showCityLabel.text = data.location?.name
                view.showTempLabel.text = String(temp)
                view.descriptionWeatherLabel.text = data.current?.condition?.text
                view.lastUpdatedWeatherLabel.text = data.current?.last_updated
                guard let weatherIcon = model?.current?.condition?.icon, let urlIcon = URL(string: weatherIcon) else { return }
                view.iconWeatherImageView.sd_setImage(with: urlIcon, completed: nil)
            }
        })
    }
}




