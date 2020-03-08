//
//  RateItem.swift
//  Goliath Trades
//
//  Created by Calin Cristian on 04/03/2020.
//  Copyright © 2020 Calin Cristian Ciubotariu. All rights reserved.
//

import Foundation

class RateJSONObject: Codable {
    let from: String
    let to: String
    let rate: String
}

class RateItem: Hashable {
    let from: Currency
    let to: Currency
    let rate: Float
    
    var inverseRate: Float {
        get {
            return 1 / rate
        }
    }
    
    init(from: Currency, to: Currency, rate: Float) {
        self.from = from
        self.to = to
        self.rate = rate
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(from)
        hasher.combine(to)
        hasher.combine(rate)
   }
}

extension RateItem: CustomStringConvertible {
    var description: String {
        get{
            return "\(from)-\(to): \(rate)"
        }
    }
}

func ==(lhs:RateItem, rhs: RateItem) -> Bool{
    return lhs.hashValue == rhs.hashValue
}
