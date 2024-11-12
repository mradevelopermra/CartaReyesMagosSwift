//
//  ContentMapUserView.swift
//  A letter to Santa
//
//  Created by Mariano Rodriguez Abarca on 28/09/23.
//
import SwiftUI
import MapKit
import CoreLocation
import Combine

struct ContentMapUserView: View {
     //@State private var santaLocation = CLLocationCoordinate2D(latitude: 90.0, longitude: 0.0) // Ubicación del Polo Norte
    @State private var santaLocation = CLLocationCoordinate2D(latitude: 32.5420294, longitude: 44.4157977) // Ubicación del Polo Norte
    @State private var userLocation: CLLocationCoordinate2D?
    @ObservedObject var locationManager = LocationManager()
    
    @State private var userLocationObtained = false
    @State private var daysRemaining: Int = 0
    @State private var santaLocations: [SantaUserLocation] = []
    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 34, longitude: 0.0),
        span: MKCoordinateSpan(latitudeDelta: 100.0, longitudeDelta: 100.0)
    )
    //Animacion para despues del conteo
    @State private var santaImageIndex = 0
    @State private var isGIFVisible = false

    var body: some View {
        VStack {
            if daysRemaining > 1 {
                MapUserView(userLocation: userLocation, santaLocation: $santaLocation, mapRegion: $mapRegion, daysRemaining: $daysRemaining, santaLocations: $santaLocations)
                    .frame(height: UIScreen.main.bounds.width)
            } else {
 
                Text("¡Feliz navidad!") // Puedes personalizar el mensaje
                    .font(.headline)
                
                // Muestra la animación de Santa al finalizar el conteo
                                /*SantaAnimationView(santaImageIndex: $santaImageIndex, santaImages: santaImages)
                                    .frame(height: UIScreen.screenWidth)*/
                // Muestra la imagen GIF al finalizar el conteo
                GIFView(gifName: "picmix.com_1757429")
                    .frame(width: UIScreen.screenWidth, height: UIScreen.screenWidth)
                    .onAppear {
                        isGIFVisible = true
                    }
            }

            /*Text("Días Restantes: \(daysRemaining)")
                .font(.headline)*/
        }
        .onAppear {
            /*let calendar = Calendar.current
            let currentDate = Date()
            let targetDateComponents = DateComponents(year: 2024, month: 01, day: 06)
            let targetDate = calendar.date(from: targetDateComponents)!*/
            
            let calendar = Calendar.current
            let currentDate = Date()

            // Obtener el año actual
            let currentYear = calendar.component(.year, from: currentDate)

            // Definir el 6 de enero del año actual
            var targetDateComponents = DateComponents(year: currentYear, month: 1, day: 6)

            // Verificar si la fecha actual ya ha pasado el 6 de enero de este año
            if currentDate > calendar.date(from: targetDateComponents)! {
                // Incrementar el año en 1
                targetDateComponents.year! += 1
            }

            // Obtener la fecha objetivo
            let targetDate = calendar.date(from: targetDateComponents)!


            daysRemaining = calendar.dateComponents([.second], from: currentDate, to: targetDate).second ?? 0

            if !userLocationObtained {
                if let location = locationManager.userLocation {
                    userLocation = location
                    userLocationObtained = true
                }
            }


            startCountdown()
        }
    }
    

    func startCountdown() {
        let calendar = Calendar.current
        let targetDateComponents = DateComponents(year: 2023, month: 12, day: 24)
        let targetDate = calendar.date(from: targetDateComponents)!

        var initialDistance: Double = 0.0 // Declarar initialDistance aquí

        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            let currentDate = Date()

            if currentDate < targetDate {
                let timeRemaining = calendar.dateComponents([.second], from: currentDate, to: targetDate)

                if let totalSecondsRemaining = timeRemaining.second, totalSecondsRemaining > 0 {
                    
                    if let userCoordinate = userLocation {
                        initialDistance = calculateDistanceBetweenCoordinates(coordinate1: santaLocation, coordinate2: userCoordinate)
                        // Resto del código que utiliza initialDistance
                    } else {
                        // Manejar el caso en el que userLocation es nil, por ejemplo, mostrando un mensaje de error o tomando alguna acción predeterminada.
                    }
     

                    let distancePerSecond = initialDistance / Double(totalSecondsRemaining)

                    updateSantaLocation(with: distancePerSecond)

                    daysRemaining = totalSecondsRemaining - 1

                    // Agregar una nueva ubicación de Santa al historial cada segundo
                    santaLocations.append(SantaUserLocation(coordinate: santaLocation))
                }
            } else {
                timer.invalidate()
                santaLocation = CLLocationCoordinate2D(latitude: 32.5420294, longitude: 44.4157977)
 
                santaLocations = []
            }
        }

        RunLoop.main.add(timer, forMode: .common)
    }


    func updateSantaLocation(with distancePerSecond: Double) {
        guard let userLocation = userLocation else {
            return
        }

        let santaHeading = calculateHeading(from: santaLocation, to: userLocation)

        let newLatitude = santaLocation.latitude + (distancePerSecond * cos(santaHeading))
        let newLongitude = santaLocation.longitude + (distancePerSecond * sin(santaHeading))

        santaLocation = CLLocationCoordinate2D(latitude: newLatitude, longitude: newLongitude)
    }

    func calculateHeading(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) -> Double {
        let lat1 = source.latitude.toRadians()
        let lon1 = source.longitude.toRadians()
        let lat2 = destination.latitude.toRadians()
        let lon2 = destination.longitude.toRadians()

        let dLon = lon2 - lon1

        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)

        let heading = atan2(y, x)

        return (heading >= 0) ? heading : (heading + (2 * .pi))
    }

    func calculateDistanceBetweenCoordinates(coordinate1: CLLocationCoordinate2D, coordinate2: CLLocationCoordinate2D) -> Double {
        let earthRadius = 6371.0

        let lat1 = coordinate1.latitude.toRadians()
        let lon1 = coordinate1.longitude.toRadians()
        let lat2 = coordinate2.latitude.toRadians()
        let lon2 = coordinate2.longitude.toRadians()

        let dLat = lat2 - lat1
        let dLon = lon2 - lon1

        let a = sin(dLat / 2) * sin(dLat / 2) + cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2)
        let c = 2 * atan2(sqrt(a), sqrt(1 - a))

        let distance = earthRadius * c

        return distance
    }
}

struct SantaUserLocation: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
}

struct MapUserView: View {
    var userLocation: CLLocationCoordinate2D?
    @Binding var santaLocation: CLLocationCoordinate2D
    @Binding var mapRegion: MKCoordinateRegion
    @Binding var daysRemaining: Int
    @Binding var santaLocations: [SantaUserLocation]

    var body: some View {
        VStack {
            Text("Faltan: \(segundosADiasHorasMinutosSegundos(segundos: daysRemaining))  ")
 
                .font(.headline)
                .foregroundColor(.white)
        

             Map(coordinateRegion: .constant(mapRegion), showsUserLocation: false, userTrackingMode: .constant(.none), annotationItems: santaLocations) { location in
                MapPin(coordinate: location.coordinate, tint: .red)
              
                /*Map(coordinateRegion: .constant(mapRegion),
                       annotationItems: santaLocations) {
                    place in
                     MapAnnotation(coordinate: place.coordinate) {
                       PlaceAnnotationView()
                     }*/
                 
 
            }
        }.background(Color(hex: 0xb8000e))
        .frame(height: UIScreen.main.bounds.height - 200)
    }
    
    func segundosAHHMMSS(segundos: Int) -> String {
        let horas = segundos / 3600
        let minutos = (segundos % 3600) / 60
        let segundosRestantes = (segundos % 3600) % 60

        let horaString = String(format: "%02d", horas)
        let minutoString = String(format: "%02d", minutos)
        let segundoString = String(format: "%02d", segundosRestantes)

        return "\(horaString):\(minutoString):\(segundoString)"
    }
    
    func segundosADiasHorasMinutosSegundos(segundos: Int) -> String {
        let dias = segundos / 86400 // 86400 segundos en un día
        let horas = (segundos % 86400) / 3600 // 3600 segundos en una hora
        let minutos = (segundos % 3600) / 60
        let segundosRestantes = (segundos % 3600) % 60

        let diasString = String(format: "%02d", dias)
        let horasString = String(format: "%02d", horas)
        let minutosString = String(format: "%02d", minutos)
        let segundosString = String(format: "%02d", segundosRestantes)

        return "\(diasString) días \(horasString) horas \(minutosString) minutos \(segundosString) segundos"
    }

}



extension Double {
    func toRadians() -> Double {
        return self * .pi / 180.0
    }
}


struct PlaceAnnotationView: View {
  var body: some View {
    VStack(spacing: 0) {
      Image(systemName: "sparkles")
        .font(.title)
        .foregroundColor(.red)
      
      /*Image(systemName: "sparkles")
        .font(.caption)
        .foregroundColor(.red)
        .offset(x: 0, y: -5)*/
    }
  }
}

/*struct MapUserView: View {
   var userLocation: CLLocationCoordinate2D?
   @Binding var santaLocation: CLLocationCoordinate2D
   @Binding var mapRegion: MKCoordinateRegion
   @Binding var daysRemaining: Int
   @Binding var santaLocations: [SantaUserLocation]

   var body: some View {
       VStack {
           Text("Days Remaining: \(daysRemaining)")
               .font(.headline)

           Map(coordinateRegion: .constant(mapRegion), showsUserLocation: true, userTrackingMode: .constant(userLocation == nil ? .follow : .none), annotationItems: santaLocations) { location in
               MapPin(coordinate: location.coordinate, tint: .red) // Marcador rojo para Santa
           }
       }
       .frame(height: UIScreen.main.bounds.width)
   }
}*/


