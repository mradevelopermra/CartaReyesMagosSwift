//
//  DalleUIView.swift
//  A letter to Santa
//
//  Created by Mariano Rodriguez Abarca on 28/08/23.
//

import SwiftUI

struct DalleUIView: View {
    
    @State private var texto = ""
    @State private var imagen: UIImage? = nil
    @State private var cargador = false
    
    @StateObject var dalle = DalleViewModel()
    
    var body: some View {
        NavigationStack{
            VStack{
                /*TextField("Describe el juguete que imaginas ", text: $texto)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(5...10)*/
                
                TextField("Describe el juguete que imaginas ", text: self.$texto)
                     .frame(height: 100).border(Color.red)
                     .lineLimit(5...10)
                     .textFieldStyle(RoundedBorderTextFieldStyle())
                     .cornerRadius(16)
                     .padding([.leading, .trailing], 5)
                
                Button {
                    cargador = true
                    imagen = nil
                    
                    
                     Task {
                        do {
                            let response = try await dalle.generarImagen(texto: texto)
                            if let url = response.data.map(\.url).first {
                                let (data,_) = try await URLSession.shared.data(from: url)
                                imagen = UIImage(data: data)
                                cargador = false
                            }
                        }catch {
                            print("Pasa \(Error.self)")
                            print(error)
                        }
                    }
                    
                    
                } label: {
                    Text("Crear")
                        .font(.title2)
                        .foregroundColor(.white)
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                
                if let imagen {
                    Image(uiImage: imagen)
                        .resizable()
                        .frame(width: 400, height: 400)
                    
                    Button("Guardar imagen"){
                        UIImageWriteToSavedPhotosAlbum(imagen, nil, nil, nil)
                    }
                } else {
                    if cargador {
                        ProgressView()
                    }
                }

                Spacer()
            }.padding(.all)
                .navigationTitle("Crea tus juguetes")
        }
    }
}
 
