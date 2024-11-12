//
//  ContentView.swift
//  A letter to Santa
//
//  Created by Mariano Rodriguez Abarca on 17/08/23.
//

import SwiftUI
import CoreData
import MapKit

struct ContentView: View {
    @EnvironmentObject private var store: Store
    var body: some View {
        //Home()
        

        TabView{
 
            Home()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            

 
            /*DalleUIView()
                .tabItem {
                    Image(systemName: "doc.text.image")
                    Text("Dale 2")
                }*/

 
            //ColorableImageView()
            //ListaPodCardsView()
            ContentDibujoView()
            //EnviaCartaUIView()
                .tabItem {
                    Image(systemName: "hand.draw.fill")
                    Text("Tarjetas")
                }
            

            
            HomeCamaraView()
          //USDZView()
          //ARFaceTrackingView()

              .tabItem {
                  Image(systemName: "sparkles.tv.fill")
                  Text("Escenas")
              }
            
            //ContentMapUserView()
            //ContentMapView()
            ValidaCompraMapaUIView()
                .tabItem {
     
                    Image(systemName: "map.fill")
                    Text("Mapa Reyes Magos")
                }
 
              

        }
        

    }

 

}

 
