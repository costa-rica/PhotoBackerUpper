//
//  ViewController.swift
//  PhotoBackerUpper
//
//  Created by Nick Rodriguez on 17/08/2023.
//

import UIKit

import UIKit

class HomeVC: UIViewController {
    
    var userStore: UserStore!
    var directoryStore: DirectoryStore!
    var requestStore: RequestStore!
    let vwVCTop = UIView()
    let vwVCTopTitle = UIView()
    let imgVwIconNoName = UIImageView()
    let lblHeaderTitle = UILabel()
    let vwCard = UIView()
    let cardInteriorPadding = Float(5.0)
    let cardTopSpacing = Float(2.5)
    
    let safeAreaTopAdjustment = 40.0
    
    private var scrllVwHome=UIScrollView()
    private var stckVwHome=UIStackView()
    let btnToLogin = UIButton()
    let btnToRegister = UIButton()
    var arryEnvironment=APIBase.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestStore = RequestStore()
        userStore = UserStore()
        userStore.requestStore = requestStore
        directoryStore = DirectoryStore()
        directoryStore.requestStore = requestStore
        
        requestStore.apiBase = APIBase.local

        setup_vwVCTop()
        setup_vwVCTopTitle()
        setup_stckVwHome()

        print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
        print("finished loading HomeVC")
        let computerName = ProcessInfo.processInfo.hostName
        print("Computer name: \(computerName)")
//        for family in UIFont.familyNames.sorted() {
//            let names = UIFont.fontNames(forFamilyName: family)
//            print("Family: \(family) Font names: \(names)")
//        }
    }

    func setup_vwVCTop(){
        view.addSubview(vwVCTop)
        vwVCTop.accessibilityIdentifier = "vwVCTop"
        vwVCTop.backgroundColor = environmentColor(requestStore:requestStore)
        vwVCTop.translatesAutoresizingMaskIntoConstraints = false
        vwVCTop.topAnchor.constraint(equalTo: view.topAnchor).isActive = true

        vwVCTop.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive=true
        vwVCTop.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive=true
        vwVCTop.heightAnchor.constraint(equalToConstant: safeAreaTopAdjustment).isActive=true
    }
    
    func setup_vwVCTopTitle(){
        view.addSubview(vwVCTopTitle)
       vwVCTopTitle.accessibilityIdentifier = "vwVCTopTitle"
        vwVCTopTitle.backgroundColor = UIColor(named: "gray-500")
       vwVCTopTitle.translatesAutoresizingMaskIntoConstraints = false
//       vwVCTopTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -safeAreaTopAdjustment).isActive = true
       vwVCTopTitle.topAnchor.constraint(equalTo: vwVCTop.bottomAnchor).isActive=true
       vwVCTopTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive=true
       vwVCTopTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive=true
        
        if let unwrapped_image = UIImage(named: "android-chrome-192x192") {
            imgVwIconNoName.image = unwrapped_image.scaleImage(toSize: CGSize(width: 20, height: 20))

           vwVCTopTitle.heightAnchor.constraint(equalToConstant: imgVwIconNoName.image!.size.height + 10).isActive=true
        }
        imgVwIconNoName.translatesAutoresizingMaskIntoConstraints = false
       vwVCTopTitle.addSubview(imgVwIconNoName)
        imgVwIconNoName.accessibilityIdentifier = "imgVwIconNoName"
        imgVwIconNoName.topAnchor.constraint(equalTo:vwVCTopTitle.topAnchor).isActive=true
        imgVwIconNoName.leadingAnchor.constraint(equalTo:vwVCTopTitle.centerXAnchor, constant: widthFromPct(percent: -35) ).isActive = true
        
        lblHeaderTitle.text = "Photo Backer Upper"
//        lblHeaderTitle.font = UIFont(name: "Rockwell_tu", size: 35)
       vwVCTopTitle.addSubview(lblHeaderTitle)
        lblHeaderTitle.accessibilityIdentifier = "lblHeaderTitle"
        lblHeaderTitle.translatesAutoresizingMaskIntoConstraints=false
        lblHeaderTitle.leadingAnchor.constraint(equalTo: imgVwIconNoName.trailingAnchor, constant: widthFromPct(percent: 2.5)).isActive=true
        lblHeaderTitle.centerYAnchor.constraint(equalTo:vwVCTopTitle.centerYAnchor).isActive=true
        
    }
    
    func setup_stckVwHome(){
        print("- setup_stckVwHome")
        scrllVwHome.translatesAutoresizingMaskIntoConstraints=false
        view.addSubview(scrllVwHome)
        scrllVwHome.accessibilityIdentifier="scrllVwHome"
        
        scrllVwHome.topAnchor.constraint(equalTo:vwVCTopTitle.bottomAnchor, constant: heightFromPct(percent: cardTopSpacing)).isActive=true
        scrllVwHome.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthFromPct(percent: cardInteriorPadding)).isActive=true
        scrllVwHome.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: widthFromPct(percent: cardInteriorPadding * -1)).isActive=true
//        scrllVwAdmin.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive=true
        scrllVwHome.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: heightFromPct(percent: -10)).isActive=true
        
//        scrllVwAdmin.leadingAnchor.constraint(equalTo: vwBackgroundCard.leadingAnchor).isActive=true
        
        view.layoutIfNeeded()
        print("scrllVwHome width: \(scrllVwHome.frame.size)")
        
        stckVwHome.translatesAutoresizingMaskIntoConstraints=false
        scrllVwHome.addSubview(stckVwHome)
        stckVwHome.accessibilityIdentifier = "stckVwHome"
        stckVwHome.axis = .vertical
        stckVwHome.topAnchor.constraint(equalTo: scrllVwHome.topAnchor).isActive=true
        stckVwHome.widthAnchor.constraint(equalToConstant: scrllVwHome.frame.size.width).isActive=true
//        stckVwHome.leadingAnchor.constraint(equalTo: scrllVwHome.leadingAnchor).isActive=true
//        stckVwHome.trailingAnchor.constraint(equalTo: scrllVwHome.trailingAnchor).isActive=true
        stckVwHome.bottomAnchor.constraint(equalTo: scrllVwHome.bottomAnchor).isActive=true
//        stckVwHome.backgroundColor = .black
        stckVwHome.spacing = 20
        setup_btnToRegister()
        setup_btnToLogin()
//        setup_pickerApi()
    }
    
    func setup_vwCard(){
        vwCard.translatesAutoresizingMaskIntoConstraints = false
        stckVwHome.insertArrangedSubview(vwCard, at: 0)
        vwCard.accessibilityIdentifier = "vwCard"
        vwCard.backgroundColor = UIColor(named: "gray-500")
        vwCard.layer.cornerRadius = 10
        
        let stckvwCard = UIStackView()
        stckvwCard.axis = .vertical
        stckvwCard.spacing = 10
        stckvwCard.translatesAutoresizingMaskIntoConstraints = false
        vwCard.addSubview(stckvwCard)
        stckvwCard.topAnchor.constraint(equalTo: vwCard.topAnchor, constant: heightFromPct(percent: 5)).isActive=true
        stckvwCard.leadingAnchor.constraint(equalTo: vwCard.leadingAnchor, constant: widthFromPct(percent: 5)).isActive=true
        stckvwCard.trailingAnchor.constraint(equalTo: vwCard.trailingAnchor, constant: widthFromPct(percent: -5)).isActive=true
        stckvwCard.bottomAnchor.constraint(equalTo: vwCard.bottomAnchor, constant: heightFromPct(percent: -5)).isActive=true
        
        
        let lblAppTitle = UILabel()
        lblAppTitle.text = "Photos Backer Upper"
        lblAppTitle.font = UIFont(name: "Rockwell_tu", size: 20)
//        vwCard.addSubview(lblAppTitle)
        stckvwCard.addArrangedSubview(lblAppTitle)
        lblAppTitle.accessibilityIdentifier = "lblAppTitle"
        lblAppTitle.translatesAutoresizingMaskIntoConstraints=false
        
//        let lblEtymology = UILabel()
//        lblEtymology.text = "Etymology"
//        lblEtymology.font = UIFont(name: "Rockwell-Bold_tu", size: 20)
////        vwCard.addSubview(lblEtymology)
//        stckvwCard.addArrangedSubview(lblEtymology)
//        lblEtymology.accessibilityIdentifier = "lblEtymology"
//        lblEtymology.translatesAutoresizingMaskIntoConstraints=false

        let imgVwLine01 = createDividerLine(thicknessOfLine: 2)
        stckvwCard.addArrangedSubview(imgVwLine01)
        imgVwLine01.translatesAutoresizingMaskIntoConstraints=false
//        imgVwLine01.topAnchor.constraint(equalTo: lblEtymology.bottomAnchor, constant: heightFromPct(percent: 2.5)).isActive=true

        
//        let lblEtymologyDef = UILabel()
//        lblEtymologyDef.text = "Spanish rincón, literally, corner, nook, alteration of recón, rencón from Arabic dialect (Spain) rukun (Arabic rukn)"
//        lblEtymologyDef.numberOfLines=0
//        lblEtymologyDef.lineBreakMode = .byWordWrapping
//        lblEtymologyDef.font = UIFont(name: "Rockwell_tu", size: 20)
//        stckvwCard.addArrangedSubview(lblEtymologyDef)
//        lblEtymologyDef.translatesAutoresizingMaskIntoConstraints=false
//
//
//        let lblFirstKnown = UILabel()
//        lblFirstKnown.text = "First Known Use"
//        lblFirstKnown.font = UIFont(name: "Rockwell-Bold_tu", size: 20)
//        stckvwCard.addArrangedSubview(lblFirstKnown)
//        lblFirstKnown.translatesAutoresizingMaskIntoConstraints=false
//
//
//        let imgVwLine02 = createDividerLine(thicknessOfLine: 2)
////        vwCard.addSubview(imgVwLine02)
//        stckvwCard.addArrangedSubview(imgVwLine02)
//        imgVwLine02.translatesAutoresizingMaskIntoConstraints=false
//
//
//        let lblDate = UILabel()
//        lblDate.text = "1589"
//        lblDate.font = UIFont(name: "Rockwell_tu", size: 20)
//        stckvwCard.addArrangedSubview(lblDate)
//        lblDate.translatesAutoresizingMaskIntoConstraints=false
    }
    
    func setup_btnToRegister(){
        btnToRegister.setTitle("Register", for: .normal)
        btnToRegister.titleLabel?.font = UIFont(name: "Rockwell_tu", size: 20)
        btnToRegister.backgroundColor = UIColor(named: "orangePrimary")
        btnToRegister.layer.cornerRadius = 10
        btnToRegister.translatesAutoresizingMaskIntoConstraints=false
        stckVwHome.addArrangedSubview(btnToRegister)
        btnToRegister.sizeToFit()
        btnToRegister.heightAnchor.constraint(equalToConstant: btnToRegister.frame.size.height + 30).isActive=true
        btnToRegister.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        btnToRegister.addTarget(self, action: #selector(touchUpInside(_:)), for: .touchUpInside)

    }

    func setup_btnToLogin(){
        btnToLogin.setTitle("Login", for: .normal)
        btnToLogin.titleLabel?.font = UIFont(name: "Rockwell_tu", size: 20)
        btnToLogin.setTitleColor(UIColor(named: "orangePrimary"), for: .normal)
        btnToLogin.layer.borderColor = UIColor(named: "orangePrimary")?.cgColor
        btnToLogin.layer.cornerRadius = 10
        btnToLogin.layer.borderWidth = 2
        btnToLogin.translatesAutoresizingMaskIntoConstraints=false
        stckVwHome.addArrangedSubview(btnToLogin)
        btnToLogin.sizeToFit()
        btnToLogin.heightAnchor.constraint(equalToConstant: btnToLogin.frame.size.height + 30).isActive=true
        btnToLogin.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        btnToLogin.addTarget(self, action: #selector(touchUpInside(_:)), for: .touchUpInside)
    }
    
    func setup_pickerApi(){
        
        let btnToDevWebsite = UIButton(type: .system)
        btnToDevWebsite.setTitle("Photo Backer Upper Dev Website", for: .normal)
        btnToDevWebsite.addTarget(self, action: #selector(goToDevWebsite), for: .touchUpInside)
        btnToDevWebsite.titleLabel?.font = UIFont(name: "Rockwell_tu", size: 20)
        stckVwHome.addArrangedSubview(btnToDevWebsite)
        
        let stckVwApi = UIStackView()
        stckVwApi.translatesAutoresizingMaskIntoConstraints=false
        stckVwApi.axis = .vertical
        stckVwHome.addArrangedSubview(stckVwApi)
        
        
        let lblApi = UILabel()
        lblApi.text = "Which Api?:"
        lblApi.translatesAutoresizingMaskIntoConstraints=false
        stckVwApi.addArrangedSubview(lblApi)
        lblApi.sizeToFit()
        print("lblApi.frame.size: \(lblApi.frame.size)")
        stckVwApi.heightAnchor.constraint(equalToConstant: lblApi.frame.size.height + 40).isActive=true

        if ProcessInfo.processInfo.hostName == "nicks-mac-mini.local"{
            requestStore.apiBase = APIBase.local

        } else {
            requestStore.apiBase = APIBase.dev
            arryEnvironment.remove(at: 0)
        }

        //            indexDict = ["http://127.0.0.1:5001/":0,Environment.dev.baseString:1,"https://api.tu-rincon.com/":2]
//        let segmentedControl = UISegmentedControl(items: arrayEnvRawValues)
        let segmentedControl = UISegmentedControl(items: arryEnvironment.map { $0.rawValue })
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        
        // Set initial selected segment
//        segmentedControl.selectedSegmentIndex = arryEnvironment[urlStore.baseString] ?? 0
        segmentedControl.selectedSegmentIndex = arryEnvironment.firstIndex(where: { $0.urlString == requestStore.apiBase.urlString }) ?? 0
        stckVwApi.addArrangedSubview(segmentedControl)
        print("APIBase is set to: \(requestStore.apiBase.rawValue)")
        vwVCTop.backgroundColor = environmentColor(requestStore:requestStore)


    }
    
    @objc func touchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseOut], animations: {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: nil)

    }

    @objc func touchUpInside(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
            sender.transform = .identity
        }, completion: nil)
        if sender === btnToRegister {
            print("btnToRegister")
            performSegue(withIdentifier: "goToRegisterVC", sender: self)
        } else if sender === btnToLogin {
            print("btnToLogin")
            performSegue(withIdentifier: "goToLoginVC", sender: self)
        }
    }
    
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let selectedEnvironment = arryEnvironment[sender.selectedSegmentIndex]
        requestStore.apiBase = selectedEnvironment
        print("API base changed by user to: \(requestStore.apiBase.urlString)")
        vwVCTop.backgroundColor = environmentColor(requestStore:requestStore)
    }
    
    @objc func goToDevWebsite() {
        guard let url = URL(string: "https://dev.tu-rincon.com") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToLoginVC"){
            let loginVC = segue.destination as! LoginVC
            loginVC.userStore = self.userStore
            loginVC.requestStore = self.requestStore
            loginVC.directoryStore = self.directoryStore

            
        }   else if (segue.identifier == "goToRegisterVC"){
            let RegisterVC = segue.destination as! RegisterVC
            RegisterVC.userStore = self.userStore
//            RegisterVC.rinconStore = self.rinconStore
            RegisterVC.requestStore = self.requestStore
        }
    }
}

