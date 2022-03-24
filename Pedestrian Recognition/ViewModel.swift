//
//  ViewModel.swift
//  Pedestrian Recognition
//
//  Created by Ning Cao on 3/22/22.
//

import SwiftUI

class ViewModel:ObservableObject {
    @Published var image: UIImage?
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
    }
    func Post(image:UIImage) async throws -> UIImage{
        let str = image.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
        
        let url = URL(string: "http://10.0.0.222:6000/test")
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
//        let postString = "data=\(str)"
//        let postData = postString.data(using: String.Encoding.utf8)
        request.httpMethod = "POST"
//        request.httpBody = postData
        request.httpBody = "data=\(str)".data(using: .utf8)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }
        let responseString = String(data: data,encoding: .ascii)
        let imageData = Data(base64Encoded: responseString!, options: .ignoreUnknownCharacters)
//        let imageData = Data(base64Encoded: str1)
        let image = UIImage(data: imageData!)
        return image!
    }
    
    func PostData(image:UIImage) async->UIImage{
        do {
            let image = try await Post(image: image)
            return image
        } catch {
                print("Error", error)
            
            }
        return image
    }
    
        
}
