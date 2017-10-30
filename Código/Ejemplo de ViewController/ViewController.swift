//
//  ViewController.swift
//  adasdads
//
//  Created by Javier Sagredo on 28/03/2017.
//  Copyright © 2017 Javier Sagredo. All rights reserved.
//

import UIKit

/**
 Fibonacci Heap. An implementation in Swift
 by Javier Sagredo
 */

import Foundation

class ViewController: UIViewController {

    func bab(){
        var M = Float(0)
        var objetos = [Objeto]()
        var K = 0
        if let filepath = Bundle.main.path(forResource: "mochilar1", ofType: "txt")
        {
            do
            {
                let contents = try String(contentsOfFile: filepath)
                let lineas = contents.components(separatedBy: "\n")
                var palabras = [String]()
                for linea in lineas {
                    palabras.append(contentsOf: linea.components(separatedBy: " "))
                }
                M = Float(palabras.remove(at: 0))!
                K = Int(palabras.remove(at: 0))!
                while palabras.count > 1 {
                    objetos.append(Objeto(peso: Float(palabras.remove(at: 0))!, valor: Float(palabras.remove(at: 0))!))
                }
            }
            catch
            {

            }
        }
        else
        {
            print("No se encuentra el archivo!!")
        }
        print("Comienzo del problema")

        let start = DispatchTime.now() // <<<<<<<<<< Start time
        objetos.sort(by: {objetoA, objetoB in
            objetoA.valor/objetoA.peso > objetoB.valor/objetoB.peso})
        print(Algoritmos.branchAndBound(objetos: objetos, M: M, K: K))
        let end = DispatchTime.now()   // <<<<<<<<<<   end time

        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
        let timeInterval = Double(nanoTime) / 1_000_000_000 // Technically could overflow for long running tests

        print("Tiempo empleado: \(timeInterval) segundos")
    }



    func dij(){
        let g = Grafo()
        var vertices = Dictionary<String, Vertice>()
        if let filepath = Bundle.main.path(forResource: "knight3", ofType: "txt")
        {
            do
            {
                let contents = try String(contentsOfFile: filepath)
                let lineas = contents.components(separatedBy: "\n")
                var g1: String = ""
                for linea in lineas {
                    if linea != "" {
                        if linea.characters.first != " " {
                            let nombre = linea.components(separatedBy: " ")[0]
                            vertices[nombre] = g.crearVertice(nombre)
                            g1 = nombre
                        } else {
                            let palabras = linea.components(separatedBy: " ")
                            let coste = Double.init(palabras[5])
                            let otro = palabras[3].substring(to: palabras[3].index(before: palabras[3].endIndex))
                            if vertices[otro] == nil {
                                vertices[otro] = g.crearVertice(otro)
                            }
                            if palabras[2] == "->" {
                                g.anadirAristaDirigida(vertices[g1]!, hasta: vertices[otro]!, peso:    coste!)
                            }


                        }
                    }
                }

            }
            catch
            {

            }
        }
        else
        {
            print("No se encuentra el archivo!!")
        }
        print("Comienzo del problema")

        let start = DispatchTime.now() // <<<<<<<<<< Start time
        Algoritmos.dijkstra(g: g, desde: vertices["0000007-O0"]!)
        let end = DispatchTime.now()   // <<<<<<<<<<   end time

        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
        let timeInterval = Double(nanoTime) / 1_000_000_000 // Technically could overflow for long running tests
        
        print("Tiempo empleado: \(timeInterval) segundos")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let dijk = true
        let baba = true
        if dijk {
            dij()
        }
        if baba {
            bab()
        }


        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

