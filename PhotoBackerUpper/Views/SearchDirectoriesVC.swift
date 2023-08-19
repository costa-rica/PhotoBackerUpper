//
//  SearchDirectoriesVC.swift
//  PhotoBackerUpper
//
//  Created by Nick Rodriguez on 18/08/2023.
//

import UIKit

class SearchDirectoriesVC:UIViewController, SearchDirectoryVCDelegate{
    
    var userStore: UserStore!
    var requestStore: RequestStore!
    var directoryStore: DirectoryStore!
    
    let vwVCHeaderOrange = UIView()
    let lblTitle = UILabel()
    var stckVwYourDirectories=UIStackView()
    
    var tblDirectories = UITableView()
    let backgroundColor = UIColor(named: "gray-300")?.cgColor
    let vwBackgroundCard = UIView()
    let cardInteriorPadding = Float(5.0)
    
    var arryDirectories: [Directory]!
    
    var isPublic: Bool = true // the checkbox state, default is checked
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("-Entered SearchDirectoriesVC")
        print("arrayRinons.coount: \(arryDirectories.count)")
        
        tblDirectories.delegate = self
        tblDirectories.dataSource = self
        // Register a UITableViewCell
        tblDirectories.register(DirectoryRow.self, forCellReuseIdentifier: "DirectoryRow")
        //tblDirectories.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tblDirectories.rowHeight = UITableView.automaticDimension
        tblDirectories.estimatedRowHeight = 30 // Provide an estimate here
        
        setup_vwVCHeaderOrange()
        setup_vwBackgroundCard()
        setup_stckVwYourDirectories()
        setup_lblTitle()
        setup_tblDirectories()
//        setup_testLabel()
        setupNavigationBar()
    }
    
    func setup_vwVCHeaderOrange(){
        view.addSubview(vwVCHeaderOrange)
        vwVCHeaderOrange.backgroundColor = environmentColor(requestStore:requestStore)
        vwVCHeaderOrange.translatesAutoresizingMaskIntoConstraints = false
        vwVCHeaderOrange.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        vwVCHeaderOrange.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        vwVCHeaderOrange.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive=true
        vwVCHeaderOrange.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive=true
    }
    func setup_vwBackgroundCard(){
        vwBackgroundCard.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(vwBackgroundCard)
        vwBackgroundCard.accessibilityIdentifier="vwBackgroundCard"
        vwBackgroundCard.backgroundColor = UIColor(named: "gray-500")
        vwBackgroundCard.topAnchor.constraint(equalTo: vwVCHeaderOrange.bottomAnchor, constant: heightFromPct(percent: 5)).isActive=true
        vwBackgroundCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthFromPct(percent: 5)).isActive=true
        vwBackgroundCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: widthFromPct(percent: -5)).isActive=true
        vwBackgroundCard.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: heightFromPct(percent: -10)).isActive=true
        vwBackgroundCard.layer.cornerRadius = 10
    }
    
    func setup_stckVwYourDirectories(){
        stckVwYourDirectories.translatesAutoresizingMaskIntoConstraints = false
        stckVwYourDirectories.spacing = 10
        stckVwYourDirectories.axis = .vertical
        view.addSubview(stckVwYourDirectories)
        stckVwYourDirectories.leadingAnchor.constraint(equalTo: vwBackgroundCard.leadingAnchor,constant: widthFromPct(percent: cardInteriorPadding)).isActive=true
        stckVwYourDirectories.trailingAnchor.constraint(equalTo: vwBackgroundCard.trailingAnchor, constant: widthFromPct(percent: cardInteriorPadding * -1)).isActive=true

        stckVwYourDirectories.topAnchor.constraint(equalTo: vwBackgroundCard.topAnchor, constant: heightFromPct(percent: 1)).isActive=true
        view.layoutIfNeeded()
    }
    
    func setup_lblTitle(){
        lblTitle.text = "Find a Rincón:"
        lblTitle.font = UIFont(name: "Rockwell_tu", size: 30)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        lblTitle.accessibilityIdentifier="lblTitle"
        stckVwYourDirectories.addArrangedSubview(lblTitle)

    }
    func setup_tblDirectories(){
        print("* steup tblDirectories")
        tblDirectories.translatesAutoresizingMaskIntoConstraints=false
        tblDirectories.widthAnchor.constraint(equalToConstant: stckVwYourDirectories.frame.size.width).isActive=true
        tblDirectories.heightAnchor.constraint(equalToConstant: heightFromPct(percent: 50)).isActive=true
//        tblDirectories.backgroundColor = UIColor(named: "gray-400")
        stckVwYourDirectories.addArrangedSubview(tblDirectories)
    }
        
    @objc func searchDirectoriesAlert(message: String) {
        // Create an alert
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        // Create an OK button
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // Dismiss the alert when the OK button is tapped
            alert.dismiss(animated: true, completion: nil)
        }
        
        // Add the OK button to the alert
        alert.addAction(okAction)
        
        // Present the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDirectory))
    }

    @objc private func addDirectory() {
        let createDirectoryVC = CreateDirectoryVC()
        createDirectoryVC.modalPresentationStyle = .overCurrentContext
        createDirectoryVC.modalTransitionStyle = .crossDissolve
//        createDirectoryVC.rinconStore = self.rinconStore
        createDirectoryVC.searchDirectoryVcDelegate = self
        createDirectoryVC.directoryStore = directoryStore
        createDirectoryVC.userStore = userStore
        createDirectoryVC.requestStore = requestStore
        present(createDirectoryVC, animated: true, completion: nil)
    }
    
    func addDirectoryToArryDirectories(directory:Directory){
        arryDirectories.append(directory)
        tblDirectories.reloadData()
    }
}

extension SearchDirectoriesVC: UITableViewDelegate{
    
}

extension SearchDirectoriesVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("arryDirectories.count: \(arryDirectories.count)")
        return arryDirectories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print("** cellForRowAt ")
        let cell = tableView.dequeueReusableCell(withIdentifier: "DirectoryRow", for: indexPath) as! DirectoryRow
        
        let current_dir = arryDirectories[indexPath.row]
        if current_dir.id == arryDirectories.last!.id {
            print("** cellForRowAt ")
            print("rincon id: \(current_dir.id)")
//            print("rincon_membership: \(current_dir.member)")
        }
        cell.lblDirectoryName.text = current_dir.display_name
        cell.membershipStatus = current_dir.member!
        cell.configure()
        cell.requestStore = self.requestStore
        cell.directory = current_dir
        cell.searchDirectoryVcDelegate = self

        return cell
    }
    
}

protocol SearchDirectoryVCDelegate {
    func searchDirectoriesAlert(message: String)
    func addDirectoryToArryDirectories(directory:Directory)
}


class DirectoryRow: UITableViewCell {
    var userStore: UserStore!
    var requestStore: RequestStore!
    var directoryStore: DirectoryStore!
    var directory:Directory!
    var searchDirectoryVcDelegate: SearchDirectoryVCDelegate!
    var stckVwDirectoryRow = UIStackView()
    var lblDirectoryName = UILabel()
    var serachDirectoryVcAlertMessage:String!
    var membershipStatus:Bool! {
        didSet{
            setup_btnMembership()
        }
    }
    var btnMembership = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure() {
        stckVwDirectoryRow.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stckVwDirectoryRow)
        stckVwDirectoryRow.topAnchor.constraint(equalTo: contentView.topAnchor).isActive=true
        stckVwDirectoryRow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: widthFromPct(percent: -1)).isActive=true
        stckVwDirectoryRow.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive=true
        stckVwDirectoryRow.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: widthFromPct(percent: 1)).isActive=true
        stckVwDirectoryRow.spacing = 10
        stckVwDirectoryRow.distribution = .fill
        
        lblDirectoryName.translatesAutoresizingMaskIntoConstraints=false
        stckVwDirectoryRow.insertArrangedSubview(lblDirectoryName, at: 0)
    }
    
    private func setup_btnMembership(){
        btnMembership.translatesAutoresizingMaskIntoConstraints=false
        stckVwDirectoryRow.addArrangedSubview(btnMembership)
        
        btnMembership.addTarget(self, action: #selector(btnMembershipTouchDown), for: .touchDown)
        btnMembership.addTarget(self, action: #selector(btnMembershipTouchUpInside), for: .touchUpInside)
        btnMembership.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        if !membershipStatus {
            setup_btnMembership_join()
        } else {
            setup_btnMembership_leave()
        }
        
    }
    
    private func setup_btnMembership_join(){
        btnMembership.setTitle(" Join ", for: .normal)
        btnMembership.setTitleColor(.green, for: .normal)
        btnMembership.layer.borderColor = UIColor.green.cgColor
        btnMembership.layer.borderWidth = 2
        btnMembership.layer.cornerRadius = 10
    }
    private func setup_btnMembership_leave(){
        btnMembership.setTitle(" Leave ", for: .normal)
        btnMembership.setTitleColor(UIColor(named: "redDelete"), for: .normal)
        btnMembership.layer.borderColor = UIColor(named: "redDelete")?.cgColor
        btnMembership.layer.borderWidth = 2
        btnMembership.layer.cornerRadius = 10
    }
    
    
    // Button action
    @objc func btnMembershipTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseOut], animations: {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: nil)
    }
    @objc func btnMembershipTouchUpInside(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
            sender.transform = .identity
        }, completion: nil)
        let buttonTitle = btnMembership.title(for: .normal) ?? "No Title"
        print("btnMembership pressed, title: \(buttonTitle)")
//        self.rinconStore.requestDirectoryMembership(rincon: rincon) { jsonDict in
//            if jsonDict["status"] == "removed user"{
////                self.btnMembership.removeFromSuperview()
//                self.setup_btnMembership_join()
////                self.layoutIfNeeded()
//                self.serachDirectoryVcAlertMessage = "You have left \(self.rincon.name)"
//            }
//            else if jsonDict["status"] == "added user"{
////                self.btnMembership.removeFromSuperview()
//                self.setup_btnMembership_leave()
////                self.layoutIfNeeded()
//                self.serachDirectoryVcAlertMessage = "You have been added to \(self.rincon.name)"
//            } else {
//                self.serachDirectoryVcAlertMessage = "Failed to communicate with main server"
//            }
//            self.searchDirectoryVcDelegate.searchDirectoriesAlert(message: self.serachDirectoryVcAlertMessage)
//        }
    }
    
}



class CreateDirectoryVC: UIViewController {
    var searchDirectoryVcDelegate: SearchDirectoryVCDelegate!
    var userStore: UserStore!
    var requestStore: RequestStore!
    var directoryStore: DirectoryStore!
    var vwCreateDirectory = UIView()
    var stckVwCreateDirectory:UIStackView!
    var lblTitle = UILabel()
    let txtNewDirectoryName = UITextField()
    let btnPublic = UIButton(type: .system)
    var isPublic: Bool = true
    var alertMessage:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addTapGestureRecognizer()
    }
    
    func setupView() {
        // The semi-transparent background
        view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.6)
        
        vwCreateDirectory.backgroundColor = UIColor.systemBackground
        vwCreateDirectory.layer.cornerRadius = 12
        vwCreateDirectory.layer.borderColor = UIColor(named: "gray-500")?.cgColor
        vwCreateDirectory.layer.borderWidth = 2
        vwCreateDirectory.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(vwCreateDirectory)
        
        NSLayoutConstraint.activate([
            vwCreateDirectory.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            vwCreateDirectory.centerXAnchor.constraint(equalTo: view.centerXAnchor),

        ])
        
        setupInputsInView()
    }
    
    func setupInputsInView() {
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        txtNewDirectoryName.translatesAutoresizingMaskIntoConstraints = false
        btnPublic.translatesAutoresizingMaskIntoConstraints = false

        lblTitle.text = "Create a new rincón"
        lblTitle.font = UIFont(name: "Rockwell_tu", size: 20)
        
        txtNewDirectoryName.placeholder = " Enter Directory Name"

        txtNewDirectoryName.layer.borderWidth = 2
        txtNewDirectoryName.layer.borderColor = CGColor(gray: 0.5, alpha: 1.0)
        txtNewDirectoryName.layer.cornerRadius = 2
        txtNewDirectoryName.widthAnchor.constraint(equalToConstant: widthFromPct(percent: 80)).isActive=true
        
        btnPublic.setTitle(" Make public", for: .normal)
        btnPublic.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        btnPublic.contentHorizontalAlignment = .left
        btnPublic.addTarget(self, action: #selector(toggleCheckbox), for: .touchUpInside)

        

        let submitButton = UIButton(type: .system)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.addTarget(self, action: #selector(submit), for: .touchUpInside)

        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        
        
        let stckVwButtons = UIStackView(arrangedSubviews: [submitButton,cancelButton])
        stckVwButtons.translatesAutoresizingMaskIntoConstraints=false
        
        stckVwCreateDirectory = UIStackView(arrangedSubviews: [lblTitle, txtNewDirectoryName, btnPublic, stckVwButtons])
        stckVwCreateDirectory.axis = .vertical
        stckVwCreateDirectory.spacing = 10

        vwCreateDirectory.addSubview(stckVwCreateDirectory)

        stckVwCreateDirectory.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stckVwCreateDirectory.topAnchor.constraint(equalTo: vwCreateDirectory.topAnchor, constant: heightFromPct(percent: 2)),
            stckVwCreateDirectory.leadingAnchor.constraint(equalTo: vwCreateDirectory.leadingAnchor, constant: widthFromPct(percent: 2)),
            stckVwCreateDirectory.trailingAnchor.constraint(equalTo: vwCreateDirectory.trailingAnchor, constant: widthFromPct(percent: -2)),
            stckVwCreateDirectory.bottomAnchor.constraint(lessThanOrEqualTo: vwCreateDirectory.bottomAnchor, constant: heightFromPct(percent: -2))
        ])
    }

    @objc func toggleCheckbox() {
        isPublic = !isPublic
        let imageName = isPublic ? "checkmark.square" : "square"
        btnPublic.setImage(UIImage(systemName: imageName), for: .normal)
    }

    @objc func submit() {

        if let unwped_directory_name = txtNewDirectoryName.text{
        print("Sending rincon name to api")
            self.directoryStore.createDirectory(directoryName: unwped_directory_name, is_public: isPublic) { directoryResult in

            switch directoryResult {
            case let .success(new_directory):
//                self.searchDirectoryVcDelegate.addDirectoryToArryDirectories(rincon: new_directory)
                self.searchDirectoryVcDelegate.addDirectoryToArryDirectories(directory: new_directory)
                self.dismiss(animated: true, completion: nil)

            case let .failure(error):
                print("rinconResult error: \(error)")
                self.alertMessage = "Failed to add rincón. Try again later."
                self.alertSearchDirectoriesVC()
            }
        }
        } else {
            self.alertMessage = "Must enter a rincón name"
            alertSearchDirectoriesVC()
        }
    }

    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    
    func alertSearchDirectoriesVC() {
        // Create an alert
        let alert = UIAlertController(title: nil, message: alertMessage, preferredStyle: .alert)
        
        // Create an OK button
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // Dismiss the alert when the OK button is tapped
            alert.dismiss(animated: true, completion: nil)
            // Go back to HomeVC
            self.navigationController?.popViewController(animated: true)
//            self.unwindToViewController(sender: alert)
        }
        
        // Add the OK button to the alert
        alert.addAction(okAction)
        
        // Present the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    private func addTapGestureRecognizer() {
        // Create a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))

        // Add the gesture recognizer to the view
        view.addGestureRecognizer(tapGesture)
    }
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: view)
        let _ = view.convert(tapLocation, to: stckVwCreateDirectory)
        
        if let activeTextField = findActiveTextField(uiStackView: stckVwCreateDirectory),
           activeTextField.isFirstResponder {
            // If a text field is active and the keyboard is visible, dismiss the keyboard
            activeTextField.resignFirstResponder()
        } else {
            // If no text field is active or the keyboard is not visible, dismiss the VC
            dismiss(animated: true, completion: nil)
        }
    }
    
    
}


