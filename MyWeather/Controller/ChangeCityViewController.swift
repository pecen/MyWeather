//
//  ChangeCityViewController.swift
//  WeatherApp
//
//  Created by Peter Centellini on 2018-11-16.
//  Copyright (c) 2018 Redesajn Interactive Solutions. All rights reserved.
//

import UIKit


//Write the protocol declaration here:
protocol ChangeCityDelegate {
    func UserEnteredANewCityName(city: String)
}


class ChangeCityViewController: UIViewController {
    
    //Declare the delegate variable here:
    var delegate : ChangeCityDelegate?
    
    //This is the pre-linked IBOutlets to the text field:
    @IBOutlet weak var changeCityTextField: UITextField!
    
    override func viewDidLoad() {
        changeCityTextField.becomeFirstResponder()
        //changeCityTextField.addTarget(self, action: #selector(myTargetFunction), for: .touchDown)
        //changeCityTextField.addTarget(self, action: #selector(myTargetFunction(_:)), for: .editingChanged)
    }
    
    //This is the IBAction that gets called when the user taps on the "Get Weather" button:
    @IBAction func getWeatherPressed(_ sender: AnyObject) {
        
        
        //1 Get the city name the user entered in the text field
        let city = changeCityTextField.text!

        
        //2 If we have a delegate set, call the method userEnteredANewCityName
        delegate?.UserEnteredANewCityName(city: city)

        
        //3 dismiss the Change City View Controller to go back to the WeatherViewController
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
//    @objc func myTargetFunction() {
//        // user touch field
//        print("key pressed")
//    }

    //This is the IBAction that gets called when the user taps the back button. It dismisses the ChangeCityViewController.
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
