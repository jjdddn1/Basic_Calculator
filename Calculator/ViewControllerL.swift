//
//  ViewControllerL.swift
//  Calculator
//
//  Created by Huiyuan Ren on 16/1/26.
//  Copyright © 2016年 Huiyuan Ren. All rights reserved.
//

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

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


class ViewControllerL: UIViewController, CalculationHistoryViewControllerDelegate {
    @IBOutlet weak var display: UILabel!

    let swipeRec = UISwipeGestureRecognizer()

    // variables to record the state of the calculation
    var userIsInTheMiddleOfTypingANumber: Bool = false // user is typing numbers
    var duplicateOp = false // user only input one operation
    var dupDot = false // user only input one dot
    var firstZero = true // there is only one zero at the beginning of the number
    var finishedCalculation: Bool = true // one round calculation finished

    @IBOutlet weak var clear: UIButton!

    @IBOutlet weak var divide: UIButton!

    @IBOutlet weak var multiple: UIButton!

    @IBOutlet weak var minus: UIButton!

    @IBOutlet weak var plus: UIButton!

    @IBOutlet weak var xpown: UIButton!

    @IBOutlet weak var nSqrt: UIButton!

    @IBOutlet weak var mr: UIButton!

    @IBOutlet weak var calculatingLabel: UILabel! // user input label, show what did th user put

    @IBOutlet weak var settingButton: UIButton!

    @IBOutlet weak var backGroundView: UIImageView!

    weak var historyViewConroller: CalculationHistoryViewController!

    override func viewDidLoad() {
        setUpSkin()
        //add swipe gesture
        if(DataStruct.beforeViewControllerP != nil) {
            DataStruct.beforeViewControllerP!.dismiss(animated: false, completion: nil)
        }
        swipeRec.addTarget(self, action: #selector(self.swipedView))
        display.addGestureRecognizer(swipeRec)
        display.isUserInteractionEnabled = true
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setUpSkin() {
        if(style == 1) {
            backGroundView.layer.backgroundColor = UIColor.clear.cgColor
        } else if(style == 2) {
            self.view.backgroundColor = UIColor(red: 60 / 255, green: 70 / 255, blue: 80 / 255, alpha: 1)
            backGroundView.image = UIImage(named: "bg_l.png")
            display.font = UIFont(name: "Avenir Next Condensed Ultra Light", size: 64)

        }
    }

    @objc func swipedView() {

        // return if current display value is invalid
        if(display.text == "+∞" || display.text == "-∞" || display.text == "NaN") {
            return
        }

        var length = display.text!.count

        //if swipe when calculation ended, clean up the user input label and start a new round
        if(finishedCalculation == true) {
            calculatingLabel.text = display.text!.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
            finishedCalculation = false
        }

        // if there are more than 1 number
        if(length > 1) {
            let endIndex = display.text!.index(display.text!.endIndex, offsetBy: -1)
            print(display.text!)

            // check the edge situation
            if(display.text![endIndex] == ".") {
                dupDot = false; // if gonna remove dot
            } else if(display.text![display.text!.index(endIndex, offsetBy: -1)] == "E") {
                length = length - 1
                calculatingLabel.text = String(calculatingLabel.text![..<calculatingLabel.text!.index(calculatingLabel.text!.endIndex, offsetBy: -1)])
            } else if(display.text![display.text!.index(endIndex, offsetBy: -1)] == "-" && length > 2 && display.text![display.text!.index(endIndex, offsetBy: -2)] == "E") {
                length = length - 2
                calculatingLabel.text = String(calculatingLabel.text![..<calculatingLabel.text!.index(calculatingLabel.text!.endIndex, offsetBy: -2)])
            } else if(String(calculatingLabel.text![calculatingLabel.text!.index(calculatingLabel.text!.endIndex, offsetBy: -1)]) == ")") {
                calculatingLabel.text = brain.removeLastNumber(calculatingLabel.text!).0 + display.text!.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)

            }

            // remove one digit
            let tmpText = (display.text! as NSString).substring(to: length - 1)
            calculatingLabel.text = String(calculatingLabel.text![..<calculatingLabel.text!.index(calculatingLabel.text!.endIndex, offsetBy: -1)])

            //reset the format
            if tmpText.contains(".") == false && tmpText.contains(",") {
                let tmpInt = Int(tmpText.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil))!
                display.text = brain.addComma(tmpInt)
            } else {
                display.text = tmpText
            }

        } else if length == 1 {
            displayValue = 0
            calculatingLabel.text = brain.removeLastNumber(calculatingLabel.text!).0 + "0"
        }
    }

    override func viewDidAppear(_ animated: Bool) {

        //load prior state


        if(style == 1) {
            self.plus.setBackgroundImage(DataStruct.beforePlusImage, for: UIControlState())
            self.minus.setBackgroundImage(DataStruct.beforeMinusImage, for: UIControlState())
            self.divide.setBackgroundImage(DataStruct.beforeDivideImage, for: UIControlState())
            self.multiple.setBackgroundImage(DataStruct.beforeMultipleImage, for: UIControlState())
            self.xpown.setBackgroundImage(DataStruct.beforexPownImage, for: UIControlState())
            self.nSqrt.setBackgroundImage(DataStruct.beforenSqrtImage, for: UIControlState())
            self.mr.setBackgroundImage(DataStruct.beforenMrImage, for: UIControlState())
        } else if style == 2 {
            self.plus.layer.borderWidth = DataStruct.beforePlusWidth!
            self.minus.layer.borderWidth = DataStruct.beforeMinusWidth!
            self.divide.layer.borderWidth = DataStruct.beforeDivideWidth!
            self.multiple.layer.borderWidth = DataStruct.beforeMultipleWidth!
            self.xpown.layer.borderWidth = DataStruct.beforexPownWidth!
            self.nSqrt.layer.borderWidth = DataStruct.beforenSqrtWidth!
            self.mr.layer.borderWidth = DataStruct.beforenMrWidth!

            self.plus.layer.borderColor = DataStruct.beforePlusColor!
            self.minus.layer.borderColor = DataStruct.beforeMinusColor!
            self.divide.layer.borderColor = DataStruct.beforeDivideColor!
            self.multiple.layer.borderColor = DataStruct.beforeMultipleColor
            self.xpown.layer.borderColor = DataStruct.beforexPownColor
            self.nSqrt.layer.borderColor = DataStruct.beforenSqrtColor
            self.mr.layer.borderColor = DataStruct.beforenMrColor
        }

        self.clear.setTitle(DataStruct.beforeClear, for: UIControlState())
        if(style == 2) {
            let attrString: NSMutableAttributedString = NSMutableAttributedString(string: clear.currentTitle!)
            attrString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: NSMakeRange(0, attrString.length))
            attrString.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "Cochin", size: 24)!, range: NSMakeRange(0, attrString.length))
            clear.setAttributedTitle(attrString, for: UIControlState())
        }
        self.userIsInTheMiddleOfTypingANumber = DataStruct.userIsInTheMiddleOfTypingANumber
        self.dupDot = DataStruct.dupDot
        self.duplicateOp = DataStruct.duplicateOp
        self.firstZero = DataStruct.firstZero
        self.finishedCalculation = DataStruct.finishedCalculation

        calculatingLabel.text = DataStruct.beforeString

        if(!userIsInTheMiddleOfTypingANumber && DataStruct.beforeNumber != "0") {
            displayValue = DataStruct.beforeRealNumber
        } else {
            display.text = DataStruct.beforeNumber
        }

    }


    /**add a border to specific button*/
    func setButtonImage (_ name: String) -> Bool {
        if(style == 1) {
            switch name {
            case "+":
                plus.setBackgroundImage(UIImage(named: "Caution-Border-02--Arvin61r58.png"), for: UIControlState())
                return true
            case "−":
                minus.setBackgroundImage(UIImage(named: "Caution-Border-02--Arvin61r58.png"), for: UIControlState())
                return true
            case "×":
                multiple.setBackgroundImage(UIImage(named: "Caution-Border-02--Arvin61r58.png"), for: UIControlState())
                return true
            case "/":
                divide.setBackgroundImage(UIImage(named: "Caution-Border-02--Arvin61r58.png"), for: UIControlState())
                return true
            case "xⁿ":
                xpown.setBackgroundImage(UIImage(named: "Caution-Border-02--Arvin61r58.png"), for: UIControlState())
                return true
            case "ⁿ√":
                nSqrt.setBackgroundImage(UIImage(named: "Caution-Border-02--Arvin61r58.png"), for: UIControlState())
                return true
            default:
                return false
            }
        } else if (style == 2) {
            switch name {
            case "+":
                plus.layer.borderColor = UIColor.white.cgColor
                plus.layer.borderWidth = 3
                return true
            case "−":
                minus.layer.borderColor = UIColor.white.cgColor
                minus.layer.borderWidth = 3
                return true
            case "×":
                multiple.layer.borderColor = UIColor.white.cgColor
                multiple.layer.borderWidth = 3
                return true
            case "/":
                divide.layer.borderColor = UIColor.white.cgColor
                divide.layer.borderWidth = 3
                return true
            case "xⁿ":
                xpown.layer.borderColor = UIColor.white.cgColor
                xpown.layer.borderWidth = 3
                return true
            case "ⁿ√":
                nSqrt.layer.borderColor = UIColor.white.cgColor
                nSqrt.layer.borderWidth = 3

                return true
            default:
                return false
            }
        }
        return false
    }

    /**
     cleanup all the
     */
    func clean_Image() {
        if(style == 1) {
            plus.setBackgroundImage(nil, for: UIControlState())
            minus.setBackgroundImage(nil, for: UIControlState())
            divide.setBackgroundImage(nil, for: UIControlState())
            multiple.setBackgroundImage(nil, for: UIControlState())
            xpown.setBackgroundImage(nil, for: UIControlState())
            nSqrt.setBackgroundImage(nil, for: UIControlState())
        } else if style == 2 {
            plus.layer.borderColor = DataStruct.red
            plus.layer.borderWidth = 1
            minus.layer.borderColor = DataStruct.red
            minus.layer.borderWidth = 1
            divide.layer.borderColor = DataStruct.red
            divide.layer.borderWidth = 1
            multiple.layer.borderColor = DataStruct.red
            multiple.layer.borderWidth = 1
            xpown.layer.borderColor = DataStruct.blue
            xpown.layer.borderWidth = 1
            nSqrt.layer.borderColor = DataStruct.blue
            nSqrt.layer.borderWidth = 1
        }
    }

    /**
     add one digit
     */
    @IBAction func appendDigit(_ sender: UIButton) {
        clean_Image()
        let digit = sender.currentTitle!
        clear.setTitle("C", for: UIControlState())
        if(style == 2) {
            let attrString: NSMutableAttributedString = NSMutableAttributedString(string: clear.currentTitle!)
            attrString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: NSMakeRange(0, attrString.length))
            attrString.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "Cochin", size: 24)!, range: NSMakeRange(0, attrString.length))
            clear.setAttributedTitle(attrString, for: UIControlState())
        }
        // if the user is typing number, add digit after the current digit
        if userIsInTheMiddleOfTypingANumber {

            let tmpText = display.text! + digit
            var removeAll = tmpText.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
            removeAll = removeAll.replacingOccurrences(of: ".", with: "", options: NSString.CompareOptions.literal, range: nil)

            //limit the total number of digits
            if removeAll.count <= DataStruct.DigitLimit {
                self.calculatingLabel.text = self.calculatingLabel.text! + digit
                if tmpText.contains(".") == false {
                    display.text = brain.addComma(Int(tmpText.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil))!)
                } else {
                    display.text = tmpText
                }
            } else {
                dupDot = true
            }

        } else {
            if digit != "0" {
                firstZero = false
            }

            // if the first digit is not zero
            if !firstZero {
                if(!finishedCalculation) {

                    self.calculatingLabel.text = brain.removeLastNumber(self.calculatingLabel.text!).0 + (display.text! == "-0" ? "-" : "") + digit

                    display.text = (display.text! == "-0" ? "-" : "") + digit
                    userIsInTheMiddleOfTypingANumber = true }
                    else {

                        self.calculatingLabel.text = digit
                        display.text = digit
                        userIsInTheMiddleOfTypingANumber = true
                        finishedCalculation = false
                }
            }

            // if the first digit is zero
                else {
                    display.text = "0"
                    if !finishedCalculation {
                        calculatingLabel.text = brain.removeLastNumber(calculatingLabel.text!).0 + "0"
                    } else {
                        calculatingLabel.text = "0"

                    }
            }
        }
        duplicateOp = false
    }

    /**
     press clean button
    */
    @IBAction func Clean(_ clear: UIButton) {

        // when the button is AC clean everything
        if(clear.currentTitle == "AC") {
//            print("AC pressed")
            clean_Image()
            display.text = "0"
            userIsInTheMiddleOfTypingANumber = false
            duplicateOp = false
            dupDot = false
            firstZero = true
            finishedCalculation = true
            brain.clearOpStack()

            self.calculatingLabel.text = ""

            // when the button is C clean the current display number
        } else {
            display.text = "0"
            userIsInTheMiddleOfTypingANumber = false
            dupDot = false
            firstZero = true
            let name = brain.peakOpStack()
            duplicateOp = setButtonImage(name)

            self.calculatingLabel.text = brain.removeLastNumber(self.calculatingLabel.text!).0

        }
        if(brain.stackNumber() == 0) {
            finishedCalculation = true
        }
        clear.setTitle("AC", for: UIControlState())
        if(style == 2) {
            let attrString: NSMutableAttributedString = NSMutableAttributedString(string: clear.currentTitle!)
            attrString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: NSMakeRange(0, attrString.length))
            attrString.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "Cochin", size: 24)!, range: NSMakeRange(0, attrString.length))
            clear.setAttributedTitle(attrString, for: UIControlState())
        }
        DataStruct.beforeRealNumber = 0.0
    }

    /**
     press the dot button
     */
    @IBAction func dot(_ sender: UIButton) {
        clean_Image()

        //if the user was typing, append one dot at the end
        if userIsInTheMiddleOfTypingANumber {
            if !dupDot {

                display.text = display.text! + "."
                calculatingLabel.text = calculatingLabel.text! + "."
                dupDot = true
            }

            // if not add a '0.'
        } else {

            if(finishedCalculation) {
                calculatingLabel.text = "0."
                finishedCalculation = false
            } else {
                calculatingLabel.text = brain.removeLastNumber(calculatingLabel.text!).0 + "0."
            }

            display.text = "0."
            dupDot = true
            userIsInTheMiddleOfTypingANumber = true
        }

    }

    /**
     press the enter button
     */
    @IBAction func enter() {

        //return when the display value is invalid
        if(display.text == "+∞" || display.text == "-∞" || display.text == "NaN") {
            finishedCalculation = true
            return
        }
        if(calculatingLabel.text!.count > 1) {
            let char = calculatingLabel.text!.substring(from: calculatingLabel.text!.characters.index(calculatingLabel.text!.endIndex, offsetBy: -1))
            if(!finishedCalculation && !userIsInTheMiddleOfTypingANumber && char != ")" && (char.unicodeScalars.first?.value < 48 || char.unicodeScalars.first?.value > 57)) {
                calculatingLabel.text = calculatingLabel.text! + display.text!.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)

            }
        }


        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }

        // update the user input label
        if(!finishedCalculation) {
            calculatingLabel.text = calculatingLabel.text! + " = " + display.text!.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
            brain.saveCalculationHistory(calculatingLabel.text!, resultText: display.text!, resultNumber: DataStruct.beforeRealNumber)
        }
        clear.setTitle("AC", for: UIControlState())
        if(style == 2) {
            let attrString: NSMutableAttributedString = NSMutableAttributedString(string: clear.currentTitle!)
            attrString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: NSMakeRange(0, attrString.length))
            attrString.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "Cochin", size: 24)!, range: NSMakeRange(0, attrString.length))
            clear.setAttributedTitle(attrString, for: UIControlState())
        }
        userIsInTheMiddleOfTypingANumber = false
        duplicateOp = false
        firstZero = true
        dupDot = false
        clean_Image()
        finishedCalculation = true

    }

    // set or get the display value
    var displayValue: Double {
        get {
            if (display.text!.contains("NaN")) {
                return 0
            }
            return NumberFormatter().number(from: display.text!.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil))!.doubleValue
        } set {

            if(newValue.truncatingRemainder(dividingBy: 1) == 0 && newValue < Double(Int.max) && newValue > Double(Int.min)) {

                let bInt = Int(newValue)
                display.text = brain.addComma(bInt)

            }
                else
            {
                display.text = brain.addComma(newValue)
            }
            if(display.text?.contains("∞") == true || display.text?.contains("NaN") == true) {
                finishedCalculation = true
            } else {
                DataStruct.beforeRealNumber = newValue
            }
            userIsInTheMiddleOfTypingANumber = false
        }

    }

    /**
     operate an operation
     */
    @IBAction func operate(_ sender: UIButton) {
        if(display.text?.contains("∞") == true || display.text == "NaN") {
            return
        }

        // If first time enter operation
        if !duplicateOp {

            firstZero = true
            dupDot = false
            userIsInTheMiddleOfTypingANumber = false


            if let operation = sender.currentTitle {
//                print("finishedCalculation: ", finishedCalculation)

                if(finishedCalculation == true) {
                    calculatingLabel.text = display.text!.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
                    finishedCalculation = false
                }
                if(calculatingLabel.text![calculatingLabel.text!.index(calculatingLabel.text!.endIndex, offsetBy: -1)...] == "(") {
                    calculatingLabel.text = calculatingLabel.text! + display.text!.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
                    finishedCalculation = false

                }

                let check = brain.checkOperation(operation)

                // unary operation
                if check == 1 {
                    let dis = brain.doUnaryCal(displayValue, symbol: operation)
                    displayValue = dis

                    self.calculatingLabel.text = brain.removeLastNumber(self.calculatingLabel.text!).0 + display.text!.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
                }
                // binary operation
                    else if check == 2 {
                        brain.addOperand(displayValue)
                        brain.addOperation(operation)
                        if(style == 1) {
                            sender.setBackgroundImage(UIImage(named: "Caution-Border-02--Arvin61r58.png"), for: UIControlState())
                        } else if style == 2 {
                            sender.layer.borderColor = UIColor.white.cgColor
                            sender.layer.borderWidth = 3
                        }
                        duplicateOp = true
                        self.calculatingLabel.text = brain.addOperation(self.calculatingLabel.text!, operation: operation)
                }
            }
        }

        // if entered one operation before
            else {
                if let operation = sender.currentTitle {

                    let check = brain.checkOperation(operation)
                    if check == 2 {
                        _ = brain.popOpStack() // delete the last operation
                        brain.addOperation(operation)
                        clean_Image()
                        if(style == 1) {
                            sender.setBackgroundImage(UIImage(named: "Caution-Border-02--Arvin61r58.png"), for: UIControlState())
                        } else if style == 2 {
                            sender.layer.borderColor = UIColor.white.cgColor
                            sender.layer.borderWidth = 3
                        }
                        self.calculatingLabel.text = brain.addOperation(brain.removeLastOperation(self.calculatingLabel.text!), operation: operation)

                    } else if check == 1 {
                        if(operation == "π" || operation == "e") {
                            let dis = brain.doUnaryCal(displayValue, symbol: operation)
                            displayValue = dis

                            self.calculatingLabel.text = brain.removeLastNumber(self.calculatingLabel.text!).0 + display.text!.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
                            duplicateOp = false
                        }
                    }
                }

        }

    }

    /**
     +/- operation
     */
    @IBAction func plusMinus(_ sender: UIButton) {
        if(display.text?.contains("∞") == true || display.text?.contains("NaN") == true) {
            return
        }

        if(!duplicateOp) {
            if(display.text![display.text!.startIndex] == "-") {
                display.text!.remove(at: display.text!.startIndex)
            } else {
                display.text!.insert("-", at: display.text!.startIndex)
            }
            if(finishedCalculation) {
                calculatingLabel.text = display.text!.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
                finishedCalculation = false
            } else {
                self.calculatingLabel.text = brain.removeLastNumber(self.calculatingLabel.text!).0 + display.text!.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
            }
        } else {
            displayValue = 0
            display.text!.insert("-", at: display.text!.startIndex)
            self.calculatingLabel.text = brain.removeLastNumber(self.calculatingLabel.text!).0 + "-0"
        }
    }

    /**
     m+, m-, mc, mr operation
     */
    @IBAction func mOperation(_ sender: UIButton) {
        if(sender.currentTitle == "mc") {
            if(style == 1) {
                mr.setBackgroundImage(UIImage(named: ""), for: UIControlState())
            } else if style == 2 {
                mr.layer.borderColor = DataStruct.blue
                mr.layer.borderWidth = 1
            }
            brain.cleanM()
        } else if(sender.currentTitle == "m+") {
            if(style == 1) {
                mr.setBackgroundImage(UIImage(named: "Caution-Border-02--Arvin61r58.png"), for: UIControlState())
            } else if style == 2 {
                mr.layer.borderColor = UIColor.white.cgColor
                mr.layer.borderWidth = 3
            }

            brain.addM(displayValue)
        } else if(sender.currentTitle == "m-") {
            if(style == 1) {
                mr.setBackgroundImage(UIImage(named: "Caution-Border-02--Arvin61r58.png"), for: UIControlState())
            } else if style == 2 {
                mr.layer.borderColor = UIColor.white.cgColor
                mr.layer.borderWidth = 3
            }
            brain.addM(-displayValue)
        } else {
            userIsInTheMiddleOfTypingANumber = false
            displayValue = brain.doUnaryCal(displayValue, symbol: sender.currentTitle!)
            if(!finishedCalculation) {
                self.calculatingLabel.text = brain.removeLastNumber(self.calculatingLabel.text!).0 + self.display.text!.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
                clean_Image()
            } else {
                self.calculatingLabel.text = self.display.text!.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)

            }
        }

    }

    /**
     left parenthese button
     */
    @IBAction func leftBracket(_ sender: UIButton) {
//        if( display.text?.containsString("∞") == true || display.text?.containsString("NaN") == true){
//            return;
//        }
        duplicateOp = false
        userIsInTheMiddleOfTypingANumber = false
        brain.addBracket("(")

        if(finishedCalculation) {
            calculatingLabel.text = "("
            finishedCalculation = false
            display.text = "0"
        } else {
            calculatingLabel.text = brain.removeLastNumber(calculatingLabel.text!).0 + "("
        }
    }

    /**
     right parenthese button
     */
    @IBAction func rightBracket(_ sender: UIButton) {
        if(display.text?.contains("∞") == true || display.text?.contains("NaN") == true) {
            return
        }
//        if(calculatingLabel.text!.characters.count == 0){
//            return
//        }

        if(finishedCalculation) {
            calculatingLabel.text = ")"
            finishedCalculation = false
            display.text = "0"
        } else {
            let char = calculatingLabel.text!.substring(from: calculatingLabel.text!.characters.index(calculatingLabel.text!.endIndex, offsetBy: -1))

            // solove the problem that a ) come right after an operation
            if(!userIsInTheMiddleOfTypingANumber && char != ")" && (char.unicodeScalars.first?.value < 48 || char.unicodeScalars.first?.value > 57)) {
                calculatingLabel.text = calculatingLabel.text! + display.text!.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)

            }
            calculatingLabel.text = calculatingLabel.text! + ")"
        }

        if let result = brain.calculateRightBracket(displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }
        brain.addBracket(")")
        userIsInTheMiddleOfTypingANumber = false
        duplicateOp = false
        firstZero = true
        dupDot = false
        clean_Image()
    }

    @IBAction func swipeFromRightEdge(_ sender: AnyObject) {
        showHistories()
    }

    func showHistories()
    {
        self.performSegue(withIdentifier: "showHistories", sender: self)
    }



    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        if(!DataStruct.enterSetting && !toInterfaceOrientation.isLandscape) {
//            let backView = self.storyboard?.instantiateViewControllerWithIdentifier("Portrait") as? ViewControllerP
//
//            self.presentViewController(backView!, animated: false, completion: nil)
//
            self.performSegue(withIdentifier: "back", sender: self)
        }
    }

    func calculationHistoryViewController(_ controller: CalculationHistoryViewController, controllerWillDisappear willDisappear: Bool) {
        if willDisappear {
            historyViewConroller = nil
        }
    }

    func calculationHistoryViewController(_ controller: CalculationHistoryViewController, displayHistory history: CalculateHistory) {
        display.text = history.value(forKey: "resultText") as? String
        calculatingLabel.text = history.value(forKey: "displayText") as? String
        DataStruct.beforeRealNumber = history.value(forKey: "resultNumber") as! Double
        DataStruct.beforeString = calculatingLabel.text!
        finishedCalculation = true
        clear.setTitle("AC", for: UIControlState())
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        DataStruct.beforeViewController = self

        if(segue.identifier == "back") {

            DataStruct.beforePlusImage = self.plus.currentBackgroundImage
            DataStruct.beforeMinusImage = self.minus.currentBackgroundImage
            DataStruct.beforeDivideImage = self.divide.currentBackgroundImage
            DataStruct.beforeMultipleImage = self.multiple.currentBackgroundImage
            DataStruct.beforexPownImage = self.xpown.currentBackgroundImage
            DataStruct.beforenSqrtImage = self.nSqrt.currentBackgroundImage
            DataStruct.beforenMrImage = self.mr.currentBackgroundImage

            DataStruct.beforePlusWidth = self.plus.layer.borderWidth
            DataStruct.beforeMinusWidth = self.minus.layer.borderWidth
            DataStruct.beforeDivideWidth = self.divide.layer.borderWidth
            DataStruct.beforeMultipleWidth = self.multiple.layer.borderWidth
            DataStruct.beforexPownWidth = self.xpown.layer.borderWidth
            DataStruct.beforenSqrtWidth = self.nSqrt.layer.borderWidth
            DataStruct.beforenMrWidth = self.mr.layer.borderWidth

            DataStruct.beforePlusColor = self.plus.layer.borderColor
            DataStruct.beforeMinusColor = self.minus.layer.borderColor
            DataStruct.beforeDivideColor = self.divide.layer.borderColor
            DataStruct.beforeMultipleColor = self.multiple.layer.borderColor
            DataStruct.beforexPownColor = self.xpown.layer.borderColor
            DataStruct.beforenSqrtColor = self.nSqrt.layer.borderColor
            DataStruct.beforenMrColor = self.mr.layer.borderColor

            DataStruct.beforeNumber = self.display.text!
            DataStruct.beforeClear = self.clear.currentTitle
            DataStruct.userIsInTheMiddleOfTypingANumber = self.userIsInTheMiddleOfTypingANumber
            DataStruct.dupDot = self.dupDot
            DataStruct.duplicateOp = self.duplicateOp
            DataStruct.firstZero = self.firstZero
            DataStruct.finishedCalculation = self.finishedCalculation
            DataStruct.beforeString = self.calculatingLabel.text!

            DataStruct.isPortrait = true

            self.dismiss(animated: false, completion: nil)


        } else if(segue.identifier == "setting") {
//            print("preform segue")
            DataStruct.enterSetting = true
            let des = segue.destination as! SettingViewController
            des.x = settingButton.frame.minX
            des.y = settingButton.frame.minY
        } else if segue.identifier == "showHistories" {
            let controller = segue.destination as! CalculationHistoryViewController
            controller.delegate = self
            historyViewConroller = controller
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
