//
//  ImageManager.swift
//  ImageUpload
//
//  Created by Pablo Alarcon on 1/26/24.
//

import Foundation

struct ImageManager {
    
    func uploadImage(data: Data, completionHandler: @escaping(_ result: ImageResponse) -> Void) {
        let httpUtility = HttpUtility()
        
        let imageUploadRequest = ImageRequest(attachment: data.base64EncodedString(), fileName: "multipartFormUploadExample")
        
        httpUtility.postApiDataWithMultipartForm(requestUrl: URL(string: Endpoints.uploadImageMultiPartForm)!, request: imageUploadRequest, resultType: ImageResponse.self) { result in
            completionHandler(result)
        }
    }
    
}
