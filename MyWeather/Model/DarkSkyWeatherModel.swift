//
//  DarkSkyWeatherModel.swift
//  MyWeather
//
//  Created by Peter Centellini on 2018-12-08.
//  Copyright © 2018 Redesajn Interactive Solutions. All rights reserved.
//

import Foundation

class DarkSkyWeatherDataModel {
    
    //Declare your model variables here
    var temperature : Double = 0
    var dewPoint : Double = 0
    var conditionCode : Int = 0
    var conditionText : String = ""
    var city : String = ""
    var country : String = ""
    var weatherIconName : String = ""
    var pressure : Int = 0
    var windDeg : Int = 0
    var windSpeed : Int = 0
    var humidity : Int = 0
    var cloudPercentage : Int = 0
    var visibility : Int = 0
    var sunrise : String = ""
    var sunset : String = ""
    var latitude : Double = 0
    var longitude : Double = 0
    var timeOfDataCalc : String = ""

    var hasData : Bool = false
    var isCelsius = true
    
}
