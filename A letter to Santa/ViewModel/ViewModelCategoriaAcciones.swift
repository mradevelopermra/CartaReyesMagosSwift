//
//  ViewModelCategoriaAcciones.swift
//  A letter to Santa
//
//  Created by Mariano Rodriguez Abarca on 09/04/24.
//

import Foundation
import CoreData
import SwiftUI

class ViewModelCategoriaAcciones: ObservableObject{
    @Published var nombreAccion = ""
    @Published var imagen = ""
    @Published var fechaGuardado = Date()
    
    var selectedItem: CategoriaAccionesFecha? // Propiedad para almacenar el ítem seleccionado
    @Published var categorias: [CategoriaAccionesFecha] = []
    
    func saveCategoriaAcciones(context: NSManagedObjectContext){
        let newAccion = CategoriaAccionesFecha(context: context)
        newAccion.nombreAccion = nombreAccion
        newAccion.imagen = imagen
        newAccion.fechaGuardado = fechaGuardado
        do{
            try context.save()
            print("Se guardó la buena acción")
        }catch let error as NSError{
            //Alerta al usuario
            print("No se guardo", error.localizedDescription)
        }
    }
    
    func deleteData(item:CategoriaAccionesFecha, context: NSManagedObjectContext){
        context.delete(item)
        do{
            try context.save()
            print("Se elimino la categoria")
            fetchData(context: context)
        }catch let error as NSError{
            //Alerta al usuario
            print("No se elimino", error.localizedDescription)
        }
    }
    
    // Función para obtener los datos de las categorías de acciones
        func fetchData(context: NSManagedObjectContext) {
            do {
                self.categorias = try context.fetch(CategoriaAccionesFecha.fetchRequest())
            } catch {
                print("Error al obtener datos de las categorías de acciones: \(error)")
            }
        }
 
 
}
