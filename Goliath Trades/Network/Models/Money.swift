//
//  Money.swift
//  Goliath Trades
//
//  Created by Calin Cristian on 08/03/2020.
//  Copyright © 2020 Calin Cristian Ciubotariu. All rights reserved.
//

import Foundation

enum Currency {
    case USD
    case EUR
    case AUD
    case CAD
    case HKD
    case GBP
    case CHF
}

extension Currency {
    init() {
      self = .EUR
    }
    
    init?(fromString string: String) {
        switch string {
        case "USD":
            self = .USD
        case "EUR":
            self = .EUR
        case "AUD":
            self = .AUD
        case "CAD":
            self = .CAD
        case "HKD":
            self = .HKD
        case "CHF":
            self = .CHF
        case "GBP":
            self = .GBP
        default:
            return nil
        }
    }
}

struct Money: Comparable {

    let money: (NSDecimalNumber, Currency)

    static let decimalHandler = NSDecimalNumberHandler(roundingMode: NSDecimalNumber.RoundingMode.bankers,
                                                       scale: 2,
                                                       raiseOnExactness: true,
                                                       raiseOnOverflow: true,
                                                       raiseOnUnderflow: true,
                                                       raiseOnDivideByZero: true)
    
    init(amount: Float, currency: Currency) {
        money = (NSDecimalNumber(value: amount), currency)
    }
    
    init(amount: Decimal, currency: Currency) {
        money = (NSDecimalNumber(decimal: amount), currency)
    }
    
    init(amount: Double, currency: Currency) {
        money = (NSDecimalNumber(value: amount), currency)
    }
    
    var amount: Float {
        get {
            return money.0.rounding(accordingToBehavior: Money.decimalHandler).floatValue
        }
    }
    
    var currency: Currency {
        get {
            return money.1
        }
    }
}

extension Money: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(currency)
        hasher.combine(amount)
        hasher.combine(Money.decimalHandler)
    }
}

extension Money {
     
    static var echangeRates: Set<RateItem> = Set()
    
    func amountIn(currency: Currency, forCurrency initialCurrency: Currency? = nil) -> Money{
        let currentRate = Money.echangeRates.filter { (er) -> Bool in
            return (er.from == self.currency && er.to == currency) || (er.to == self.currency && er.from == currency)
        }
        
        guard let rate = currentRate.first else {
            
            let intermediateFromCurrencies = Money.echangeRates.filter { (er) -> Bool in
                return (er.from == self.currency)
            }
            
            guard let intermediateFromCurrency = intermediateFromCurrencies.first else {
                print("no intermediateFromCurrency")
                return Money(amount: money.0.floatValue, currency: currency)
            }
            
            if let initialCurrency = initialCurrency {
                
                if initialCurrency == intermediateFromCurrency.to {
                    return Money(amount: money.0.floatValue, currency: self.currency)
                            .amountIn(currency: intermediateFromCurrency.to,
                                      forCurrency: nil)
                }
                
                return Money(amount: money.0.floatValue,
                             currency: self.currency)
                    .amountIn(currency: intermediateFromCurrency.to,
                              forCurrency: initialCurrency)
            }
            
            return Money(amount: money.0.floatValue, currency: self.currency).amountIn(currency: intermediateFromCurrency.to, forCurrency: currency)
        }
        
        if let initialCurrency = initialCurrency {
            if rate.from == self.currency {
                return Money(amount: self.money.0.floatValue * rate.rate, currency: currency).amountIn(currency: initialCurrency)
            } else{
                return Money(amount: self.money.0.floatValue * rate.inverseRate, currency: currency).amountIn(currency: initialCurrency)
            }
        }
        
        if rate.from == self.currency {
            return Money(amount: self.money.0.floatValue * rate.rate, currency: currency)
        } else{
            return Money(amount: self.money.0.floatValue * rate.inverseRate, currency: currency)
        }
    }
}


extension Money: CustomStringConvertible {
    var description: String {
        get{
            let amount = money.0.rounding(accordingToBehavior: Money.decimalHandler)
            return "\(amount) \(money.1)"
        }
    }
}

func ==(lhs: Money, rhs: Money) -> Bool {
    
    if lhs.money.0.compare(rhs.money.0) == .orderedSame && lhs.currency == rhs.currency {
        return true
    }
    
    return false
}

func <(lhs:Money, rhs:Money) -> Bool{
    if lhs.currency == rhs.currency && lhs.amount < rhs.amount{
        return true
    }
    
    return false
}

func +(lhs: Money, rhs: Money) -> Money{
    
    if lhs.currency == rhs.currency {
        let money = lhs.money.0.adding(rhs.money.0)
        return Money(amount: money.floatValue, currency: lhs.currency)
    }
    
    return Money(amount: 0.0, currency: lhs.currency)
}
