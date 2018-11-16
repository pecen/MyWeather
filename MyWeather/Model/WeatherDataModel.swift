//
//  WeatherDataModel.swift
//  WeatherApp
//
//  Created by Peter Centellini on 2018-11-16
//  Copyright (c) 2018 redesajn interactive solutions ab. All rights reserved.
//

import UIKit

class WeatherDataModel {

    //Declare your model variables here
    var temperature : Double = 0
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
    
    //This method turns a condition code into the name of the weather condition image
    
    func updateWeatherIcon(conditionCode: Int) -> String {
        
    switch (conditionCode) {
    
        case 0...299 :
            return "tstorm1"
        
        //case 301...500 :
        case 300...501 :
            return "light_rain"
        
        case 502...599 :
            return "shower3"
        
        //case 600...700 :
        case 600...699 :
            return "snow4"
        
        case 701...771 :
            return "fog"
        
        case 772...799 :
            return "tstorm3"
        
        case 800 :
            return "sunny"
        
        case 801...804 :
            return "cloudy2"
        
        case 900...902, 905...1000  :
            return "tstorm3"
        
        case 903 :
            return "snow5"
        
        case 904 :
            return "sunny"
        
        default :
            return "dunno"
        }

    }
    
    func getWeatherInSwedish(conditionCode: Int) -> String {
        switch (conditionCode) {
        case 200:
            return "Åska med lätt regn"
        case 201:
            return "Åska med regn"
        case 202:
            return "Åska med kraftigt regn"
        case 210:
            return "Lätt åska"
        case 211:
            return "Åska"
        case 212:
            return "Kraftig åska"
        case 221:
            return "Utspridd åska"
        case 230:
            return "Åska med lätt duggregn"
        case 231:
            return "Åska med duggregn"
        case 232:
            return "Åska med kraftigt duggregn"
        case 300:
            return "Lågintensivt duggregn"
        case 301:
            return "Duggregn"
        case 302:
            return "Högintensivt duggregn"
        case 310:
            return "Lågintensivt duggregn"
        case 311:
            return "Duggregn"
        case 312:
            return "Högintensivt duggregn"
        case 313:
            return "Regnskurar och duggregn"
        case 314:
            return "Kraftiga regnskurar och duggregn"
        case 321:
            return "Skurar med duggregn"
        case 500:
            return "Lätt regn"
        case 501:
            return "Måttligt regn"
        case 502:
            return "Högintensivt regn"
        case 503:
            return "Mycket kraftigt regn"
        case 504:
            return "Extremt regn"
        case 511:
            return "Underkylt regn"
        case 520:
            return "Lågintensiva regnskurar"
        case 521:
            return "Regnskurar"
        case 522:
            return "Högintensiva regnskurar"
        case 531:
            return "Utspridda regnskurar"
        case 600:
            return "Lätt snöfall"
        case 601:
            return "Snöfall"
        case 602:
            return "Kraftigt snöfall"
        case 611:
            return "Snöblandat regn"
        case 612:
            return "Snöblandade regnskurar"
        case 615:
            return "Lätt regn och snö"
        case 616:
            return "Regn och snö"
        case 620:
            return "Lätta skurar med snö"
        case 621:
            return "Skurar med snö"
        case 622:
            return "Kraftiga skurar med snö"
        case 701:
            return "Dimma"
        case 711:
            return "Rök"
        case 721:
            return "Dis"
        case 731:
            return "Sand, dammvirvlar"
        case 741:
            return "Kraftig dimma"
        case 751:
            return "Sand"
        case 761:
            return "Damm"
        case 762:
            return "Vulkanisk aska"
        case 771:
            return "Vindbyar"
        case 781:
            return "Tornado"
        case 800:
            return "Klar himmel"
        case 801:
            return "Enstaka moln"
        case 802:
            return "Utspridda moln"
        case 803:
            return "Brutna moln"
        case 804:
            return "Mulet"
        default:
            return "?"
        }
    }
}
