//
//  DMShowScanFilesViewController.swift
//  DealerMutual
//
//  Created by 222 on 4/7/20.
//  Copyright © 2020 sasha dovbnya. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseUI
import QuickLook
import PDFReader
import MBProgressHUD

class DMShowScanFilesViewController: DMBaseViewController<DMShowScanFileModel> {
    
    @IBOutlet weak var pdfScanFilesCollectionView: UICollectionView!
    lazy private var previewItem = NSURL()
    private var scanFiles = [DMPDFScanningFile]()
    private var filesDownLoaded = [NSURL]()
    
    var hud:MBProgressHUD?
    var currentURL:URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Scan PDF Files"
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupUI(){
//        screenWidth = self.view.frame.size.width
        pdfScanFilesCollectionView.delegate = self
        pdfScanFilesCollectionView.dataSource = self
        loadScanFiles()
    }
    private func loadScanFiles(){
        DMDatabaseManager.shared.fetchPDFScanningFiles() { [weak self] (files, error) in
            guard let strongSelf = self else { return }

            if error != nil {
                return
            }
            guard let files = files else {
                _ = NSError(domain: "AppErrorDomain", code: -1, userInfo: [
                    NSLocalizedDescriptionKey: "Could not fetch Shares"
                ])
                return
            }
            
            strongSelf.scanFiles = files
            strongSelf.pdfScanFilesCollectionView.reloadData()
        }
    }
    
    func saveImage(imageName: String, image: UIImage) {
     guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = UIImageJPEGRepresentation(image, 1) else { return }

        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }

        }

        do {
            try data.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
        }

    }
    
    func loadImageFromDiskWith(fileName: String) -> NSURL? {

      let documentDirectory = FileManager.SearchPathDirectory.documentDirectory

        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)

        if let dirPath = paths.first {
            let imageUrl = NSURL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            return imageUrl as NSURL?
        }
        return nil
    }
    
    func showPDFFile(url : URL){
        self.previewItem = url as NSURL
        let previewController = QLPreviewController()
        
        previewController.navigationController?.view.backgroundColor = #colorLiteral(red: 0.1725490196, green: 0.5725490196, blue: 0.8509803922, alpha: 1)
        previewController.dataSource = self
        if #available(iOS 13.0, *) {
            self.navigationController?.pushViewController(previewController, animated: true)
        } else {
            self.present(previewController, animated: true, completion: nil)
        }
    }
    
    // MARK: fetch image from url
    func download(from url: URL) {

        currentURL = url
        let showView = UIApplication.shared.keyWindow ?? UIView()
        hud = MBProgressHUD.showAdded(to: showView, animated: true)
        hud?.mode = .determinateHorizontalBar
        
        let documentsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsPath.appendingPathComponent(String(url.lastPathComponent.split(separator: "?")[0]))
        
        if FileManager.default.fileExists(atPath: destinationURL.absoluteString) {
            self.showPDFFile(url: destinationURL)
        } else {
            let storageRef = Storage.storage().reference()
            let pdfRef = storageRef.child(String(url.lastPathComponent.split(separator: "?")[0]))
            let downloadTask = pdfRef.write(toFile: destinationURL) { url, error in
                DispatchQueue.main.async {
                    self.hud?.hide(animated: true)
                }
                if let error = error {
                    print(error.localizedDescription)
                }else{
                    DispatchQueue.main.async {
                        self.showPDFFile(url: url!)
                                
            //                    if let document = PDFDocument(url: url!) {
            //                        let readerController = PDFViewController.createNew(with: document)
            //                        readerController.navigationController?.view.backgroundColor = #colorLiteral(red: 0.1725490196, green: 0.5725490196, blue: 0.8509803922, alpha: 1)
            //                        if #available(iOS 13.0, *) {
            //                            self.navigationController?.pushViewController(readerController, animated: true)
            //                        } else {
            //                            self.present(readerController, animated: true, completion: nil)
            //                        }
            //                    }
                    }
                }
            }
            downloadTask.observe(.progress) { snapshot in
                let percentComplete = Float(snapshot.progress!.completedUnitCount) / Float(snapshot.progress!.totalUnitCount)
                print("\(percentComplete)")
                DispatchQueue.main.async {
                    self.hud?.progress = percentComplete
                }
            }

            downloadTask.observe(.success) { snapshot in
              // Download completed successfully
            }
        }
    }
    
    func getURLFromString(_ str: String) -> URL? {
        return URL(string: str)
    }
    
}

extension DMShowScanFilesViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return scanFiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DMScanFileCell", for: indexPath) as! DMScanFileCell
        cell.fileNameLbl.isHidden = true
        let scanFile = scanFiles[indexPath.row]
        if let imageUrl = scanFile.imageUrl, imageUrl.count > 0 {
            cell.scanImageView.sd_setImage(with: DMUploadManager.shared.getReference(for: imageUrl), placeholderImage: nil) { (image, error, imageCacheType, storageReference) in
                if let image = image {
                    self.saveImage(imageName: imageUrl, image: image)
                }
            }
        }else if let pdfUrl = scanFile.pdfURL, pdfUrl.count > 0 {
            cell.fileNameLbl.isHidden = false
            let pdfURL = URL(string: pdfUrl)
            cell.fileNameLbl.text = pdfURL?.lastPathComponent
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let scanFile = scanFiles[indexPath.row]
        if let pdfUrl = scanFile.pdfURL {
            if let pdfURL = getURLFromString(pdfUrl) {
                download(from: pdfURL)
            }
        }else if let imageUrl = scanFile.imageUrl {
            previewItem = self.loadImageFromDiskWith(fileName: imageUrl)!
            let previewController = QLPreviewController()
            
            previewController.navigationController?.view.backgroundColor = #colorLiteral(red: 0.1725490196, green: 0.5725490196, blue: 0.8509803922, alpha: 1)
            previewController.dataSource = self
            if #available(iOS 13.0, *) {
                self.navigationController?.pushViewController(previewController, animated: true)
            } else {
                self.present(previewController, animated: true, completion: nil)
            }
        }
    }
}

extension DMShowScanFilesViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = (collectionView.bounds.size.width - 10.0)/3
        return CGSize(width: cellWidth, height: cellWidth * 1.5)
    }
}

extension DMShowScanFilesViewController: QLPreviewControllerDataSource {
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return self.previewItem as QLPreviewItem
    }
}
