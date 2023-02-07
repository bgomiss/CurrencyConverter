//
//  ViewController.swift
//  currency converter
//
//  Created by aycan duskun on 28.10.2022.
//

import UIKit
import Charts



class ViewController: UIViewController, ChartViewDelegate {
   
    
    
    
    
    @IBOutlet weak var amountText: UITextField!
    
    @IBOutlet weak var amountText2: UITextField!
    
    @IBOutlet weak var fromLabel: UILabel!
    
    @IBOutlet weak var fromImage: UILabel!
    
    @IBOutlet weak var toImage: UILabel!
    
    @IBOutlet weak var toLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
   lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
        
    }()
   
    let fromDateLabel = UILabel()
    let toDateLabel = UILabel()
    let fromdatePicker = UIDatePicker()
    let todatePicker = UIDatePicker()
    var lineChart = LineChartView()
    var currencyManager = CurrencyManager()
    
    
    var from: String = "EUR"
    var to: String = "TRY"
    var amount: String = "0"
    var entries = [ChartDataEntry]()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        fromdatePicker.translatesAutoresizingMaskIntoConstraints = false
        todatePicker.translatesAutoresizingMaskIntoConstraints = false
        fromDateLabel.translatesAutoresizingMaskIntoConstraints = false
        toDateLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(fromdatePicker)
        view.addSubview(todatePicker)
        view.addSubview(fromDateLabel)
        view.addSubview(toDateLabel)
        view.addSubview(fromdatePicker)

        // Add constraints
        let fromHorizontalConstraint = NSLayoutConstraint(item: fromdatePicker, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: 100)
        let fromVerticalConstraint = NSLayoutConstraint(item: fromdatePicker, attribute: .centerY, relatedBy: .equal, toItem: amountText2, attribute: .centerY, multiplier: 1, constant: 120)

        let toHorizontalConstraint = NSLayoutConstraint(item: todatePicker, attribute: .left, relatedBy: .equal, toItem: fromdatePicker, attribute: .right, multiplier: 1, constant: 56)
        let toVerticalConstraint = NSLayoutConstraint(item: todatePicker, attribute: .centerY, relatedBy: .equal, toItem: fromdatePicker, attribute: .centerY, multiplier: 1, constant: 0)
        
        let fromDateLabelHorizontal = NSLayoutConstraint(item: fromDateLabel, attribute: .centerX, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: 100)
        let fromDateLabelVertical = NSLayoutConstraint(item: fromDateLabel, attribute: .centerY, relatedBy: .equal, toItem: amountText2, attribute: .centerY, multiplier: 1, constant: 80)
        
        let toDateLabelHorizontal = NSLayoutConstraint(item: toDateLabel, attribute: .left, relatedBy: .equal, toItem: fromDateLabel, attribute: .right, multiplier: 1, constant: 20)
        let toDateLabelVertical = NSLayoutConstraint(item: toDateLabel, attribute: .centerY, relatedBy: .equal, toItem: amountText2, attribute: .centerY, multiplier: 1, constant: 80)
        
        view.addConstraints([fromHorizontalConstraint, fromVerticalConstraint, toVerticalConstraint, toHorizontalConstraint, fromDateLabelHorizontal, fromDateLabelVertical, toDateLabelHorizontal, toDateLabelVertical])
        
        fromdatePicker.locale = .autoupdatingCurrent
        todatePicker.locale = .autoupdatingCurrent
        fromdatePicker.datePickerMode = .date
        todatePicker.datePickerMode = .date
        let fromcurrentFont = fromDateLabel.font
        let tocurrentFont = toDateLabel.font
        fromDateLabel.font = UIFont.boldSystemFont(ofSize: fromcurrentFont!.pointSize)
        toDateLabel.font = UIFont.boldSystemFont(ofSize: tocurrentFont!.pointSize)
        fromdatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: -10, to: Date())
        fromdatePicker.maximumDate = Calendar.current.date(byAdding: .day, value: 10, to: Date())
        
        fromDateLabel.text = "Choose a start Date"
        toDateLabel.text = "Choose an end Date"
        
        
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
       
        titleLabel.text = ""
        var charIndex = 0.0
        let titleText = "💱Currency Converter🪙"
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { timer in
                self.titleLabel.text?.append(letter)
            }
            charIndex += 1
        }
        
        titleLabel.textAlignment = .center
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
        updateChart()
        }
    func didGetCurrencyCode(to: String, toImage: String) {
        toLabel.text = to
        self.toImage.text = toImage
        self.to = to
        updateChart()
    }
    
}

