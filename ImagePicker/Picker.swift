//
//  Picker.swift
//  Pedestrian Recognition
//
//  Created by Ning Cao on 3/22/22.
//

import Foundation
import UIKit

enum Picker{
    enum Source: String{
        case library, camera
    }
    static func checkPermissions() -> Bool{
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            return true
        }else{
            return false
        }
    }
}
