//
//  PromocionView.swift
//  A letter to Santa
//
//  Created by Mariano Rodriguez Abarca on 21/03/24.
//
import SwiftUI

struct PromocionView: View {
    @EnvironmentObject private var store: Store
    var body: some View {
        VStack {
            /*GIFView(gifName: "santa_buy")
                .frame(width: (UIScreen.screenWidth / 2) , height: (UIScreen.screenWidth / 2) )*/
            
            Text("Todas las tarjetas.")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            Text("Todas las imagenes 3D.")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            Text("Todas las cartas.")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            Text("Viaje reyes magos.")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            Text("Buenas acciones ilimitadas.")
                .font(.title)
                .fontWeight(.bold)
                .padding()
 
            
            /*Text("Custom Santa Call.")
                .font(.title)
                .fontWeight(.bold)
                .padding()*/
            
            /*Text("No Ads.")
                .font(.title)
                .fontWeight(.bold)
                .padding()*/

            HStack {
                /*Button(action: {
                    // Acción para el botón "Weekly"
                }) {
                    Text("Weekly")
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(width: 120, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                }*/

                Button(action: {
                    // Acción para el botón "Lifetime"
                    if let product = store.product(for: store.allBooks[0].id){
                        store.purchaseProduct(product: product)
                    }
                }) {
                    VStack {
                        Text("LIFETIME")
                            .font(.title)
                            .foregroundColor(.white)
                        Text(store.allBooks[0].price ?? "$1.99") // Precio debajo del texto
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                    .frame(width: 150, height: 80) // Ajusta el tamaño del botón
                    .background(Color(hex: 0xc09b28))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            
            Button("Restore purchase"){
                store.restorePurchase()
            }
        }
    }
}
