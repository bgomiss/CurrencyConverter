//
//  CurrencySelectorViewController.swift
//  currency converter
//
//  Created by aycan duskun on 26.11.2022.
//

import UIKit

protocol FromCurrencySelectorDelegate: AnyObject {
    func didGetCurrencyCode(from: String)
    
}
protocol ToCurrencySelectorDelegate: AnyObject {
    func didGetCurrencyCode(to: String)
}
class CurrencySelectorViewController: UIViewController {
    
    weak var fromCurrencySelection: FromCurrencySelectorDelegate!
    weak var toCurrencySelection: ToCurrencySelectorDelegate!
    
    let reusableCell = "ReusableCell"
    
    let currencyArray = ["EUR", "USD", "TRY", "GBP", "JPY", "CAD", "AUD", "BGN", "RUB", "NOK", "CNY", "CHF", "MXN"]
    
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension CurrencySelectorViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableCell, for: indexPath)
        cell.textLabel?.text = currencyArray[indexPath.row]
        return cell
    }
    
    
}

extension CurrencySelectorViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if fromCurrencySelection != nil {
            
            fromCurrencySelection.didGetCurrencyCode(from: currencyArray[indexPath.row])
            
        } else {
            
            toCurrencySelection.didGetCurrencyCode(to: currencyArray[indexPath.row])
            
        }
        dismiss(animated: true, completion: nil)
    }
}
