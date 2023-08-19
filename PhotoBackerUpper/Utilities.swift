//
//  Utilities.swift
//  PhotoBackerUpper
//
//  Created by Nick Rodriguez on 17/08/2023.
//

import UIKit


func environmentColor(requestStore:RequestStore) -> UIColor{
    if requestStore.apiBase == .prod{
        return UIColor(named: "gray-300") ?? UIColor.cyan
    } else if requestStore.apiBase == .dev{
        return UIColor(named: "gray-500") ?? UIColor.cyan
    } else if requestStore.apiBase == .local{
        return UIColor(hex: "#8ea202")
    }
    return UIColor.cyan
}

func widthFromPct(percent:Float) -> CGFloat {
    let screenWidth = UIScreen.main.bounds.width
    let width = screenWidth * CGFloat(percent/100)
    return width
}

func heightFromPct(percent:Float) -> CGFloat {
    let screenHeight = UIScreen.main.bounds.height
    let height = screenHeight * CGFloat(percent/100)
    return height
}

func createDividerLine(thicknessOfLine:CGFloat) -> UIImageView{
    let screenWidth = UIScreen.main.bounds.width
    let lineImage = UIImage(named: "line01")
    
    let lineImageScreenWidth = cropImage(image: lineImage!, width: screenWidth)
    let cropThin = CGRect(x:0,y:0,width:screenWidth,height:thicknessOfLine)
    let lineImageScreenWidthThin = lineImageScreenWidth?.cgImage?.cropping(to: cropThin)
    let imageViewLine = UIImageView(image: UIImage(cgImage: lineImageScreenWidthThin!))
//    imageViewLine.layer.opacity = 0.6
    imageViewLine.layer.opacity = 0.1
    return imageViewLine
}

// Crops from both sides evenly no aspect ratio adjustment
func cropImage(image: UIImage, width: CGFloat) -> UIImage? {
    let originalSize = image.size
    let originalWidth = originalSize.width
    let originalHeight = originalSize.height
    
    // Calculate the desired height based on the original aspect ratio
    let scaleFactor = width / originalWidth
    let croppedHeight = originalHeight * scaleFactor
    
    // Calculate the crop rect
    let cropRect = CGRect(x: (originalWidth - width) / 2, y: 0, width: width, height: croppedHeight)
    
    // Perform the crop operation
    if let croppedImage = image.cgImage?.cropping(to: cropRect) {
        return UIImage(cgImage: croppedImage)
    }
    
    return nil
}

func findActiveTextField(uiStackView: UIStackView) -> UITextField? {
    // Iterate through your UIStackView's subviews to find the active text field
    for subview in uiStackView.subviews {
        if let textField = subview as? UITextField, textField.isFirstResponder {
            return textField
        }
    }
    return nil
}

