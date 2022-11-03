//
//  ViewController.swift
//  currency converter
//
//  Created by aycan duskun on 28.10.2022.
//

import UIKit

let currencyArray = ["EUR", "USD", "TRY", "GBP", "JPY", "CAD", "AUD", "BGN", "RUB", "NOK", "CNY", "CHF", "MXN"]



class ViewController: UIViewController {

    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var amountText: UITextField!
   @IBOutlet weak var picker: UIPickerView!
   
    var currencyManager = CurrencyManager()
    
    var from: Int = 0
    var to: Int = 0
    var amount: String = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        picker.dataSource = self
        amountText.delegate = self
        currencyManager.delegate = self
       
        
    }
   
    @IBAction func calculateTapped(_ sender: UIButton) {
        amountText.endEditing(true)
        currencyManager.fetchRates(from: currencyArray[from], to: currencyArray[to], amount: amount )
        
       
    }
    
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        from = pickerView.selectedRow(inComponent: 0)
        to = pickerView.selectedRow(inComponent: 1)
        
        
        print(currencyArray[from])
        print(currencyArray[to])
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        amountText.endEditing(true)
        currencyManager.fetchRates(from: currencyArray[from], to: currencyArray[to], amount: amount )
        
        
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            amountText.placeholder = "Enter an amount"
            return false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        amount = amountText.text!
        amountText.text = ""
    }
}

extension ViewController: CurrencyManagerDelegate {
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
    func didUpdateCurrency(_ currencyManager: String) {
      
        DispatchQueue.main.async {
      
            self.resultLabel.text = currencyManager
        }
    }
}
    
