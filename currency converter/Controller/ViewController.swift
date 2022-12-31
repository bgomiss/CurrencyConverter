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
    var entries = [ChartDataEntry]()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        lineChart.delegate = self
        amountText.delegate = self
        currencyManager.delegate = self
        updateChart()
        
        
       }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        lineChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 240)
        lineChart.center = view.center
        view.addSubview(lineChart)
       

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
       
       currencyManager.fetchRatesForTimeframe(from: from, to: to, startDate: startDatee, endDate: endDate)
      
        }
    
    
    @IBAction func amountChanged(_ sender: UITextField) {
        amount = sender.text!
        
        //amountText.endEditing(true)
        currencyManager.fetchRates(from: from, to: to, amount: amount )
        updateChart()
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
             
             let sortedRates = timeFrameRates.sorted(by: {$0 < $1})
             let keys = sortedRates.map({$0.key})
//             let keys = sortedRates.map {(self.formatter.date(from: $0.key)!.timeIntervalSince1970 as Double)}
             let values = sortedRates.map({$0.value})
             entries = []
             
             for item in 0..<keys.count {
                 entries.append(ChartDataEntry(x: Double(item), y: values[item]))
             }
             
             // format the values on the x-axis as a list of string values from the keys array
             lineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: keys)
             
             lineChart.xAxis.labelPosition = .bottom
             lineChart.xAxis.labelRotationAngle = 45
             lineChart.rightAxis.enabled = false
             lineChart.xAxis.labelCount = keys.count - 1
             lineChart.xAxis.drawGridLinesEnabled = true
             lineChart.leftAxis.drawGridLinesEnabled = false
             
            
             
             let set = LineChartDataSet(entries: entries, label: "Rates Chart")
              
             set.colors = ChartColorTemplates.liberty()
              
              let data = LineChartData(dataSet: set)
              lineChart.data = data
                 
//                 self.xAxis = timeFrameRates.map { ($0.key, $0.value) }
//
//                 self.entries = timeFrameRates.map { ChartDataEntry(x: self.formatter.date(from: $0.key)!.timeIntervalSince1970 as Double, y: $0.value) }
               
                 //print(self.xAxis!)
                 print(self.entries)
             DispatchQueue.main.async {
                 self.lineChart.notifyDataSetChanged()

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

    //#if canImport(SwiftUI) && DEBUG
    //import SwiftUI
    //struct UIViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {
    //    let viewController: ViewController
    //
    //    init(_ builder: @escaping () -> ViewController) {
    //        viewController = builder()
    //    }
    //
    //    // MARK: - UIViewControllerRepresentable
    //    func makeUIViewController(context: Context) -> ViewController {
    //        viewController
    //    }
    //
    //    func updateUIViewController(_ uiViewController: ViewController, context: UIViewControllerRepresentableContext<UIViewControllerPreview<ViewController>>) {
    //        return
    //    }
    //}
    //#endif
    //
    //#if canImport(SwiftUI) && DEBUG
    //import SwiftUI
    //
    //let deviceNames: [String] = [
    //    "iPhone SE",
    //    "iPhone 11 Pro Max",
    //    "iPhone 11",
    //    "iPad Pro (11-inch)"
    //]
    //
    //@available(iOS 13.0, *)
    //struct ViewController_Preview: PreviewProvider {
    //  static var previews: some View {
    //
    //      ForEach(deviceNames, id: \.self) { deviceName in
    //      UIViewControllerPreview {
    //        ViewController()
    //      }.previewDevice(PreviewDevice(rawValue: deviceName))
    //        .previewDisplayName(deviceName)
    //      }
    //      .previewDisplayName(/*@START_MENU_TOKEN@*/"Preview"/*@END_MENU_TOKEN@*/)
    //
    //
    //
    //  }
    //}
    //#endif
