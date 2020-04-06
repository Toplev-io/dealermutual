//
//  DMBaseMainModel.swift
//  DealerMutual
//
//  Created by sasha dovbnya on 10/1/18.
//  Copyright © 2018 sasha dovbnya. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SwiftDate

protocol MainModelProtocol: class {
    var tableView: UITableView! { get }
    var storyboard: UIStoryboard? { get }
    var navigationController: UINavigationController? { get }
    var refresher: UIRefreshControl { get }
}

enum DMDateFilter {

    case all
    case day
    case week
    case month
    case customDate( from: Date, to: Date)
    
    var intValue: Int {
        switch self {
        case .all: return 0
        case .day: return 1
        case .week: return 2
        case .month: return 3
        case .customDate( _,  _): return 4
        }
    }
}


class DMBaseItemsModel: DMBaseModel {
    
    let ref = Database.database().reference()
    
    required init() {
        super.init()
    }
    
    func getItems<T: DMItem>(type: T.Type, authorID: String? = nil) {
        ref.child(T.itemKey).observeSingleEvent(of: .value) { [weak self] (snapshot) in
            var temArray = [T]()
            defer {
                if let authorID = authorID {
                    temArray = temArray.filter({ $0.author ==  authorID})
                }
                temArray.sort(by: { $0.date > $1.date })
                self?.didUpdate(with: temArray)
            }
            guard let data = snapshot.value as? [String: [String : Any]] else {
                return
            }
            for (key, value) in data {
                if let item = T(JSON: value) {
                    item.itemID = key
                    temArray.append(item)
                }
            }
        }
    }
    
    func didUpdate(with data: [DMBaseHomeItem]) {
    }
}

class DMBaseMainModel: DMBaseItemsModel, UITableViewDataSource, UITableViewDelegate  {

    private var allData: [DMBaseHomeItem] = []
    private(set) var data: [DMBaseHomeItem] = []
    var selectedDateFilter: DMDateFilter = .all {
        didSet {
            filterByDate()
            view?.tableView.reloadData()
            view?.refresher.endRefreshing()
        }
    }
    
    weak var view: MainModelProtocol?
    
    @objc func updateData() {
    }
    
    override func didUpdate(with data: [DMBaseHomeItem]) {
        super.didUpdate(with: data)
        self.allData = data
        filterByDate()
        view?.tableView.reloadData()
        view?.refresher.endRefreshing()
    }
    
    private func filterByDate() {
        let currentDate = Date()
        var filterComponent: Calendar.Component?
        switch selectedDateFilter {
        case .day: filterComponent = .day
        case .week:
            let timeInterval: TimeInterval = 7 * 24 * 60 * 60
            self.data = allData.filter({ currentDate.timeIntervalSince($0.date) <= timeInterval })
            return
        case .month: filterComponent = .month
        case .customDate(let from, let to):
            self.data = allData.filter({ $0.date >= from && $0.date <= to })
            return
        default: break
        }
        if let filterComponent = filterComponent {
            self.data = allData.filter({
                let result = $0.date.compare(toDate: currentDate, granularity: filterComponent)
                if result == .orderedSame || result == .orderedDescending {
                    return true
                }
                return false
            })
        }
        else {
            self.data = allData
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellInditifier = data[indexPath.row].cellInditifier
        let cell = tableView.dequeueReusableCell(withIdentifier: cellInditifier, for: indexPath)
        if let itemCell = cell as? DMBaseHomeCell {
            itemCell.updateCell(with: data[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if  let info = data[indexPath.row] as? DMSolicit ,
            let controller = view?.storyboard?.instantiateViewController(withIdentifier: "DMEditSolicitViewController") as? DMEditSolicitViewController {
            controller.displayItem = info
            view?.navigationController?.pushViewController(controller, animated: true)
        }
        else if let info = data[indexPath.row] as? DMSale,
            let controller = view?.storyboard?.instantiateViewController(withIdentifier: "DMEditSaleViewController") as? DMEditSaleViewController {
            controller.displayItem = info
            view?.navigationController?.pushViewController(controller, animated: true)
        }
        else if let info = data[indexPath.row] as? DMDemo,
            let controller = view?.storyboard?.instantiateViewController(withIdentifier: "DMEditDemoViewController") as? DMEditDemoViewController {
            controller.displayItem = info
            view?.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
