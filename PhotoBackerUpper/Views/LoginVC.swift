//
//  LoginVC.swift
//  PhotoBackerUpper
//
//  Created by Nick Rodriguez on 17/08/2023.
//

import UIKit

class LoginVC: UIViewController, LoginVCDelegate{
    
    var userStore: UserStore!
    var directoryStore: DirectoryStore!
    var requestStore: RequestStore!
    let vwVCTop = UIView()
    let vwVCTopTitle = UIView()
    
    let imgVwIconNoName = UIImageView()
    let lblHeaderTitle = UILabel()
    
    let vwBackgroundCard = UIView()
    let lblTitle = UILabel()
    
    let stckVwLogin = UIStackView()
    let stckVwEmailRow = UIStackView()
    let stckVwPasswordRow = UIStackView()
    let stckVwAdmin = UIStackView()
    
    let lblEmail = UILabel()
    let txtEmail = UITextField()
    let lblPassword = UILabel()
    let txtPassword = UITextField()
    let btnShowPassword = UIButton()
    
    var stckVwRememberMe: UIStackView!
    
    let cardInteriorPadding = Float(5.0)
    let screenWidth = UIScreen.main.bounds.width
    
    let btnLogin = UIButton()
    var btnAdmin:UIButton?
    var goToAdminFlag=false
    
    let swRememberMe = UISwitch()
    var lblMachineName = UILabel()
    
    
    var token = "token" {
        
        didSet{
            print("- token didSet")
            if token != "token"{

                if swRememberMe.isOn{
                    self.userStore.writeUserJson()
                } else {
                    self.userStore.deleteUserJsonFile()
                    self.txtEmail.text = ""
                    self.txtPassword.text = ""
                }
                
                if goToAdminFlag{
//                    print("- token didSet goToAdminFlag")
                    performSegue(withIdentifier: "goToAdminVC", sender: self)
                } else{
//                    print("- token didSet goToAdminFlag: False --> goToYourDirectoriesVC")
                    performSegue(withIdentifier: "goToYourDirectoriesVC", sender: self)
                }
            }
        }
    }
    
    var lblLoginStatusMessage = UILabel() {
        didSet{
            if lblLoginStatusMessage.text != ""{
                setup_vwFailedToLogin()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup_vwVCTop()
        setup_vwVCTopTitle()
        setup_vwBackgroundCard()
        setup_lblTitle()
        setup_stckVwLogin()
        setup_btnLogin()
        setup_stckVwRememberMe()
        setup_stckVwAdmin()
        setup_lblMachineName()
        
        userStore.checkUserJson(completion: { result in
            switch result{
            case let .success(user):
                self.txtEmail.text = user.email
                self.txtPassword.text = user.password
                self.userStore.user = user
            case let .failure(error):
                print(error)
            }
        })
        if ProcessInfo.processInfo.hostName == "nicks-mac-mini.local" || ProcessInfo.processInfo.hostName == "localhost"
        {
            txtEmail.text="nrodrig1@gmail.com"
            txtPassword.text = "test"
        }
    }

    
    func setup_vwVCTop(){
        view.addSubview(vwVCTop)
        vwVCTop.backgroundColor = environmentColor(requestStore:requestStore)
        vwVCTop.translatesAutoresizingMaskIntoConstraints = false
        vwVCTop.accessibilityIdentifier = "vwVCTop"
        vwVCTop.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        vwVCTop.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        vwVCTop.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive=true
        vwVCTop.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive=true
    }
    func setup_vwVCTopTitle(){
        view.addSubview(vwVCTopTitle)
        vwVCTopTitle.backgroundColor = UIColor(named: "orangePrimary")
        vwVCTopTitle.translatesAutoresizingMaskIntoConstraints = false
        vwVCTopTitle.accessibilityIdentifier = "vwVCTopTitle"
        vwVCTopTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        vwVCTopTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive=true
        vwVCTopTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive=true
        
        if let unwrapped_image = UIImage(named: "android-chrome-192x192") {
            imgVwIconNoName.image = unwrapped_image.scaleImage(toSize: CGSize(width: 20, height: 20))
            vwVCTopTitle.heightAnchor.constraint(equalToConstant: imgVwIconNoName.image!.size.height + 10).isActive=true
        }
        imgVwIconNoName.translatesAutoresizingMaskIntoConstraints = false
        imgVwIconNoName.accessibilityIdentifier = "imgVwIconNoName"
        vwVCTopTitle.addSubview(imgVwIconNoName)
        imgVwIconNoName.layer.cornerRadius = 10
        imgVwIconNoName.clipsToBounds = true

        imgVwIconNoName.topAnchor.constraint(equalTo:vwVCTopTitle.topAnchor,constant: heightFromPct(percent: 1)).isActive=true
        imgVwIconNoName.leadingAnchor.constraint(equalTo: vwVCTopTitle.centerXAnchor, constant: widthFromPct(percent: -35) ).isActive = true
        
        lblHeaderTitle.text = "Photo Backer Upper"
        lblHeaderTitle.font = UIFont(name: "Rockwell_tu", size: 35)
        vwVCTopTitle.addSubview(lblHeaderTitle)
        lblHeaderTitle.translatesAutoresizingMaskIntoConstraints=false
        lblHeaderTitle.accessibilityIdentifier = "lblHeaderTitle"
        lblHeaderTitle.leadingAnchor.constraint(equalTo: imgVwIconNoName.trailingAnchor, constant: widthFromPct(percent: 2.5)).isActive=true
        lblHeaderTitle.centerYAnchor.constraint(equalTo: vwVCTopTitle.centerYAnchor).isActive=true
    }
    func setup_vwBackgroundCard(){
        vwBackgroundCard.translatesAutoresizingMaskIntoConstraints = false
        vwBackgroundCard.accessibilityIdentifier="vwBackgroundCard"
        view.addSubview(vwBackgroundCard)
        vwBackgroundCard.backgroundColor = UIColor(named: "gray-500")
        vwBackgroundCard.topAnchor.constraint(equalTo: vwVCTopTitle.bottomAnchor, constant: heightFromPct(percent: 5)).isActive=true
        vwBackgroundCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthFromPct(percent: 5)).isActive=true
        vwBackgroundCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: widthFromPct(percent: -5)).isActive=true
        vwBackgroundCard.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: heightFromPct(percent: -10)).isActive=true
//        vwBackgroundCard.heightAnchor.constraint(equalToConstant: heightFromPct(percent: 50)).isActive=true
        vwBackgroundCard.layer.cornerRadius = 10
    }
    func setup_lblTitle(){
        lblTitle.text = "Login"
        lblTitle.font = UIFont(name: "Rockwell_tu", size: 30)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        lblTitle.accessibilityIdentifier="lblTitle"
        view.addSubview(lblTitle)
        lblTitle.topAnchor.constraint(equalTo: vwBackgroundCard.topAnchor, constant: heightFromPct(percent: cardInteriorPadding)).isActive=true
        lblTitle.leadingAnchor.constraint(equalTo: vwBackgroundCard.leadingAnchor, constant: widthFromPct(percent: 2.5)).isActive=true
    }
    
    func setup_stckVwLogin(){
        lblEmail.text = "Email"
        lblPassword.text = "Password"
        
        stckVwLogin.translatesAutoresizingMaskIntoConstraints = false
        stckVwEmailRow.translatesAutoresizingMaskIntoConstraints = false
        stckVwPasswordRow.translatesAutoresizingMaskIntoConstraints = false
        txtEmail.translatesAutoresizingMaskIntoConstraints = false
        txtPassword.translatesAutoresizingMaskIntoConstraints = false
        lblEmail.translatesAutoresizingMaskIntoConstraints = false
        lblPassword.translatesAutoresizingMaskIntoConstraints = false
        
        stckVwLogin.accessibilityIdentifier="stckVwLogin"
        stckVwEmailRow.accessibilityIdentifier="stckVwEmailRow"
        stckVwPasswordRow.accessibilityIdentifier = "stckVwPasswordRow"
        txtEmail.accessibilityIdentifier = "txtEmail"
        txtPassword.accessibilityIdentifier = "txtPassword"
        lblEmail.accessibilityIdentifier = "lblEmail"
        lblPassword.accessibilityIdentifier = "lblPassword"

        txtPassword.isSecureTextEntry = true
        btnShowPassword.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        btnShowPassword.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        stckVwEmailRow.addArrangedSubview(lblEmail)
        stckVwEmailRow.addArrangedSubview(txtEmail)
        
        stckVwPasswordRow.addArrangedSubview(lblPassword)
        stckVwPasswordRow.addArrangedSubview(txtPassword)
        stckVwPasswordRow.addArrangedSubview(btnShowPassword)

        stckVwLogin.addArrangedSubview(stckVwEmailRow)
        stckVwLogin.addArrangedSubview(stckVwPasswordRow)

        stckVwLogin.axis = .vertical
        stckVwEmailRow.axis = .horizontal
        stckVwPasswordRow.axis = .horizontal
        
        stckVwLogin.spacing = 5
        stckVwEmailRow.spacing = 2
        stckVwPasswordRow.spacing = 2
        
        txtEmail.borderStyle = .roundedRect
        txtPassword.borderStyle = .roundedRect
        
        view.addSubview(stckVwLogin)

        NSLayoutConstraint.activate([
            stckVwLogin.leadingAnchor.constraint(equalTo: vwBackgroundCard.leadingAnchor,constant: widthFromPct(percent: cardInteriorPadding)),
            stckVwLogin.trailingAnchor.constraint(equalTo: vwBackgroundCard.trailingAnchor, constant: widthFromPct(percent: cardInteriorPadding * -1)),
            stckVwLogin.topAnchor.constraint(equalTo: lblTitle.topAnchor, constant: heightFromPct(percent: cardInteriorPadding)),
            
            lblEmail.widthAnchor.constraint(equalTo: lblPassword.widthAnchor),
        ])
        
        view.layoutIfNeeded()// <-- Realizes size of lblPassword and stckVwLogin

        // This code makes the widths of lblPassword and btnShowPassword take lower precedence than txtPassword.
        lblPassword.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        btnShowPassword.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }

    @objc func togglePasswordVisibility() {
        txtPassword.isSecureTextEntry = !txtPassword.isSecureTextEntry
        let imageName = txtPassword.isSecureTextEntry ? "eye.slash" : "eye"
        btnShowPassword.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    func setup_btnLogin(){
        btnLogin.setTitle("Login", for: .normal)
        btnLogin.layer.borderColor = UIColor.systemBlue.cgColor
        btnLogin.layer.borderWidth = 2
        btnLogin.setTitleColor(.black, for: .normal)
        btnLogin.layer.cornerRadius = 10
        btnLogin.translatesAutoresizingMaskIntoConstraints = false
        stckVwLogin.addArrangedSubview(btnLogin)
        
        btnLogin.addTarget(self, action: #selector(touchDownLogin(_:)), for: .touchDown)
        btnLogin.addTarget(self, action: #selector(touchUpInside(_:)), for: .touchUpInside)

    }
    @objc func touchDownLogin(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseOut], animations: {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: nil)
        goToAdminFlag = false
    }
    @objc func touchDownAdmin(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseOut], animations: {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: nil)
        goToAdminFlag = true
    }

    @objc func touchUpInside(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
            sender.transform = .identity
        }, completion: nil)
        requestLogin()
    }

    func requestLogin(){
        
        if let unwrapped_email = txtEmail.text, let unwrapped_pw = txtPassword.text {
            
            // send api request
            userStore.requestLoginUser(email: unwrapped_email, password: unwrapped_pw) { responseResultLogin in
                switch responseResultLogin{
                case let .success(user_obj):
//                    print("user_response: \(user_obj)")
                    self.userStore.user.id = user_obj.id
                    self.userStore.user.token = user_obj.token
                    self.userStore.user.email = self.txtEmail.text
                    self.userStore.user.password = self.txtPassword.text
                    self.userStore.user.user_directories = user_obj.user_directories
                    self.userStore.user.username = user_obj.username
                    self.lblLoginStatusMessage.text = ""
                    self.token = user_obj.token!
                case let .failure(error):
                    print("Login error: \(error)")
                    OperationQueue.main.addOperation {
                        let tempLabel = UILabel()
                        tempLabel.text = "Failed To Login"
                        self.lblLoginStatusMessage = tempLabel
                        self.lblLoginStatusMessage.textColor = UIColor.white
                    }
                }

            }
        } else {
            print("No email and password provided! ")
        }

    }
    
    func setup_stckVwRememberMe() {
        stckVwRememberMe = UIStackView()
        let lblRememberMe = UILabel()

        lblRememberMe.text = "Remember Me"

        stckVwRememberMe.spacing = 10
        
        stckVwRememberMe.addArrangedSubview(lblRememberMe)
        stckVwRememberMe.addArrangedSubview(swRememberMe)
        
//        vwBackgroundCard.addSubview(stckVwRememberMe)
        stckVwLogin.addArrangedSubview(stckVwRememberMe)
        
        stckVwRememberMe.translatesAutoresizingMaskIntoConstraints = false
        lblRememberMe.translatesAutoresizingMaskIntoConstraints = false
        swRememberMe.translatesAutoresizingMaskIntoConstraints = false
        stckVwRememberMe.accessibilityIdentifier = "stckVwRememberMe"
        lblRememberMe.accessibilityIdentifier = "lblRememberMe"
        swRememberMe.accessibilityIdentifier = "swRememberMe"

        
        swRememberMe.isOn = true
    }

    func setup_vwFailedToLogin(){
        let vwFailedToLogin = UIView()
        vwFailedToLogin.backgroundColor = UIColor(red: 0.8, green: 0.2, blue: 0.4, alpha: 1.0)
        vwFailedToLogin.translatesAutoresizingMaskIntoConstraints=false
        view.addSubview(vwFailedToLogin)
        lblLoginStatusMessage.translatesAutoresizingMaskIntoConstraints=false
        vwFailedToLogin.addSubview(lblLoginStatusMessage)
        
        vwFailedToLogin.topAnchor.constraint(equalTo: vwVCTopTitle.bottomAnchor, constant: heightFromPct(percent: 1)).isActive=true
        vwFailedToLogin.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: widthFromPct(percent: 5)).isActive=true
        vwFailedToLogin.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: widthFromPct(percent: -5)).isActive=true
        
        vwFailedToLogin.layer.cornerRadius = 10
        
        view.layoutIfNeeded()
        vwFailedToLogin.heightAnchor.constraint(equalToConstant: lblLoginStatusMessage.frame.size.height).isActive=true
        

        lblLoginStatusMessage.topAnchor.constraint(equalTo: vwFailedToLogin.topAnchor).isActive=true
        lblLoginStatusMessage.leadingAnchor.constraint(equalTo: vwFailedToLogin.leadingAnchor, constant: widthFromPct(percent: 5)).isActive=true
        
//        lblLoginStatusMessage
        
    }
    
    
    func setup_stckVwAdmin(){

        stckVwAdmin.translatesAutoresizingMaskIntoConstraints = false
        stckVwAdmin.spacing = 5
        stckVwAdmin.axis = .vertical
        view.addSubview(stckVwAdmin)

        NSLayoutConstraint.activate([
            stckVwAdmin.leadingAnchor.constraint(equalTo: vwBackgroundCard.leadingAnchor,constant: widthFromPct(percent: cardInteriorPadding)),
            stckVwAdmin.trailingAnchor.constraint(equalTo: vwBackgroundCard.trailingAnchor, constant: widthFromPct(percent: cardInteriorPadding * -1)),
            stckVwAdmin.bottomAnchor.constraint(equalTo: vwBackgroundCard.bottomAnchor, constant: heightFromPct(percent: -cardInteriorPadding)),

        ])
        
        view.layoutIfNeeded()// <-- Realizes size of lblPassword and stckVwLogin

    }
    
    
    private func setup_lblMachineName(){
        lblMachineName.text = ProcessInfo.processInfo.hostName
        lblMachineName.textAlignment = .center
        stckVwAdmin.addArrangedSubview(lblMachineName)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToYourDirectoriesVC"){
            let yourDirectoriesVC = segue.destination as! YourDirectoriesVC
            yourDirectoriesVC.userStore = self.userStore
            yourDirectoriesVC.requestStore = self.requestStore
            yourDirectoriesVC.requestStore.user_token = self.token
            yourDirectoriesVC.directoryStore = self.directoryStore
            yourDirectoriesVC.navigationItem.title = "Your Directories"
            yourDirectoriesVC.loginVcDelegate = self
            yourDirectoriesVC.arryDirectories = self.userStore.user.user_directories

        }
//        else if (segue.identifier == "goToAdminVC"){
//            let adminVC = segue.destination as! AdminVC
//            adminVC.userStore = self.userStore
//            adminVC.urlStore = self.urlStore
//            adminVC.rinconStore = self.rinconStore
//        }
    }
    
    func clearUser(){
        print("- LoginVC deleage method")
        txtEmail.text = nil
        txtPassword.text = nil
        userStore.deleteUserJsonFile()
        print("-finisehd Loginv VC deleaget method")
    }
    
}

protocol LoginVCDelegate{
    func clearUser()
}
