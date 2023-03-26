//
//  Extension+Subviews.swift
//  Weather
//
//  Created by Zaur on 10.12.2022.
//

import Foundation
import UIKit

extension UIView {
    func addSubviews(_ view: UIView...) {
        view.forEach { addSubview($0) }
    }
    
    func addSubviews(_ view: [UIView]) {
        view.forEach { addSubview($0) }
    }
}
