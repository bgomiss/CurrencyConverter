//
//  CurrencyData.swift
//  currency converter
//
//  Created by aycan duskun on 28.10.2022.
//


import Foundation

struct CurrencyData: Codable {
    
   // let status: String
   // let base_currency_code: String
   // let base_currency_name: String
   // let amount: String
   // let updated_date: String
   // let rates: [String: Currency]
    let success: Bool
    let query: Currency
    let result: Double
}
    
struct Currency: Codable {
    
    //let currencyName: String
   // let rate: String
   // let rate_for_amount: String
    let from: String
    let to: String
    let amount: Int
}

struct APIResult: Codable {
    let timeseries: Bool
    let success: Bool
    let startDate: String
    let endDate: String
    let base: String
    var rates: [String:[String:Double]]
}




