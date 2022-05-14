//
//  ViewModel.swift
//  Pedestrian Recognition
//
//  Created by Ning Cao on 3/22/22.
//
// view model and post function to server
import SwiftUI

class ViewModel:ObservableObject {
    @Published var image: UIImage?
    @Published var originalImage: UIImage?
    @Published var showPicker = false
    @Published var source: Picker.Source = .library
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
    func Post(image:UIImage) async throws -> (UIImage,String){
        struct product: Codable {
            var name: String
            var b64string: String
        }
        let str = image.jpegData(compressionQuality: 0.3)?.base64EncodedString() ?? ""
        
        let url = URL(string: "http://10.0.0.36:6000/runmodel")
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        request.httpBody = "\(str)".data(using: .utf8)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }
//        let responseString = String(data: data,encoding: .utf8)
        let responseString = try JSONDecoder().decode(product.self, from: data)
        let name = responseString.name
        let b64string = responseString.b64string
        let imageData = Data(base64Encoded: b64string, options: .ignoreUnknownCharacters)
        let image = UIImage(data: imageData!)
        return (image!, name)
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
        var rectstring = ""
        for r in rect {
            let text = NSCoder.string(for: r)
            rectstring = rectstring + text
        }
        let str = image.jpegData(compressionQuality: 0.7)?.base64EncodedString() ?? ""
        let json: [String: Any] = ["name": name,
                                   "rectangle": rectstring,
                                   "imageb64": str]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
//        let url = URL(string: "http://10.0.0.36:6000/savemodify")
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        let (_, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching finish data") }
//        let responseString = String(data: data,encoding: .utf8)
        if ((response as? HTTPURLResponse)?.statusCode == 200){
            return "success"
        }else{
            return "error"
        }
    }
    
}
