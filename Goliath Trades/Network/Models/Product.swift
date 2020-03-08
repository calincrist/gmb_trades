//
//  ProductItem.swift
//  Goliath Trades
//
//  Created by Calin Cristian on 04/03/2020.
//  Copyright © 2020 Calin Cristian Ciubotariu. All rights reserved.
//

import Foundation

class Product {
    let sku: String?
    var transactions: [TransactionItem]?
    var sumEUR: Money = Money(amount: 0.0, currency: .EUR)
    var rates: [RateItem]
    
    init(sku: String, transactions: [TransactionItem], rates: [RateItem]) {
        self.sku = sku
        self.transactions = transactions
        self.rates = rates
    }
    
    func addTransaction(transaction: TransactionItem) {
        transactions?.append(transaction)
    }
    
    func computeTotalAmount() {
        let _ = self.transactions?.map { (transaction) in
            let moneyEUR = transaction.money.amountIn(currency: .EUR)
            self.sumEUR = self.sumEUR + moneyEUR
        }
    }
}
