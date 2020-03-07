//
//  ProductItem.swift
//  Goliath Trades
//
//  Created by Calin Cristian on 04/03/2020.
//  Copyright © 2020 Calin Cristian Ciubotariu. All rights reserved.
//

import Foundation

class Product: Codable {
    let sku: String?
    var transactions: [TransactionItem]?
    var sumEUR: String?
    
    init(sku: String, transactions: [TransactionItem], sumEUR: String){
        self.sku = sku
        self.transactions = transactions
        self.sumEUR = sumEUR
    }
}
