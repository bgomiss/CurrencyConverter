//
//  CurrencyManager.swift
//  currency converter
//
//  Created by aycan duskun on 28.10.2022.
//


import Foundation

protocol CurrencyManagerDelegate {
    func didUpdateCurrency(_ currencyManager: String)
    
    func didFailWithError(error: Error)
}


struct CurrencyManager {
    
    var api = ApiKey()
    var delegate: CurrencyManagerDelegate?
    
    let currencyUrl = "https://api.apilayer.com/currency_data/convert?"
    
    /* let headers = [
     "X-RapidAPI-Key": "1f5d035635msh5a1a9c566f3d4cdp1c793cjsn2b7bdad60fe2",
     "X-RapidAPI-Host": "currency-converter5.p.rapidapi.com"
     ]*/
    
    /*let request = NSMutableURLRequest(url: NSURL(string: "https://currency-converter5.p.rapidapi.com/currency/convert?format=json&from=USD&to=TRY&amount=1")! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)*/
    func fetchRates(from: String, to: String, amount: String) {
        
        let urlString = "\(currencyUrl)from=\(from)&to=\(to)&amount=\(amount)&apikey=\(api.api)"
        
        //performRequest(with: urlString)
        
       // func performRequest(with urlString: String) {
            
            /*request.httpMethod = "GET"
             request.allHTTPHeaderFields = headers*/
            if let url = URL(string: urlString) {
                
                let session = URLSession(configuration: .default)
                
                let task = session.dataTask(with: url) { data, response, error in
                    
                    
                    
                    /*let session = URLSession.shared
                     let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in*/
                    if error != nil {
                        print(error!)
                    } else {
                        if let safeData = data {

                            if let currency = parseJSON(currencyData: safeData, toCurrency: to) {
                            
                                self.delegate?.didUpdateCurrency(currency)
                            }
                        }
                    }
                    
                }
                
                
                task.resume()
            }
            
            
            func parseJSON(currencyData: Data, toCurrency: String) -> String? {
                
                
                let decoder = JSONDecoder()
                do {
                    let decodedData = try decoder.decode(CurrencyData.self, from: currencyData)
                    
                    let result = decodedData.result
                    
                   // let finalResult = Double(result)
                   
                    
                    return String(format: "%.2f", result)
                    //
                    
                } catch {
                    delegate?.didFailWithError(error: error)
                    return nil
                }
                
            }
        }
        
    }

