//
//  DrawingView.swift
//  A letter to Santa
//
//  Created by Mariano Rodriguez Abarca on 19/09/23.
//
import SwiftUI

struct DrawingView: View {
    @State private var drawing = Drawing() // Modelo para almacenar el dibujo
    @State private var selectedColor: Color = .red // Color seleccionado por defecto
    @State private var isDrawing = false // Controla si el usuario está dibujando o eligiendo un color
    
    // Lista de colores para el menú
    let colorOptions: [Color] = [.red, .blue, .green, .yellow, .orange, .purple]
    
    var body: some View {
        VStack {
            // Vista de dibujo
            DrawingCanvas(drawing: $drawing, isDrawing: $isDrawing, selectedColor: $selectedColor)
                .frame(width: 300, height: 300)
                .border(Color.gray, width: 1)
            
            // Menú de colores
            HStack {
                ForEach(colorOptions, id: \.self) { color in
                    Circle()
                        .fill(color)
                        .frame(width: 30, height: 30)
                        .onTapGesture {
                            selectedColor = color
                            isDrawing = false
                        }
                }
            }
        }
    }
}

struct DrawingCanvas: View {
    @Binding var drawing: Drawing
    @Binding var isDrawing: Bool
    @Binding var selectedColor: Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Imagen de fondo (puedes usar una imagen como fondo si lo deseas)
                Image(systemName: "photo.fill")
                    .resizable()
                    .scaledToFit()
                    .opacity(0.5)
                    .frame(width: geometry.size.width, height: geometry.size.height)
 
                
                // Dibujo
                ForEach(drawing.strokes) { stroke in
                    Path { path in
                        path.addLines(stroke.points)
                    }
                    .stroke(stroke.color, lineWidth: 5)
                }
                .background(
                    Rectangle()
                        .fill(Color.white)
                        .opacity(0.001) // Hace que el área sea interactiva para toques
                        .gesture(DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                if isDrawing {
                                    drawing.addPoint(point: value.location, color: selectedColor)
                                }
                            }
                            .onEnded { _ in
                                if isDrawing {
                                    drawing.endStroke()
                                }
                            }
                        )
                )
            }
        }
    }
}

struct Drawing {
    var strokes: [Stroke] = []
    
    mutating func addPoint(point: CGPoint, color: Color) {
        if var lastStroke = strokes.last {
            lastStroke.points.append(point)
            strokes[strokes.count - 1] = lastStroke
        } else {
            strokes.append(Stroke(points: [point], color: color))
        }
    }
    
    mutating func endStroke() {
        strokes.append(Stroke(points: [], color: .clear)) // Puedes establecer un color nulo o transparente aquí
    }
}

struct Stroke: Identifiable {
    let id = UUID() // Proporciona un ID único
    var points: [CGPoint]
    var color: Color
}
 
