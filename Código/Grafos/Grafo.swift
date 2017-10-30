//
//  Graph.swift
//  adasdads
//
//  Created by Javier Sagredo on 04/06/2017.
//  Copyright © 2017 Javier Sagredo. All rights reserved.
//

import Foundation

fileprivate class ListaAristas {

    var vertice: Vertice
    var aristas: [Arista]?

    init(vertice: Vertice) {
        self.vertice = vertice
    }

    func anadirArista(_ arista: Arista) {
        aristas?.append(arista)
    }

}
/**
 Clase que representa la abstracción de un grafo
 */
public class Grafo {

    fileprivate var listaAdyacencia: [ListaAristas] = []

    ///Lista de vértices del grafo
    public var vertices: [Vertice] {
        var vertices = [Vertice]()
        for lista in listaAdyacencia {
            vertices.append(lista.vertice)
        }
        return vertices
    }

    ///Lista de aristas del grafo
    public var aristas: [Arista] {
        var todas = Set<Arista>()
        for lista in listaAdyacencia {
            guard let aristas = lista.aristas else {
                continue
            }

            for arista in aristas {
                todas.insert(arista)
            }
        }
        return Array(todas)
    }

    ///Constructor vacío de un grafo
    public init() {}

    /** 
     Constructor que copia un grafo sobre este
     - Parameter desde: Grafo del que se va a copiar la información
     */
    public init(desde: Grafo) {
        for arista in desde.aristas {
            let origen = crearVertice(arista.desde.id)
            let destino = crearVertice(arista.hasta.id)

            anadirAristaDirigida(origen, hasta: destino, peso: arista.peso)
        }
    }

    /**
     Creación de un vértice en el grafo
     - Parameter id: String con el nombre del vértice
     */
    public func crearVertice(_ id: String) -> Vertice {

        let coincidentes = vertices.filter {vertice in
                                            return vertice.id == id}
        if coincidentes.count > 0 {
            return coincidentes.last!
        }

        let vertice = Vertice(id: id, indice: listaAdyacencia.count)
        listaAdyacencia.append(ListaAristas(vertice: vertice))
        return vertice
    }

    /**
     Creación de una arista dirigida en el grafo
     - Parameter desde: Vértice inicial
     - Parameter hasta: Vértice final
     - Parameter peso: Peso de la arista
     */
    public func anadirAristaDirigida(_ desde: Vertice, hasta: Vertice, peso: Double) {

        let arista = Arista(desde: desde, hasta: hasta, peso: peso)
        let lista = listaAdyacencia[desde.indice]
        if lista.aristas != nil {
            lista.anadirArista(arista)
        } else {
            lista.aristas = [arista]
        }
    }

    /**
     Creación de una arista no dirigida en el grafo
     - Parameter vertices: Tupla formada por los vértices que une la arista
     - Parameter peso: Peso de la arista
     */
    public func anadirAristaNoDirigida(_ vertices: (Vertice, Vertice), peso: Double) {
        anadirAristaDirigida(vertices.0, hasta: vertices.1, peso: peso)
        anadirAristaDirigida(vertices.1, hasta: vertices.0, peso: peso)
    }

    /**
     Consulta del peso de una arista
     - Parameter origen: Vértice de inicio
     - Parameter destino: Vértice de destino
     - Returns: Peso de la arista
     */
    public func pesoArista(_ origen: Vertice, destino: Vertice) -> Double? {
        guard let aristas = listaAdyacencia[origen.indice].aristas else {
            return nil
        }
        for arista in aristas {
            if arista.hasta == destino {
                return arista.peso
            }
        }

        return nil
    }
    
    /**
     Consulta de las aristas desde un vértice
     - Parameter origen: Vértice
     - Returns: Lista de aristas desde el vértice
     */
    public func aristasDesde(_ origen: Vertice) -> [Arista] {
        return listaAdyacencia[origen.indice].aristas ?? []
    }

}

extension Grafo : CustomStringConvertible{
    ///:nodoc:
    public var description: String {
        var filas = [String]()
        for listaAristas in listaAdyacencia {

            guard let aristas = listaAristas.aristas else {
                continue
            }

            var fila = [String]()
            for arista in aristas {
                var valor = "\(arista.hasta.id)"
                valor = "(\(valor): \(arista.peso))"
                fila.append(valor)
            }

            filas.append("\(listaAristas.vertice.id) -> [\(fila.joined(separator: ", "))]")
        }

        return filas.joined(separator: "\n")
    }
}
