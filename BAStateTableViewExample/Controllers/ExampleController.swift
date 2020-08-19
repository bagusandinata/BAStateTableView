//
//  ExampleController.swift
//  BAStateTableViewExample
//
//  Created by Bagus Andinata on 05/08/20.
//  Copyright © 2020 Bagus Andinata. All rights reserved.
//

import UIKit
import BAStateTableView

class ExampleController: UIViewController {
    
    @IBOutlet weak var tableView: BAStateTableView! {
        didSet {
            tableView.dataSource = self
            tableView.registerNIB(with: ExampleCell.self)
            tableView.emptyView = UIView.nib(withType: EmptyView.self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "BAStateTableView"
    }
    
    //MARK: - BUTTON
    @IBAction func loadingTapped(_ sender: Any) {
        tableView.setState(.loading())
    }
    
    @IBAction func customLoadingTapped(_ sender: Any) {
        tableView.loadingView = UIView.nib(withType: BasicLoadingView.self)
        tableView.setState(.customLoadingView)
    }
    
    @IBAction func skeletonLoadingTapped(_ sender: Any) {
        tableView.setState(.skeletonLoading)
    }
    
    @IBAction func emptyDataTapped(_ sender: Any) {
        tableView.setState(.emptyData)
    }
    
    @IBAction func dataAvailableTapped(_ sender: Any) {
        tableView.setState(.availableData())
    }
}

extension ExampleController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (tableView as! BAStateTableView).currentState {
        case .availableData:
            return 10
        case .skeletonLoading:
            return 10
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: ExampleCell.self, indexPath: indexPath)!
        
        switch (tableView as! BAStateTableView).currentState {
        case .availableData:
            cell.labelExample.text = "Coba Coba"
            return cell
        default:
            return cell
        }
    }
}
