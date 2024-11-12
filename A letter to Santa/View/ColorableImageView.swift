//
//  ColorableImageView.swift
//  A letter to Santa
//
//  Created by Mariano Rodriguez Abarca on 19/09/23.
//
 
import SwiftUI
import CoreGraphics

struct ColorableImageView: View {
    @State private var selectedColor: Color = .red
    @State private var coloredAreas: [ColorableArea] = []

    var body: some View {
        VStack {
            Image(uiImage: UIImage(named: "bota_dot.png")!) // Reemplaza "tu_imagen" con el nombre de tu imagen
                .resizable()
                .scaledToFit()
                .overlay(
                    ZStack {
                        ForEach($coloredAreas, id: \.id) { $area in
                            Rectangle()
                                .fill(Color($area.color.wrappedValue))
                                .frame(width: CGFloat($area.size.width.wrappedValue), height: CGFloat($area.size.height.wrappedValue))
                                .position(x: CGFloat($area.position.x.wrappedValue), y: CGFloat($area.position.y.wrappedValue))
                                .onTapGesture {
                                    // Cambiar el color del área
                                    if let index = coloredAreas.firstIndex(where: { $0.id == area.id }) {
                                        coloredAreas[index].color = selectedColor.cgColor!
                                    }
                                }
                        }

                    }
                )
                .gesture(DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        // Agregar un área coloreable en la posición actual del toque
                        let position = value.location
                        let size = CGSize(width: 10, height: 10) // Tamaño del área
                        coloredAreas.append(ColorableArea(position: position, size: size, color: selectedColor.uiColor.cgColor))
                    }
                )

            ColorPicker("Seleccionar color", selection: $selectedColor)
                .padding()
        }
    }
}

 

struct ColorableArea: Identifiable {
    let id = UUID() // Proporciona un ID único
    var position: CGPoint
    var size: CGSize
    var color: CGColor
}

extension Color {
    var uiColor: UIColor {
        return UIColor(self)
    }
}


 
