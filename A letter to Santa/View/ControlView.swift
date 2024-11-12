//
//  ControlView.swift
//  A letter to Santa
//
//  Created by Mariano Rodriguez Abarca on 13/09/23.
//

import SwiftUI
import ARKit

struct ControlView: View {
     @EnvironmentObject private var store: Store
    @State private var showingAlertPlus = false
    @State private var showingAlertSave = false
    @State private var showingAlertBuy = false
    
    @Binding var showMenu : Bool
    var body: some View {
        VStack(alignment: .center){
            Spacer()
            HStack(alignment: .center){
                Button {
                     showMenu.toggle()
                    //showingAlertPlus = true
                } label: {
                    Image(systemName: "plus.app.fill")
                        .font(.system(size: 35))
                        .foregroundColor(.white)
                        .buttonStyle(PlainButtonStyle())
                }.alert(isPresented:$showingAlertPlus) {
                    Alert(
                        title: Text("Scene"),
                        message: Text( "Choose and move the camera to put the yellow box in a flat place"),
                        primaryButton: .destructive(Text("OK")) {
                            showMenu.toggle()
                        },
                        secondaryButton: .cancel()
                    )

                }
                .frame(width: 50, height: 50)
                .sheet(isPresented: $showMenu) {
                    MenuView(showMenu: $showMenu)
                }
                
                if validaCompra(){
                    Button {
 
                              // (Placeholder): Take a snapshot
                              ARViewContainer.arView.snapshot(saveToHDR: false) { (image) in
                                
                                // Compress the image
                                let compressedImage = UIImage(data: (image?.pngData())!)
                                // Save in the photo album
                                UIImageWriteToSavedPhotosAlbum(compressedImage!, nil, nil, nil)
                              }
                            print("imagen guardada")
                              showingAlertSave = true
 
     
                      } label: {
                        Image(systemName: "camera")
                          .frame(width:60, height:60)
                          .font(.title)
                          .background(.white.opacity(0.75))
                          .cornerRadius(30)
                          .padding()
                      }.alert(isPresented:$showingAlertSave) {
                          Alert(
                              title: Text("Imagen guardada"),
                              message: Text( "La imagen fue guardada en la galeria"),
                              dismissButton: .default(Text("OK" )))
     
                      }
                    
                }else {
                    Button {
  
                              // (Placeholder): Take a snapshot
                              ARViewContainer.arView.snapshot(saveToHDR: false) { (image) in
                                
                                // Compress the image
                                let compressedImage = UIImage(data: (image?.pngData())!)
                                // Save in the photo album
                                UIImageWriteToSavedPhotosAlbum(compressedImage!, nil, nil, nil)
                              }
                            print("imagen guardada")
 
                            showingAlertBuy = true
    
                      } label: {
                        Image(systemName: "camera")
                          .frame(width:60, height:60)
                          .font(.title)
                          .background(.white.opacity(0.75))
                          .cornerRadius(30)
                          .padding()
 
                      }
                      .alert(isPresented:$showingAlertBuy) {
                          Alert(
                              title: Text("Versión pro"),
                              message: Text( "Para tomr fotos, por favor, adquiere la versión PRO y tendrás acceso a todas las herramientas de la app por $0.99."),
                              dismissButton: .default(Text("OK" )))
                             /* primaryButton: .destructive(Text("Buy")) {
                                  if let product = store.product(for: store.allBooks[0].id){
                                      store.purchaseProduct(product: product)
                                  }
                              },
                              secondaryButton: .cancel()
                          )*/
                      }
                    
               }
                

  

 
                 Button  {
                     let lastIndex = ARViewContainer.arView.scene.anchors.count - 1
                     
                     if lastIndex > -1 {
                         ARViewContainer.arView.scene.anchors.remove(at: lastIndex)
                     }
                     print(ARViewContainer.arView.scene.anchors.count)
                 } label: {
                   Image(systemName: "arrowshape.turn.up.backward.fill")
                     .frame(width:60, height:60)
                     .font(.title)
                     .background(.white.opacity(0.75))
                     .cornerRadius(30)
                     .padding()
                 }
 
                /*if !validaCompra() {
                    Button  {
                        if let product = store.product(for: store.allBooks[0].id){
                            store.purchaseProduct(product: product)
                        }
      
                    print("comprar")
                    } label: {
                      Image(systemName: "cart.fill")
                        .frame(width:60, height:60)
                        .font(.title)
                        .background(.white.opacity(0.75))
                        .cornerRadius(30)
                        .padding()
                    }
       
                }else{

     
                }*/
     
 
            }
            .frame(maxWidth: 500)
            .padding(30)
            .background(Color.black.opacity(0.25))

        }.padding(.bottom, 50)
    }
    
     func validaCompra() -> Bool {
       var compro = false
        if  (store.allBooks[0].lock) {
            print("producto no comprado")
            compro = false
        }else{
            print("producto si comprado")
            compro = true
        }
       return compro
    }
}

 
