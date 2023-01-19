//
//  ViewModel.swift
//  Pedestrian Recognition
//
//  Created by Ning Cao on 3/22/22.
//
// view model and post function to server
import SwiftUI
import Alamofire
import MultipartForm

typealias Parameters = [String: Any]

typealias HTTPHeaders = [String: String]
class ViewModel:ObservableObject {
    @Published var image: UIImage?
    @Published var originalImage: UIImage?
    @Published var showPicker = false
    @Published var source: Picker.Source = .library
    var id = 0
    
 
    
    func showPhotoPicker() {
        if source == .camera {
            if !Picker.checkPermissions() {
                print("There is no camera on this device")
                return
            }
        }
        showPicker = true
        self.originalImage = self.image
    }
// post base64 image
//    func Post(image:UIImage) async throws -> (UIImage,String){
//        struct product: Codable {
//            var name: String
//            var b64string: String
//        }
//        let str = image.jpegData(compressionQuality: 0.3)?.base64EncodedString() ?? ""
//
//        let url = URL(string: "http://10.0.0.36:6000/runmodel")
//        guard let requestUrl = url else { fatalError() }
//        var request = URLRequest(url: requestUrl)
//        request.httpMethod = "POST"
//        request.httpBody = "\(str)".data(using: .utf8)
//        let (data, response) = try await URLSession.shared.data(for: request)
//        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }
////        let responseString = String(data: data,encoding: .utf8)
//        let responseString = try JSONDecoder().decode(product.self, from: data)
//        let name = responseString.name
//        let b64string = responseString.b64string
//        let imageData = Data(base64Encoded: b64string, options: .ignoreUnknownCharacters)
//        let image = UIImage(data: imageData!)
//        return (image!, name)
//    }
    // new post function based on Django backend
    func Post(image:UIImage) async throws -> (UIImage,String){
        
        struct product: Codable {
            var id: Int
            var origin_image: String
            var update_image: String
        }
        
        struct DecodableType: Decodable { let origin_image: String }
        let url = URL(string: "http://10.0.0.221:8000/api/recognition/recognition/")
//        let url = URL(string: "http://127.0.0.1:8000/api/recognition/recognition/1/prediction/")
        guard let requesturl = url else { fatalError() }
//        let imageData = image.jpegData(compressionQuality: 1)
        let imageData =  image.jpegData(compressionQuality: 0.7)

        // create a recognition and get id from response
        var request_creat = URLRequest(url: requesturl)
        request_creat.httpMethod = "POST"
        let form_create = MultipartForm(parts: [
            MultipartForm.Part(name: "description", value: "test description"),
            MultipartForm.Part(name: "origin_image", data: imageData!, filename: "123.jpg", contentType: "image/jpeg"),
        ])
        request_creat.setValue(form_create.contentType, forHTTPHeaderField: "Content-Type")
        request_creat.setValue("Token eadd4c6198cf8c024e0bfbbb80dd203d74b012cf", forHTTPHeaderField: "Authorization")
        
        request_creat.httpBody = form_create.bodyData
        
        let (data, response) = try await URLSession.shared.data(for: request_creat)
        guard (response as? HTTPURLResponse)?.statusCode == 201 else { fatalError("Error while fetching data") }
//        let responseString = String(data: data,encoding: .utf8)
        let responseString = try JSONDecoder().decode(product.self, from: data)
        let imagepath = responseString.update_image
        id = responseString.id
//        print(id)
//        print(imagepath)
        
        let date = NSData(contentsOf: URL(string: imagepath)!)
        return (UIImage(data: date! as Data)!, "name")
    }
    
    func PostData(image:UIImage) async->(UIImage, String){
        do {
            let (image, name) = try await Post(image: image)
            return (image, name)
        } catch {
            print("Error", error)
        }
        return (image, "")
    }
    
    func PostRectandName(image:UIImage, _ name:String, _ rect:[CGRect]) async-> String{
        do {
            let success = try await Post_finish(image: image, name, rect)
            return success
        } catch {
            print("Error in finish post", error)
        }
        return "error"
    }
    func Post_finish(image:UIImage, _ name:String, _ rect:[CGRect]) async throws -> String{
        
        struct product: Codable {
            var update_pos: String
            var update_image: String
        }
        var rectstring = ""
        for r in rect {
            let text = NSCoder.string(for: r)
            rectstring = rectstring + text
        }
        
        let imageData =  image.jpegData(compressionQuality: 0.7)
        struct DecodableType: Decodable { let origin_image: String }
        var urlstirng = "http://10.0.0.221:8000/api/recognition/recognition/"
        urlstirng += String(id)
        urlstirng += "/update-image/"
        let url = URL(string: urlstirng)
    
        guard let requesturl = url else { fatalError() }


        // create a recognition and get id from response
        var request_creat = URLRequest(url: requesturl)
        request_creat.httpMethod = "POST"
        let form_create = MultipartForm(parts: [
            MultipartForm.Part(name: "update_pos", value: rectstring),
            MultipartForm.Part(name: "update_image", data: imageData!, filename: "123.jpg", contentType: "image/jpeg"),
        ])
        request_creat.setValue(form_create.contentType, forHTTPHeaderField: "Content-Type")
        request_creat.setValue("Token eadd4c6198cf8c024e0bfbbb80dd203d74b012cf", forHTTPHeaderField: "Authorization")
        
        request_creat.httpBody = form_create.bodyData
        
        let (data, response) = try await URLSession.shared.data(for: request_creat)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }
//        let responseString = String(data: data,encoding: .utf8)
        let responseString = try JSONDecoder().decode(product.self, from: data)
        let imagepath = responseString.update_image
        let update_pos = responseString.update_pos
//        print(update_pos)
//        print(imagepath)
        
        
//        let str = image.jpegData(compressionQuality: 0.7)?.base64EncodedString() ?? ""
//        let json: [String: Any] = ["name": name,
//                                   "rectangle": rectstring,
//                                   "imageb64": str]
//        let jsonData = try? JSONSerialization.data(withJSONObject: json)
//
//        let url = URL(string: "http://10.0.0.36:6000/savemodify")
//        guard let requestUrl = url else { fatalError() }
//        var request = URLRequest(url: requestUrl)
//        request.httpMethod = "POST"
//        request.httpBody = jsonData
//        let (_, response) = try await URLSession.shared.data(for: request)
//        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching finish data") }
////        let responseString = String(data: data,encoding: .utf8)
        if ((response as? HTTPURLResponse)?.statusCode == 200){
            return "success"
        }else{
            return "error"
        }
    }
    
    private func createHttpBody(binaryData: Data, mimeType: String) -> Data {
        var parameters: Parameters? {
            return [
                "origin_image": Data.self
            ]
        }
//        let boundary = "Boundary-\(NSUUID().uuidString)"
        let boundary = "example.boundary.\(ProcessInfo.processInfo.globallyUniqueString)"
        var postContent = "--\(boundary)\r\n"
//        let fileName = "\(UUID().uuidString).jpeg"
        let fileName = "123.jpeg"
        let fieldName = "origin_image"
//        postContent += "Content-Disposition: form-data; name=\"\(fieldName)\"\r\n"
        postContent += "Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n"
//        postContent += filename=\"\(fileName)\"\r\n"
        print(postContent)
        postContent += "Content-Type: \(mimeType)\r\n"
        postContent += "\r\n"
        
        
        var data = Data()
        guard let postData = postContent.data(using: .utf8) else { return data }
        data.append(postData)
        data.append(binaryData)
        guard let end = "\r\n".data(using: .utf8) else { return data }
        data.append(end)

//        if let parameters = parameters {
//            var content = ""
//            parameters.forEach {
//                content += "\r\n--\(boundary)\r\n"
//                content += "Content-Disposition: form-data; name=\"\($0.key)\"\r\n\r\n"
//                content += "\($0.value)"
//            }
//            if let postData = content.data(using: .utf8) { data.append(postData) }
//        }
//        guard let endData = "\r\n--\(boundary)--\r\n".data(using: .utf8) else { return data }
        guard let endData = "--\(boundary)--\r\n".data(using: .utf8) else { return data }
        data.append(endData)
//        print(data)
        return data
    }
    
}
