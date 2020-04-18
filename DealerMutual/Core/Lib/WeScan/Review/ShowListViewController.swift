//
//  ShowListViewController.swift
//  DealerMutual
//
//  Created by 222 on 4/16/20.
//  Copyright © 2020 sasha dovbnya. All rights reserved.
//

import UIKit
import AVFoundation
import SnapKit
import PDFGenerator

class PhotoCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.contentMode = .scaleToFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    func setupViews() {
        addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(30)
        }
        
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(textLabel.snp.top)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

final class ShowListViewController: UIViewController {
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5.0
        layout.minimumInteritemSpacing = 5.0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        cv.register(PhotoCell.self, forCellWithReuseIdentifier: "cellId")
        return cv
    }()
    
    private var pdfURL:URL?
    
    private lazy var doneButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(finishScan))
        button.tintColor = .white
        return button
    }()
    
    private lazy var cancelButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelScan))
        button.tintColor = .white
        return button
    }()
    
    private lazy var shareButton: UIBarButtonItem = {
        let image = UIImage(named: "icon_share", in: Bundle(for: ScannerViewController.self), compatibleWith: nil)
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(sharePDF))
        button.tintColor = .white
        return button
    }()
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("wescan.scanning.add", tableName: nil, bundle: Bundle(for: ShowListViewController.self), value: "+", comment: "The cancel button"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.textColor = .white
        button.backgroundColor = .orange
        button.layer.cornerRadius = 30.0
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(addScanFiles), for: .touchUpInside)
        return button
    }()
    
    private let results: ImageScannerResults
    
    // MARK: - Life Cycle
    
    init(results: ImageScannerResults) {
        self.results = results
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        setupCollection()
        
        title = NSLocalizedString("wescan.show.title", tableName: nil, bundle: Bundle(for: ReviewViewController.self), value: "Scanned files", comment: "The review title of the ShowListViewController")
        navigationItem.rightBarButtonItems = [doneButton, shareButton]
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    // MARK: Setups
    
    private func setupViews() {
        self.view.addSubview(collectionView)
        self.view.addSubview(addButton)
        self.view.backgroundColor = .white
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.right.equalToSuperview().offset(-10)
        }
        addButton.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(60)
            make.bottom.equalToSuperview().offset(-10)
            make.right.equalToSuperview().offset(-10)
        }
    }
    
    private func setupCollection() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    @objc func sharePDF() {
        if pdfURL == nil {
            pdfURL = getPDFUrl()
        }
        
        let ac = UIActivityViewController(activityItems: [pdfURL!], applicationActivities: nil)
        self.present(ac, animated: true, completion: nil)
    }
    
    @objc func getPDFUrl() -> URL{
        let fileName = "PDF_\(Int(Date().timeIntervalSince1970)).pdf"
        let pdfURL = URL(fileURLWithPath: NSTemporaryDirectory().appending(fileName))
        do {
            try PDFGenerator.generate(ScanManager.shared.scanPhoto, to: pdfURL)
        } catch (let error){
            print(error)
        }
        
        return pdfURL
    }
    
    @objc private func cancelScan() {
        let actionSheet = UIAlertController(title: "Are you sure to cancel?", message: nil, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (_) in
            guard let imageScannerController = self.navigationController as? ImageScannerController else { return }
            imageScannerController.dismiss(animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "No", style: .default) { (_) in
            
        }
        actionSheet.addAction(yesAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true)
    }
    @objc private func finishScan() {
        guard let imageScannerController = navigationController as? ImageScannerController else { return }
        
        var newResults = results
        if pdfURL == nil {
            pdfURL = getPDFUrl()
        }
        newResults.pdfURL = pdfURL!
        newResults.thumbImage = ScanManager.shared.scanPhoto[0]
        imageScannerController.imageScannerDelegate?.imageScannerController(imageScannerController, didFinishScanningWithResults: newResults)
    }
    
    @objc private func addScanFiles() {
        guard let imageScannerController = navigationController as? ImageScannerController else { return }
        let vcs = imageScannerController.viewControllers
        if vcs.count > 3 {
            let cameraScanVC = vcs[vcs.count - 4]
            imageScannerController.popToViewController(cameraScanVC, animated: true)
        }
    }
}

extension ShowListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ScanManager.shared.scanPhoto.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! PhotoCell
        cell.imageView.image = ScanManager.shared.scanPhoto[indexPath.item]
        cell.textLabel.text = "\(indexPath.row + 1) Page"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = (collectionView.bounds.size.width - 10.0)/3
        return CGSize(width: cellWidth, height: cellWidth * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
}
