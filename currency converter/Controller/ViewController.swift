//
//  ViewController.swift
//  currency converter
//
//  Created by aycan duskun on 28.10.2022.
//

import UIKit


class ViewController: UIViewController {
  

    
    @IBOutlet weak var amountText: UITextField!
    
    @IBOutlet weak var amountText2: UITextField!
    
    @IBOutlet weak var fromLabel: UILabel!
    
    @IBOutlet weak var fromImage: UIImageView!
    
    @IBOutlet weak var toImage: UIImageView!
    
    @IBOutlet weak var toLabel: UILabel!
    
    
    
    
    var currencyManager = CurrencyManager()
    //var currencySelector = CurrencySelectorViewController()
    
    var from: Int = 0
    var to: Int = 0
    var amount: String = "0"
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*picker.isHidden = true
        picker.delegate = self
        picker.dataSource = self
        amountText.delegate = self
        currencyManager.delegate = self*/
        
        
    }
    
    /*@IBAction func calculateTapped(_ sender: UIButton) {
        amountText.endEditing(true)
        currencyManager.fetchRates(from: currencyArray[from], to: currencyArray[to], amount: amount )
        
        
    }*/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let currencySelectorViewController = segue.destination as? CurrencySelectorViewController {
                if let sender = sender as? Int {
                  if sender == 1 {
                currencySelectorViewController.fromCurrencySelection = self
                 } else {
                currencySelectorViewController.toCurrencySelection = self
                  }
                }
            }
        }
    
    @IBAction func didTapView(_ sender: UITapGestureRecognizer) {
    
        performSegue(withIdentifier: "currencySelector", sender: 1)
    }
    @IBAction func didTapView2(_ sender: UITapGestureRecognizer) {
       
        performSegue(withIdentifier: "currencySelector", sender: 2)
        
    }
    
    /*extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
     
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
     
     }*/
}
extension ViewController: FromCurrencySelectorDelegate, ToCurrencySelectorDelegate {
    func didGetCurrencyCode(from: String) {
        fromLabel.text = from
        }
    func didGetCurrencyCode(to: String) {
        toLabel.text = to
    }
}

