//
//  CanvasView.swift
//  Pedestrian Recognition
//
//  Created by Ning Cao on 4/10/22.
//

import SwiftUI
import Foundation
import UIKit

class CanvasView: UIView {
    @Published var photo: UIImage?
    @Published var lines = [[CGPoint]]()
//    @State private var imageX: CGFloat
//    @State private var imageY: CGFloat
    @State private var isClear: Bool
    public init(_ isClear: Bool){
//        self.imageX = x
//        self.imageY = y
        self.isClear = isClear
        super.init(frame: .zero)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clear() {
        lines.removeAll()
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect){
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        var start = CGPoint()
        var end = CGPoint()
        lines.forEach { (line) in
            for (i, p) in line.enumerated() {
                print(p.x,p.y)
                if i == 0 {
                    context.move(to: p)
                    start = p
                } else {
                    end = p

                }
            }
            let rect = CGRect(x: start.x, y: start.y, width: end.x - start.x, height: end.y-start.y)
            context.addRect(rect)
        }
        
        
        
        context.setLineWidth(5)
        
        context.strokePath()
    }
    
    @Published var paths = [Path]()
//    var tempoint = Path()
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lines.append([CGPoint]())
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        guard var lastLine = lines.popLast() else { return }
        lastLine.append(point)
        lines.append(lastLine)
        Pp = lines
        setNeedsDisplay()
    }
    
    
}

struct Path {
    let type: PathType
    let startpoint: CGPoint
    let endpoint: CGPoint
    
    init(type: PathType, startpoint: CGPoint, endpoint: CGPoint) {
        self.type = type
        self.startpoint = startpoint
        self.endpoint = endpoint
    }
    
    enum PathType {
        case move
        case line
    }
}

