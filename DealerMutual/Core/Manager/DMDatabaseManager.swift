//
//  DMDatabaseManager.swift
//  DealerMutual
//
//  Created by 222 on 4/6/20.
//  Copyright © 2020 sasha dovbnya. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseFirestore

typealias AddPDFScanningFileCompletionHandler = (DMPDFScanningFile?, Error?) -> Void
typealias FetchPDFScanningFilesCompletionHandler = ([DMPDFScanningFile]?, Error?) -> Void
typealias DeletePDFScanningFileCompletionHandler = (Error?) -> Void

internal final class DMDatabaseManager {
    
    static let shared = DMDatabaseManager()
    private let db = Firestore.firestore()
    let PDFScannings = "PDFScannings"
    
    private init() {
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        // Do some set up
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        settings.cacheSizeBytes = FirestoreCacheSizeUnlimited
        db.settings = settings
    }
    
    func addPDFScanningFile(_ scaningFile: DMPDFScanningFile, completionHandler: AddPDFScanningFileCompletionHandler? = nil) {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("\(PDFScannings)/\(currentUserID)").childByAutoId().setValue(scaningFile.toJSON())
        if let handler = completionHandler {
            handler(scaningFile, nil)
        }
    }
    func fetchPDFScanningFiles(completionHandler: FetchPDFScanningFilesCompletionHandler? = nil) {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        guard currentUserID.count > 0 else { return }
        Database.database().reference().child("\(PDFScannings)/\(currentUserID)").observe(.value) { snapshot in
            guard let snap = snapshot.children.allObjects as? [DataSnapshot] else {
                return
            }

            var scanFiles = [DMPDFScanningFile]()
            for child in snap {
                guard let sessionsDict = child.value as? [String: Any] else { continue }
                if let scanFile = DMPDFScanningFile(JSON: sessionsDict) {
                    scanFiles.append(scanFile)
                }
            }
            completionHandler?(scanFiles, nil)
        }
    }
    
//    func deletePDFScanningFile(_ scaningFile: DMPDFScanningFile, completionHandler: DeletePDFScanningFileCompletionHandler? = nil) {
//        guard let scanID = scaningFile.scanID else { return }
//        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
//        guard let ownerID = scaningFile.ownerID else { return }
//        guard currentUserID == ownerID else { return }
//        
//        db.collection(PDFScannings).document(scanID).delete { (error) in
//            completionHandler?(error)
//        }
//    }
}
