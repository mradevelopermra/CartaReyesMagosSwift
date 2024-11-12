//
//  ViewModelAcciones.swift
//  A letter to Santa
//
//  Created by Mariano Rodriguez Abarca on 09/04/24.
//
import Foundation
import CoreData
import SwiftUI

class ViewModelAcciones: ObservableObject{
    @Published var nombreAccion = ""
    @Published var comentariosAccion = ""
    @Published var fecha = Date()
    @Published var showModal = false
    @Published var updateItem: BuenasAcciones!
    var selectedItem: BuenasAcciones? // Propiedad para almacenar el ítem seleccionado
    
    func saveBuenasAcciones(context: NSManagedObjectContext){
        let newAccion = BuenasAcciones(context: context)
        newAccion.nombreAccion = nombreAccion
        newAccion.comentarios = comentariosAccion
        newAccion.fecha = fecha
        
        do{
            try context.save()
            print("Se guardó la buena acción")
        }catch let error as NSError{
            //Alerta al usuario
            print("No se guardo", error.localizedDescription)
        }
    }
    
    func deleteData(item:BuenasAcciones, context: NSManagedObjectContext){
        context.delete(item)
        do{
            try context.save()
            print("Se elimino el archivo")
 
        }catch let error as NSError{
            //Alerta al usuario
            print("No se elimino", error.localizedDescription)
        }
    }
    

        
        func setSelectedItem(_ item: BuenasAcciones) {
            selectedItem = item
        }
    
 
}
