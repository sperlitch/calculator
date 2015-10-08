//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Scott Perlitch on 10/7/15.
//  Copyright © 2015 Scott Perlitch. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    private enum InputStack: CustomStringConvertible {
        case Number(Double)
        case Constant(String, Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .Number(let number):
                        return "\(number)"
                case .UnaryOperation(let symbol, _):
                        return symbol // already strings
                case .BinaryOperation(let symbol, _):
                        return symbol // already strings
                case .Constant(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    private var inputStack = [InputStack]() // or : Array<Op> = Array<Op>
    
    private var knownOperations = [String: InputStack]() // Dictionary<String, Op>()
    
    init() {
        func addOperation(operation: InputStack) {
            knownOperations[operation.description] = operation
        }
        addOperation(InputStack.BinaryOperation("✖️", *))
        addOperation(InputStack.BinaryOperation("➗") { $1 / $0 })
        addOperation(InputStack.BinaryOperation("➕", +))
        addOperation(InputStack.BinaryOperation("➖") { $1 - $0 })
        addOperation(InputStack.UnaryOperation("✔️", sqrt))
        addOperation(InputStack.UnaryOperation("sin", sin))
        addOperation(InputStack.UnaryOperation("cos", cos))
        addOperation(InputStack.Constant("π", M_PI))
    }
    
    private func evaluate(let stack: [InputStack]) -> (result: Double?, remainingStack: [InputStack]) {  // implicit let infront of passed arguments
        
        if !stack.isEmpty { // Stack has something in it
            var remainingStack = stack // Make a mutable copy, read and write
            let numOrSymbol = remainingStack.removeLast()
            switch numOrSymbol {
            
            case .Number(let number):
                // Its a Double
                return (number, remainingStack)
                
            case .Constant(_, let value):
                return (value, remainingStack)
                
            case .UnaryOperation(_, let typeOfUnaryOperation): // _ (underscore) = I dont care about it
                
                // Its a unary operator string ie square root
                let stackEvaluation = evaluate(remainingStack) //  it has returned one number and remainingStack
                
                if let number = stackEvaluation.result { //
                    return (typeOfUnaryOperation(number), stackEvaluation.remainingStack)
                }
            case .BinaryOperation(_, let typeOfBinaryOperation):
                // It's a binary operator string ie + - * /
                let stackFirstEvaluation = evaluate(remainingStack) // Pull off top
                
                if let firstNumber = stackFirstEvaluation.result {
                    
                    let stackSecondEvaluation = evaluate(stackFirstEvaluation.remainingStack) // Pull off top
                    
                    if let secondNumber = stackSecondEvaluation.result {
                        return (typeOfBinaryOperation(firstNumber, secondNumber), stackSecondEvaluation.remainingStack)
                    }
                }
            // No default because handled every switch case
            }
        }
        return (nil, stack)
    }
    
    
    func evaluate() -> Double? {
        let (finalCalculation, finalStack) = evaluate(inputStack)
        print("\(inputStack) = \(finalCalculation) with \(finalStack) left over")
        return finalCalculation
    }
    
    func pushNumber(number: Double) -> Double? {
        inputStack.append(InputStack.Number(number))
        return evaluate() // Evaluate after every number entered
    }
    
    func performOperation(symbol: String) -> Double?{
        if let operation = knownOperations[symbol] {
            inputStack.append(operation)
        }
        return evaluate() // Evaluate after operation is entered
    }
    
    func clear() {
        inputStack = [InputStack]()
    }
}