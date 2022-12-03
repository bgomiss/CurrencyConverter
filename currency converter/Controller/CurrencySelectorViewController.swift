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
    
    let currencyArray = ["🇪🇺  EUR", "\u{1F1FA}\u{1F1F8}  USD", "\u{1F1F9}\u{1F1F7}  TRY", "\u{1F1EC}\u{1F1E7}  GBP", "\u{1F1EF}\u{1F1F5}  JPY", "\u{1F1E8}\u{1F1E6}  CAD", "\u{1F1E6}\u{1F1FA}  AUD", "\u{1F1E7}\u{1F1EC}  BGN", "\u{1F1F7}\u{1F1FA}  RUB", "\u{1F1F3}\u{1F1F4}  NOK", "\u{1F1E8}\u{1F1F3}  CNY", "\u{1F1E8}\u{1F1ED}  CHF", "\u{1F1F2}\u{1F1FD}  MXN"]
    
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
        cell.textLabel?.text = filteredData[indexPath.row]
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
