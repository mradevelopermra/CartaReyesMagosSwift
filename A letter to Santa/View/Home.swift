//
//  Home.swift
//  A letter to Santa
//
//  Created by Mariano Rodriguez Abarca on 17/08/23.
//

import SwiftUI

extension View {
    func printUI(_ args: Any..., separator: String = " ", terminator: String = "\n") -> EmptyView {
        let output = args.map(String.init(describing:)).joined(separator: separator)
        print(output, terminator: terminator)
        return EmptyView()
    }
}

struct Home: View {
    
    @StateObject var model = ViewModel()
    @StateObject var modelBuenasAcciones = ViewModelAcciones()
    @StateObject var modelCategoriaAcciones = ViewModelCategoriaAcciones()
    @FetchRequest(entity: Carta.entity(), sortDescriptors: [NSSortDescriptor(key: "fechaCreacion", ascending: true)], animation: .spring())
    var results : FetchedResults<Carta>
 
    @Environment(\.managedObjectContext) var context
    @State private var showingAlert = false
    @State private var  showVideoCallView = false
    @State private var  showingAlertCall = false
    @State private var showPromocionView = false
    @State private var showingAlertGoodDeed = false
    @State private var showGoodDeed = false
    @EnvironmentObject private var store: Store
    
    var body: some View {
        
        VStack{
            Button(action: {
                model.dibujaCarta = nil
                /*model.sigueCarta = nil
                model.creaJuguetes = nil
                model.enviaGlobo = nil*/
                
                if(results.count > 0){
                    
                    for item in results{
                         model.sendData(item: item)
                    }
 
                     
                }else{
                    
                    model.cleanup()
                     model.updateItem = nil
                    model.dibujaCarta = nil
                    /*model.enviaGlobo = nil
                    model.creaJuguetes = nil*/
                    model.show.toggle()
                }
                
            }){
                ///Text("Crear carta ")
                ///print("Nombre del niño esta vacio")
                Label {
                    Text(results.count <= 0 ?  "Escribe tu carta" : "Actualiza tu carta").foregroundColor(.white).bold()
                        .frame(maxWidth: .infinity)
                } icon: {
                    Image(systemName: "crown.fill").foregroundColor(.white)
                }
                
            }.padding()
                //.frame(width: UIScreen.main.bounds.width - 30 )
                .backgroundStyle(Color.blue)
                .cornerRadius(0)
                .buttonStyle(.borderedProminent)
                .tint(Color(hex: 0x2d572c))
             .sheet(isPresented: $model.show, content: {
                   addView(model: model)
                
            })
            

            
            NavigationStack {
                /*VStack(alignment: .leading){
                    let nombreLabel = "My name is: "
                    let nombreValor =  ""
                    let nombreNino = nombreLabel + nombreValor
                    Text(nombreNino).font(.title).bold().foregroundColor(.blue)
                    let edadLabel = "Age: "
                    let edadValor =  ""
                    let edadNino = edadLabel + edadValor
                    Text(edadNino)
                    Text("For this year, I would like:")
                    let opcionUnoLabel = "* 1: "
                    let opcionUnoValor =  ""
                    let opcionUnoNino = opcionUnoLabel + opcionUnoValor
                    Text(opcionUnoNino)
                    let opcionDosLabel = "* 2: "
                    let opcionDosValor =  ""
                    let opcionDosNino = opcionDosLabel + opcionDosValor
                    Text(opcionDosNino)
                    let opcionTresLabel = "* 3: "
                    let opcionTresValor =  ""
                    let opcionTresNino = opcionTresLabel + opcionTresValor
                    Text(opcionTresNino)
                    let sePortoLabel = "In 2023, I have been: "
                    let sePortoValor =  ""
                    let sePortoNino = sePortoLabel + sePortoValor
                    Text(sePortoNino)
                     
                }*/
                List{
                    
                    if(results.count > 0){
                        ForEach(results){ item in
                            VStack(alignment: .leading){
                                self.printUI("nombreNino", item.nombreNino ?? "")
                                let nombreLabel = "Mi nombre es: "
                                let nombreValor = item.nombreNino ?? ""
                                let nombreNino = nombreLabel + nombreValor
                                Text(nombreNino).font(.title).bold().foregroundColor(.blue)
                                let edadLabel = "Edad: "
                                let edadValor = item.edad ?? ""
                                let edadNino = edadLabel + edadValor
                                Text(edadNino)
                                Text("Este año, me gustaría: ")
                                let opcionUnoLabel = "* 1: "
                                let opcionUnoValor = item.opcionUno ?? ""
                                let opcionUnoNino = opcionUnoLabel + opcionUnoValor
                                Text(opcionUnoNino)
                                let opcionDosLabel = "* 2: "
                                let opcionDosValor = item.opcionDos ?? ""
                                let opcionDosNino = opcionDosLabel + opcionDosValor
                                Text(opcionDosNino)
                                let opcionTresLabel = "* 3: "
                                let opcionTresValor = item.opcionTres ?? ""
                                let opcionTresNino = opcionTresLabel + opcionTresValor
                                Text(opcionTresNino)
                                let sePortoLabel = "Este año, Me he portado: "
                                let sePortoValor = item.sePorto ?? ""
                                let sePortoNino = sePortoLabel + sePortoValor
                                Text(sePortoNino)
                                 
                            }.contextMenu(ContextMenu(menuItems: {
                                Button(action: {
                                    model.dibujaCarta = nil
     
                                     model.sendData(item: item)
                                    print("editar")
                                }){
                                    Label(title: {
                                        Text("Actualiza")
                                    }, icon: {
                                        Image(systemName: "pencil")
                                    })
                                }
                                
                                Button(action: {
                                    model.deleteData(item: item, context: context)
                                    print("eliminar")
                                }){
                                    Label(title: {
                                        Text("Eliminar")
                                    }, icon: {
                                        Image(systemName: "trash")
                                    })
                                }
                            }))
                            
                            
                        }
                    }else{
                        let nombreLabel = "Mi nombre es: "
                        let nombreValor =  ""
                        let nombreNino = nombreLabel + nombreValor
                        Text(nombreNino).font(.title).bold().foregroundColor(.blue)
                        let edadLabel = "Edad: "
                        let edadValor =  ""
                        let edadNino = edadLabel + edadValor
                        Text(edadNino)
                        Text("Este año, me gustaría:")
                        let opcionUnoLabel = "* 1: "
                        let opcionUnoValor =  ""
                        let opcionUnoNino = opcionUnoLabel + opcionUnoValor
                        Text(opcionUnoNino)
                        let opcionDosLabel = "* 2: "
                        let opcionDosValor =  ""
                        let opcionDosNino = opcionDosLabel + opcionDosValor
                        Text(opcionDosNino)
                        let opcionTresLabel = "* 3: "
                        let opcionTresValor =  ""
                        let opcionTresNino = opcionTresLabel + opcionTresValor
                        Text(opcionTresNino)
                        let sePortoLabel = "Este año, Me he portado: "
                        let sePortoValor =  ""
                        let sePortoNino = sePortoLabel + sePortoValor
                        Text(sePortoNino)
                    }
                    
                }.navigationTitle("Mi carta")
                    .listStyle(PlainListStyle())
                    .foregroundColor(Color(hex: 0xc09b28))
                    /*.navigationBarItems(trailing:
                                Button(action:{
                                     model.show.toggle()
                                }){
                                     Image(systemName: "plus")
                                        .font(.title)
                                        .foregroundColor(.blue)
                                }
                    )*/
                }.sheet(isPresented: $model.show, content: {
                     addView(model: model)
                   
               }).background(Color(hex: 0xd8ae2d))
            
 
            
            /*Button(action: {
                NavigationLink(
                    destination: MapaUIView()){
                            
                    }
                
            }){
 
                Label {
                    Text(results.count <= 0 ?  "Santa`s Journeyyy" : "ssSanta`s Journey").foregroundColor(.white).bold()
                        .frame(maxWidth: .infinity)
                } icon: {
                    Image(systemName: "crown.fill").foregroundColor(.white)
                }
                
            }.padding()
 
                .backgroundStyle(Color.blue)
                .cornerRadius(0)
                .buttonStyle(.borderedProminent)
                .tint(Color(hex: 0x2d572c))*/
            VStack {
                VStack {
                    
                    Button {
                        showingAlertGoodDeed = true
                    } label: {
                        Label {
                            Text("Buenas acciones").foregroundColor(.white).bold()
                                .frame(maxWidth: .infinity)
                        } icon: {
                            Image(systemName: "heart.fill").foregroundColor(.white)
                        }
                    }
                    .padding()
                    .background(Color(hex: 0x2d572c))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(20)
                    .alert(isPresented: $showingAlertGoodDeed) {
                        Alert(
                            title: Text("Buenas acciones"),
                            message: Text(
                                results.count > 0 ? "Agrega buenas acciones" : "Por favor guarda tu carta, antes de agregar buenas acciones."),
                            primaryButton: .destructive(Text("Ok")) {
                                if results.count > 0 {
                                    showGoodDeed = true
                                }
                            },
                            secondaryButton: .cancel()
                        )
                    }
                    .sheet(isPresented: $showGoodDeed) {
                        addBuenasAccionesView(modelBuenaAccion: modelBuenasAcciones, modelCategoriaAccion: modelCategoriaAcciones)
                    }
                    
                    Button {
                        //showVideoCallView.toggle()
                        showingAlertCall = true
                    } label: {
                        Label {
                            Text("Selfie").foregroundColor(.white).bold()
                                .frame(maxWidth: .infinity)
                        } icon: {
                            Image(systemName: "video.fill.badge.plus").foregroundColor(.white)
                        }
                    }
                    .padding()
                    //.tint(Color(hex: 0xd8ae2d))
                    .background(Color(hex: 0x2d572c))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                     .padding(20)
                    .alert(isPresented: $showingAlertCall) {
                        Alert(
                            title: Text("Selfie"),
                            message: Text(
                                results.count > 0 ? "Carta virtual..." : "Por favor guarda tu carta, antes de hacer la carta virtual "),
                            primaryButton: .destructive(Text("Ok")) {
                                if results.count > 0 {
                                    // Cuando se presiona "Ok", configuramos la variable showVideoCallView
                                    showVideoCallView = true
                                }
                            },
                            secondaryButton: .cancel()
                        )
                    }
                    // Navegación a la vista VideoCallView
                    .sheet(isPresented: $showVideoCallView) {
                         //CamaraPruebasView()
                         //CamaraCartaPruebasView()
                        //ARVideoRecordingView()
                        //ARRecordingViewTres()
                        //ARModelView()
                        ListaModelosUIView()
                        //ARModelViewVideo()--video ar en desarrollo
                          //FotoUIView()
                          //FotoARView()
                    }
                    /*.sheet(isPresented: $showVideoCallView) {
                                VideoCallView()
                            }*/ 
                    Button {
                        showingAlert = true
                    }label: {
                        Label {
                            Text("Envia tu carta").foregroundColor(.white).bold()
                                .frame(maxWidth: .infinity)
                        } icon: {
                            Image(systemName: "pencil").foregroundColor(.white)
                        }
                    }.padding()
                    //.frame(width: UIScreen.main.bounds.width - 10)
                        .background(Color(hex: 0x2d572c))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                         .padding(20)
                    //.buttonStyle(.borderedProminent)
                    .tint(Color(hex: 0x2d572c))
                    .alert(isPresented:$showingAlert) {
                        Alert(
                            title: Text("Dibuja"),
                            message: Text(
                                results.count>0  ? "Dibuja tus juguetes para los reyes magos y envia tu carta" :
                                
                                "Por favor guarda tu carta antes de enviarla"),
                            primaryButton: .destructive(Text("Ok")) {
                                if(results.count>0){
                                    model.updateItem = nil
                                    for item in results{
                                         model.sendDataDibujoCarta(item: item)
                                    }
                                }else{
                                    model.cleanup()
                                    model.updateItem = nil
                                     model.show.toggle()
                                }
                            },
                            secondaryButton: .cancel()
                        )
                    }
                    
                }
            }
            
            
            if !validaCompra() {
                VStack {
                    HStack(spacing: 20) {
                        // Botón "WEEKLY"
                        /*Button(action: {
                            // Agrega aquí la acción para el botón "WEEKLY"
                        }) {
                            VStack {
                                Text("WEEKLY")
                                    .font(.title)
                                    .foregroundColor(.white)
                                Text("$9.99") // Precio debajo del texto
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                            }
                         .frame(width: 150, height: 80) // Ajusta el tamaño del botón
                            .background(Color(hex: 0xc09b28))
                           .foregroundColor(.white)
                            .cornerRadius(10)
                        }*/
                        
                        // Botón "LIFETIME"
                                    Button(action: {
                                        // Agrega aquí la acción para el botón "LIFETIME"
                                        showPromocionView.toggle()
                                    }) {
                                        VStack {
                                            Text("LIFETIME")
                                                .font(.title)
                                                .foregroundColor(.white)
                                            Text( "$0.99") // Precio debajo del texto
                                                .font(.subheadline)
                                                .foregroundColor(.white)
                                        }
                                        .frame(width: 150, height: 80) // Ajusta el tamaño del botón
                                        .background(Color(hex: 0xc09b28))
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                    }
                                    .sheet(isPresented: $showPromocionView) {
                                        PromocionView()
                                    }
                    }
                }
            } else {
            }
            
 
            
        }.padding(.bottom, 20)
             .background(Color(hex: 0xEC8F12))
            /*.background( Image("carta_reyes_magos_fondo") // Reemplaza "tuImagenDeFondo" con el nombre real de tu imagen de fondo
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight )
                                    .edgesIgnoringSafeArea(.all))*/
    }
    
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
    

}

 
extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}
