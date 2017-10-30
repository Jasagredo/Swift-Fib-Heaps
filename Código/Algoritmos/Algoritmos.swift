//
//  Dijkstra.swift
//  FibHeap
//
//  Created by Javier Sagredo on 04/06/2017.
//  Copyright © 2017 Javier Sagredo. All rights reserved.
//

import Foundation

/**
 Struct que abstrae la representación de un objeto para el problema de la mochila
 */
public struct Objeto {
    ///Peso del objeto
    var peso: Float
    ///Valor del objeto
    var valor: Float
}

/**
 Clase a almacenar en los nodos del montículo para Ramificación y Poda. Implementa los métodos exigidos por el protocolo Contenido
 */
public class BABInfo: Contenido {
    public typealias U = Int
    public typealias T = Float
    ///Solución parcial actual
    public var sol: [Bool]
    ///Nivel
    public var k: Int
    ///Peso acumulado
    public var peso: Float
    ///Valor acumulado
    public var beneficio: Float
    ///Prioridad
    public var benef_est: Float

    ///Constructor
    init(sol: [Bool], k: Int, peso: Float, beneficio: Float, benef_est: Float) {
        self.sol = sol
        self.k = k
        self.peso = peso
        self.beneficio = beneficio
        self.benef_est = benef_est
    }

    ///Constructor a partir de otra información
    init(otro: BABInfo){
        self.sol = otro.sol
        self.k = otro.k
        self.peso = otro.peso
        self.beneficio = otro.beneficio
        self.benef_est = otro.benef_est
    }

    ///:nodoc:
    public func id() -> Int {
        return (String(describing: sol)+String(describing:k)).hashValue
    }

    ///:nodoc:
    public func prio() -> Float {
        return self.benef_est
    }

    ///:nodoc:
    public func actualizar(otro: BABInfo) {
        self.sol = otro.sol
        self.k = otro.k
        self.peso = otro.peso
        self.beneficio = otro.beneficio
        self.benef_est = otro.benef_est
    }
}

/**
 Clase a almacenar en los nodos del montículo para Dijkstra. Implementa los métodos exigidos por el protocolo Contenido
 */
public class DijkstraInfo: Contenido {
    public typealias U = String
    public typealias T = Double
    ///Distancia al vértice
    var peso: Double
    ///Vértice almacenado
    var vertice: Vertice
    ///Constructor de la información
    init(_ peso: Double, _ vertice: Vertice) {
        self.peso = peso
        self.vertice = vertice
    }
    ///:nodoc:
    public func id() -> U {
        return vertice.id
    }
    ///:nodoc:
    public func prio() -> T {
        return peso
    }
    ///:nodoc:
    public func actualizar(otro: DijkstraInfo){
        self.vertice = otro.vertice
        self.peso = otro.peso
    }

}

/**
 Clase con la implementación de los algoritmos en métodos estáticos
 */
public class Algoritmos {

    private static func calculoVoraz(objetos: [Objeto], m: Float, k: Int, peso: Float, beneficio: Float) -> Float {
        var hueco = m-peso
        var estimacion = beneficio
        var j = k+1
        while j < objetos.count && objetos[j].peso <= hueco {
            hueco -= objetos[j].peso
            estimacion += objetos[j].valor
            j += 1
        }
        if j < objetos.count {
            estimacion += (hueco / objetos[j].peso) * objetos[j].valor
        }
        return estimacion
    }

    /**
        Ejecución del método de ramificación y poda. 
     
        ***Aviso***: es necesario que la lista de objetos esté ordenada de manera decreciente en valor por unidad de peso
     */
    public static func branchAndBound(objetos: [Objeto], M: Float, K: Int) -> (Float, [Bool]?,Float) {
        let n = objetos.count
        var contenido = BABInfo(sol: [Bool](repeating: false, count: K), k: -1, peso: 0, beneficio: 0, benef_est: calculoVoraz(objetos: objetos, m: M, k: -1, peso: 0, beneficio: 0))
        let fibHeap = FibonacciHeapMax<BABInfo>()
        fibHeap.insertar(info: contenido)
        var sol_mejor = [Bool]()
        var benef_mejor = Float(-1)
        while fibHeap.nodos! > 0 && fibHeap.minimo()!.benef_est > benef_mejor {
            contenido = fibHeap.extraerMinimo()!
            let x = BABInfo(otro: contenido)
            x.k += 1
            if contenido.peso + objetos[x.k].peso <= M{
                x.sol[x.k] = true
                x.peso = contenido.peso + objetos[x.k].peso
                x.beneficio = contenido.beneficio + objetos[x.k].valor
                x.benef_est = contenido.benef_est
                if x.k == n-1 {
                    sol_mejor = x.sol
                    benef_mejor = x.beneficio
                } else {
                    fibHeap.insertar(info: BABInfo(otro: x))
                }
            }

            x.benef_est = calculoVoraz(objetos: objetos, m: M, k: x.k, peso: contenido.peso, beneficio: contenido.beneficio)
            if x.benef_est > benef_mejor {
                x.peso = contenido.peso
                x.beneficio = contenido.beneficio
                x.sol[x.k] = false
                if x.k == n-1 {
                    sol_mejor = x.sol
                    benef_mejor = x.beneficio
                } else {
                    fibHeap.insertar(info: BABInfo(otro: x))
                }
            }
        }
        var p = Float(0)
        var i = 0
        while i < sol_mejor.count{
            if sol_mejor[i] {
                p += objetos[i].peso
            }
            i += 1
        }
        return (p, sol_mejor, benef_mejor)
    }

    /**
        Ejecución del algoritmo de Dijkstra desde un determinado vértice
    */
    public static func dijkstra(g: Grafo, desde: Vertice){
        let infinito:Double = DBL_MAX
        let fibHeap = FibonacciHeapMin<DijkstraInfo>()
        var distancias = [(Vertice, Double)]()

        for vertice in g.vertices {
            distancias.insert((vertice, infinito), at: vertice.indice)
        }

        fibHeap.insertar(info: DijkstraInfo(0, desde))
        distancias[desde.indice] = (desde, 0);

        while fibHeap.nodos! > 0 {
            let min = fibHeap.extraerMinimo()!

            for arista in g.aristasDesde(min.vertice) {
                let hasta = arista.hasta
                let peso = arista.peso

                if distancias[hasta.indice].1 > distancias[min.vertice.indice].1 + peso {
                    distancias[hasta.indice].1 = distancias[min.vertice.indice].1 + peso
                    let aux = distancias[hasta.indice].1
                    if !fibHeap.insertar(info: DijkstraInfo(aux, hasta)) {
                        fibHeap.decrementarClave(contenido: min, nuevo: DijkstraInfo(aux, hasta))
                    }
                }
            }
        }

        print("Algoritmo de dijkstra\n")
        for vertice in g.vertices {
            print(vertice.description + " -> " + String.init(describing: distancias[vertice.indice].1))
        }
    }
}
