//
//  DMHomeModel.swift
//  DealerMutual
//
//  Created by sasha dovbnya on 9/16/18.
//  Copyright © 2018 sasha dovbnya. All rights reserved.
//

import UIKit

protocol DMBaseHomeItem {
    var cellInditifier: String { get }
    var date: Date { get }
}

enum DMHomeModelTypeItem: Equatable {
    case solicit
    case sale
    case demo
    case dealer(isOnline: Bool)
}

class DMDealerItemsModel: DMBaseMainModel {
    
    func getUsers() {
        ref.child("users").observeSingleEvent(of: .value) { [weak self] (snapshot) in
            var temArray = [DMDealer]()
            defer {
                temArray = self?.sortDealer(array: temArray) ?? [DMDealer]()
                self?.didUpdate(with: temArray)
            }
            guard let data = snapshot.value as? [String: [String : Any]] else {
                return
            }
            for (key, value) in data {
                if let item = DMDealer(JSON: value) {
                    item.userID = key
                    temArray.append(item)
                }
            }
        }
    }
    
    func sortDealer(array: [DMDealer]) -> [DMDealer] {
        return [DMDealer]()
    }
}

class DMHomeModel: DMDealerItemsModel, DMHomeSearchHeaderDelegate {
    
    private(set) var type: DMHomeModelTypeItem = .solicit {
        didSet {
            updateData()
        }
    }
    
    func didChangeSearch(status: DMHomeModelTypeItem) {
        if type != status {
            type = status
        }
    }
    
    override func updateData() {
        switch type {
        case .solicit:
            getItems(type: DMSolicit.self)
        case .sale:
            getItems(type: DMSale.self)
        case .demo:
            getItems(type: DMDemo.self)
        case .dealer(_):
            getUsers()
        }
    }
    
    override func didUpdate(with data: [DMBaseHomeItem]) {
        if data.count > 0 {
            if data is [DMSale], type == .sale {
                super.didUpdate(with: data)
            }
            if data is [DMDemo], type == .demo {
                super.didUpdate(with: data)
            }
            if data is [DMSolicit], type == .solicit {
               super.didUpdate(with: data)
            }
            if data is [DMDealer], (type == .dealer(isOnline: true) || type == .dealer(isOnline: false)) {
                 super.didUpdate(with: data)
            }
        }
        else {
            super.didUpdate(with: data)
        }
    }
    
    override func sortDealer(array: [DMDealer]) -> [DMDealer] {
        switch type {
        case .dealer(let isOnline):
            return array.sorted(by: {
                if isOnline { return $0 < $1 }
                else { return $0.name < $1.name }
            })
        default:
            return super.sortDealer(array: array)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        tableView.deselectRow(at: indexPath, animated: false)
        switch type {
        case .dealer( _):
            if let controller = view?.storyboard?.instantiateViewController(withIdentifier: "DMDealerInfoViewController") as? DMDealerInfoViewController,
                let info = data[indexPath.row] as? DMDealer {
                controller.model.dealerInfo = info
                view?.navigationController?.pushViewController(controller, animated: true)
            }
        default:
            break
        }
    }
    
}
