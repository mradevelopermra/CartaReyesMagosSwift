//
//  EditView.swift
//  A letter to Santa
//
//  Created by Mariano Rodriguez Abarca on 29/08/23.
//

import SwiftUI

struct EditView: View {
    let items : ModeloLista
    @StateObject var viewModel = ViewModel()
    @State var text = ""
    @State var selectedImage: Image?
    @State var emptyImage: Image = Image(systemName: "photo.on.rectangle.angled")
    
    var currentImage: some View{
        if let selectedImage{
            return selectedImage
                .resizable()
                .scaledToFill()
                .frame(width: 300, height: 300)
        }else {
           return emptyImage
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40)
        }
    }
    
    var body: some View {
        ZStack{
            currentImage
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(items: ModeloLista(emoji: "", emojiFinal: "", nombre: "", descripcion: ""))
    }
}
