//
//  MenuView.swift
//  A letter to Santa
//
//  Created by Mariano Rodriguez Abarca on 13/09/23.
//

import SwiftUI

struct MenuView: View {
    
    @Binding var showMenu : Bool
    
    var body: some View {
        NavigationView{
            ScrollView(showsIndicators: false) {
                CategoryView(showMenu: $showMenu)
            }.navigationTitle("Choose")
        }
    }
}


struct GridView: View {
    
    @Binding var showMenu : Bool
    var title : String
    var items : [Model]
    let gridItem = [GridItem(.fixed(150))]
    @EnvironmentObject var settings : Settings
    
    var body: some View {
        VStack(alignment: .leading){
            Text(title)
                .font(.title)
                .padding(.leading, 22)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: gridItem, spacing: 10) {
                    ForEach(0..<items.count, id:\.self){ index in
                        let model = items[index]
                        Button {
                            print("seleccionar modelo")
                            model.loadModel()
                            settings.selectedModel = model
                            showMenu.toggle()
                        } label: {
                            Image(uiImage: model.thumbnail)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 200)
                                .background(Color.white)
                                .cornerRadius(8.0)
                        }

                    }
                }
            }
            .padding(.horizontal, 23)
            .padding(.vertical, 10)
            
        }
    }
    
    func saveImage(image: UIImage) {
 
        // saving to album
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
 
    }
}

/*struct GridView: View {
    //@EnvironmentObject private var store: Store
    @State private var showingAlert = false
    @Binding var showMenu : Bool
    var title : String
    var items : [Model]
    let gridItem = [GridItem(.fixed(150))]
    @EnvironmentObject var settings : Settings
    @State private var isLoading = true
    
    var body: some View {
        VStack(alignment: .leading){
            Text(title)
                .font(.title)
                .padding(.leading, 22)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: gridItem, spacing: 10) {
                    ForEach(0..<items.count, id:\.self){ index in
                        let model = items[index]
                        Button {

                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                                    .padding()
                                    .background(.black)
                            } else {
                 
                            }
                            


                            
                           if validaCompra(){
                                 print("seleccionar modelo")
                                model.loadModel()
                                settings.selectedModel = model
                                showMenu.toggle()
                               
                               
                               DispatchQueue.main.async {
                                   print("seleccionar modelo")
                                   model.loadModel()
                                   settings.selectedModel = model
                                   settings.confirmedModel = settings.selectedModel
                                   settings.selectedModel = nil
                                   isLoading = false
                                   showMenu.toggle()
                               }
                               
                             }else {
                                showingAlert = true
                            }
                            
                        } label: {
                            Image(uiImage: model.thumbnail)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 200)
                                .background(Color.white)
                                .cornerRadius(8.0)
                        }
                        .alert(isPresented:$showingAlert) {
                            Alert(
                                title: Text("3D Images"),
                                message: Text( "Please buy all items, Post cards and Santa Tracker for $1.99, before to create a scene"),
                                primaryButton: .destructive(Text("Buy")) {
                                    if let product = store.product(for: store.allBooks[2].id){
                                        store.purchaseProduct(product: product)
                                    }
                                },
                                secondaryButton: .cancel()
                            )
                        }

                    }
                }
            }
            .padding(.horizontal, 23)
            .padding(.vertical, 10)
            
        }
    }
    
    func saveImage(image: UIImage) {
 
        // saving to album
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
 
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
}*/


struct CategoryView: View {
    
    @Binding var showMenu : Bool
    let models = Models()
    var body: some View {
        VStack(alignment: .center){
            ForEach(ModelCategory.allCases, id:\.self){ category in
                if let categorias = models.get(category: category) {
                    GridView(showMenu: $showMenu, title: category.label, items: categorias)
                }
            }
        }
    }
}
