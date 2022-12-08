//
//  CurrencySelectorViewController.swift
//  currency converter
//
//  Created by aycan duskun on 26.11.2022.
//

import UIKit

protocol FromCurrencySelectorDelegate: AnyObject {
    func didGetCurrencyCode(from: String, fromImage: String)
    
}
protocol ToCurrencySelectorDelegate: AnyObject {
    func didGetCurrencyCode(to: String, toImage: String)
}
class CurrencySelectorViewController: UIViewController {
    
    weak var fromCurrencySelection: FromCurrencySelectorDelegate!
    weak var toCurrencySelection: ToCurrencySelectorDelegate!
    
    let reusableCell = "ReusableCell"
    
    let currencyArray = ["EUR", "USD", "TRY", "GBP", "JPY", "CAD", "AUD", "BGN", "RUB", "NOK", "CNY", "CHF", "MXN"]
    
    let extraInfoArray: [String] = ["EURO", "American Dollar", "Turkish Lira","British Pound","Japanese Yen","Canadian Dollar","Australian Dollar","Bulgarian Lev","Russian Ruble","Norwegian Krone","Chinese Yuan","Swiss Franc", "Mexican Peso"]
    
    let flagsArray = ["🇪🇺", "🇺🇸", "🇹🇷", "🇬🇧", "🇯🇵", "🇨🇦", "🇦🇺", "🇧🇬", "🇷🇺", "🇳🇴", "🇨🇳", "🇨🇭", "🇲🇽"]
    
    var filteredData: [String]!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        filteredData = currencyArray
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension CurrencySelectorViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableCell, for: indexPath)
        cell.textLabel?.text = "\(flagsArray[indexPath.row]) \(filteredData[indexPath.row]) \(extraInfoArray[indexPath.row])"
        //cell.textLabel?.text = filteredData[indexPath.row]
        return cell
    }
    
    
}

extension CurrencySelectorViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if fromCurrencySelection != nil {
            
            fromCurrencySelection.didGetCurrencyCode(from: currencyArray[indexPath.row], fromImage: flagsArray[indexPath.row])
            
        } else {
            
            toCurrencySelection.didGetCurrencyCode(to: currencyArray[indexPath.row], toImage: flagsArray[indexPath.row])
            
        }
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - Search Bar Methods
extension CurrencySelectorViewController: UISearchBarDelegate {
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredData = []
        
        if searchText == "" {
            filteredData = currencyArray
        }
        
        for word in currencyArray {
            if word.uppercased().contains(searchText.uppercased()) {
                filteredData.append(word)
            }
            }
        self.tableView.reloadData()
        }
        
    }
