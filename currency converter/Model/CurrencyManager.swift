//
//  CurrencyManager.swift
//  currency converter
//
//  Created by aycan duskun on 28.10.2022.
//


import Foundation

protocol CurrencyManagerDelegate {
    func didUpdateCurrency(_ currencyManager: String)
    
    func didGetTimeframeRates(_ timeFrameRates: [String : Double])
    
    func didFailWithError(error: Error)
}


struct CurrencyManager {

    
    var api = ApiKey()
    var delegate: CurrencyManagerDelegate?
    
    
    let currencyUrl = "https://api.apilayer.com/exchangerates_data/convert?"
    
    let timeFrameUrl = "https://api.apilayer.com/exchangerates_data/timeseries?"
    
    func fetchRatesForTimeframe(from: String, to: String, startDate: String, endDate:String) {
        let urlString = "\(timeFrameUrl)base=\(from)&symbols=\(to)&start_date=\(startDate)&end_date=\(endDate)&apikey=\(api.convertApi)"
        performRequestforTimeframe(with: urlString)
  }
  
    func fetchRates(from: String, to: String, amount: String) {

        let urlString = "\(currencyUrl)to=\(to)&from=\(from)&amount=\(amount)&apikey=\(api.convertApi)"
        performRequestforConvert(with: urlString)
      
    }
  


    func parseJSONforConvert(currencyData: Data) -> String? {


           let decoder = JSONDecoder()


           do {
               let decodedData = try decoder.decode(CurrencyData.self, from: currencyData)

               let result = decodedData.result

               return String(format: "%.2f", result)


           } catch {
               delegate?.didFailWithError(error: error)
               return nil
           }

       }
    
    func performRequestforConvert(with urlString: String) {
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                
                if error != nil {
                    print(error!)
                } else {
                    if let safeData = data {
                        
                        if let currency = parseJSONforConvert(currencyData: safeData) {
                            //print(currency)
                            self.delegate?.didUpdateCurrency(currency)
                        }
                    }
                }
                
            }
            
            
            task.resume()
        }
    }

    func performRequestforTimeframe(with urlString: String) {

                if let url = URL(string: urlString) {

                    let session = URLSession(configuration: .default)

                  let task = session.dataTask(with: url) { data, response, error in
                     
                  if error != nil {
                            print(error!)
                        } else {
                            if let safeData = data {

                               let timeFrameRates = parseJSONForTimeframe(currencyData: safeData)
                                   //print(timeFrameRates)
                                
                                   self.delegate?.didGetTimeframeRates(timeFrameRates)
                                }
                            }
                        }
                    task.resume()
                    }

                    
                }
            

//    func cut(_ value: [String: [String: Double]]) -> [String: [String: Double]] {
//        let dic = value
//            .sorted(by: { $0.0 < $1.0 })[0..<10] // <-- last 2 results (in your case 10)
//            .reduce(into: [String: [String: Double]]()) {
//                $0[$1.key] = $1.value
//            }
//        return dic
//    }
    
    func parseJSONForTimeframe(currencyData: Data) -> [String: Double] {

        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        do {
            let decodedData = try decoder.decode(APIResult.self, from: currencyData)
            
            var rates: [String: Double] = [:]
            for (date, rate) in decodedData.rates {
                let ratess = rate.values.first
                rates[date] = ratess
            }
            //print("Rates: \(rates)")
    
            return rates

            } catch {
           
                print(error.localizedDescription)
        }
        return ["N/A" : 0.0]
    }

}
