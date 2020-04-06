//
//  DMNewItemModel.swift
//  DealerMutual
//
//  Created by sasha dovbnya on 9/23/18.
//  Copyright © 2018 sasha dovbnya. All rights reserved.
//

import UIKit
import FirebaseDatabase
import MBProgressHUD

class DMNewItemModel: DMBaseModel {
    
    func create(item: DMItem, controller: UIViewController) {
        var path = Database.database().reference().child(item.databaseKey)
        let key = item.itemID ?? path.childByAutoId().key
        path = path.child(key ?? "")
        let hud = MBProgressHUD.showAdded(to: controller.view.window ?? UIView(), animated: true)
        path.setValue(item.toJSON()) { (error, reference) in
            hud.hide(animated: true)
            if let error = error {
                controller.showError(error.localizedDescription)
            }
            else {
                if item.databaseKey == "demo" {
                    self.sendNotificationsOut(message:"🎉 Another one! Demo logged by: \(item.authorName ?? "") 🎉")

                } else {
                    self.sendNotificationsOut(message:"BEAST MODE! Sale logged by: \(item.authorName ?? "") 💰 🔥 🎉")
                }
                controller.dismiss(animated: true, completion: nil)
            }
        }
    }
    
  func sendNotificationsOut(message: String){
     let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate

    let ref = Database.database().reference()
    ref.observeSingleEvent(of: .value, with: { (snapshot) in
     let snapChildren = snapshot.children
     for snapChild in snapChildren {
         let dtChild = snapChild as? DataSnapshot
         if dtChild?.key == "tokens" {
             let dtVal = dtChild?.value as! [String: AnyObject]
             for dt in dtVal {
                 let dtDic = dt.value as? NSDictionary
                 let token = dtDic?.value(forKey: "token") as? String
                print("-----TOKEN----")
                    print(token!)
                 appDelegate.sendPush(text: message, token: token!)
             }
         }
     }
    })
   
    
    }
    
}
