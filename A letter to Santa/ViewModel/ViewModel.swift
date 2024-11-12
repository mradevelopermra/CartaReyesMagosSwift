//
//  ViewModel.swift
//  A letter to Santa
//
//  Created by Mariano Rodriguez Abarca on 17/08/23.
//

import Foundation
import CoreData
import SwiftUI

class ViewModel: ObservableObject {
    @Published var edad = ""
    @Published var nombreFirma = ""
    @Published var nombreNino = ""
    @Published var opcionUno = ""
    @Published var opcionDos = ""
    @Published var opcionTres = ""
    @Published var fechaCreacion = Date()
    @Published var fechaReyes = Date()
    @Published var sePorto = ""
    @Published var show = false
     @Published var updateItem: Carta!
     @Published var dibujaCarta: Carta!
 
    
    func saveData(context: NSManagedObjectContext){
        let newCarta = Carta(context: context)
        newCarta.nombreNino = nombreNino
        newCarta.edad =  edad
        newCarta.opcionUno = opcionUno
        newCarta.opcionDos = opcionDos
        newCarta.opcionTres = opcionTres
        newCarta.fechaCreacion = fechaCreacion
        newCarta.sePorto = sePorto
        //newCarta.fechaReyes = fechaReyes
        
        do{
            try context.save()
            print("Se guardó el archivo")
            show.toggle()
        }catch let error as NSError{
            //Alerta al usuario
            print("No se guardo", error.localizedDescription)
        }
 
    }
    
    func deleteData(item:Carta, context: NSManagedObjectContext){
        context.delete(item)
        do{
            try context.save()
            print("Se elimino el archivo")
 
        }catch let error as NSError{
            //Alerta al usuario
            print("No se elimino", error.localizedDescription)
        }
    }
    
    func cleanup(){
        nombreNino =  ""
        edad =  ""
        opcionUno =  ""
        opcionDos =  ""
        opcionTres =  ""
        fechaCreacion =  Date()
        sePorto =  ""
        fechaReyes =  Date()
 
    }
    
    func sendData(item: Carta){
        updateItem = item
        nombreNino = item.nombreNino ?? ""
        edad = item.edad ?? ""
        opcionUno = item.opcionUno ?? ""
        opcionDos = item.opcionDos ?? ""
        opcionTres = item.opcionTres ?? ""
        fechaCreacion = item.fechaCreacion ?? Date()
        sePorto = item.sePorto ?? ""
        fechaReyes = item.fechaReyes ?? Date()
        show.toggle()
    }
    
    func sendDataToMap(item: Carta){
        updateItem = item
        nombreNino = item.nombreNino ?? ""
        edad = item.edad ?? ""
        opcionUno = item.opcionUno ?? ""
        opcionDos = item.opcionDos ?? ""
        opcionTres = item.opcionTres ?? ""
        fechaCreacion = item.fechaCreacion ?? Date()
        sePorto = item.sePorto ?? ""
        fechaReyes = item.fechaReyes ?? Date()
 
    }
    
    func sendDataDibujoCarta(item: Carta){
        dibujaCarta = item
        nombreNino = item.nombreNino ?? ""
        edad = item.edad ?? ""
        opcionUno = item.opcionUno ?? ""
        opcionDos = item.opcionDos ?? ""
        opcionTres = item.opcionTres ?? ""
        fechaCreacion = item.fechaCreacion ?? Date()
        sePorto = item.sePorto ?? ""
        //fechaReyes = item.fechaReyes ?? Date()
        show.toggle()
    }
    
    func editData(context: NSManagedObjectContext){
        updateItem.nombreNino = nombreNino
        updateItem.edad =  edad
        updateItem.opcionUno = opcionUno
        updateItem.opcionDos = opcionDos
        updateItem.opcionTres = opcionTres
        updateItem.sePorto = sePorto
        do{
            try context.save()
            print("Se edito la carta")
            show.toggle()
        }catch let error as NSError{
            //Alerta al usuario
            print("No se edito", error.localizedDescription)
        }
    }
}
