//
//  API.swift
//  Goliath Trades
//
//  Created by Calin Cristian on 04/03/2020.
//  Copyright © 2020 Calin Cristian Ciubotariu. All rights reserved.
//

import Foundation

enum API {
    case getRates
    case getTransactions
    
    var scheme: String {
        switch self {
        case .getTransactions, .getRates:
          return "http"
        }
    }
    
    var host: String {
      switch self {
      case .getTransactions, .getRates:
        return "gnb.dev.airtouchmedia.com"
      }
    }
    
    var path: String {
        switch self {
        case .getRates:
            return "/rates.json"
        case .getTransactions:
            return "/transactions.json"
        }
    }
    
    var method: String {
      switch self {
        case .getRates, .getTransactions:
          return "GET"
      }
    }
}
