//
//  ProductDetailsViewController.swift
//  Goliath Trades
//
//  Created by Calin Cristian on 07/03/2020.
//  Copyright © 2020 Calin Cristian Ciubotariu. All rights reserved.
//

import UIKit

class ProductDetailsViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    var product: Product! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = product.sku
        titleLabel.text = "Total amount: \(product.sumEUR!) EUR"
        
        tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: "transactionCell")
        tableView.register(UINib(nibName: "TransactionTableViewCell", bundle: nil), forCellReuseIdentifier: "transactionCell")
        
        tableView.dataSource = self
    }
}

extension ProductDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return product.transactions!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCell", for: indexPath) as! TransactionTableViewCell
        
        let transaction: TransactionItem = (product.transactions?[indexPath.row])!
        
        cell.priceLabel.text = transaction.amount
        cell.currencyLabel.text = transaction.currency
        
        return cell
    }
    
    
}
