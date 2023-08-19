//
//  PhotosDirectoryVC.swift
//  PhotoBackerUpper
//
//  Created by Nick Rodriguez on 19/08/2023.
//

import UIKit

class PhotosDirectoryVC: UIViewController {
    
    
    // UI Components
    let stckVwDirectory = UIStackView()
    let btnSelectPhotos = UIButton()
    let swtchDelete = UISwitch()
    let lblDeletePhotos = UILabel()
    let btnSubmit = UIButton()

    // For holding the selected photos
    var selectedImages: [UIImage] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        // Set up the stack view
        stckVwDirectory.axis = .vertical
        stckVwDirectory.spacing = 10
        stckVwDirectory.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stckVwDirectory)
        
        // Set up the select photos button
        btnSelectPhotos.setTitle("Select Photos", for: .normal)
        btnSelectPhotos.addTarget(self, action: #selector(selectPhotosTapped), for: .touchUpInside)
        
        // Set up the delete photos switch and label
        lblDeletePhotos.text = "Delete photos?"
        
        // Set up the submit button
        btnSubmit.setTitle("Submit", for: .normal)
        btnSubmit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        btnSubmit.isEnabled = false
        
        // Add components to the stack view
        stckVwDirectory.addArrangedSubview(btnSelectPhotos)
        stckVwDirectory.addArrangedSubview(lblDeletePhotos)
        stckVwDirectory.addArrangedSubview(swtchDelete)
        stckVwDirectory.addArrangedSubview(btnSubmit)
        
        // Add constraints
        NSLayoutConstraint.activate([
            stckVwDirectory.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stckVwDirectory.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    
    @objc func selectPhotosTapped() {
//        let imagePickerController = UIImagePickerController()
//        imagePickerController.delegate = self
//        imagePickerController.sourceType = .photoLibrary
//        imagePickerController.allowsEditing = false
//        imagePickerController.mediaTypes = ["public.image"]
//        imagePickerController.allowsMultipleSelection = true
//        present(imagePickerController, animated: true)
    }

    @objc func submitTapped() {
        // TODO: Implement sending the images to the API
        
        if swtchDelete.isOn {
            // TODO: Implement deleting photos from the device
        }
    }
    
    
}
