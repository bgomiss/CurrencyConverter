//
//  ViewController.swift
//  currency converter
//
//  Created by aycan duskun on 28.10.2022.
//

import UIKit
import Charts
import SwiftUI


class ViewController: UIViewController, ChartViewDelegate {
    
    
    
    @IBOutlet weak var amountText: UITextField!
    
    @IBOutlet weak var amountText2: UITextField!
    
    @IBOutlet weak var fromLabel: UILabel!
    
    @IBOutlet weak var fromImage: UILabel!
    
    @IBOutlet weak var toImage: UILabel!
    
    @IBOutlet weak var toLabel: UILabel!
    
    
   lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
        
    }()
   
 
    var lineChart = LineChartView()
    var currencyManager = CurrencyManager()
    
    
    var from: String = "EUR"
    var to: String = "TRY"
    var amount: String = "0"
    var result: ()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        updateChart()
        lineChart.delegate = self
        amountText.delegate = self
        currencyManager.delegate = self
       }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        lineChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 240)
        lineChart.center = view.center
        view.addSubview(lineChart)
       
       var entries = [ChartDataEntry]()
        
        for x in 0..<10 {
            
            entries.append(ChartDataEntry(x: Double(x), y: Double(x)))
        }
        
        let set = LineChartDataSet(entries: entries)
        
        set.colors = ChartColorTemplates.material()
        
        let data = LineChartData(dataSet: set)
        lineChart.data = data
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
    
    func updateChart () {
       
        let date = Date()
        let endDate = formatter.string(from: date)
        let startDate = Calendar.current.date(byAdding: .day, value: -9, to: date)
        let startDatee = formatter.string(from: startDate ?? Date())
        print(endDate)
        print(startDatee)
        result = currencyManager.fetchRatesForTimeframe(from: from, to: to, startDate: startDatee, endDate: endDate)
        }
    
    
    @IBAction func amountChanged(_ sender: UITextField) {
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
     //currencyManager.fetchRates(from: from, to: to, amount: amount)
         //updateChart()
     
     
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
         //amount = amountText.text!
         //amount = amountText2.text!
        
         amountText.text = ""
         //amountText2.text = ""
         }
          }
     
     extension ViewController: CurrencyManagerDelegate {
     
     func didFailWithError(error: Error) {
     print(error)
     }
         func didGetTimeframeRates(_ timeFrameRates: [String : Double]) {
             DispatchQueue.main.async {
             
             print(timeFrameRates)
             }
         }
     func didUpdateCurrency(_ currencyManager: String) {
     
     DispatchQueue.main.async {
     
     self.amountText2.text = currencyManager
     }
     }
     }
     
     

extension ViewController: FromCurrencySelectorDelegate, ToCurrencySelectorDelegate {
    func didGetCurrencyCode(from: String, fromImage: String) {
        fromLabel.text = from
        self.fromImage.text = fromImage
        self.from = from
        }
    func didGetCurrencyCode(to: String, toImage: String) {
        toLabel.text = to
        self.toImage.text = toImage
        self.to = to
    }
    
}

//struct ViewController_Previews: PreviewProvider {
//
//static var previews: some View {
//       return ViewController()
//    }
//
//    struct ContentView: UIViewControllerRepresentable {
//
//        func makeUIViewController(context: Context) -> ViewController {
//             ViewController()
//        }
//
//        func updateUIViewController(_ uiViewController: ViewController, context: Context) {
//
//        }
//    }
//}
