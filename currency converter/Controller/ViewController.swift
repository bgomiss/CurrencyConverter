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
    
    
    var from: String = "EUR"
    var to: String = "TRY"
    var amount: String = "0"
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        amountText.delegate = self
        currencyManager.delegate = self
        
        
    }
    
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
    
    //amountText.addTarget(self, action: #selector(yourHandler(textField:)), for: //.editingChanged)

       // @objc final private func yourHandler(textField: UITextField) {
            //print("Text changed")
       // }
    
    @IBAction func editingChanged(_ sender: UITextField) {
        
        amount = sender.text!
        
        //amountText.endEditing(true)
        currencyManager.fetchRates(from: from, to: to, amount: amount )
    }
    
   //@IBAction func editingChanged2(_ sender: UITextField) {
   //    amount = sender.text!
   //
   //    //amountText.endEditing(true)
   //    currencyManager.fetchRates(from: to, to: from, amount: amount )
   // }
    
    @IBAction func didTapView(_ sender: UITapGestureRecognizer) {
        
        performSegue(withIdentifier: "currencySelector", sender: 1)
    }
    @IBAction func didTapView2(_ sender: UITapGestureRecognizer) {
        
        performSegue(withIdentifier: "currencySelector", sender: 2)
        
    }
}
    
extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        amountText.endEditing(true)
        // amountText2.endEditing(true)
        currencyManager.fetchRates(from: from, to: to, amount: amount )
        
        
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            amountText.placeholder = "Enter an amount"
            //amountText2.placeholder = "Enter an amount"
            return false
        }
    }
    // func textFieldDidEndEditing(_ textField: UITextField) {
    // amount = amountText.text!
    // //amount = amountText2.text!
    //
    // amountText.text = ""
    // //amountText2.text = ""
    // }
     }
    
    extension ViewController: CurrencyManagerDelegate {
        
        func didFailWithError(error: Error) {
            print(error)
        }
        
        
        func didUpdateCurrency(_ currencyManager: String) {
            
            DispatchQueue.main.async {
                
                self.amountText2.text = currencyManager
                    
               }
        }
    }
    
    
    
    extension ViewController: FromCurrencySelectorDelegate, ToCurrencySelectorDelegate {
        func didGetCurrencyCode(from: String) {
            fromLabel.text = from
            self.from = from
        }
        func didGetCurrencyCode(to: String) {
            toLabel.text = to
            self.to = to
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
         }*/
        
        
        /*@IBAction func calculateTapped(_ sender: UIButton) {
         amountText.endEditing(true)
         currencyManager.fetchRates(from: currencyArray[from], to: currencyArray[to], amount: amount )
         
         
         }*/
        
    }

