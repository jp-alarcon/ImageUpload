//
//  HttpUtility.swift
//  ImageUpload
//
//  Created by Pablo Alarcon on 1/26/24.
//

import Foundation


struct HttpUtility {
    
    func getApiData<T: Decodable>(requestUrl: URL, resultType: T.Type, completionHandler: @escaping(_ result: T?) -> Void) {
        URLSession.shared.dataTask(with: requestUrl) { responseData, httpUrlResponse, error in
            if (error == nil && responseData != nil && responseData?.count != 0) {
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(T.self, from: responseData!)
                    completionHandler(result)
                } catch let error {
                    debugPrint(error)
                }
            }
        }.resume()
    }
    
    func postApiData<T: Decodable>(requestUrl: URL, requestBody: Data, resultType: T.Type, completionHandler: @escaping(_ result: T) -> Void) {
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = "post"
        urlRequest.httpBody = requestBody
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        
        URLSession.shared.dataTask(with: urlRequest) { data, httpUrlResponse, error in
            if (error == nil && data != nil && data?.count != 0) {
                do {
                    let response = try JSONDecoder().decode(T.self, from: data!)
                    completionHandler(response)
                } catch let error {
                    debugPrint(error)
                }
            }
        }.resume()
    }
    
    func postApiDataWithMultipartForm<T: Decodable>(requestUrl: URL, request: ImageRequest, resultType: T.Type, completionHandler: @escaping(_ result: T) -> Void) {
        var urlRequest = URLRequest(url: requestUrl)
        let lineBreak = "\r\n"
        
        urlRequest.httpMethod = "post"
        let boundary = "----------------------------------------" + UUID().uuidString
        urlRequest.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "content-type")
        
        var requestData = Data()
        
        requestData.append("--\(boundary)\r\n".data(using: .utf8)!)
        requestData.append("content-disposition: form-data; name=\"attachment\" \(lineBreak+lineBreak)".data(using: .utf8)!)
        requestData.append(request.attachment.data(using: .utf8)!)
        
        requestData.append("\(lineBreak)--\(boundary)\r\n".data(using: .utf8)!)
        requestData.append("content-disposition: form-data; name=\"fileName\" \(lineBreak+lineBreak)".data(using: .utf8)!)
        requestData.append((request.fileName + lineBreak).data(using: .utf8)!)
        
        requestData.append("\(lineBreak)--\(boundary)".data(using: .utf8)!)
        
        urlRequest.addValue("\(requestData.count)", forHTTPHeaderField: "content-length")
        urlRequest.httpBody = requestData
        
        URLSession.shared.dataTask(with: urlRequest) { data, httpUrlResponse, error in
            if (error == nil && data != nil && data?.count != 0) {
                do {
                    let response = try JSONDecoder().decode(T.self, from: data!)
                    completionHandler(response)
                } catch let error {
                    debugPrint(error)
                }
            }
        }.resume()
    }
}
