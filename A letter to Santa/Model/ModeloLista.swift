//
//  ModeloLista.swift
//  A letter to Santa
//
//  Created by Mariano Rodriguez Abarca on 29/08/23.
//

import Foundation

struct ModeloLista:  Identifiable{
    let id = UUID()
    let emoji: String
    let emojiFinal: String
    let nombre: String
    let descripcion: String
    
 
}

let lista: [ModeloLista] = [
    ModeloLista(
           emoji: "duende_esfera_dots.png",
           emojiFinal: "duende_esfera.png",
           nombre: "Merry Christmas",
           descripcion: "Draw christmas tree."),
    ModeloLista(
           emoji: "bota_dot.png",
           emojiFinal: "bota.png",
           nombre: "Merry Christmas",
           descripcion: "Draw christmas tree."),
    ModeloLista(
           emoji: "bota_dulce_dot.png",
           emojiFinal: "bota_dulce.png",
           nombre: "Christmas boot.",
           descripcion: "Christmas boot."),
    ModeloLista(
           emoji: "cabana_venados_dot.png",
           emojiFinal: "cabana_venados.png",
           nombre: "Christmas boot.",
           descripcion: "Christmas boot."),

    ModeloLista(
           emoji: "luna_venados_dot.png",
           emojiFinal: "luna_venados.png",
           nombre: "Christmas boot.",
           descripcion: "Christmas boot."),

    ModeloLista(
           emoji: "muneco_nieve_dot.png",
           emojiFinal: "muneco_nieve.png",
           nombre: "Christmas boot.",
           descripcion: "Christmas boot."),
    ModeloLista(
        emoji: "chimenea_dots.png",
        emojiFinal: "chimenea.png",
           nombre: "Christmas tree",
           descripcion: "Draw christmas tree."),
    ModeloLista(
           emoji: "patos_hombre_nieve_dot.png",
           emojiFinal: "patos_hombre_nieve.png",
           nombre: "Christmas boot.",
           descripcion: "Christmas boot."),
    ModeloLista(
        emoji: "noche_buena.png",
        emojiFinal: "noche_buena_normal.png",
           nombre: "Christmas color tree",
           descripcion: "Draw and color christmas tree."),
    ModeloLista(
           emoji: "pino_nacimiento_dot.png",
           emojiFinal: "pino_nacimiento.png",
           nombre: "Christmas boot.",
           descripcion: "Christmas boot."),
    ModeloLista(
        emoji: "pino_dos_dots.png",
        emojiFinal: "pino_dos.png",
           nombre: "Christmas crown",
           descripcion: "Draw and color christmas crown"),
    ModeloLista(
           emoji: "venado_dot.png",
           emojiFinal: "venado.png",
           nombre: "Christmas boot.",
           descripcion: "Christmas boot."),
    ModeloLista(
        emoji: "pino_dot.png",
        emojiFinal: "pino_dots_normal.png",
           nombre: "Santa´s boots",
           descripcion: "Draw and color Santa´s boots."),
    ModeloLista(
        emoji: "pino_dots_tres.png",
        emojiFinal: "pino_dots_tres_normal.png",
           nombre: "Santa´s boots",
           descripcion: "Draw and color Santa´s boots."),
    ModeloLista(
        emoji: "pino_dots.png",
        emojiFinal: "pino.png",
           nombre: "Santa´s boots",
           descripcion: "Draw and color Santa´s boots."),
    ModeloLista(
        emoji: "regalo_dots.png",
        emojiFinal: "regalo_dots_normal.png",
           nombre: "Santa´s boots",
           descripcion: "Draw and color Santa´s boots."),
    ModeloLista(
        emoji: "regalos_dots.png",
        emojiFinal: "regalos_dots_normal.png",
           nombre: "Santa´s boots",
           descripcion: "Draw and color Santa´s boots."),
    ModeloLista(
        emoji: "santa_dot.png",
        emojiFinal: "santa_dot_normal.png",
           nombre: "Santa´s boots",
           descripcion: "Draw and color Santa´s boots."),
    ModeloLista(
        emoji: "snow_ball_clothes.png",
        emojiFinal: "snow_ball_clothes_normal.png",
           nombre: "Santa´s boots",
           descripcion: "Draw and color Santa´s boots."),
    ModeloLista(
        emoji: "snow_ball_dot_dos.png",
        emojiFinal: "snow_ball_dot_dos.png",
           nombre: "Santa´s boots",
           descripcion: "Draw and color Santa´s boots."),
    ModeloLista(
        emoji: "snow_ball_dot.png",
        emojiFinal: "snow_ball_dot_dos_normal.png",
           nombre: "Santa´s boots",
           descripcion: "Draw and color Santa´s boots."),
    ModeloLista(
        emoji: "snowball_dots_dos.png",
        emojiFinal: "snowball_dots_dos_normal.png",
           nombre: "Santa´s boots",
           descripcion: "Draw and color Santa´s boots."),
    ModeloLista(
        emoji: "trineo.png",
        emojiFinal: "trineo_normal.png",
           nombre: "Santa´s boots",
           descripcion: "Draw and color Santa´s boots."),
    ModeloLista(
        emoji: "vela_dots.png",
        emojiFinal: "vela_dots_normal.png",
           nombre: "Santa´s boots",
           descripcion: "Draw and color Santa´s boots.")
]
