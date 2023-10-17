//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Paige Stephenson on 10/16/23.
//

import Foundation

struct ExpenseItem: Identifiable, Codable {
//    let id: UUID
//    Writing it this way ^^ would mean you would need to generate a UUID by hand, then load and save the UUID along with the other data. INSTEAD...
    var id = UUID()
//    This line ^^ tells swift to generate a UUID automatically
   
    let name: String
    let type: String
    let amount: Double
    var currencyCode: String 
}


extension ExpenseItem {
    var amountFormatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode // Use the stored currency code
        return formatter.string(from: NSNumber(value: amount)) ?? ""
    }
}
