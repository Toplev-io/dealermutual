//
//  DMBaseMainViewController.swift
//  DealerMutual
//
//  Created by sasha dovbnya on 10/1/18.
//  Copyright © 2018 sasha dovbnya. All rights reserved.
//

import UIKit

class DMBaseMainViewController<T>: DMBaseViewController<T>, MainModelProtocol where T: DMBaseMainModel {
    @IBOutlet weak var tableView: UITableView!
    var refresher = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = createLogo()
        navigationItem.leftItemsSupplementBackButton = true
        refresher.addTarget(model, action: #selector(DMBaseMainModel.updateData), for: .valueChanged)
        tableView.addSubview(refresher)
        tableView.dataSource = model
        tableView.delegate = model
        model.view = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model.updateData()
    }
}
