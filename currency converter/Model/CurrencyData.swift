//
//  CurrencyData.swift
//  currency converter
//
//  Created by aycan duskun on 28.10.2022.
//


import Foundation

struct CurrencyData: Codable {
    
    let status: String
    let base_currency_code: String
    let base_currency_name: String
    let amount: String
    let updated_date: String
    let rates: [String: Currency]
}
    
struct Currency: Codable {
    
    //let currencyName: String
    let rate: String
    let rate_for_amount: String
}

/*enum CodingKeys: String, CodingKey {
        case currencyName = "currency_name"
        case rate
        case rateForAmount = "rate_for_amount"
    }

*/
