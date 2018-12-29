//
//  ViewController.swift
//  WeatherApp
//
//  Created by Peter Centellini on 2018-11-16.
//  Copyright (c) 2018 Redesajn Interactive Solutions. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import LatLongToTimezone
import SwiftyJSON

//import LatLongToTimezone
//import StringExtensions

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    //Constants
    // OpenWeatherMap
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "6d782de5b8f6e4993751482e1bbb8ce3"
    
    // DarkSky
    let WEATHER_URL2 = "https://api.darksky.net/forecast"
    let APP_ID2 = "54850b7eb2c2f396abe26747ba18d351"
    

    //TODO: Declare instance variables here
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    let darkSkyWeatherDataModel = DarkSkyWeatherDataModel()

    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var cloudsLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var longLabel: UILabel!
    @IBOutlet weak var timeOfDataCalcLabel: UILabel!
    
    @IBAction func WeatherUpdate(_ sender: Any) {
        setCurrentLocation()
    }
    
    @IBAction func changeTempUnit(_ sender: Any) {
        //let temp : String = String(describing: temperatureLabel.text!.removeTemperatureUnitFromString())
        let temp : String = String(describing: temperatureLabel.text!.dropLast())

        if temp.isNumeric() {
        //if (temperatureLabel.text?.removeLast2Chars().isNumeric())! {
            //weatherDataModel.temperature = Double(temp)!
            
            if weatherDataModel.isCelsius {
                weatherDataModel.isCelsius = false
                weatherDataModel.temperature = weatherDataModel.temperature.celsiusToFahrenheit()
                temperatureLabel.text = "\(Int(weatherDataModel.temperature))℉"
            }
            else {
                weatherDataModel.isCelsius = true
                weatherDataModel.temperature = weatherDataModel.temperature.fahrenheitToCelsius()
                temperatureLabel.text = "\(Int(weatherDataModel.temperature))℃"
           }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //TODO:Set up the location manager here.
        setCurrentLocation()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(AppInFocus ), name: UIApplication.willEnterForegroundNotification, object: nil)
     }

    @objc func AppInFocus() {
        setCurrentLocation()
    }
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    
    func getWeatherData(url: String, params: [String : String]){
        Alamofire.request(url, method: .get, parameters: params).responseJSON {
            response in
            if response.result.isSuccess{
                //print("Success! Got the weather data")
                //print(JSON(response.result.value as Any))
                
                let weatherJSON : JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
            }
            else {
                print("Error \(String(describing: response.result.error))")
                self.cityLabel.text = "Connection Issues"
            }
        }
        
    }
    
    func getDarkSkyWeatherData(url: String, params: [String : String]) {
        let requestUrl = url + "/" + APP_ID2 + "/" + params["lat"]! + "," + params["lon"]!
        Alamofire.request(requestUrl, method: .get).responseJSON { (response) in
            if response.result.isSuccess {
                print("Success from DarkSky!")
                print(JSON(response.result.value as Any))
                
                let weatherJSON : JSON = JSON(response.result.value!)
                self.updateDarkSkyWeatherData(json: weatherJSON)
            }
            else {
                print("Error \(String(describing: response.result.error))")
            }
        }


        //Alamofire.request(requestUrl, method: .get, parameters: params).responseJSON { (response) in
        //    if response.result.isSuccess {
        //        print("Success from DarkSky!")
        //        print(JSON(response.result.value as Any))
        //    }
        //    else {
        //        print("Error \(String(describing: response.result.error))")
        //    }
        //}
    }
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    
    //Write the updateWeatherData method here:
    func updateWeatherData(json : JSON){
        if let temperature = json["main"]["temp"].double {
            weatherDataModel.temperature = temperature // - 273.15)
            weatherDataModel.city = json["name"].stringValue
            weatherDataModel.country = json["sys"]["country"].stringValue
            weatherDataModel.conditionCode = json["weather"][0]["id"].intValue
            //weatherDataModel.conditionText = json["weather"][0]["description"].stringValue.firstUppercased //json["weather"][0]["main"].stringValue
            weatherDataModel.conditionText = weatherDataModel.getWeatherInSwedish(conditionCode: weatherDataModel.conditionCode)
            weatherDataModel.pressure = json["main"]["pressure"].intValue // Int(json["main"]["pressure"].doubleValue)
            weatherDataModel.windDeg = json["wind"]["deg"].intValue
            weatherDataModel.windSpeed = json["wind"]["speed"].intValue // Int(json["wind"]["speed"].doubleValue)
            weatherDataModel.humidity = json["main"]["humidity"].intValue
            weatherDataModel.cloudPercentage = json["clouds"]["all"].intValue
            weatherDataModel.visibility = json["visibility"].intValue
            
            //let unixTimeStamp = json["sys"]["sunrise"].stringValue
            //let myFloat = (unixTimeStamp as NSString).doubleValue
            //weatherDataModel.sunrise = unixTimeToDate(unixTime: myFloat)
            //weatherDataModel.sunset = json["sys"]["sunset"].doubleValue
            
            //let zone = weatherDataModel.city //json["sys"]["country"].stringValue
            //weatherDataModel.sunrise = unixTimeToDate(unixTime: json["sys"]["sunrise"].doubleValue, timeZone: zone)
            //weatherDataModel.sunset = unixTimeToDate(unixTime: json["sys"]["sunset"].doubleValue, timeZone: zone)
            
            let lat = json["coord"]["lat"].doubleValue
            let long = json["coord"]["lon"].doubleValue
            let location = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let timeZone = TimezoneMapper.latLngToTimezoneString(location)
            
            weatherDataModel.sunrise = unixTimeToDate(unixTime: json["sys"]["sunrise"].doubleValue, timeZone: timeZone)
            weatherDataModel.sunset = unixTimeToDate(unixTime: json["sys"]["sunset"].doubleValue, timeZone: timeZone)
            weatherDataModel.latitude = lat
            weatherDataModel.longitude = long
            
            //print(unixTimeToDate(unixTime: json["dt"].doubleValue, timeZone: timeZone))
            weatherDataModel.timeOfDataCalc = unixTimeToDate(unixTime: json["dt"].doubleValue, timeZone: timeZone)

            weatherDataModel.hasData = true
        }
        else {
            weatherDataModel.conditionCode = -1
            weatherDataModel.hasData = false
        }

        weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(conditionCode: weatherDataModel.conditionCode)
        self.updateUIWithWeatherData()
    }
    
    func updateDarkSkyWeatherData(json: JSON){
        if let temperature = json["currently"]["temperature"].double {
            darkSkyWeatherDataModel.temperature = temperature
        }
    }
    
    //MARK: - Converters
    /***************************************************************/


    func unixTimeToDate(unixTime : Double, timeZone : String) -> String {
        let date = Date(timeIntervalSince1970: unixTime)
        let dateFormatter = DateFormatter()
        //dateFormatter.timeZone = TimeZone(abbreviation: timeZone) // "GMT") //Set timezone that you want
        //dateFormatter.timeZone = TimeZone.knownTimeZoneIdentifiers.first(where: timeZone)
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "HH:mm" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        
        return strDate
    }
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    func updateUIWithWeatherData() {
        if weatherDataModel.hasData {
            conditionLabel.text = weatherDataModel.conditionText
            temperatureLabel.text = "\(Int(darkSkyWeatherDataModel.temperature))℃"
            cityLabel.text = "\(weatherDataModel.city), \(weatherDataModel.country)"
            pressureLabel.text = "\(weatherDataModel.pressure) hPa"
            windDirectionLabel.text = "\(weatherDataModel.windDeg)°"
            windSpeedLabel.text = "\(weatherDataModel.windSpeed) m/s"
            visibilityLabel.text = "Sikt: \(Double(weatherDataModel.visibility/1000)) km"
            humidityLabel.text = "Fuktighet: \(weatherDataModel.humidity)%"
            cloudsLabel.text = "Moln: \(weatherDataModel.cloudPercentage)%"
            sunriseLabel.text = "Soluppgång: \(weatherDataModel.sunrise)"
            sunsetLabel.text = "Solnedgång: \(weatherDataModel.sunset)"
            //localTimeLabel.text = "Lokal tid: \(weatherDataModel.localTime)"
            timeOfDataCalcLabel.text = "Tid för väderberäkning: \(weatherDataModel.timeOfDataCalc) lokal tid"
            
            var lat : String = "Lat: \(weatherDataModel.latitude)"
            var long : String = "Long: \(weatherDataModel.longitude)"
            
            if weatherDataModel.latitude > 0 {
                lat += " N"
            }
            else if weatherDataModel.latitude < 0 {
                lat += " S"
            }
            
            if weatherDataModel.longitude > 0 {
                long += " E"
            }
            else if weatherDataModel.longitude < 0 {
                long += " W"
            }
            
            latLabel.text = lat
            longLabel.text = long
        }
        else {
            conditionLabel.text = ""
            cityLabel.text = "Väder ej tillgängligt" // "Weather Unavailable"
            temperatureLabel.text = "--℃"
            pressureLabel.text = "-- hPa"
            windDirectionLabel.text = "--°"
            windSpeedLabel.text = "-- m/s"
            visibilityLabel.text = "Sikt: -- m"
            humidityLabel.text = "Fuktighet: --%"
            cloudsLabel.text = "Moln: --%"
            sunriseLabel.text = "Soluppgång: --:--"
            sunsetLabel.text = "Solnedgång: --:--"
            //localTimeLabel.text = "Lokal tid: --:--"
            timeOfDataCalcLabel.text = "Tid för väderberäkning: --:--"
            latLabel.text = "Lat: --.--"
            longLabel.text = "Long: --.--"
        }
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
    }
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        
        if(location.horizontalAccuracy > 0){
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            let long = String(location.coordinate.longitude)
            let lat = String(location.coordinate.latitude)
            
            let params : [String : String] = ["lat" : lat, "lon" : long, "units" : "metric", "appid" : APP_ID]
            
            getWeatherData(url: WEATHER_URL, params: params)
            
            let params2 : [String : String] = ["lat" : lat, "lon" : long, "units" : "metric", "appid" : APP_ID2]
            
            getDarkSkyWeatherData(url: WEATHER_URL2, params: params2)
        }
    }
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Plats otillgänglig" // "Location unavailable"
    }
    
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    func setCurrentLocation(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    //Write the userEnteredANewCityName Delegate method here:
    func UserEnteredANewCityName(city: String) {
        let params : [String : String] = ["q" : city, "units" : "metric", "appid" : APP_ID]
        
        getWeatherData(url: WEATHER_URL, params: params)
    }
    


    
    //Write the PrepareForSegue Method here
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            let destinationVC = segue.destination as! ChangeCityViewController
            destinationVC.delegate = self
        }
    }
    
    
    
    
}


