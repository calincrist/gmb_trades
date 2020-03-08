//
//  TransactionsViewModel.swift
//  Goliath Trades
//
//  Created by Calin Cristian on 07/03/2020.
//  Copyright © 2020 Calin Cristian Ciubotariu. All rights reserved.
//

import Foundation

class TransactionsViewModel {
    
    var products: [Product] = []
    
    func fetchData(_ callback: @escaping () -> Void) {
        self.fetchRates { (rates) in
            self.fetchTransactions(withRates: rates, callback)
        }
    }
    
    func fetchTransactions(withRates rates: [RateItem], _ callback: @escaping () -> Void) {
        let _ = rates.map { rate in
            Money.echangeRates.insert(rate)
        }
        
        ServiceLayer.request(router: .getTransactions) { (result: Result<[TransactionJSONObject], Error>)  in
            switch result {
            case .success:
                let transactionsJSONObject = try! result.get()
                
                let _ = transactionsJSONObject.map { (transaction) in
                    let sku = transaction.sku
                    
                    let amountFloat = Float(transaction.amount)
                    let currency = Currency(fromString: transaction.currency)
                    
                    let money = Money(amount: amountFloat!, currency: currency!)
                    let transactionItem = TransactionItem(sku: sku, money: money)
                    
                    if let index = self.products.firstIndex(where: {$0.sku == sku}) {
                        self.products[index].addTransaction(transaction: transactionItem)
                    } else {
                        let newProductItem: Product = Product(sku: sku, transactions: [], rates: rates)
                        newProductItem.addTransaction(transaction: transactionItem)
                        self.products.append(newProductItem)
                    }
                }
                
                for product in self.products {
                    DispatchQueue.global().async {
                        product.computeTotalAmount()
                        callback()
                    }
                }
                
                callback()
            
            case .failure:
                print(result)
            }
        }
    }
    
    func fetchRates(_ callback: @escaping ([RateItem]) -> Void) {
        
        ServiceLayer.request(router: .getRates) { (result: Result<[RateJSONObject], Error>)  in
            switch result {
            case .success:
                let rates = try! result.get()
                
                let rateItems: [RateItem] = rates.map { jsonObj in
                    let fromCurrency = Currency(fromString: jsonObj.from)
                    let toCurrency = Currency(fromString: jsonObj.to)
                    let rate = Float(jsonObj.rate)
                    
                    let rateItem = RateItem(from: fromCurrency!, to: toCurrency!, rate: rate!)
                    return rateItem
                }
                
                callback(rateItems)
                
            case .failure:
                print(result)
            }
        }
    }
}
