//
//  PhotosDownloadVC.swift
//  PhotoBackerUpper
//
//  Created by Nick Rodriguez on 24/08/2023.
//
import UIKit
import Photos

class PhotosDownloadVC: UIViewController {
    
    var userStore: UserStore!
    var requestStore: RequestStore!
    var directoryStore: DirectoryStore!
    var directory: Directory!
    private var tblBackUpImages: UITableView!
    
    let vwVCTop = UIView()
    var arryDirFilenames:[String]!
//    var arryImageBackUp:[ImageBackUp]!
    
    var stckVwDownloads:UIStackView!
    var collectionView:UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        // Set up collection view layout
//        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize(width: (self.view.frame.width - 30) / 2, height: (self.view.frame.width - 30) / 2) // setting item size, you might want to adjust
//        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//
//        // Initialize collection view
//        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.backgroundColor = .white
//        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
//
//        self.view.addSubview(collectionView)
        
        
        setup_vwVCTop()
        setupCollectionView()
        setupStackView()
    }
    
    private func setup_vwVCTop(){
        view.addSubview(vwVCTop)
        vwVCTop.backgroundColor = environmentColor(requestStore:requestStore)
        vwVCTop.translatesAutoresizingMaskIntoConstraints = false
        vwVCTop.accessibilityIdentifier = "vwVCTop"
        vwVCTop.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        vwVCTop.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        vwVCTop.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive=true
        vwVCTop.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive=true
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (self.view.frame.width - 30) / 2, height: (self.view.frame.width - 30) / 2)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .black
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupStackView() {
        stckVwDownloads = UIStackView(arrangedSubviews: [collectionView])
        stckVwDownloads.axis = .vertical
        stckVwDownloads.spacing = 10
        stckVwDownloads.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(stckVwDownloads)
        
        NSLayoutConstraint.activate([
            stckVwDownloads.topAnchor.constraint(equalTo: vwVCTop.bottomAnchor),
            stckVwDownloads.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stckVwDownloads.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stckVwDownloads.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    
//    private func setup_stckVwDownloads(){
//        let stckVwDownloads = UIStackView()
//        stckVwDownloads.translatesAutoresizingMaskIntoConstraints=false
//        stckVwDownloads.axis = .vertical
//        view.addSubview(stckVwDownloads)
//        stckVwDownloads.topAnchor.constraint(equalTo: vwVCTop.bottomAnchor).isActive=true
//        stckVwDownloads.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
//        stckVwDownloads.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive=true
//        stckVwDownloads.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive=true
//        for imgFilename in arryDirFilenames{
//            let label = UILabel()
//            label.text = imgFilename
//            stckVwDownloads.addArrangedSubview(label)
//        }
//    }
}



extension PhotosDownloadVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        cell.directory = self.directory
        cell.directoryStore = self.directoryStore
        cell.imageFilename = self.arryDirFilenames[indexPath.row]
        cell.setupImageView()
        return cell
    }
    
    
    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arryDirFilenames.count
    }
    
    // MARK: UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.width - 30) / 2, height: (self.view.frame.width - 30) / 2)
    }
}



class PhotoCell: UICollectionViewCell {
    var directory:Directory!
    var directoryStore:DirectoryStore!
    var imageFilename:String!
    
    var imageBackUp:ImageBackUp!
    var imageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
//        setupImageView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func setupImageView() {
//        self.imageBackUp = ImageBackUp()
        imageView = UIImageView(frame: self.contentView.bounds)
        directoryStore.receiveImage(directory: directory, imageFilename: imageFilename) { resultImage in
            switch resultImage{
            case let .success(uiimage):
                DispatchQueue.main.async {
//                    self.imageBackUp.uiimage = uiimage
                    self.imageView.image = uiimage
                    self.imageView.contentMode = .scaleAspectFill
                    self.imageView.clipsToBounds = true
                    self.contentView.addSubview(self.imageView)
                }

                print("- Photocell has image")
            case let .failure(error):
                print("- Photocell failed to get image: \(error)")
            }
        }
        
        
//        imageView.image = self.imageBackUp.uiimage

    }
}
