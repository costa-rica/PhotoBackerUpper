//
//  YourDirectoriesVC.swift
//  PhotoBackerUpper
//
//  Created by Nick Rodriguez on 18/08/2023.
//

import UIKit

class YourDirectoriesVC: UIViewController, YourDirectoriesVCDelegate{
    
    var loginVcDelegate: LoginVCDelegate!
    var userStore: UserStore!
    var requestStore: RequestStore!
    var directoryStore: DirectoryStore!
//    var urlStore: URLStore!

    let vwVCTop = UIView()
    let lblTitle = UILabel()
    var stckVwYourDirectories=UIStackView()
    
    var tblYourDirectories = UITableView()
    var btnYourDirectoryOptions: UIBarButtonItem!
    var arryDirectories:[Directory]!
    var segueDirName:String!
    var segueDir:Directory!
    var segueDirFilenames=[String](){
        didSet{
            if segueDirFilenames.count > 0 {
                performSegue(withIdentifier: "goToPhotosDownloadVC", sender: self)
            }
        }
    }
    
    var arryAppFunction=AppFunction.allCases
    var appFunctionSelected=AppFunction.backup

    override func viewDidLoad() {
        super.viewDidLoad()
        setup_vwVCTop()

        tblYourDirectories.delegate = self
        tblYourDirectories.dataSource = self
        
        // Register a UITableViewCell
        tblYourDirectories.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")

        setup_stckVwYourDirectories()
        setup_btnYourDirectoryOptions()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        tblYourDirectories.refreshControl = refreshControl
        setup_pickerBackupOrDownload()
//        print("- YourDirectoriesVC viewDidLoad() end")

    }
    func setup_vwVCTop(){
        view.addSubview(vwVCTop)
        vwVCTop.backgroundColor = environmentColor(requestStore:requestStore)
        vwVCTop.translatesAutoresizingMaskIntoConstraints = false
        vwVCTop.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        vwVCTop.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        vwVCTop.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive=true
        vwVCTop.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive=true
    }
    
    func setup_btnYourDirectoryOptions() {
        btnYourDirectoryOptions = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onYourDirectoryOptions))
        navigationItem.rightBarButtonItem = btnYourDirectoryOptions
    }
    
    func setup_stckVwYourDirectories(){
        view.addSubview(stckVwYourDirectories)
        stckVwYourDirectories.translatesAutoresizingMaskIntoConstraints=false
        stckVwYourDirectories.axis = .vertical
        stckVwYourDirectories.topAnchor.constraint(equalTo: vwVCTop.bottomAnchor,constant: heightFromPct(percent: 5)).isActive=true
        stckVwYourDirectories.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive=true
        stckVwYourDirectories.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive=true
        stckVwYourDirectories.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive=true
        
        tblYourDirectories.translatesAutoresizingMaskIntoConstraints=false
        stckVwYourDirectories.addArrangedSubview(tblYourDirectories)
        stckVwYourDirectories.spacing = 20
                
    }
    
    

    
    func setup_pickerBackupOrDownload(){
        
        let segmentedControl = UISegmentedControl(items: arryAppFunction.map { $0.rawValue })
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        
        // Set initial selected segment
//        segmentedControl.selectedSegmentIndex = arryEnvironment[urlStore.baseString] ?? 0
        segmentedControl.selectedSegmentIndex = arryAppFunction.firstIndex(where: { $0.rawValue == "backup" }) ?? 0
        stckVwYourDirectories.insertArrangedSubview(segmentedControl, at: 0)
    }
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let selectedEnvironment = arryAppFunction[sender.selectedSegmentIndex]
        appFunctionSelected = selectedEnvironment
        print("appFunctionSelected: \(appFunctionSelected.rawValue)")
//        requestStore.apiBase = selectedEnvironment
//        print("API base changed by user to: \(requestStore.apiBase.urlString)")
//        vwVCTop.backgroundColor = environmentColor(requestStore:requestStore)
    }

    @objc func onYourDirectoryOptions() {
        // Create an action sheet
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Search/Create Directory", style: .default, handler: { action in
            print("Some Directories Stuff here")
            // Get rincons availible to user
//            self.rinconStore.getDirectoriesForSearch { jsonDirectoryArray in
//                self.segue_rincons_array = jsonDirectoryArray
//            }
        }))
        // Send user to User Options
        actionSheet.addAction(UIAlertAction(title: "Manage User", style: .default, handler: { action in
            self.performSegue(withIdentifier: "goToManageUserVC", sender: self)
        }))
        // Add the "Cancel" action
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        // Show the action sheet
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @objc private func refreshData(_ sender: UIRefreshControl) {
        print("-- Call to get Directores")
    }
    
    func alertYourDirectoriesVC(alertMessage:String) {
        // Create an alert
        let alert = UIAlertController(title: nil, message: alertMessage, preferredStyle: .alert)
        
        // Create an OK button
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // Dismiss the alert when the OK button is tapped
            alert.dismiss(animated: true, completion: nil)
            // Go back to HomeVC
            self.navigationController?.popViewController(animated: true)
        }
        
        // Add the OK button to the alert
        alert.addAction(okAction)
        
        // Present the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func alertYourDirectoriesVcRefresh(alertMessage:String, sender: UIRefreshControl) {
        // Create an alert
        let alert = UIAlertController(title: nil, message: alertMessage, preferredStyle: .alert)
        
        // Create an OK button
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // Dismiss the alert when the OK button is tapped
            alert.dismiss(animated: true, completion: nil)
            // End refresh stay on YourDirectoryVC
            sender.endRefreshing()
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToPhotosDirectoryVC") {
            let photosDirectoryVC = segue.destination as! PhotosDirectoryVC
            photosDirectoryVC.navigationItem.title = self.segueDirName
            photosDirectoryVC.requestStore = requestStore
            photosDirectoryVC.directory = self.segueDir
            photosDirectoryVC.userStore = userStore
            photosDirectoryVC.directoryStore = directoryStore
        } else if (segue.identifier == "goToPhotosDownloadVC"){
            let photosDownloadVC = segue.destination as! PhotosDownloadVC
            photosDownloadVC.navigationItem.title = self.segueDirName
            photosDownloadVC.requestStore = requestStore
            photosDownloadVC.directory = self.segueDir
            photosDownloadVC.userStore = userStore
            photosDownloadVC.directoryStore = directoryStore
            photosDownloadVC.arryDirFilenames = self.segueDirFilenames
        }
    }

    
    /* Delegate functions */
    func goBackToLogin(){
//        print("- in YourDirectoriesVC delegate method")
        if let unwp_navController = self.navigationController{
//            print("self.navigationController: \(unwp_navController)")
//            print("viewControllers: \(unwp_navController.viewControllers)")
//            print("visibleViewController: \(unwp_navController.visibleViewController!)")
            self.navigationController?.popViewController(animated: true)
            self.loginVcDelegate.clearUser()

        }
    }
    
}


extension YourDirectoriesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arryDirectories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = arryDirectories[indexPath.row].display_name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        segueDir = arryDirectories[indexPath.row]
        segueDirName = arryDirectories[indexPath.row].display_name
        
        if appFunctionSelected == .backup{
            performSegue(withIdentifier: "goToPhotosDirectoryVC", sender: self)
        } else {
            directoryStore.receiveImageFilenamesArray(directory: segueDir) { resultResponseArray in
                switch resultResponseArray{
                case let .success(arryFilenames):
                    self.segueDirFilenames = arryFilenames
                case let .failure(error):
                    print("Failed to get list of filenames: \(error)")
                }
            }
        }
    }
}

protocol YourDirectoriesVCDelegate{
    func goBackToLogin()
}
