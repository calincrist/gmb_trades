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
    
    let viewModel: TransactionsViewModel = TransactionsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.title = "Products"
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        viewModel.fetchData {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath)
        
        let product = viewModel.products[indexPath.row]
        
        cell.textLabel?.text = product.sku
        cell.detailTextLabel?.text = "Total: \(product.sumEUR.amount) EUR from \(product.transactions!.count) transactions"
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = viewModel.products[indexPath.row]
        
        let productDetailsViewController = ProductDetailsViewController(nibName: "ProductDetailsViewController", bundle: Bundle.main)
        productDetailsViewController.product = product
        
        navigationController?.pushViewController(productDetailsViewController, animated: true)
    }

}

