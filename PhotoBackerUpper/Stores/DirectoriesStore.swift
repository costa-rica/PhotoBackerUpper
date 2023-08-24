//
//  DirectoriesStore.swift
//  PhotoBackerUpper
//
//  Created by Nick Rodriguez on 18/08/2023.
//

import UIKit
import Alamofire

enum DirectoryStoreError: Error {
    case failedToCreateDirectory
    case failedToSendImage
    
    var localizedDescription: String {
        switch self {
        case .failedToCreateDirectory: return "Server unable to make new directory"
        case .failedToSendImage: return "Server did not receive the image sent"
        }
    }
}

class DirectoryStore {
    var requestStore:RequestStore!
    
    
    
    func createDirectory(directoryName:String,is_public: Bool, completion:@escaping(Result<Directory,Error>)->Void){
        let request = requestStore.createRequestWithTokenAndBody(endPoint: .create_directory, dictBody: ["new_dir_name":directoryName])
        let task = requestStore.session.dataTask(with: request){ data, response, error in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let new_dir = try jsonDecoder.decode(Directory.self, from:data)
                    OperationQueue.main.addOperation {
                        completion(.success(new_dir))
                    }
                }
                catch {
                    print("Failed to make new direcotry")
                    OperationQueue.main.addOperation {
                        completion(.failure(DirectoryStoreError.failedToCreateDirectory))
                    }
                }
            }
        }
        task.resume()
    }
    
    
    

//    func uploadImage(imageFilename: String, imageData: Data, directory: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
//        let url = requestStore.apiBase.urlString
//
//        // Parameters for JSON data
//        let parameters: [String: String] = [
//            "json": "{\"directory\": \"\(directory)\"}"
//        ]
//
//        AF.upload(multipartFormData: { multipartFormData in
//            // Append image data
//            multipartFormData.append(imageData, withName: "file", fileName: imageFilename, mimeType: "image/jpeg")
//
//            // Append parameters
//            for (key, value) in parameters {
//                if let data = value.data(using: .utf8) {
//                    multipartFormData.append(data, withName: key)
//                }
//            }
//        }, to: url, method: .post).responseDecodable { response in
//            switch response.result {
//            case .success(let value):
//                if let JSON = value as? [String: Any] {
//                    completion(.success(JSON))
//                } else {
//                    completion(.failure(NSError(domain: "InvalidData", code: -1, userInfo: nil)))
//                }
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }


    func uploadImage(image: UIImage, uiimageName:String, withParameters params: [String: String],  completion: @escaping (Result<[String:String],Error>) -> Void) {

        
        let request = requestStore.createRequestSendImageAndTokenFour(endpoint: .receive_image, uiimage: image,uiimageName:uiimageName, dictString: params )
        
//        let session = URLSession.shared
        let task = requestStore.session.dataTask(with: request!) { data, response, error in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let respSavedImage = try jsonDecoder.decode([String:String].self, from:data)
                    OperationQueue.main.addOperation {
                        completion(.success(respSavedImage))
                    }
                }
                catch {
                    print("Failed to make new direcotry")
                    OperationQueue.main.addOperation {
                        completion(.failure(DirectoryStoreError.failedToSendImage))
                    }
                }
            }
        }
        task.resume()
    }

//    // Usage
//    if let sampleImage = UIImage(named: "sampleImage") {
//        let params: [String: String] = ["param1": "value1", "param2": "value2"]
//        uploadImage(sampleImage, withParameters: params, toURL: "https://example.com/upload") { (data, response, error) in
//            if let error = error {
//                print("Error:", error)
//                return
//            }
//
//            // Handle the response and data as required
//        }
//    }


    
    

//    func postImage(image: UIImage, body: [String:String]) {
//      // Create a URL for the POST request.
//      let url = URL(string: "https://example.com/api/v1/photos")!
//
//      // Create a multipart form data request.
//      let boundary = "----WebKitFormBoundary7MAJ16kKGqFhcea"
//      let bodyData = NSMutableData()
//
//      // Add the image to the request.
//        bodyData.append(Data("--\(boundary)\r\n".utf8))
//      bodyData.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpeg\"\r\n")
//      bodyData.append("Content-Type: image/jpeg\r\n\r\n")
//      bodyData.append(image.jpegData(compressionQuality: 1.0)!)
//
//      // Add the other body parameters to the request.
//      for (key, value) in body {
//        bodyData.append("--\(boundary)\r\n")
//        bodyData.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
//        bodyData.append("\(value)\r\n")
//      }
//
//      // Add the end of the multipart form data.
//      bodyData.append("--\(boundary)--\r\n")
//
//      // Create the URLRequest object.
//      let request = URLRequest(url: url)
//      request.httpMethod = "POST"
//      request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//      request.httpBody = bodyData as Data
//
//      // Send the request.
//      let task = URLSession.shared.dataTask(with: request) { data, response, error in
//        guard let data = data else {
//          print(error!)
//          return
//        }
//
//        // Print the response data.
//        print(String(data: data, encoding: .utf8)!)
//      }
//
//      task.resume()
//    }

    
    
}


