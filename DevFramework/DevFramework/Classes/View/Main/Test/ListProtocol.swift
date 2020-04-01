//
//  List.swift
//  DevFramework
//
//  Created by macode on 2020/1/8.
//  Copyright © 2020 志方. All rights reserved.
//我使用的协议继承来帮助我建立更加专业化FIFO，并LIFO从更抽象的协议List协议。然后，我利用协议扩展来实现Queue和Stack值类型

import Foundation

protocol ListSubscript {
    associatedtype AnyType
    var elements: [AnyType] { get }
}

extension ListSubscript {
    subscript(i: Int) -> Any {
        return elements[i]
    }
}

protocol ListPrintForward {
    associatedtype AnyType
    var elements: [AnyType] { get }
}

extension ListPrintForward {
    func showList() {
        if elements.count > 0 {
            var line = ""
            var index = 1
            for element in elements {
                line += "\(element)"
                index += 1
            }
            print("\(line)\n")
        }else {
            print("empty")
        }
    }
}

protocol ListPrintBackward {
    associatedtype AnyType
    var elements: [AnyType] { get }
}

extension ListPrintBackward {
    func showRverseList() {
        if elements.count > 0 {
            var line = ""
            var index = 1
            for element in elements.reversed() {
                line += "\(element)"
                index += 1
            }
            print("\(line)\n")
        }else {
            print("empty")
        }
    }
}

protocol ListCount {
    associatedtype AnyType
    var elements: [AnyType] { get }
}

extension ListCount {
    func count() -> Int {
        return elements.count
    }
}

protocol ListArray {
    associatedtype AnyType
    var elements: [AnyType] { get set }
    mutating func remove() -> AnyType
    mutating func add(_ element: AnyType)
}

extension ListArray {
    mutating func add(_ element: AnyType) {
        elements.append(element)
    }
}

protocol FIFO: ListArray, ListCount, ListPrintForward, ListPrintBackward {
    
}

extension FIFO {
    mutating func remove() -> AnyType {
        if elements.count > 0 {
            return elements.removeFirst()
        }else {
            return "EMPTY" as! AnyType
        }
    }
}

struct Queue: FIFO {
    typealias AnyType = Any
    var elements: [AnyType] = []
}

func testQueue() {
    var queue = Queue()
    queue.add("Bob")
    queue.showList()
    queue.add(1)
    queue.showRverseList()
    queue.add(3.0)
}

protocol LIFO: ListArray, ListCount, ListPrintForward, ListPrintBackward {
    
}

extension LIFO {
    mutating func remove() -> AnyType {
        if elements.count > 0 {
            return elements.removeLast()
        }else {
            return "EMPTY" as! AnyType
        }
    }
}

struct Stack: LIFO {
    typealias AnyType = Any
    var elements: [AnyType] = []
}

func testStack() {
    var stack = Stack()
    stack.add("Bob")
    stack.showList()
    stack.add(1)
    stack.showRverseList()
    stack.add(3.0)
}
