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
        case Number(Double) // 7.0
        case Constant(String, Double) // PI
        case UnaryOperation(String, Double -> Double) // Squareroot, exponent
        case BinaryOperation(String, (Double, Double) -> Double) // multiplication, division, addition
        
        var description: String {
            get {
                switch self {
                case .Number(let number):
                        return "\(number)" // number as string
                case .UnaryOperation(let symbol, _):
                        return symbol // already strings: sqrt symbol
                case .BinaryOperation(let symbol, _):
                        return symbol // already strings + -
                case .Constant(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    private var inputStack = [InputStack]() // or : Array<Op> = Array<Op>
    
    private var knownOperations = [String: InputStack]() // Dictionary<String, Op>()
    
    var variableValues = [String: Double]()
    
    var final: String?
    
    var description: String {
        get {
            //print(self.final)
            //print("description")
            //return "\(self.final)"
            return "\(inputStack)"
        }
    }
    
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
            var stack = stack // Make a mutable copy, read and write
            let numOrSymbol = stack.removeLast()
            print("evaluate: \(stack)")
            switch numOrSymbol {
            
            case .Number(let number):
                // Its a Double
                //final = "\(number) + \(final!)"
                //print(final!)
                return (number, stack)
                
            case .Constant(_, let value):
                return (value, stack)
                
            case .UnaryOperation(_, let typeOfUnaryOperation): // _ (underscore) = I dont care about it
                
                // Its a unary operator string ie square root
                let stackEvaluation = evaluate(stack) //  it has returned one number and remainingStack
                
                if let number = stackEvaluation.result { //
                    return (typeOfUnaryOperation(number), stackEvaluation.remainingStack)
                }
            case .BinaryOperation(_, let typeOfBinaryOperation):
                // It's a binary operator string ie + - * /
                let stackFirstEvaluation = evaluate(stack) // Pull off top
                
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
        
        //final = "\(inputStack)"
        return finalCalculation
    }
    
    func setVariable(number: Double) {
        variableValues["M"] = number
        print(variableValues)
    }
    
    func getVariable(key: String) -> Double? {
        return variableValues[key]
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
    
    func getInputStack() -> String {
        return "\(inputStack)"
    }
    
    func clear() {
        inputStack = [InputStack]()
    }
}