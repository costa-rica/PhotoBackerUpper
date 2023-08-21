//
//  RequestStore.swift
//  PhotoBackerUpper
//
//  Created by Nick Rodriguez on 18/08/2023.
//

import UIKit

enum RequestStoreError: Error{
    case failedToProvideCredentials
    case failedToCodeCredentials
    case failedToReachServer
    case failedToDecodeResponse
    
    var localizedDescription: String{
        switch self {
        case .failedToProvideCredentials: return "No credentials provided"
        case .failedToCodeCredentials: return "Credentials did not code into json"
        case .failedToDecodeResponse: return "Failed to decode server response"
        default: return "Failed to reach server"
        }
    }
}

enum APIBase:String, CaseIterable {
    case local = "localhost"
    case dev = "dev"
    case prod = "prod"
    var urlString:String {
        switch self{
        case .local: return "http://127.0.0.1:5001/"
        case .dev: return "https://dev.api.photos-backer-upper.dashanddata.com/"
        case .prod: return "https://api.photos-backer-upper.dashanddata.com/"
        }
    }
}

enum EndPoint: String {
    case are_we_running = "are_we_running"
    case register = "register"
    case login = "login"
    case create_directory = "create_directory"
    case receive_image = "receive_image"
}

class RequestStore {
    
    var user_token:String!
    
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    //MARK: for json writing/reading only
    let fileManager:FileManager
    private let documentsURL:URL
    init() {
        self.fileManager = FileManager.default
        self.documentsURL = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    
    /* Former:  URLStore Stuff */
    
    var apiBase:APIBase!

    private func callEndpoint(endPoint: EndPoint) -> URL{
        let baseURLString = apiBase.urlString + endPoint.rawValue
        let components = URLComponents(string:baseURLString)!
        return components.url!
    }
    private func callDirectoryEndpoint(endPoint: EndPoint, rincon_id: String) -> URL{
        let baseURLString = apiBase.urlString + endPoint.rawValue + "/\(rincon_id)"
        let components = URLComponents(string:baseURLString)!
        return components.url!
    }

    private func callApiQueryStrings(endPoint:EndPoint, queryStringArray:[String]) -> URL {
        var urlString = apiBase.urlString + endPoint.rawValue
        for queryString in queryStringArray {
            urlString = urlString + "/\(queryString)"
        }
        let components = URLComponents(string:urlString)!
        return components.url!
    }
    
    /*  Former:  URLStore Stuff --- End ----- */
    

    func checkAPI(completion:@escaping(Result<String,Error>)->Void){
        let url = callEndpoint(endPoint: .are_we_running)
        let request = URLRequest(url:url)
        let task = session.dataTask(with: request) { data, resp, error in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let responseCheckApi = try jsonDecoder.decode(String.self, from:data)
                    OperationQueue.main.addOperation {
                        completion(.success(responseCheckApi))
                    }
                } catch {
                    print("Failed to decode response")
                    OperationQueue.main.addOperation {
                        completion(.failure(RequestStoreError.failedToReachServer))
                    }
                }
            }
        }
        task.resume()
    }
    
    func createRequestWithBody(endPoint: EndPoint, dictBody:[String:String])->URLRequest? {
        print("- createRequestWithTokenAndBody")
        var jsonData = Data()
        let url = callEndpoint(endPoint: endPoint)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if endPoint == .login {
            guard let email = dictBody["email"],
                  let password = dictBody["password"] else {
                print(RequestStoreError.failedToProvideCredentials)
                return nil
            }
            let loginString = "\(email):\(password)"
            guard let loginData = loginString.data(using: String.Encoding.utf8) else {
                print(RequestStoreError.failedToCodeCredentials)
                return nil
            }
            let base64LoginString = loginData.base64EncodedString()
            request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
                    
        }else {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            do {
                jsonData = try encoder.encode(dictBody)
                request.httpBody = jsonData
            } catch {
                print("Failed to encode dict_body: \(error)")
                
            }
        }
        print("built request: \(request)")
        return request
    }
    
    func createRequestWithToken(endpoint:EndPoint) ->URLRequest{
        let url = callEndpoint(endPoint: endpoint)
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.addValue("application/json",forHTTPHeaderField: "Content-Type")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
        request.setValue( user_token, forHTTPHeaderField: "x-access-token")
        return request
    }
    
    func createRequestWithTokenAndQueryString(endpoint: EndPoint, queryString:[String]) -> URLRequest{
        print("- createRequestWithTokenAndQueryString")

        let url = callApiQueryStrings(endPoint: endpoint, queryStringArray: queryString)
        print("url: \(url)")
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.addValue("application/json",forHTTPHeaderField: "Content-Type")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
        request.setValue( user_token, forHTTPHeaderField: "x-access-token")
        
        return request
    }
    
    func createRequestWithTokenAndDirectoryAndQueryStringAndBody(endpoint: EndPoint, rincon_id:String, queryString:[String], bodyParamDict:[String:String]?) -> URLRequest{
        print("- createRequestWithTokenAndDirectoryAndQueryStringAndBody")
        var jsonData = Data()
//        var url = urlStore.callDirectoryEndpoint(endPoint: .rincon_posts, rincon_id: rincon_id)
        let url = callApiQueryStrings(endPoint: endpoint, queryStringArray: queryString)

        print("url: \(url)")
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.addValue("application/json",forHTTPHeaderField: "Content-Type")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
//        print("** DirectoryStore token \(self.token!)")
        request.setValue( user_token, forHTTPHeaderField: "x-access-token")
        
//        print("reques.header: \(request.allHTTPHeaderFields!)")
        if var unwrapped_bodyParamsDict = bodyParamDict{
            unwrapped_bodyParamsDict["ios_flag"] = "true"
            do {
                let jsonEncoder = JSONEncoder()
                jsonData = try jsonEncoder.encode(unwrapped_bodyParamsDict)
            } catch {
                print("- Failed to encode rincon_id ")
            }
            request.httpBody = jsonData
            return request
        }
        return request
    }
    
    func printCallBackToTerminal(){
        let url = callEndpoint(endPoint: .are_we_running)
        let task = self.session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    print(jsonResult)
                } catch {
                    print("Error: \(error)")
                }
            }
        }
        task.resume()
    }
    
    func createRequestWithTokenAndBody(endPoint: EndPoint, dictBody:[String:String])->URLRequest {
        print("- createRequestWithTokenAndBody")
        let url = callEndpoint(endPoint: endPoint)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue( user_token, forHTTPHeaderField: "x-access-token")

        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        do {
            let jsonData = try encoder.encode(dictBody)
            request.httpBody = jsonData
        } catch {
            print("Failed to encode dict_body: \(error)")

        }
        print("built request: \(request)")
        return request
    }
    
    /* send image 3: stackoverflow version */
    func createRequestSendImageAndTokenThree(dictNewImages:[String:UIImage]) -> (URLRequest, Data){
        print("- createRequestSendImageAndTokenThree")
        let url = callEndpoint(endPoint: .receive_image)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue( self.user_token, forHTTPHeaderField: "x-access-token")
        
        let boundary = UUID().uuidString
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        for (filename, uiimage) in dictNewImages{
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"\(filename)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            data.append(uiimage.jpegData(compressionQuality: 1)!)
        }
        
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        urlRequest.httpBody = data
        return (urlRequest, data)
    }
    
    /* send image 4: ChatGPT version */
    func createRequestSendImageAndTokenFour(endpoint:EndPoint, uiimage:UIImage, uiimageName:String, dictString:[String:String]) -> URLRequest?{
//        guard let url = URL(string: urlString) else {
//            print("Error: cannot create URL from string")
//            return
//        }
        let url = callEndpoint(endPoint: .receive_image)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let imageData = uiimage.jpegData(compressionQuality: 1.0)
        
        if imageData == nil {
            print("Error: could not convert image to data")
            return nil
        }
        
        var body = Data()
        
        // Append parameters
        for (key, value) in dictString {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }
        
        // Append image data
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"uiimage\"; filename=\"\(uiimageName)\"\r\n")
        body.append("Content-Type: image/jpeg\r\n\r\n")
        body.append(imageData!)
        body.append("\r\n")
        
        body.append("--\(boundary)--\r\n")
        
        request.httpBody = body
        
        return request
    }
}


