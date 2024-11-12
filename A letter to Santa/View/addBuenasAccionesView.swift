//
//  addBuenasAccionesView.swift
//  A letter to Santa
//
//  Created by Mariano Rodriguez Abarca on 09/04/24.
//
//
//  addBuenasAccionesView.swift
//  A letter to Santa
//
//  Created by Mariano Rodriguez Abarca on 01/04/24.
//
import SwiftUI
import CoreData
import Charts
 
// Otras vistas aquí...
struct addBuenasAccionesView: View {
    @State private var selectedGoodDeed: String = ""
    @State private var comments: String = ""
    @State private var categoriaDeed: String = ""
    @State private var showCategoryInput: Bool = false
    @ObservedObject var modelBuenaAccion: ViewModelAcciones
    @ObservedObject var modelCategoriaAccion: ViewModelCategoriaAcciones
    @Environment(\.managedObjectContext) var context
    @State private var showingAlert = false
    @State private var showingAlertCategorias = false
    @State private var mensaje = "Information"
    // Declaración de las variables
    // Estructura auxiliar para manejar las fechas de inicio y fin del año
      struct YearDates {
          let startOfYear: Date
          let endOfYear: Date
          
          init() {
              let calendar = Calendar.current
              self.startOfYear = calendar.date(from: calendar.dateComponents([.year], from: Date()))!
              self.endOfYear = calendar.date(byAdding: DateComponents(year: 1, second: -1), to: self.startOfYear)!
          }
      }
      
      @FetchRequest(entity: BuenasAcciones.entity(),
                    sortDescriptors: [NSSortDescriptor(key: "fecha", ascending: true)],
                    predicate: NSPredicate(format: "fecha >= %@ AND fecha <= %@", argumentArray: [YearDates().startOfYear as NSDate, YearDates().endOfYear as NSDate]),
                    animation: .spring())
      var results: FetchedResults<BuenasAcciones>
      
      // Estado para controlar si las buenas acciones están guardadas
      @State private var buenasAccionesSaved = false
      
    @FetchRequest(entity: CategoriaAccionesFecha.entity(), sortDescriptors: [NSSortDescriptor(key: "fechaGuardado", ascending: true)], animation: .spring())
    var resultsCategoriaAcciones: FetchedResults<CategoriaAccionesFecha>
 
 
    // Arrays de nombres de imágenes y acciones correspondientes
    let buenasAcciones: [String] = [
        "Recoger juguetes",
        "Cepillarse los dientes",
        "Tomar un baño",
        "Alimentar a las mascotas",
        "Hacer la tarea",
        "Donar ropa",
        "Donar juguetes",
        "Ser amable con tus hermanos",
        "Prestar atención en la escuela",
        "No pelear en la escuela",
        "Visitar a tus abuelos",
        "Dar dulces a otros niños",
        "Lavar la ropa",
        "Lavar los platos",
        "Cuidar las plantas",
        "Limpiar tu habitación",
        "Desearle feliz cumpleaños a alguien",
        "Donar comida para perros o gatos"
    ]

    
    let buenasAccionesImages: [String] = [
        "recoger_juguetes_nina",
        "lavarse_dientes_nino",
        "duchasre_nina",
        "dar_comer_mascotas_nino",
        "hacer_tarea_nino",
        "donar_ropa",
        "donar_juguetes",
        "ayudar_hermanos",
        "poner_atencion_en_clase",
        "no_pelear",
        "visitar_abuelos",
        "donar_dulces",
        "ayudar_en_casa_nina",
        "lavar_platos_nino",
        "cuidar_plantas",
        "limpiar_cuarto",
        "happy_birthday",
        "dona_comida_perros_gatos"
    ]
    
    var body: some View {
        ZStack {
            Color.clear.onTapGesture {
                hideKeyboard()
            }
            ScrollView {
                VStack {
                    Text("Agregar Buenas Acciones")
                        .font(.largeTitle)
                        .bold()
                    Text("Selecciona una imagen")
                        .font(.headline)
                        .bold()
                    // Si las buenas acciones están guardadas, muestra la cuadrícula
                    if buenasAccionesSaved {
                        LazyVGrid(columns: Array(repeating: GridItem(), count: 4)) {
                            ForEach(resultsCategoriaAcciones) { categoria in
                                VStack {
                                    Image(categoria.imagen ?? "")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 80, height: 80)
                                        .onTapGesture {
                                            // Cuando se selecciona una imagen, actualizar el campo "Selected Good Deed" con el nombre correspondiente
                                            selectedGoodDeed = categoria.nombreAccion ?? ""
                                        }
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color.green, lineWidth: selectedGoodDeed == categoria.nombreAccion ? 3 : 0)
                                        )
                                    
                                     if selectedGoodDeed == categoria.nombreAccion {
                                        Text(categoria.nombreAccion ?? "")
                                            .foregroundColor(.green)
                                            .padding(.horizontal, 8)
                                            .background(Color.yellow.opacity(0.5))
                                            .cornerRadius(8)
                                     }else{
                                         Text(categoria.nombreAccion ?? "")
                                                             .font(.caption)
                                                             .foregroundColor(.primary)
                                     }
                                    
                                    
                                }
                            }
                        }
                        .padding()

                    }
 
                    // Botón para mostrar u ocultar CategoriasInput
                    Button(action: {
                        showCategoryInput.toggle()
                    }) {
                        Text(showCategoryInput ? "Ocultar categorías" : "Agrega una categoría nueva")
                    }

                    // Vista CategoriasInput que se muestra u oculta según el estado de showCategoryInput
                    if showCategoryInput {
                        CategoriasInput(categoriaGoodDeed: $categoriaDeed)
                     
                        SaveCategoriaButton(categoriaGoodDeed:  $categoriaDeed, modelCategoriaBuenaAccion: modelCategoriaAccion, context: context, showingAlertCategoria: $showingAlertCategorias, mensajeCategoria: $mensaje)
                     
                        ListaDeCategoriaAcciones(results: resultsCategoriaAcciones, modelCategoriaBuenaAccion: modelCategoriaAccion, context: context)
                    }
                    CommentsInput(comments: $comments, selectedGoodDeed: $selectedGoodDeed)
                    DateDisplay()
                    SaveButton(selectedGoodDeed: $selectedGoodDeed, comments: $comments, modelBuenaAccion: modelBuenaAccion, context: context, showingAlert: $showingAlert, mensaje: $mensaje)
                    VStack {
                        TodaysActsOfKindness(results: results, modelBuenaAccion: modelBuenaAccion, context: context, selectedGoodDeed: $selectedGoodDeed, comments: $comments)
                        Spacer()
                        
                        if(results.count > 0){
                            let pieChartData = getPieChartDataFromResults() // Obtener los datos del gráfico de pastel
                            let uniqueColors = uniqueColors(count: pieChartData.count) // Generar colores únicos basados en la cantidad de segmentos

                            // Luego, puedes usar estos datos y colores únicos en tu vista PieChartView
                            let currentYear = Calendar.current.component(.year, from: Date()) // Obtener el año en curso

                            PieChartView(data: pieChartData,
                                         colors: uniqueColors,
                                         chartTitle: "Gráfica de actividades - \(currentYear)")
                                .frame(width: 600, height: 600)
                                .padding()
                        }
 
                    }
                }
                .onAppear {
                    // Verificar si ya existen registros
                    if resultsCategoriaAcciones.isEmpty {
                        // Si no existen registros, guardar las buenas acciones desde los arrays
                        saveBuenasAccionesFromArrays(context: context)
                        // Actualizar el estado para indicar que las acciones están guardadas
                        buenasAccionesSaved = true
                    } else {
                        // Si existen registros, simplemente actualizar el estado
                        buenasAccionesSaved = true
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func getCounts() -> [String: Int] {
        var counts: [String: Int] = [:]
        for result in results {
            if let nombreAccion = result.nombreAccion {
                counts[nombreAccion, default: 0] += 1
            }
        }
        return counts
    }
    
    
    // Función para obtener los datos del gráfico de pie
    private func getPieChartData() -> [String: Int] {
        var pieChartData: [String: Int] = [:]

        // Iterar sobre los resultados y contar la frecuencia de cada nombreAccion
        for result in results {
            if let nombreAccion = result.nombreAccion {
                pieChartData[nombreAccion, default: 0] += 1
            }
        }

        return pieChartData
    }
    
    private func getPieChartDataFromResults() -> [(label: String, value: Double)] {
        var pieChartData: [(label: String, value: Double)] = []

        // Iterar sobre los resultados y obtener el nombre de la acción y contar su frecuencia
        let counts = getCounts()
        for (nombreAccion, count) in counts {
            pieChartData.append((label: nombreAccion, value: Double(count)))
        }

        return pieChartData
    }
    
    // Función para generar un color aleatorio vibrante
    func randomVibrantColor() -> Color {
        // Generar componentes RGB aleatorios en un rango específico para obtener colores vibrantes
        let red = Double.random(in: 0.5...1)
        let green = Double.random(in: 0.5...1)
        let blue = Double.random(in: 0.5...1)
        
        // Crear y devolver el color con los componentes generados
        return Color(red: red, green: green, blue: blue)
    }

 
    let colors: [Color] = [.red, .green, .blue, .orange, .yellow, .purple, .pink] // Define tus colores aquí

    // Función para generar colores únicos para la cantidad de registros especificada
    func uniqueColors(count: Int) -> [Color] {
        var uniqueColors: [Color] = []
        
        // Generar un color único para cada registro
        for _ in 0..<count {
            let color = randomVibrantColor()
            uniqueColors.append(color)
        }
        
        return uniqueColors
    }
    
    func saveBuenasAccionesFromArrays(context: NSManagedObjectContext) {
        for index in 0..<min(buenasAcciones.count, buenasAccionesImages.count) {
            let nuevaCategoria = CategoriaAccionesFecha(context: context)
            nuevaCategoria.nombreAccion = buenasAcciones[index]
            nuevaCategoria.imagen = buenasAccionesImages[index]
            
            // Imprimir los datos antes de guardar
            print("Nombre de la acción: \(nuevaCategoria.nombreAccion ?? "N/A")")
            print("Imagen: \(nuevaCategoria.imagen ?? "N/A")")
            
            // Guardar en el contexto
            do {
                try context.save()
                print("Guardado exitosamente: \(nuevaCategoria)")
            } catch {
                print("Error al guardar la categoría de acciones: \(error)")
            }
        }
    }
}




struct AddGoodDeedSelection: View {
    @Binding var selectedGoodDeed: String
    
    var body: some View {
        VStack {
            Text("Agrega una buena acción")
                .font(.largeTitle)
                .bold()
            
            // Your selection UI here...
            TextField("Selecciona una imagen", text: $selectedGoodDeed)
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .background(Color.yellow.opacity(0.5))
                .cornerRadius(8)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding()
    }
}
struct CommentsInput: View {
    @Binding var comments: String
    @Binding var selectedGoodDeed: String // Agregamos un binding para el nombre de la acción seleccionada
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Buena acción seleccionada:") // Cambiamos el texto a "Selected Good Deed:"
                .font(.headline)
            
            TextField("Buena acción seleccionada", text: $selectedGoodDeed) // Usamos el binding del nombre de la acción seleccionada
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .background(Color.yellow.opacity(0.5))
                .cornerRadius(8)
            
            Text("Comentarios:") // Texto para los comentarios
                .font(.headline)
                .padding(.top)
            
            TextField("Agrega comentarios", text: $comments) // Campo de texto para los comentarios
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .background(Color.yellow.opacity(0.5))
                .cornerRadius(8)
        }
        .padding()
    }
}


struct DateDisplay: View {
    var body: some View {
        HStack {
            Text("Fecha:")
                .font(.headline)
                .padding(.horizontal)
            
            Text(getFormattedDate())
                .font(.body)
            
            Spacer()
        }
        .padding()
    }
    
    func getFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: Date())
    }
}

/*struct SaveButton: View {
    @Binding var selectedGoodDeed: String
    @Binding var comments: String
    var modelBuenaAccion: ViewModelAcciones
    var context: NSManagedObjectContext
    @Binding var showingAlert: Bool
    @Binding var mensaje: String
    @EnvironmentObject private var store: Store
    @FetchRequest(entity: BuenasAcciones.entity(), sortDescriptors: [NSSortDescriptor(key: "fecha", ascending: true)], animation: .spring())
    var resultsBuenasAcciones: FetchedResults<BuenasAcciones>
 
    var body: some View {
        Button(action: {
            if !selectedGoodDeed.isEmpty {
                // Asignar el valor de selectedGoodDeed al nombre de la buena acción en el modelo
                modelBuenaAccion.nombreAccion = selectedGoodDeed
                     
                // Asignar el valor de los comentarios al modelo
                modelBuenaAccion.comentariosAccion = comments
                     
                // Obtener la fecha actual
                let currentDate = Date()
                
                // Asignar la fecha actual al modelo
                modelBuenaAccion.fecha = currentDate
                     
                // Guardar la buena acción en el contexto
                modelBuenaAccion.saveBuenasAcciones(context: context)
                
                // Limpiar los TextField
                selectedGoodDeed = ""
                comments = ""
 
            } else {
                print("Nombre de la buena acción está vacío")
                showingAlert = true
                mensaje = "Please choose a good deed"
            }
        }) {
            Text("Save Good Deed")
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(8)
        }
        .alert(mensaje, isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        }
    }
}*/

struct SaveButton: View {
    @Binding var selectedGoodDeed: String
    @Binding var comments: String
    var modelBuenaAccion: ViewModelAcciones
    var context: NSManagedObjectContext
    @Binding var showingAlert: Bool
    @Binding var mensaje: String
    @EnvironmentObject private var store: Store
    @FetchRequest(entity: BuenasAcciones.entity(), sortDescriptors: [NSSortDescriptor(key: "fecha", ascending: true)], animation: .spring())
    var resultsBuenasAcciones: FetchedResults<BuenasAcciones>
 
    var body: some View {
        Button(action: {
            if resultsBuenasAcciones.count >= 10 {
                if validaCompra() {
                    if !selectedGoodDeed.isEmpty {
                        // Asignar el valor de selectedGoodDeed al nombre de la buena acción en el modelo
                        modelBuenaAccion.nombreAccion = selectedGoodDeed
                     
                        // Asignar el valor de los comentarios al modelo
                        modelBuenaAccion.comentariosAccion = comments
                     
                        // Obtener la fecha actual
                        let currentDate = Date()
                    
                        // Asignar la fecha actual al modelo
                        modelBuenaAccion.fecha = currentDate
                     
                        // Guardar la buena acción en el contexto
                        modelBuenaAccion.saveBuenasAcciones(context: context)
                    
                        // Limpiar los TextField
                        selectedGoodDeed = ""
                        comments = ""
 
                    } else {
                        print("Nombre de la buena acción está vacío")
                        showingAlert = true
                        mensaje = "Por favor, selecciona una buena acción"
                    }
                } else {
                    // Muestra un mensaje si la aplicación no ha sido comprada
                    showingAlert = true
                    mensaje = "Para agregar más buenas acciones, por favor adquiere la versión Pro."

                }
            } else {
                // No se necesita validar la compra si hay menos de 10 registros en resultsBuenasAcciones
                if !selectedGoodDeed.isEmpty {
                    // Asignar el valor de selectedGoodDeed al nombre de la buena acción en el modelo
                    modelBuenaAccion.nombreAccion = selectedGoodDeed
                     
                    // Asignar el valor de los comentarios al modelo
                    modelBuenaAccion.comentariosAccion = comments
                     
                    // Obtener la fecha actual
                    let currentDate = Date()
                    
                    // Asignar la fecha actual al modelo
                    modelBuenaAccion.fecha = currentDate
                     
                    // Guardar la buena acción en el contexto
                    modelBuenaAccion.saveBuenasAcciones(context: context)
                    
                    // Limpiar los TextField
                    selectedGoodDeed = ""
                    comments = ""
 
                } else {
                    print("Nombre de la buena acción está vacío")
                    showingAlert = true
                    mensaje = "Por favor, selecciona una buena acción."
                }
            }
        }) {
            Text("Guarda tu buena acción")
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(8)
        }
        .alert(mensaje, isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        }
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



struct CategoriasInput: View {
    @Binding var categoriaGoodDeed: String // Binding for the selected action name
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Categorías:")
                .font(.headline)
            TextField("Agrega una categoría", text: $categoriaGoodDeed) // TextField for entering the category name
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .background(Color.green.opacity(0.5))
                .cornerRadius(8)

        }
        .padding()
    }
}

/*struct SaveCategoriaButton: View {
    @Binding var categoriaGoodDeed: String
    var modelCategoriaBuenaAccion: ViewModelCategoriaAcciones
    var context: NSManagedObjectContext
    @Binding var showingAlertCategoria: Bool
    @Binding var mensajeCategoria: String
    @EnvironmentObject private var store: Store
    
    var body: some View {
        Button(action: {
            if !categoriaGoodDeed.isEmpty {
                // Asignar el valor de selectedGoodDeed al nombre de la buena acción en el modelo
                modelCategoriaBuenaAccion.nombreAccion = categoriaGoodDeed
                     
                // Asignar el valor de los comentarios al modelo
                modelCategoriaBuenaAccion.imagen = "tarea_generica_ninos"
                
                // Obtener la fecha actual
                let currentDate = Date()
                modelCategoriaBuenaAccion.fechaGuardado = currentDate
 
                // Guardar la buena acción en el contexto
                modelCategoriaBuenaAccion.saveCategoriaAcciones(context: context)
                
                // Limpiar los TextField
                categoriaGoodDeed = ""
                
                showingAlertCategoria = true
                mensajeCategoria = "Category saved successfully"
 
            } else {
                print("Nombre de la buena acción está vacío")
                showingAlertCategoria = true
                mensajeCategoria = "Please add a good deed category name"
            }
        }) {
            Text("Save Good Deed Category")
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(8)
        }
        .alert(mensajeCategoria, isPresented: $showingAlertCategoria) {
            Button("OK", role: .cancel) { }
        }
    }
 
}*/

struct SaveCategoriaButton: View {
    @Binding var categoriaGoodDeed: String
    var modelCategoriaBuenaAccion: ViewModelCategoriaAcciones
    var context: NSManagedObjectContext
    @Binding var showingAlertCategoria: Bool
    @Binding var mensajeCategoria: String
    @EnvironmentObject private var store: Store

    var body: some View {
        Button(action: {
            if validaCompra() {
                if !categoriaGoodDeed.isEmpty {
                    // Asignar el valor de selectedGoodDeed al nombre de la buena acción en el modelo
                    modelCategoriaBuenaAccion.nombreAccion = categoriaGoodDeed

                    // Asignar el valor de los comentarios al modelo
                    modelCategoriaBuenaAccion.imagen = "tarea_generica_ninos"

                    // Obtener la fecha actual
                    let currentDate = Date()
                    modelCategoriaBuenaAccion.fechaGuardado = currentDate

                    // Guardar la buena acción en el contexto
                    modelCategoriaBuenaAccion.saveCategoriaAcciones(context: context)

                    // Limpiar los TextField
                    categoriaGoodDeed = ""

                    showingAlertCategoria = true
                    mensajeCategoria = "La categoría se ha guardado correctamente."

                } else {
                    print("Nombre de la buena acción está vacío")
                    showingAlertCategoria = true
                    mensajeCategoria = "Por favor agrega el nombre de la categoría"
                }
            } else {
                // Muestra un mensaje si la aplicación no ha sido comprada
                showingAlertCategoria = true
                mensajeCategoria = "Para continuar, por favor adquiere la versión PRO."
            }
        }) {
            Text("Guarda categoría")
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(8)
        }
        .alert(mensajeCategoria, isPresented: $showingAlertCategoria) {
            Button("OK", role: .cancel) { }
        }
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



struct TodaysActsOfKindness: View {
    var results: FetchedResults<BuenasAcciones>
    var modelBuenaAccion: ViewModelAcciones
    var context: NSManagedObjectContext
    @Binding var selectedGoodDeed: String
    @Binding var comments: String



    var body: some View {
        VStack {
            Text("Buenas acciones del dia")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
                            .padding()

            Text("Selecciona un registro para eliminarlo.")
                .font(.headline)
                .foregroundColor(.gray)

            ForEach(results.filter { isToday($0.fecha) }) { item in
                HStack {
                    Text(item.nombreAccion ?? "N/A")
                        .font(.headline)
                        .bold()
                        .foregroundColor(.orange)

                    Text(item.comentarios ?? "")
                        .font(.body)
                        .foregroundColor(.black)
                }
                .contextMenu(ContextMenu(menuItems: {
                    /*Button(action: {
                        if let selectedItem = modelBuenaAccion.selectedItem {
                            selectedGoodDeed = selectedItem.nombreAccion ?? ""
                            comments = selectedItem.comentarios ?? ""
                        }
                    }) {
                        Label(title: {
                            Text("Update")
                        }, icon: {
                            Image(systemName: "pencil")
                        })
                    }*/

                    Button(action: {
                        modelBuenaAccion.deleteData(item: item, context: context)
                        print("eliminar")
                    }) {
                        Label(title: {
                            Text("Eliminar")
                        }, icon: {
                            Image(systemName: "trash")
                        })
                    }
                }))
            }
        }
    }

    // Función para verificar si la fecha es hoy
    private func isToday(_ date: Date?) -> Bool {
        guard let date = date else { return false }
        return Calendar.current.isDateInToday(date)
    }
}


struct ListaDeCategoriaAcciones: View {
    var results: FetchedResults<CategoriaAccionesFecha>
    var modelCategoriaBuenaAccion: ViewModelCategoriaAcciones
    var context: NSManagedObjectContext // Agregué context aquí
 
    var body: some View {
        VStack {
            Text("Listado de categorías")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.blue)
                .padding()
            
            Text("Selecciona un registro para eliminarlo.")
                .font(.headline)
                .foregroundColor(.gray)
            
            ForEach(results) { item in
                HStack {
                    Text(item.nombreAccion ?? "N/A")
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.blue)
 
                }
                .contextMenu(ContextMenu(menuItems: {
  
                    Button(action: {
                        modelCategoriaBuenaAccion.deleteData(item: item, context: context)
                        print("eliminar")
                    }) {
                        Label(title: {
                            Text("Eliminar")
                        }, icon: {
                            Image(systemName: "trash")
                        })
                    }
                }))
            }
        }
    }
}
 
 
struct PieChartView: View {
    let data: [(label: String, value: Double)]
    let colors: [Color]
    let chartTitle: String

    @State private var selectedSliceIndex: Int?

    init(data: [(label: String, value: Double)], colors: [Color], chartTitle: String) {
        self.data = data
        self.colors = colors
        self.chartTitle = chartTitle
    }

    var body: some View {
        VStack {
            Spacer()

            Text(chartTitle)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.green)
                .padding()

            GeometryReader { geometry in
                HStack {
                    ZStack {
                        // Círculo de fondo
                        Circle()
                            .fill(Color.white)
                            .frame(width: geometry.size.width / 2, height: geometry.size.height)

                        // Segmentos del gráfico de pastel
                        PieSlicesView(data: data, colors: colors, selectedSliceIndex: $selectedSliceIndex)
                            .onTapGesture {
                                // Restablecer el índice seleccionado si se toca fuera de un segmento
                                if let index = selectedSliceIndex {
                                    selectedSliceIndex = nil
                                }
                            }
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(0..<data.count, id: \.self) { index in
                            ColorAndLabelRow(color: colors[index], label: data[index].label, value: data[index].value)
                        }
 
                    }
                }
            }
            .padding()
        }
    }
}


struct PieSlicesView: View {
    let data: [(label: String, value: Double)]
    let colors: [Color]
    @Binding var selectedSliceIndex: Int?

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<data.count, id: \.self) { index in
                    PieSlice(startAngle: angle(for: index, in: data), endAngle: angle(for: index + 1, in: data))
                        .fill(colors[index])
                        .gesture(
                            TapGesture()
                                .onEnded { _ in
                                    selectedSliceIndex = index
                                }
                        )
                }
                // Mostrar el nombre del segmento seleccionado
                if let index = selectedSliceIndex {
                    Text(data[index].label + " : \(Int(data[index].value))")
                        .font(.headline)
                        .foregroundColor(Color.white)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .offset(x: geometry.size.width / 4, y: geometry.size.height / 2)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }

    private func angle(for index: Int, in data: [(label: String, value: Double)]) -> Angle {
        guard !data.isEmpty else { return .zero }

        let total = data.map { $0.value }.reduce(0, +)
        guard total != 0 else { return .zero }

        var accumulatedAngle: Double = 0

        for i in 0..<index {
            accumulatedAngle += (data[i].value / total) * 360
        }

        return .degrees(accumulatedAngle)
    }
}


struct PieSlice: Shape {
    let startAngle: Angle
    let endAngle: Angle
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        path.move(to: center)
        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        path.closeSubpath()
        
        return path
    }
}

struct ColorAndLabelRow: View {
    let color: Color
    let label: String
    let value: Double
    
    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)
            VStack(alignment: .leading) {
                Text(label)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                    .font(.subheadline) +
                Text(" - ") +
                Text(String(format: "%.0f", value))
                    .font(.headline)


            }
        }
    }
}

