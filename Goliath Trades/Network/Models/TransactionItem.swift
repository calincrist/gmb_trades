//
//  TransactionItem.swift
//  Goliath Trades
//
//  Created by Calin Cristian on 04/03/2020.
//  Copyright © 2020 Calin Cristian Ciubotariu. All rights reserved.
//

import Foundation

class TransactionJSONObject: Codable {
    let sku: String
    let amount: String
    let currency: String
}

class TransactionItem: Hashable {
    let sku: String
    let money: Money
    
    init(sku: String, money: Money) {
        self.sku = sku
        self.money = money
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(sku)
        hasher.combine(money)
    }
}

func == (lhs: TransactionItem, rhs: TransactionItem) -> Bool {
    return lhs.sku == rhs.sku && lhs.money == rhs.money
}
