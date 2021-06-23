//
//  ConversionViewController.swift
//  WordTrotter2
//
//  Created by Dylan Welch on 4/9/20.
//  Copyright © 2020 Dylan Welch. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var celciusLabel: UILabel!
    @IBOutlet var textField: UITextField!
    
    var fahrenheitValue: Measurement<UnitTemperature>? {
        didSet {
            updateCelciusLabel()
        }
    }
    
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        let currentLocale = Locale.current
        let isMetric = currentLocale.usesMetricSystem
        let currencySymbol = currentLocale.currencySymbol
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    }()
    
    @IBAction func fahrenheitFieldEditingChanged(_ textField: UITextField) {
        if let text = textField.text, let number = numberFormatter.number(from: text) {
            fahrenheitValue = Measurement(value: number.doubleValue, unit: .fahrenheit)
        } else {
            fahrenheitValue = nil
        }
        
    }
    
    func updateCelciusLabel() {
        if let celciusValue = celciusValue {
            celciusLabel.text = numberFormatter.string(from: NSNumber(value: celciusValue.value))
        } else {
            celciusLabel.text = "???"
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("Current text: \(textField.text!)")
        print("Replacement text: <\(string)>", terminator: "")
    
        let allowedCharacterSet = CharacterSet(charactersIn: "0123456789.")
        let replacementStringCharacterSet = CharacterSet(charactersIn: string)
        if !replacementStringCharacterSet.isSubset(of: allowedCharacterSet) {
            print("Rejected (Invalid Character)")
            return false
        }
        
        let currentLocale = Locale.current
        let decimalSeperator = currentLocale.decimalSeparator ?? "."
        
        let existingTextHasDecimalSeparator = textField.text?.range(of: decimalSeperator)
        let replacementTextHasDecimalSeparator = string.range(of: decimalSeperator)

        if existingTextHasDecimalSeparator != nil, replacementTextHasDecimalSeparator != nil {
            if replacementTextHasDecimalSeparator != nil{
                print("Rejected (Already has decimal point)")
                return false
            }
            return false
        } else {
            return true
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ConversionViewController loaded its view.")
        
        updateCelciusLabel()
    }

    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
    
    var celciusValue: Measurement<UnitTemperature>? {
        if let fahrenheitValue = fahrenheitValue {
            return fahrenheitValue.converted(to: .celsius)
        } else {
            return nil
        }
    }
}
