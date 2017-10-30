//
//  FibonacciHeap.swift
//  FIB
//
//  Created by Javier Sagredo on 04/06/2017.
//  Copyright © 2017 Javier Sagredo. All rights reserved.
//

import Foundation

fileprivate class Nodo<U: Contenido> {
    ///Contenido del nodo, a especificar por el usuario
    public var contenido: U
    ///Puntero al nodo hijo
    public var hijo: Nodo?
    ///Puntero al nodo siguiente en su lista enlazada
    public var siguiente: Nodo?
    ///Puntero al nodo anterior en su lista enlazada
    public var anterior: Nodo?
    ///Puntero al nodo padre
    public weak var padre: Nodo?
    ///Grado del nodo
    public var grado: Int
    ///Marca del nodo
    public var marca: Bool

    ///:nodoc:
    convenience init(contenido: U) {
        self.init(contenido: contenido, hijo: nil, siguiente: nil, anterior: nil, padre: nil, grado: 0, marca: false)
    }

    private init(contenido: U, hijo: Nodo?, siguiente: Nodo?, anterior: Nodo?, padre: Nodo?, grado: Int, marca: Bool) {
        self.contenido = contenido
        self.hijo = hijo
        self.siguiente = siguiente
        self.anterior = anterior
        self.padre = padre
        self.grado = grado
        self.marca = marca
    }

    ///Función que devuelve el id del nodo (obtenido del contenido)
    public func id() -> U.U {
        return contenido.id()
    }

    //////Función que devuelve la prioridad del nodo (obtenida del contenido)
    public func prio() -> U.T {
        return contenido.prio()
    }


    
}

/**
 Clase básica de los montículos de mínimos de Fibonacci
 
 Para ser instanciada requiere de un tipo que implemente el protocolo Contenido
*/
public class FibonacciHeapMin<U: Contenido> {
    fileprivate typealias Fhn = Nodo<U>

    private var min: Fhn?
    private var raices: Int?
    ///Número de nodos del montículo
    public var nodos: Int?
    private var hash = Dictionary<U.U, Fhn>()

    ///Constructor vacío del montículo
    public init() {
        self.min = nil
        self.raices = 0
        self.nodos = 0
    }

    private func anadirAListaRaices(_ nodo: Fhn) -> Void {
        nodo.siguiente = self.min?.siguiente
        nodo.siguiente?.anterior = nodo
        nodo.anterior = self.min
        self.min?.siguiente = nodo
        nodo.padre = nil
        self.raices! += 1
    }

    /**
     Consultar el mínimo del montículo

     - Returns: contenido del mínimo o nil si el montículo está vacío
     */
    public func minimo() -> U? {
        return self.min?.contenido
    }

    /**
     Insertar contenido en el montículo

     - Parameter info: contenido del nodo que se quiere insertar
     - Returns: True si se ha insertado, False si no
     */
    public func insertar(info: U) -> Bool {
        return insertarNodo(nodo: Nodo<U>(contenido: info))
    }

    private func insertarNodo(nodo: Fhn) -> Bool {
        if hash[nodo.contenido.id()] == nil {
            nodo.grado = 0
            nodo.padre = nil
            nodo.hijo = nil
            nodo.marca = false
            if self.min == nil {
                nodo.siguiente = nodo
                nodo.anterior = nodo
                self.min = nodo
                self.raices! += 1
            } else {
                anadirAListaRaices(nodo)
                if nodo.prio() <= self.min!.prio() {
                    self.min = nodo
                }
            }
            self.nodos! += 1
            hash[nodo.id()] = nodo
            return true
        }
        return false
    }


    /**
     Unir dos montículos

     - Parameter otro: montículo que se anexionará a este
     */
    public func unir(otro: FibonacciHeapMin<U>) -> Void {
        let mark1 = self.min?.anterior
        let mark2 = otro.min?.anterior
        self.min?.anterior = mark2
        mark1?.siguiente = otro.min
        otro.min?.anterior = mark1
        mark2?.siguiente = self.min
        if self.min == nil || (otro.min != nil && otro.min!.prio() <= self.min!.prio()) {
            self.min = otro.min
        }
        self.nodos! += otro.nodos!
        self.raices! += otro.raices!
    }


    /**
     Extraer el nodo con la mínima clave del montículo

     - Returns: Contenido del nodo con la mínima clave del montículo
     */
    public func extraerMinimo() -> U? {
        if let z = self.min {
            var nodo = z.hijo
            if nodo != nil {
                z.anterior?.siguiente = nodo
                nodo?.anterior?.siguiente = z
                let aux = nodo?.anterior
                nodo?.anterior = z.anterior
                z.anterior = aux
                self.min = z
                self.raices! += z.grado
                repeat {
                    nodo?.padre = nil
                    nodo = nodo?.siguiente
                } while nodo !== z
            }
            z.hijo = nil
            z.siguiente!.anterior = z.anterior
            z.anterior!.siguiente = z.siguiente
            if z === z.siguiente {
                self.min = nil
            } else {
                self.min = z.siguiente
                consolidar()
            }
            self.nodos! -= 1
            self.raices! -= 1
            hash[z.id()] = nil
            return z.contenido
        }
        return nil
    }


    private func consolidar() -> Void {
        var A = [Fhn?]()
        let cota = Int(2*floor(log(Double(self.nodos!))))
        for _ in 0...cota {
            A.append(nil)
        }
        var nodo_actual: Fhn?
        nodo_actual = self.min
        var nodo2 = nodo_actual?.siguiente
        var i = 0
        if nodo_actual != nil {
            repeat {
                var d = nodo_actual!.grado
                while A[d] != nil {
                    i -= 1
                    var y = A[d]!
                    if nodo_actual!.prio() > y.prio() {
                        let aux = nodo_actual!
                        nodo_actual = y
                        y = aux
                    }
                    if nodo2 === self.min && self.min === y {
                        nodo2 = y.siguiente
                    }
                    if self.min === y {
                        self.min = y.siguiente
                    }
                    linkar(y, nodo_actual!)
                    A[d] = nil
                    d += 1
                }
                A[d] = nodo_actual
                nodo_actual = nodo2
                nodo2 = nodo_actual!.siguiente
                i += 1
            } while nodo_actual !== self.min && i < self.raices!
        }
        self.raices = 1
        self.min = nil
        for i in 0...cota {
            if A[i] != nil {
                if self.min == nil {
                    self.min = A[i]
                    self.min!.siguiente = self.min
                    self.min!.anterior = self.min
                    self.raices! += 1
                } else {
                    anadirAListaRaices(A[i]!)
                    if A[i]!.prio() <= self.min!.prio() {
                        self.min = A[i]
                    }
                }
            }
        }
    }

    private func linkar(_ futuroHijo: Fhn, _ futuroPadre: Fhn) -> Void {
        futuroHijo.siguiente?.anterior = futuroHijo.anterior
        futuroHijo.anterior?.siguiente = futuroHijo.siguiente
        if futuroPadre.hijo != nil {
            futuroPadre.hijo?.siguiente?.anterior = futuroHijo
            futuroHijo.siguiente = futuroPadre.hijo?.siguiente
            futuroHijo.anterior = futuroPadre.hijo
            futuroPadre.hijo?.siguiente = futuroHijo
            futuroHijo.padre = futuroPadre
        } else {
            futuroPadre.hijo = futuroHijo
            futuroHijo.padre = futuroPadre
            futuroHijo.siguiente = futuroHijo
            futuroHijo.anterior = futuroHijo
        }
        futuroPadre.grado += 1
        futuroHijo.marca = false
        self.raices! -= 1
    }


    /**
     Decrementar la clave de un nodo dado

     - parameter contenido: contenido del nodo del que se quiere decrementar la clave
     - parameter nuevo: nuevo contenido que se quiere asignar al nodo
     - Returns: True si se ha podido decrementar, False si no
     */
    public func decrementarClave(contenido: U, nuevo: U) -> Bool{
        if hash[contenido.id()] != nil {
            return decrementarClaveAux(nodo: hash[contenido.id()]!, nuevo: nuevo)
        }
        return false
    }

    private func decrementarClaveAux(nodo: Nodo<U>, nuevo: U) -> Bool {
        if nuevo.prio() < nodo.prio() {
            nodo.contenido.actualizar(otro: nuevo)
            let y = nodo.padre
            if y != nil && nodo.prio() < y!.prio() {
                cortar(nodo, y!)
                corteCascada(y!)
            }
            if self.min == nil || nodo.prio() <= self.min!.prio() {
                self.min = nodo
            }
            return true
        }
        return false
    }


    private func cortar(_ futuraRaiz: Fhn, _ actualPadre: Fhn) -> Void {
        futuraRaiz.siguiente?.anterior = futuraRaiz.anterior
        futuraRaiz.anterior?.siguiente = futuraRaiz.siguiente
        if futuraRaiz === actualPadre.hijo {
            actualPadre.hijo = futuraRaiz.siguiente
        }
        if futuraRaiz === futuraRaiz.siguiente {
            actualPadre.hijo = nil
        }
        actualPadre.grado -= 1
        self.anadirAListaRaices(futuraRaiz)
        futuraRaiz.marca = false
    }

    private func corteCascada(_ nodo: Fhn) -> Void {
        let z = nodo.padre
        if z != nil {
            if nodo.marca == false {
                nodo.marca = true
            } else {
                cortar(nodo, z!)
                corteCascada(z!)
            }
        }
    }


    /**
     Borrar del montículo el nodo con el contenido dado

     - parameter contenido: contenido del nodo que se quiere borrar
     - Returns: True si se ha podido borrar, False si no
     */
    public func borrarNodo(contenido: U) -> Bool {
        if hash[contenido.id()] != nil {
            let aux = self.min
            decrementarClaveAux(nodo: hash[contenido.id()]!, nuevo: self.min!.contenido)
            self.extraerMinimo()
            self.min = aux
            return true
        }
        return false
    }
}


