//
//  ValidaCompraMapaUIView.swift
//  A letter to Santa
//
//  Created by Mariano Rodriguez Abarca on 01/10/23.
//
import SwiftUI
 
struct ValidaCompraMapaUIView: View {
    @EnvironmentObject private var store: Store
    
    // Define la función validaCompra() aquí, fuera del cuerpo de la vista
    func validaCompra() -> Bool {
        var compro = false
        if store.allBooks.isEmpty {
            print("El array de libros está vacío")
            compro = false
        } else if store.allBooks[0].lock {
            print("Producto no comprado")
            compro = false
        } else {
            print("Producto sí comprado")
            compro = true
        }
        return compro
    }
    
    var body: some View {
        VStack {
            if !validaCompra() {
                ContentMapView()
            } else {
                ContentMapUserView()
            }
        }
    }
}
