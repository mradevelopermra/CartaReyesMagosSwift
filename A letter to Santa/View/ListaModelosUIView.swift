//
//  ListaModelosUIView.swift
//  A letter to Santa
//
//  Created by Mariano Rodriguez Abarca on 20/03/24.
//

import SwiftUI

// Estructura para representar un modelo identificable
struct ModelItem: Identifiable {
    var id = UUID()
    var modelName: String
}

struct ListaModelosUIView: View {
    @State private var selectedModel: ModelItem?

    let modelos = [
        "tiara",
        "sombrero_bruja_morado",
        "gorro_santa_roblox",
        "gorro_luces",
        "gorro_cuadrado_orejas",
        "gorro_bolita_santa",
        "cute_crown",
        "corona_rosa",
        "corona_p_rojas",
        "corona_colores",
        "corona_bowsete",
        "corona_azul"
    ]

    var body: some View {
        // Instrucciones
           Text("Selecciona un sombrero para tomarte una selfie que podrás agregar en tú carta de los Reyes Magos")
               .padding()
               .foregroundColor(.black)
               .font(.headline)
           
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 20) {
                ForEach(modelos, id: \.self) { modelo in
                    Button(action: {
                        // Al seleccionar un modelo, guardamos su nombre
                        selectedModel = ModelItem(modelName: modelo)
                    }) {
                        VStack {
                            Image(modelo)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                            //Text(modelo)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
        .sheet(item: $selectedModel) { modelItem in
                   // Mostrar ARModelView con el modelo seleccionado
                   ARModelView(modelName: modelItem.modelName, onClose: { selectedModel = nil })
               }
    }
}

 
