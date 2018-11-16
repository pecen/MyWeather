//
//  Conversions.swift
//  MyWeather
//
//  Created by Peter Centellini on 2018-11-16.
//  Copyright © 2018 redesajn interactive solutions ab. All rights reserved.
//

import Foundation

extension Double {
    
    func celsiusToFahrenheit() -> Double {
        let t = self * 9 / 5 + 32
        return t
    }
    
    func fahrenheitToCelsius() -> Double {
        let t = (self - 32) * 5 / 9
        return t
    }
}
