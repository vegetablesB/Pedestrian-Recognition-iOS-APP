//
//  ContentView.swift
//  Pedestrian Recognition
//
//  Created by Ning Cao on 3/22/22.
//
import AVFoundation
import SwiftUI
import UIKit
import ToastUI
var Pp = [[CGPoint]]()
var rectList = [CGRect]()

struct ContentView: View {
    @EnvironmentObject var vm: ViewModel
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var ImageforDraw: UIImage? = nil
    @State private var isClear = false
    @State private var name: String = "123"
    @State private var presentingToast: Bool = false
    @State private var presentingToastNil: Bool = false
    @State private var presentingToastfinish: Bool = false
    @GestureState var press = false
    
    
    
    var body: some View {
        if ImageforDraw != nil {
            VStack {
                imageDrawingView
                Button("Finish") {
                    rectList = getrectlist(vm.image!, Pp)
//                    print(rectList)
                    self.ImageforDraw = nil
                }
                Button("Clear") {
                    isClear = true
                    Pp = [[]]
//                    CanvasViewWrapper.clear()
                }
                Button("Start") {
                    isClear = false
                }
            }
        } else {
            if horizontalSizeClass == .compact{
                NavigationView {
                    content
                }
            } else{
                content
            }
        }
    }
    
    var content: some View{
        VStack{
            if let image = vm.image{
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .scaleEffect(press ? 0.7: 1)
                        .gesture(LongPressGesture(minimumDuration: 1.2)
                            .updating($press) { currentState, gestureState,
                                    transaction in
                                gestureState = currentState
                                transaction.animation = Animation.easeIn(duration: 1.5)

                            }
                            .onEnded { finished in
                                presentingToastNil = true
                            }
                        )
                        .animation(Animation.spring(), value: press)
                        .toast(isPresented: $presentingToastNil) {
                              ToastView {
                                VStack {
                                  Text("Do you want to save the image")
                                    .padding(.bottom)
                                    .multilineTextAlignment(.center)
                                
                                    HStack{
                                        Button {
                                          presentingToastNil = false
                                          
                                        } label: {
                                          Text("CANCEL")
                                            .bold()
                                            .foregroundColor(.white)
                                            .padding(.horizontal)
                                            .padding(.vertical, 12.0)
                                            .background(Color.accentColor)
                                            .cornerRadius(8.0)
                                        }
                                        Button {
                                          UIImageWriteToSavedPhotosAlbum(vm.image!, nil, nil, nil)
                                          presentingToastNil = false
                                          
                                        } label: {
                                          Text("OK")
                                            .bold()
                                            .foregroundColor(.white)
                                            .padding(.horizontal)
                                            .padding(.vertical, 12.0)
                                            .background(Color.accentColor)
                                            .cornerRadius(8.0)
                                        }
                                    }
                                  
                                }
                              }
                      }
                            
                        
               
            }else{
                Image(systemName: "photo.fill")
                    .resizable()
                    .scaledToFit()
                    .opacity(0.6)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding(.horizontal)
            }
            HStack{
                Button("Camera") {
                    vm.source = .camera
                    vm.showPhotoPicker()
                }
                Button("Photos") {
                    vm.source = .library
                    vm.showPhotoPicker()
                }
                Button("Post") {
                    if vm.image == nil{
                        presentingToastNil = true
                    }
                    else{
                        presentingToast = true
                        Task.init{
                            (vm.image, name)=await vm.PostData(image: vm.image!)
//                            print(name)
                            presentingToast = false
                        }
                    }
                }.toast(isPresented: $presentingToast) {
                    print("Toast dismissed")
                  } content: {
                    ToastView("Loading...")
                  }
                  .toast(isPresented: $presentingToastNil) {
                        ToastView {
                          VStack {
                            Text("No image right now")
                              .padding(.bottom)
                              .multilineTextAlignment(.center)

                            Button {
                              presentingToastNil = false
                            } label: {
                              Text("OK")
                                .bold()
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                .padding(.vertical, 12.0)
                                .background(Color.accentColor)
                                .cornerRadius(8.0)
                            }
                          }
                        }
                }
                Button("Draw") {
                    if vm.originalImage == nil{
                        presentingToastNil = true
                    }
                    else{
                        self.ImageforDraw = vm.originalImage
                    }
                    
                }.toast(isPresented: $presentingToastNil) {
                    ToastView {
                      VStack {
                        Text("No image right now")
                          .padding(.bottom)
                          .multilineTextAlignment(.center)

                        Button {
                          presentingToastNil = false
                        } label: {
                          Text("OK")
                            .bold()
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .padding(.vertical, 12.0)
                            .background(Color.accentColor)
                            .cornerRadius(8.0)
                        }
                      }
                    }
            }
                
                Button("Finish"){
                    if vm.image == nil{
                        presentingToastNil = true
                    }
                    else{
                        presentingToastfinish = true
                        rectList = getrectlist(vm.originalImage!, Pp)
                        vm.image = drawOnImage(vm.originalImage!, rectList)
                        Task.init{
                            let answer = await vm.PostRectandName(image: vm.image!, name, rectList)
//                            print(name)
                            print(answer)
                        }
//                        presentingToastfinish = false
                    }
                }.toast(isPresented: $presentingToastfinish, dismissAfter: 1.2) {
                    ToastView {
                      VStack {
                        Text("Posting to the server")
                          .multilineTextAlignment(.center)
                      }
                    }
                  }
                .toast(isPresented: $presentingToastNil) {
                      ToastView {
                        VStack {
                          Text("No image right now")
                            .padding(.bottom)
                            .multilineTextAlignment(.center)

                          Button {
                            presentingToastNil = false
                          } label: {
                            Text("OK")
                              .bold()
                              .foregroundColor(.white)
                              .padding(.horizontal)
                              .padding(.vertical, 12.0)
                              .background(Color.accentColor)
                              .cornerRadius(8.0)
                          }
                        }
                      }
              }

            }
            Spacer()
        }
        .sheet(isPresented: $vm.showPicker){
            ImagePicker(sourceType: vm.source == .library ? .photoLibrary : .camera, selectedImage:$vm.image, image: $vm.originalImage)
            
        }
        .navigationTitle("Pedestrian Recognition")
    }
    
    var imageDrawingView: some View {
            ZStack(alignment: .top) {
                if let image = ImageforDraw {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(minWidth: 0, maxWidth: .infinity)
                }
                CanvasViewWrapper(isClear: $isClear)
            }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ViewModel())
    }
}

func drawOnImage(_ image: UIImage, _ rectlist: [CGRect]) -> UIImage {
     
    // Create a context of the starting image size and set it as the current one
    UIGraphicsBeginImageContext(image.size)
     
    // Draw the starting image in the current context as background
    image.draw(at: CGPoint.zero)
     // Get the current context
     let context = UIGraphicsGetCurrentContext()!

     // Draw rectangles in rectlist
     context.setLineWidth(15)
     context.setStrokeColor(UIColor.green.cgColor)
     rectlist.forEach { (rect) in
         context.addRect(rect)
     }
     context.strokePath()
     
     // Save the context as a new UIImage
     let myImage = UIGraphicsGetImageFromCurrentImageContext()
     UIGraphicsEndImageContext()
     
     // Return modified image
    return myImage!
}

func getrectlist(_ image: UIImage, _ lines: [[CGPoint]])->[CGRect]{
    var start = CGPoint()
    var end = CGPoint()
    var result = [CGRect]()
    let ratio = image.size.width / UIScreen.main.bounds.width
    print(ratio)
    lines.forEach { (line) in
        for (i, p) in line.enumerated() {
            if i == 0 {
                start = p
            } else {
                end = p
            }
        }
        let rect = CGRect(x: (start.x)*ratio, y: start.y*ratio, width: (end.x - start.x)*ratio, height: (end.y-start.y)*ratio)
        print(rect)
        result.append(rect)
    }
    return result
}

