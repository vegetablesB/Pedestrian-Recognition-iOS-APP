//
//  Pedestrian_RecognitionApp.swift
//  Pedestrian Recognition
//
//  Created by Ning Cao on 3/22/22.
//

import SwiftUI

@main
struct Pedestrian_RecognitionApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ViewModel())
                .onAppear(){
                    UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                }
        }
    }
}
