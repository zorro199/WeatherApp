//
//  WeatherBuilder.swift
//  Weather
//
//  Created by Zaur on 11.12.2022.
//

import Foundation
import UIKit

protocol Builder {
    static func createWeatherModule() -> UIViewController
}

class WeatherBuilder: Builder {
    static func createWeatherModule() -> UIViewController {
        let view = WeatherViewController()
        let presenter = WeatherPresenter(view: view)
        view.presenter = presenter
        return view
    }
}

