//
//  ContentMapView.swift
//  A letter to Santa
//
//  Created by Mariano Rodriguez Abarca on 24/09/23.
//
import SwiftUI
import MapKit
import UIKit
import ImageIO

struct ContentMapView: View {
    @State private var santaLocation = CLLocationCoordinate2D(latitude: 32.5420294, longitude: 44.4157977) // Ubicación del Polo Norte
    @State private var userLocation = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194) // Ubicación de San Francisco
    @State private var daysRemaining: Int = 0
    @State private var santaLocations: [SantaLocation] = []
    
    //Animacion para despues del conteo
    @State private var santaImageIndex = 0
    @State private var isGIFVisible = false
    @EnvironmentObject private var store: Store
     // Define una matriz de nombres de imágenes de Santa en orden de animación
     let santaImages = ["cartoon-santa.jpeg", "cartoon-santa.jpeg", "cartoon-santa.jpeg", "cartoon-santa.jpeg", "cartoon-santa.jpeg"]

    var body: some View {
        VStack {
            if daysRemaining > 1 { // Verifica si quedan más de 1 día
                MapView(santaLocation: $santaLocation, santaLocations: $santaLocations)
                    .frame(height: UIScreen.screenWidth)
            } else {
                Text("¡Feliz navidad!.")
                    .font(.headline)
                    .foregroundColor(.white)

                
                // Muestra la animación de Santa al finalizar el conteo
                                /*SantaAnimationView(santaImageIndex: $santaImageIndex, santaImages: santaImages)
                                    .frame(height: UIScreen.screenWidth)*/
                // Muestra la imagen GIF al finalizar el conteo
                /*Button(action: {
                        if let product = store.product(for: store.allBooks[0].id){
                            store.purchaseProduct(product: product)
                        }
      
                    print("editar")

                }){
                    Label(title: {
                        Text("Versión Pro: Todas las herramientas y el seguimiento de los reyes mapas por $0.99")
                    }, icon: {
                        Image(systemName: "pencil")
                    })
                }.padding()
                 .frame(width: UIScreen.main.bounds.width - 30 )
                .backgroundStyle(Color.blue)
                .cornerRadius(0)
                .buttonStyle(.borderedProminent)
                .tint(Color(hex: 0x2d572c))*/
 
            }
             
            Text("Faltan: \(daysRemaining) dias")
                .font(.headline)
                .foregroundColor(.white)
            /*Text("Versión Pro: Todas las herramientas y el mapa de los Reyes Magos por $0.99")
                .font(.headline)
                .foregroundColor(.white)*/
        }.background(Color(hex: 0xb8000e))
        .onAppear {
            // Calcula los días restantes hasta el 24 de diciembre de 2023
            /*let calendar = Calendar.current
            let currentDate = Date()
            let targetDateComponents = DateComponents(year: 2024, month: 01, day: 06)
            let targetDate = calendar.date(from: targetDateComponents)!*/
            let calendar = Calendar.current
            let currentDate = Date()
            let currentYear = calendar.component(.year, from: Date())
            var january6th = DateComponents(year: currentYear, month: 1, day: 6)

            // Verifica si la fecha actual ya ha pasado el 6 de enero de este año
            if Date() > calendar.date(from: january6th)! {
                // Incrementa el año en 1
                let nextYear = currentYear + 1
                january6th.year = nextYear
            }

            let targetDate = calendar.date(from: january6th)!


            daysRemaining = calendar.dateComponents([.day], from: currentDate, to: targetDate).day ?? 0

            // Inicia la cuenta regresiva (opcional)
            startCountdown()
        }
    }

    // Función para iniciar la cuenta regresiva (opcional)
    func startCountdown() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if daysRemaining > 0 {
                daysRemaining -= 1
                // Agrega un nuevo pin en la ubicación actual de Santa cada día
                updateSantaLocation()
            } else {
                timer.invalidate() // Detiene el temporizador cuando la cuenta regresiva ha terminado
                santaLocation = CLLocationCoordinate2D(latitude: 32.5420294, longitude: 44.4157977) // Ubicación del Polo Norte
 
 
                 santaLocations = []
            }
        }
    }

    // Función para actualizar la ubicación de Santa (esto debe basarse en tu propia lógica)
    func updateSantaLocation() {
        // Simulamos que Santa se mueve hacia San Francisco una cantidad fija cada día
        let latitudeChange = (userLocation.latitude - santaLocation.latitude) / Double(daysRemaining)
        let longitudeChange = (userLocation.longitude - santaLocation.longitude) / Double(daysRemaining)

        santaLocation.latitude += latitudeChange
        santaLocation.longitude += longitudeChange

        // Agregamos la ubicación actual de Santa al historial
        santaLocations.append(SantaLocation(coordinate: santaLocation))
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
 


// UIViewRepresentable para cargar y mostrar un GIF
struct GIFView: UIViewRepresentable {
    let gifName: String

    func makeUIView(context: Context) -> UIView {
        let containerView = UIView()
        return containerView
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        guard let gifUrl = Bundle.main.url(forResource: gifName, withExtension: "gif") else {
            return
        }

        guard let gifSource = CGImageSourceCreateWithURL(gifUrl as CFURL, nil) else {
            return
        }

        let gifCount = CGImageSourceGetCount(gifSource)

        var images: [UIImage] = []

        for i in 0..<gifCount {
            if let cgImage = CGImageSourceCreateImageAtIndex(gifSource, i, nil) {
                let uiImage = UIImage(cgImage: cgImage)
                images.append(uiImage)
            }
        }

        if images.count > 0 {
            let imageView = UIImageView()
            imageView.animationImages = images
            imageView.animationDuration = TimeInterval(images.count) * 0.1
            imageView.startAnimating()

            uiView.subviews.forEach { $0.removeFromSuperview() } // Limpiar cualquier vista previa
            uiView.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                imageView.leadingAnchor.constraint(equalTo: uiView.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: uiView.trailingAnchor),
                imageView.topAnchor.constraint(equalTo: uiView.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: uiView.bottomAnchor)
            ])
        }
    }
    
    
}
 
struct SantaAnimationView: View {
    @Binding var santaImageIndex: Int
    let santaImages: [String]

    var body: some View {
        Image(santaImages[santaImageIndex])
            .resizable()
            .aspectRatio(contentMode: .fit)
            .onAppear {
                // Inicia la animación de cambio de imagen
                startAnimation()
            }
    }

    func startAnimation() {
        let animationDuration = 0.5 // Ajusta la duración de la animación
        let totalImages = santaImages.count

        // Crea una secuencia de animación infinita
        withAnimation(.linear(duration: animationDuration)) {
            Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: true) { timer in
                santaImageIndex = (santaImageIndex + 1) % totalImages
            }
        }
    }
}

struct SantaLocation: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
}

struct MapView: View {
    @Binding var santaLocation: CLLocationCoordinate2D
    @Binding var santaLocations: [SantaLocation]

    var body: some View {
        Map(coordinateRegion: .constant(
            MKCoordinateRegion(
                center: santaLocation,
                span: MKCoordinateSpan(latitudeDelta: 30.0, longitudeDelta: 30.0)
            )
        ), showsUserLocation: false, userTrackingMode: .constant(.none), annotationItems: santaLocations) { location in
            MapPin(coordinate: location.coordinate, tint: .red)
        }
        .frame(height: UIScreen.screenWidth)
    }
}
