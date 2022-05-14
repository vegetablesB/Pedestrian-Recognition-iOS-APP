//
//  CanvasViewWrapper.swift
//  Pedestrian Recognition
//
//  Created by Ning Cao on 4/10/22.
//

import SwiftUI
import UIKit
struct CanvasViewWrapper: UIViewRepresentable {
    @Binding var isClear: Bool
//    @Binding var imageX: CGFloat
//    @Binding var imageY: CGFloat
    func makeUIView(context: Context) -> CanvasView {
        return CanvasView(isClear)
    }
    func updateUIView(_ uiView: CanvasView, context: Context) {
        uiView.backgroundColor = .clear
        if(self.isClear){
            uiView.clear()
        }
    }
    func makeCoordinator() -> Coordinator {
        Coordinator()
        
    }
    
    func clear(){
        self.isClear = false
    }
    
    class Coordinator: NSObject {
//        var parent: CanvasViewWrapper
//        init(_ parent: CanvasViewWrapper) {
//            self.parent = parent
//        }
        
    }
}

