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
        
        print("- YourDirectoriesVC viewDidLoad() end")

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
    
    func setup_stckVwYourDirectories(){
        view.addSubview(stckVwYourDirectories)
        stckVwYourDirectories.translatesAutoresizingMaskIntoConstraints=false
        stckVwYourDirectories.axis = .vertical
        stckVwYourDirectories.topAnchor.constraint(equalTo: vwVCTop.bottomAnchor).isActive=true
        stckVwYourDirectories.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive=true
        stckVwYourDirectories.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive=true
        stckVwYourDirectories.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive=true
        
        tblYourDirectories.translatesAutoresizingMaskIntoConstraints=false
        stckVwYourDirectories.addArrangedSubview(tblYourDirectories)
                
    }
    
    
    func setup_btnYourDirectoryOptions() {
        btnYourDirectoryOptions = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onYourDirectoryOptions))
        navigationItem.rightBarButtonItem = btnYourDirectoryOptions
    }

    @objc func onYourDirectoryOptions() {
        // Create an action sheet
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Search/Create Rincón", style: .default, handler: { action in
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
//        self.rinconStore.requestUserDirectories { responseResultDirectories in
//            switch responseResultDirectories {
//            case let .success(arryDirectories):
//                self.userStore.user.user_rincons = arryDirectories
//                self.tblYourDirectories.reloadData()
//                sender.endRefreshing()
//            case let .failure(error):
//                print("Error updating rincon array: \(error)")
//                self.alertYourDirectoriesVcRefresh(alertMessage: "Failed to update rincon list", sender: sender)
//            }
//        }
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

        }
    }
//        else if (segue.identifier == "goToSearchDirectoriesVC"){
//            let searchDirectoriesVC = segue.destination as! SearchDirectoriesVC
//            searchDirectoriesVC.arryDirectories = segue_rincons_array
//            searchDirectoriesVC.rinconStore = rinconStore
//            searchDirectoriesVC.urlStore = self.urlStore
//
//        } else if (segue.identifier == "goToManageUserVC"){
//            let manageUserVc = segue.destination as! ManageUserVC
//            manageUserVc.userStore = self.userStore
//            manageUserVc.rinconStore = self.rinconStore
//            manageUserVc.navigationItem.title = self.userStore.user.username
//            manageUserVc.yourDirectoriesVcDelegate = self
//            manageUserVc.urlStore = self.urlStore
//        }
//    }
    
    /* Delegate functions */
    
    func goBackToLogin(){
        print("- in YourDirectoriesVC delegate method")
        if let unwp_navController = self.navigationController{

            print("self.navigationController: \(unwp_navController)")
            print("viewControllers: \(unwp_navController.viewControllers)")
            print("visibleViewController: \(unwp_navController.visibleViewController!)")
            
            self.navigationController?.popViewController(animated: true)
            self.loginVcDelegate.clearUser()

        }
    }
    
}

extension YourDirectoriesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        print("Selelcted a directory ")
        segueDir = arryDirectories[indexPath.row]
        segueDirName = arryDirectories[indexPath.row].display_name
        
        performSegue(withIdentifier: "goToPhotosDirectoryVC", sender: self)
        
        
    }
}

extension YourDirectoriesVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return arryDirectories.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = arryDirectories[indexPath.row].display_name

//        }
        return cell
    }
}

protocol YourDirectoriesVCDelegate{
    func goBackToLogin()
}
