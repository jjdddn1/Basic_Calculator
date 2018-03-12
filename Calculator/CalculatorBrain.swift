//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Huiyuan Ren on 15/9/5.
//  Copyright (c) 2015年 Huiyuan Ren. All rights reserved.
//

import Foundation
import CoreData
import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l >= r
    default:
        return !(lhs < rhs)
    }
}

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l <= r
    default:
        return !(rhs < lhs)
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


class CalculatorBrain {

    //define all the possible operation & operand
    fileprivate enum Op: CustomStringConvertible {

        case operand(Double) // numbers
        case bracket(String) // left & right parentheses
        case unaryOperation(String, (Double) -> Double)
        case binaryOperation(String, (Double, Double) -> Double)
        case forceBinaryOperation(String, (Double, Double) -> Double)
        var description: String {
            get {
                switch self {
                case .operand(let operand):
                    return "\(operand)"
                case .bracket(let bracket):
                    return bracket
                case .unaryOperation(let symbol, _):
                    return symbol
                case .binaryOperation(let symbol, _):
                    return symbol
                case .forceBinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }

    fileprivate var opStack = Array<Op>() // origin
    fileprivate var numStack = Array<Double>() // for numbers
    fileprivate var opStack1 = Array<Op>() // for output
    fileprivate var opStack2 = Array<Op>() // for multiple/divide
    fileprivate var opStack3 = Array<Op>() // for plus/minus
    fileprivate var knownOps = Dictionary<String, Op>()
    fileprivate var m: Double = 0


    // initialize all the operation
    init() {

        knownOps["×"] = Op.binaryOperation("×", { $0 * $1 })
        knownOps["/"] = Op.binaryOperation("/", { $0 / $1 })
        knownOps["+"] = Op.binaryOperation("+", { $0 + $1 })
        knownOps["−"] = Op.binaryOperation("−", { $0 - $1 })

        // means the highest priority to calculate
        knownOps["xⁿ"] = Op.forceBinaryOperation("xⁿ", { pow($0, $1) })
        knownOps["ⁿ√"] = Op.forceBinaryOperation("ⁿ√", { pow($0, 1.0 / $1) })

        knownOps["√"] = Op.unaryOperation("√", { sqrt($0) })
        knownOps["%"] = Op.unaryOperation("%", { $0 / 100 })
        knownOps["+/-"] = Op.unaryOperation("+/-", { $0 * (-1) })
        knownOps["Rd"] = Op.unaryOperation("Rd", { $0 > 0 ? Double(arc4random_uniform(UInt32($0))) : -Double(arc4random_uniform(UInt32(-$0))) })
        knownOps["π"] = Op.unaryOperation("π", { _ in M_PI })
        knownOps["x²"] = Op.unaryOperation("x²", { $0 * $0 })
        knownOps["sin"] = Op.unaryOperation("sin", { sin($0 * M_PI / 180.0) })
        knownOps["cos"] = Op.unaryOperation("cos", { cos($0 * M_PI / 180.0) })
        knownOps["tan"] = Op.unaryOperation("tan", { tan($0 * M_PI / 180.0) })
        knownOps["mr"] = Op.unaryOperation("mr", { _ in self.m })
        knownOps["x³"] = Op.unaryOperation("x³", { $0 * $0 * $0 })
        knownOps["e"] = Op.unaryOperation("e", { _ in M_E })
        knownOps["10ⁿ"] = Op.unaryOperation("10ⁿ", { pow(10.0, $0) })


    }

    /**
     calculate a collection of operation & operand 
     return the result in double
     */
    fileprivate func toEvaluate(_ ops: [Op]) -> (Double) {

        var res: Double = 0
        var remainingOps = ops
        let op = remainingOps.removeFirst()

        // if the operation comes first, insert a zero at very beginning
        switch op {
        case .operand(let operand):
            numStack.append(operand)
        case .bracket(_):
            break
        case .unaryOperation(_, _):
            opStack2.append(op)
        case .binaryOperation(_, _):
            numStack.append(0)
            opStack2.append(op)
        case .forceBinaryOperation(_, _):
            numStack.append(0)
            opStack2.append(op)

        }

        // seperate the operation / operand in to different array
        while !remainingOps.isEmpty {

            let op = remainingOps.removeFirst()

            switch op {
            case .operand(let operand):
                numStack.append(operand)
            case .bracket(_):
                break
            case .unaryOperation(_, _):
                opStack2.append(op)
            case .binaryOperation(_, _):
                opStack2.append(op)
            case .forceBinaryOperation(_, _):
                opStack2.append(op)

            }
        }

        // calculate the first priority operation first
        var i = 0
        while(i < opStack2.count) {
            let opt = opStack2[i]
            switch opt {
            case .forceBinaryOperation(_, let operation):
                let a = numStack[i]
                let b = numStack[i + 1]
                let c = operation(a, b)
                numStack[i] = c
                numStack.remove(at: i + 1)
                opStack2.remove(at: i)
                i -= 1
            default:
                break
            }
            i += 1
        }

        //calculate second priority operation
        i = 0
        while(i < opStack2.count) {
            let opt = opStack2[i]
            switch opt {
            case .binaryOperation(let symbol, let operation):
                if(symbol == "+" || symbol == "−") {
                    opStack3.append(opt)
                } else {
                    let a = numStack[i]
                    let b = numStack[i + 1]
                    let c = operation(a, b)
                    numStack[i] = c
                    numStack.remove(at: i + 1)
                    opStack2.remove(at: i)
                    i -= 1

                }
            default:
                break
            }
            i += 1
        }

        //calculate the third priority operation
        while !numStack.isEmpty {

            //if there is no number left to calculate, break
            if opStack3.isEmpty {
                res = numStack.removeLast()
                break
            }
            let opt = opStack3.removeFirst()
            switch opt {
            case .binaryOperation(_, let operation):
                var operand1: Double = 0
                if res == 0 {
                    operand1 = numStack.removeFirst() }
                    else {
                        operand1 = res }
                if !numStack.isEmpty {
                    let operand2 = numStack.removeFirst()
                    res = (operation(operand1, operand2))
                } else {
                    res = operand1
                }
            default:
                break
            }

        }
        return res
    }

    /**
     calculate the result start from the most recent left parenthese
     return the result
     */
    fileprivate func checkCurlyBracket(_ ops: [Op]) -> Double {
        var ops = ops
        var lastLeft = -1
        var res = 0.0

        // find the most recent left parenthese
        for i in 0 ..< ops.count {
            let op = ops[i]
            switch op {
            case .bracket(_):
                lastLeft = i
                break
            default:
                break
            }
        }

        var newOps: [Op] = []
        let count = ops.count

        // copy the part need to be calculated
        for _ in ((lastLeft + 1) ... (count - 1)).reversed() {
//        for(var i = count - 1; i > lastLeft ; i -= 1){
            newOps.insert(ops.removeLast(), at: 0)
        }

        // remove the left parenthese
        if lastLeft != -1 {
            ops.removeLast()
        }

        opStack = ops

        // calcuate the part after left parenthese
        res = toEvaluate(newOps)

        opStack2.removeAll()
        opStack3.removeAll()
        numStack.removeAll()

        return res

    }

    /**
        to calculate the result from the most recent left parenthese
        return the result
     */
    func calculateRightBracket(_ operand: Double) -> Double? {
        opStack1.append(Op.operand(operand))
        opStack.append(Op.operand(operand))
        return checkCurlyBracket(opStack)
    }

    /**
     clean up all the left parentheses 
     return the rest operation / operand
     */
    fileprivate func clearBracket(_ ops: [Op]) -> [Op] {
        var newOps: [Op] = []
        for i in 0 ..< ops.count {
            let opt = ops[i]
            switch opt {
            case .bracket(_):
//                    if i != 0 {
//                        switch ops[i - 1] {
//                            case .BinaryOperation(_, _):
//                            newOps.removeLast()
//                        default:
//                            break;
//                        }
//                    }
                break
            default:
                newOps.append(opt)
                break
            }
        }
        return newOps
    }

    /**
     do a unary calculating
     return the result
     */
    func doUnaryCal (_ num: Double, symbol: String) -> Double {
        var res: Double = 0
        if let opt = knownOps[symbol] {
            switch opt {
            case .unaryOperation(_, let operation): // _ means I don't care about that

                res = (operation(num))
            default:
                break

            }

        }
        return res
    }

    /**
     called from the view controller to calculate the final result
     return the result
     */
    func evaluate() -> Double? {

        let result = toEvaluate(clearBracket(opStack))
        opStack.removeAll()
        opStack2.removeAll()
        opStack3.removeAll()
        numStack.removeAll()

        return result

    }

    /**
     return number of op in the stack
     */
    func stackNumber() -> Int {
        return opStack.count
    }

    /**
     push the last operand into the stack and calculate the result
     return the result
     */
    func pushOperand(_ operand: Double) -> Double? {
        opStack.append(Op.operand(operand))
        opStack1.append(Op.operand(operand))
        return evaluate()

    }

    /**
     add one operand into the stack
     */
    func addOperand(_ operand: Double) {
        opStack.append(Op.operand(operand))
        opStack1.append(Op.operand(operand))
    }

    /**
     return the type of a specific operation
     */
    func checkOperation(_ symbol: String) -> Int {
        var res = 0
        if let operation = knownOps[symbol] {
            switch operation {
            case .unaryOperation(_, _):
                res = 1
            case .binaryOperation(_, _):
                res = 2
            case .forceBinaryOperation(_, _):
                res = 2
            default:
                break
            }
        }
        return res
    }

    /**
     add one operation into the stack
     */
    func addOperation(_ symbol: String) {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
            opStack1.append(operation)
        }
    }

    /**
     add one parenthese into the stack
     */
    func addBracket(_ symbol: String) {
        if symbol == "(" {
            opStack.append(Op.bracket(symbol))
            opStack1.append(Op.bracket(symbol))
        } else {
            opStack1.append(Op.bracket(symbol))
        }
    }

    /**
     print the current stack
     */
    func printLabel() -> String {
        var s = ""
        for Op in opStack1 {
            s = s + Op.description + " "
        }
        return s
    }

    /**
     clean up the stack
     */
    func clearOpStack() {
        opStack.removeAll()
        opStack1.removeAll()
    }

    /**
     return the name of the last input operation or operand
     */
    func peakOpStack() -> String {
        if(!opStack.isEmpty) {
            return opStack.last!.description }
            else {
                return "" }
    }

    /**
     remove the last operation or operand
     */
    func popOpStack() -> String {
        opStack1.removeLast()
        return opStack.removeLast().description
    }

    /**
     format the number
     */
    func addComma(_ number: Double) -> String {
        let numberFormatter = NumberFormatter()

        // if the number is too long, change it to scientific style
        if(number >= pow(10.0, Double(DataStruct.DigitLimit)) || number <= -1.0 * pow(10.0, Double(DataStruct.DigitLimit)) || (number >= -1.0 * pow(10.0, -1.0 * Double(DataStruct.DigitLimit - 1)) && number < 0) || (number <= pow(10.0, -1.0 * Double(DataStruct.DigitLimit - 1)) && number > 0)) {
            numberFormatter.numberStyle = NumberFormatter.Style.scientific
            numberFormatter.maximumFractionDigits = DataStruct.DigitLimit - 4
        }

        // change the number to decimal style
            else if (number < pow(10.0, Double(DataStruct.DigitLimit)) && number > -1.0 * pow(10.0, Double(DataStruct.DigitLimit))) {

                var n = 0
                var tmpInt = Int(number)
                while(tmpInt != 0) {
                    n += 1
                    tmpInt /= 10
                }
                numberFormatter.numberStyle = NumberFormatter.Style.decimal
                numberFormatter.maximumFractionDigits = DataStruct.DigitLimit - n
        }

        return numberFormatter.string(from: (number as NSNumber))!
    }

    /**
     format the number
     */
    func addComma(_ number: Int) -> String {
//        print(Int.max)
        let numberFormatter = NumberFormatter()
        if(number >= Int(pow(10.0, Double(DataStruct.DigitLimit))) || number <= Int(-1 * pow(10.0, Double(DataStruct.DigitLimit)))) {
            numberFormatter.numberStyle = NumberFormatter.Style.scientific
            numberFormatter.maximumFractionDigits = DataStruct.DigitLimit - 4
        } else {
            numberFormatter.numberStyle = NumberFormatter.Style.decimal
            numberFormatter.maximumFractionDigits = DataStruct.DigitLimit
        }
        return numberFormatter.string(from: (number as NSNumber))!
    }

    func cleanM() {
        m = 0
    }

    func addM(_ add: Double) {
        m += add
    }

    /**
     remove the last digit from the user input label
     */
    func removeLastNumber(_ str: String) -> (String, String) {
        var str = str
        var removedNumber = ""
        while(str.characters.count != 0) {
            let char = str.substring(from: str.characters.index(str.endIndex, offsetBy: -1))
            if(char == ")" && removedNumber == "") {
                while(str.characters.count != 0) {
                    let char2 = str.substring(from: str.characters.index(str.endIndex, offsetBy: -1))
                    if (char2 != "(") {
                        removedNumber = String(str.remove(at: str.characters.index(str.endIndex, offsetBy: -1))) + removedNumber
                    } else {
                        break
                    }
                }
                if(str.characters.count != 0) {
                    removedNumber = String(str.remove(at: str.characters.index(str.endIndex, offsetBy: -1))) + removedNumber
                }
                break
            }
            if (char.unicodeScalars.first?.value >= 48 && char.unicodeScalars.first?.value <= 57) || char == "-" || char == "." || char == "E" || char == "N" || char == "a" {
                removedNumber = String(str.remove(at: str.characters.index(str.endIndex, offsetBy: -1))) + removedNumber
            } else {
                break
            }
        }

        return (str, removedNumber)
    }

    /**
     remove the last operation of the user input label
     */
    func removeLastOperation(_ str: String) -> String {
        var str = str
        while(str.characters.count != 0) {
            let char = str.substring(from: str.characters.index(str.endIndex, offsetBy: -1))
            if (char.unicodeScalars.first?.value < 48 || char.unicodeScalars.first?.value > 57) {
                str.remove(at: str.characters.index(str.endIndex, offsetBy: -1))
            } else {
                break
            }
        }

        return str

    }

    /**
     add one opeartion to the user input label
     */
    func addOperation(_ basStr: String, operation: String) -> String
    {
        var res = ""
        if operation == "+" || operation == "−" || operation == "×" || operation == "/" {
            res = basStr + " \(operation) "
        } else if operation == "ⁿ√" {
            res = basStr + " ^ ¹/"
        } else if operation == "xⁿ" {
            res = basStr + " ^ "
        }

        return res
    }

    //MARK: - save/get calculation history
    func saveCalculationHistory(_ displayText: String, resultText: String, resultNumber: Double)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "CalculateHistory", in: managedContext)

        let item = NSManagedObject(entity: entity!, insertInto: managedContext)
        item.setValue(displayText, forKey: "displayText")
        item.setValue(resultText, forKey: "resultText")
        item.setValue(Date.init(), forKey: "date")
        item.setValue(resultNumber, forKey: "resultNumber")
        do {
            try managedContext.save()

        } catch {
            print("Error")
        }
    }

    func retrieveCalculationHistory() -> [CalculateHistory]
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest: NSFetchRequest<CalculateHistory> = CalculateHistory.fetchRequest()

//        let fetchRequest = NSFetchRequest(entityName: "CalculateHistory")
        do {
            let result = try managedContext.fetch(fetchRequest)
            return result
        } catch {
            print("Check Saved Data Error")
        }
        return []
    }
}
