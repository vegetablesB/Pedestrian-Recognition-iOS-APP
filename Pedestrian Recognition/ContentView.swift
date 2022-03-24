//
//  ContentView.swift
//  Pedestrian Recognition
//
//  Created by Ning Cao on 3/22/22.
//
import AVFoundation
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var vm: ViewModel
    var body: some View {
        NavigationView {
            VStack{
                if let image = vm.image{
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(minWidth: 0, maxWidth: .infinity)
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
                        Task.init{
                            vm.image=await vm.PostData(image: vm.image!)
                        }
                    }

                }
                Spacer()
            }
            .sheet(isPresented: $vm.showPicker){
                ImagePicker(sourceType: vm.source == .library ? .photoLibrary : .camera, selectedImage:$vm.image)
            }
            .navigationTitle("Pedestrian Recognition")
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ViewModel())
    }
}
