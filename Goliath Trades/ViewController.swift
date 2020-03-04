//
//  ViewController.swift
//  Goliath Trades
//
//  Created by Calin Cristian on 04/03/2020.
//  Copyright © 2020 Calin Cristian Ciubotariu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.title = "Products"
        
        ServiceLayer.request(router: .getRates) { (result: Result<[RateItem], Error>)  in
            switch result {
            case .success:
                print(result)
            case .failure:
                print(result)
            }
        }
        
        ServiceLayer.request(router: .getTransactions) { (result: Result<[TransactionItem], Error>)  in
            switch result {
            case .success:
                print(result)
            case .failure:
                print(result)
            }
        }
    }
}

