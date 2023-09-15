import UIKit
import PhotosUI
import Photos

class PhotosDirectoryVC: UIViewController, PHPickerViewControllerDelegate {
    
    var userStore: UserStore!
    var requestStore: RequestStore!
    var directoryStore: DirectoryStore!
    var directory: Directory!
    private var tblBackUpImages: UITableView!
    
    let vwVCTop = UIView()
    
    var arryImageBackUp: [ImageBackUp] = [] {
        didSet{
            if arryImageBackUp.count > 0 {
                print("- added objects to arryImageBackUp")
                OperationQueue.main.addOperation {
                    if self.tblBackUpImages == nil {
                        self.setup_tblBackUpImages()
                        self.setup_stckVwDirectory()
                    }
                    self.tblBackUpImages.reloadData()
                }
            }
        }
    }
    
    var arryImageBackUpDelete:[ImageBackUp] = []

    var btnPhotoDirectoryOptions: UIBarButtonItem!
    let stckVwDirectory = UIStackView()
    var stckVwDelete = UIStackView()
    
    var swtchDelete = UISwitch()

    let lblDeletePhotos = UILabel()
    let btnSubmit = UIButton()
    let spinner = UIActivityIndicatorView(style: .large)
    var imageBackedUpCounter = 0 {
        didSet{
            if imageBackedUpCounter == self.arryImageBackUp.count {
                print("self.swtchDelete.isEnabled: \(self.swtchDelete.isOn)")
                if self.swtchDelete.isOn {
                    print("* only if delete selected ****")
                    self.deleteImages(from: self.arryImageBackUpDelete) { imgDelBool, imgDelError in
                        // nothing needed here
                    }
                }
                self.spinner.removeFromSuperview()
                self.arryImageBackUp = []
                self.imageBackedUpCounter=0
                self.tblBackUpImages.reloadData()
                
            }
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        setup_vwVCTop()
        setup_btnPhotoDirectoryOptions()
        print("-- PhotosDirecotryVC--")
        print("---> requestStore.user_token: \(requestStore.user_token!)")
    }
    
//    override func viewDidLayoutSubviews() {
//        print("----- viewDidLayoutSubview -----")
//        print("vwVCTop size: \(vwVCTop.frame.size)")
//        print("stckVwDirectory.frame.size: \(stckVwDirectory.frame.size)")
//    }
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
    private func setup_tblBackUpImages() {
        tblBackUpImages = UITableView(frame: .zero, style: .plain)
        tblBackUpImages.translatesAutoresizingMaskIntoConstraints=false
        view.addSubview(tblBackUpImages)
        tblBackUpImages.topAnchor.constraint(equalTo: vwVCTop.bottomAnchor).isActive=true
        tblBackUpImages.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive=true
        tblBackUpImages.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive=true
        tblBackUpImages.dataSource = self
        tblBackUpImages.delegate = self
        tblBackUpImages.register(PhotoDirCell.self, forCellReuseIdentifier: "PhotoDirCell")
        tblBackUpImages.estimatedRowHeight = 50
        tblBackUpImages.rowHeight = UITableView.automaticDimension
    }
    private func setup_stckVwDirectory(){
        stckVwDirectory.axis = .vertical
        stckVwDirectory.alignment = .fill
        stckVwDirectory.distribution = .fill
        stckVwDirectory.spacing = 20
        view.addSubview(stckVwDirectory)
        stckVwDirectory.translatesAutoresizingMaskIntoConstraints = false
        stckVwDirectory.accessibilityIdentifier = "stckVwDirectory"
        stckVwDirectory.topAnchor.constraint(equalTo: tblBackUpImages.bottomAnchor).isActive=true
        stckVwDirectory.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive=true
        stckVwDirectory.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive=true
        stckVwDirectory.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive=true
        
        stckVwDirectory.addArrangedSubview(stckVwDelete)
        stckVwDelete.accessibilityIdentifier="stckVwDelete"
        stckVwDelete.spacing = 10
        lblDeletePhotos.text = "Do you wish to delete the photos after backing them up?"
        lblDeletePhotos.accessibilityIdentifier = "lblDeletePhotos"
        lblDeletePhotos.numberOfLines = 0
        stckVwDelete.addArrangedSubview(lblDeletePhotos)
        

        
        // Set the label’s compression resistance priority lower than the switch's:
        lblDeletePhotos.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        swtchDelete.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        // label hug content (grow as needed) more than the switch
        lblDeletePhotos.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        swtchDelete.setContentHuggingPriority(.defaultLow, for: .horizontal)

        
        stckVwDelete.addArrangedSubview(swtchDelete)
//        self.stckVwDelete.widthAnchor.constraint(equalToConstant: self.stckVwDirectory.frame.size.width ).isActive=true
        
        btnSubmit.setTitle("Back up these images", for: .normal)
        btnSubmit.layer.borderWidth = 2
        btnSubmit.layer.borderColor = UIColor.blue.cgColor
        btnSubmit.layer.cornerRadius = 20
        btnSubmit.addTarget(self, action: #selector(touchDownBtnSubmit), for: .touchDown)
        btnSubmit.addTarget(self, action: #selector(touchUpInsideBtnSubmit), for: .touchUpInside)
        stckVwDirectory.addArrangedSubview(btnSubmit)
        btnSubmit.accessibilityIdentifier="btnSubmit"
    }
    func setup_btnPhotoDirectoryOptions() {
        btnPhotoDirectoryOptions = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openPhotoGallery))
        navigationItem.rightBarButtonItem = btnPhotoDirectoryOptions
    }
    @objc func openPhotoGallery() {
        var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        configuration.selectionLimit = 0 // No limit
        configuration.filter = .images // Only images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        print("-- Selecting photos")
        
        for result in results {
            let backUpImage = ImageBackUp()
            // Obtain the assetIdentifier to fetch PHAsset (optional step)
            if let assetIdentifier = result.assetIdentifier {
                let assets = PHAsset.fetchAssets(withLocalIdentifiers: [assetIdentifier], options: nil)
                backUpImage.phAsset = assets.firstObject
                print("* getting phAssets: \(backUpImage.phAsset!)")
            } else {
                print("---> unable to get phAssets")
            }
            
            let resultProvider = result.itemProvider
            resultProvider.loadFileRepresentation(forTypeIdentifier: "public.item") { (url,error) in
                if error != nil {
                    print("error: \(error!)")
                } else {
                    if let url = url {
                        let temp_image = getImageFrom(url: url)
                        if let temp_image = temp_image {
                            
                            backUpImage.name = url.lastPathComponent
                            backUpImage.url = url
                            backUpImage.uiimage = temp_image
                            backUpImage.directory = self.directory
                            self.arryImageBackUp.append(backUpImage)
                        }
                    }
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)

    }
    
    @objc func touchDownBtnSubmit(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseOut], animations: {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: nil)

    }

    @objc func touchUpInsideBtnSubmit(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
            sender.transform = .identity
        }, completion: nil)
        
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = UIColor.white.withAlphaComponent(1.0) // Make spinner brighter
        spinner.transform = CGAffineTransform(scaleX: 2, y: 2)
        spinner.startAnimating()
        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive=true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive=true
        
        for  imageBackup in arryImageBackUp{
            print("imageBackup: \(imageBackup.name)")
//            print("imageBacukp: \(imageBackup.)")
            directoryStore.uploadImage(image:imageBackup.uiimage!, uiimageName: imageBackup.name, withParameters: ["directory_id":imageBackup.directory!.id]) { resultResponse in
                switch resultResponse{
                case .success(_)://dict ["message":String]
                    print("imageBackup.url!: \(imageBackup.url!)")
                    if self.swtchDelete.isEnabled{
                        self.arryImageBackUpDelete.append(imageBackup)
                    }
                    self.imageBackedUpCounter+=1
                case let .failure(error):
                    print("failed to send image: \(error)")
                    self.imageBackedUpCounter+=1
                }
            }
        }
    }
    
    /* Delete Photos*/
    func deleteImages(from imageBackups: [ImageBackUp], completion: @escaping (Bool, Error?) -> Void) {
        print("- deleteImges")
        // Filter out nil PHAssets
        let assetsToDelete = imageBackups.compactMap { $0.phAsset }
//        print("assetsToDelete: \(assetsToDelete)")
        if assetsToDelete.isEmpty {
            completion(true, nil)
            return
        }
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.deleteAssets(assetsToDelete as NSArray)
        }) { (success, error) in
            DispatchQueue.main.async {
                completion(success, error)
            }
        }
    }


}


extension PhotosDirectoryVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arryImageBackUp.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoDirCell", for: indexPath) as! PhotoDirCell
        let imageBackup = arryImageBackUp[indexPath.row]
        cell.configure(with: imageBackup)
        return cell
    }

}



class PhotoDirCell: UITableViewCell{
    var imageBackUp: ImageBackUp!
    var stckVwPhotoDirCell=UIStackView()
    var stckVwPhotoDirCellText = UIStackView()
    var lblName=UILabel()
//    var lblPhAsset=UILabel()
    var imgVw: UIImageView?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        stckVwPhotoDirCell.removeFromSuperview()
        lblName.removeFromSuperview()
        imgVw?.removeFromSuperview()
        stckVwPhotoDirCellText.removeFromSuperview()
    }
    
    func configure(with imageBackUp:ImageBackUp){
        self.imageBackUp=imageBackUp
        stckVwPhotoDirCell.translatesAutoresizingMaskIntoConstraints=false
        contentView.addSubview(stckVwPhotoDirCell)
        stckVwPhotoDirCell.topAnchor.constraint(equalTo: contentView.topAnchor).isActive=true
        stckVwPhotoDirCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive=true
        stckVwPhotoDirCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive=true
        stckVwPhotoDirCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive=true
        stckVwPhotoDirCellText.axis = .vertical
        
        
        lblName.text = imageBackUp.name
        lblName.numberOfLines=0
        lblName.lineBreakMode = .byCharWrapping

        imgVw = UIImageView(image: imageBackUp.uiimage?.scaleImage(toSize: CGSize(width: 30, height: 30)))
        
        stckVwPhotoDirCellText.addArrangedSubview(lblName)
        stckVwPhotoDirCell.addArrangedSubview(stckVwPhotoDirCellText)
        
        if let unwp_imgVw = imgVw{
            stckVwPhotoDirCell.addArrangedSubview(unwp_imgVw)
            stckVwPhotoDirCellText.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - unwp_imgVw.frame.size.width).isActive=true
        }
        
    }
    
    
    
    
}


