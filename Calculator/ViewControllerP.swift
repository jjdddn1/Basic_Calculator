//
//  ViewController.swift
//  Calculator
//
//  Created by Huiyuan Ren on 15/9/5.
//  Copyright (c) 2015年 Huiyuan Ren. All rights reserved.
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


class ViewControllerP: UIViewController, CalculationHistoryViewControllerDelegate {

    let swipeRec = UISwipeGestureRecognizer()

    // variables to record the state of the calculation
    var userIsInTheMiddleOfTypingANumber: Bool = false // user is typing numbers
    var duplicateOp = false // user only input one operation
    var dupDot = false // user only input one dot
    var firstZero = true // there is only one zero at the beginning of the number
    var finishedCalculation: Bool = true // one round calculation finished

    weak var tipViewController: TipsViewController!
    weak var historyViewConroller: CalculationHistoryViewController!

    @IBOutlet weak var display: UILabel!

    @IBOutlet weak var clear: UIButton!

    @IBOutlet weak var divide: UIButton!

    @IBOutlet weak var multiple: UIButton!

    @IBOutlet weak var minus: UIButton!

    @IBOutlet weak var plus: UIButton!

    @IBOutlet weak var backGroundView: UIImageView!

    @IBOutlet weak var calculatingLabel: UILabel!

    override func viewDidLoad() {
        if(DataStruct.beforeViewControllerP != nil) {
            DataStruct.beforeViewControllerP!.dismiss(animated: false, completion: nil)
        }
        setUpSkin()
        swipeRec.addTarget(self, action: #selector(ViewControllerP.swipedView))
        display.addGestureRecognizer(swipeRec)
        display.isUserInteractionEnabled = true


        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {

        //load prior state
        display.text = DataStruct.beforeNumber

        if(style == 1) {
            self.plus.setBackgroundImage(DataStruct.beforePlusImage, for: UIControlState())
            self.minus.setBackgroundImage(DataStruct.beforeMinusImage, for: UIControlState())
            self.divide.setBackgroundImage(DataStruct.beforeDivideImage, for: UIControlState())
            self.multiple.setBackgroundImage(DataStruct.beforeMultipleImage, for: UIControlState())
        } else if style == 2 {
            self.plus.layer.borderWidth = DataStruct.beforePlusWidth!
            self.minus.layer.borderWidth = DataStruct.beforeMinusWidth!
            self.divide.layer.borderWidth = DataStruct.beforeDivideWidth!
            self.multiple.layer.borderWidth = DataStruct.beforeMultipleWidth!

            self.plus.layer.borderColor = DataStruct.beforePlusColor!
            self.minus.layer.borderColor = DataStruct.beforeMinusColor!
            self.divide.layer.borderColor = DataStruct.beforeDivideColor!
            self.multiple.layer.borderColor = DataStruct.beforeMultipleColor
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


    }

    override func viewWillAppear(_ animated: Bool) {
        self.calculatingLabel.text = DataStruct.beforeString
    }

    func setUpSkin() {
        if(style == 1) {
            backGroundView.layer.backgroundColor = UIColor.clear.cgColor
        } else if(style == 2) {
            self.view.backgroundColor = UIColor(red: 60 / 255, green: 70 / 255, blue: 80 / 255, alpha: 1)
            backGroundView.image = UIImage(named: "bg_p.png")
            display.font = UIFont(name: "Avenir Next Condensed Ultra Light", size: 64)

        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    @objc func swipedView() {
        if(display.text == "+∞" || display.text == "-∞" || display.text == "NaN") {
            return
        }

        if(finishedCalculation) {
            DataStruct.beforeString = display.text!.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
            self.calculatingLabel.text = DataStruct.beforeString
            finishedCalculation = false
        }

        var length = display.text!.characters.count

        if(length > 1) {
            let endIndex = display.text!.characters.index(display.text!.endIndex, offsetBy: -1)
            if(display.text![endIndex] == ".") {
                dupDot = false
            } else if(display.text![display.text!.characters.index(endIndex, offsetBy: -1)] == "E") {
                length = length - 1
                DataStruct.beforeString = DataStruct.beforeString.substring(to: DataStruct.beforeString.characters.index(DataStruct.beforeString.endIndex, offsetBy: -1))
                self.calculatingLabel.text = DataStruct.beforeString

            } else if(display.text![display.text!.characters.index(endIndex, offsetBy: -1)] == "-" && length > 2 && display.text![display.text!.characters.index(endIndex, offsetBy: -2)] == "E") {
                length = length - 2
                DataStruct.beforeString = DataStruct.beforeString.substring(to: DataStruct.beforeString.characters.index(DataStruct.beforeString.endIndex, offsetBy: -2))
                self.calculatingLabel.text = DataStruct.beforeString

            } else if(DataStruct.beforeString.substring(from: DataStruct.beforeString.characters.index(DataStruct.beforeString.endIndex, offsetBy: -1)) == ")") {
                DataStruct.beforeString = brain.removeLastNumber(DataStruct.beforeString).0 + display.text!.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
                self.calculatingLabel.text = DataStruct.beforeString
            }


            //remove one digit
            let tmpText = (display.text! as NSString).substring(to: length - 1)

            DataStruct.beforeString = DataStruct.beforeString.substring(to: DataStruct.beforeString.characters.index(DataStruct.beforeString.endIndex, offsetBy: -1))
            self.calculatingLabel.text = DataStruct.beforeString

            if tmpText.contains(".") == false && tmpText.contains(",") {
                let tmpInt = Int(tmpText.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil))!
                display.text = brain.addComma(tmpInt)
            } else {
                display.text = tmpText
            }

        } else if length == 1 {
            displayValue = 0
            DataStruct.beforeString = brain.removeLastNumber(DataStruct.beforeString).0
            self.calculatingLabel.text = DataStruct.beforeString

        }
    }


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

            default:
                return false
            }
        } else if(style == 2) {
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

            default:
                return false
            }
        }
        return false
    }

    func clean_Image() {
        if(style == 2) {
            plus.layer.borderColor = DataStruct.red
            plus.layer.borderWidth = 1
            minus.layer.borderColor = DataStruct.red
            minus.layer.borderWidth = 1
            divide.layer.borderColor = DataStruct.red
            divide.layer.borderWidth = 1
            multiple.layer.borderColor = DataStruct.red
            multiple.layer.borderWidth = 1
        }
        plus.setBackgroundImage(nil, for: UIControlState())
        minus.setBackgroundImage(nil, for: UIControlState())
        divide.setBackgroundImage(nil, for: UIControlState())
        multiple.setBackgroundImage(nil, for: UIControlState())
        DataStruct.beforexPownImage = nil
        DataStruct.beforenSqrtImage = nil

    }

    @IBAction func appendDigit(_ sender: UIButton) {
        clean_Image()
        let digit = sender.currentTitle!
        clear.setTitle("C", for: UIControlState())
        if style == 2 {
            let attrString: NSMutableAttributedString = NSMutableAttributedString(string: clear.currentTitle!)
            attrString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: NSMakeRange(0, attrString.length))
            attrString.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "Cochin", size: 24)!, range: NSMakeRange(0, attrString.length))
            clear.setAttributedTitle(attrString, for: UIControlState())
        }
        if userIsInTheMiddleOfTypingANumber {
            let tmpText = display.text! + digit
            var removeAll = tmpText.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
            removeAll = removeAll.replacingOccurrences(of: ".", with: "", options: NSString.CompareOptions.literal, range: nil)
            if removeAll.count <= DataStruct.DigitLimit {

                DataStruct.beforeString = DataStruct.beforeString + digit
                self.calculatingLabel.text = DataStruct.beforeString

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
            if !firstZero {
                if(!finishedCalculation) {

                    DataStruct.beforeString = brain.removeLastNumber(DataStruct.beforeString).0 + (display.text! == "-0" ? "-" : "") + digit
                    self.calculatingLabel.text = DataStruct.beforeString

                    display.text = (display.text! == "-0" ? "-" : "") + digit
                    userIsInTheMiddleOfTypingANumber = true }
                    else {
                        DataStruct.beforeString = digit
                        display.text = digit
                        self.calculatingLabel.text = DataStruct.beforeString
                        userIsInTheMiddleOfTypingANumber = true
                        finishedCalculation = false
                }
            }
                else {
                    display.text = "0"
                    if(!finishedCalculation) {
                        DataStruct.beforeString = brain.removeLastNumber(DataStruct.beforeString).0 + "0"
                        self.calculatingLabel.text = DataStruct.beforeString

                    } else {
                        DataStruct.beforeString = "0"
                        self.calculatingLabel.text = DataStruct.beforeString

                    }


            }
        }
        duplicateOp = false
    }

    @IBAction func Clean(_ clear: UIButton) {
        if(clear.currentTitle == "AC") {
            clean_Image()
            display.text = "0"
            userIsInTheMiddleOfTypingANumber = false
            duplicateOp = false
            dupDot = false
            firstZero = true
            brain.clearOpStack()
            finishedCalculation = true

            DataStruct.beforeString = ""
            self.calculatingLabel.text = DataStruct.beforeString

        } else {
            display.text = "0"
            userIsInTheMiddleOfTypingANumber = false
            dupDot = false
            firstZero = true
            let name = brain.peakOpStack()
            duplicateOp = setButtonImage(name)

            DataStruct.beforeString = brain.removeLastNumber(DataStruct.beforeString).0
            self.calculatingLabel.text = DataStruct.beforeString


        }

        clear.setTitle("AC", for: UIControlState())
        if(style == 2) {
            let attrString: NSMutableAttributedString = NSMutableAttributedString(string: clear.currentTitle!)
            attrString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: NSMakeRange(0, attrString.length))
            attrString.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "Cochin", size: 24)!, range: NSMakeRange(0, attrString.length))
            clear.setAttributedTitle(attrString, for: UIControlState())
        }
        if(brain.stackNumber() == 0) {
            finishedCalculation = true
        }
        DataStruct.beforeRealNumber = 0.0

    }

    @IBAction func dot(_ sender: UIButton) {
        clean_Image()
        if userIsInTheMiddleOfTypingANumber {
            if !dupDot {

                display.text = display.text! + "."
                DataStruct.beforeString = DataStruct.beforeString + "."
                self.calculatingLabel.text = DataStruct.beforeString

                dupDot = true
            }

        } else {

            if(finishedCalculation) {
                DataStruct.beforeString = "0."
                self.calculatingLabel.text = DataStruct.beforeString
                finishedCalculation = false
            } else {
                DataStruct.beforeString = brain.removeLastNumber(DataStruct.beforeString).0 + "0."
                self.calculatingLabel.text = DataStruct.beforeString
            }

            display.text = "0."
            dupDot = true
            userIsInTheMiddleOfTypingANumber = true
        }

    }
    @IBAction func enter() {

        if(display.text == "+∞" || display.text == "-∞" || display.text == "NaN") {
            finishedCalculation = true
            return
        }

        if(!finishedCalculation && !userIsInTheMiddleOfTypingANumber && DataStruct.beforeString.substring(from: DataStruct.beforeString.characters.index(DataStruct.beforeString.endIndex, offsetBy: -1)) != ")") {
            DataStruct.beforeString = DataStruct.beforeString + display.text!.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
            self.calculatingLabel.text = DataStruct.beforeString
        }

        if(DataStruct.beforeString.characters.count > 1) {
            let char = DataStruct.beforeString.substring(from: DataStruct.beforeString.characters.index(DataStruct.beforeString.endIndex, offsetBy: -1))
            if(!finishedCalculation && !userIsInTheMiddleOfTypingANumber && char != ")" && (char.unicodeScalars.first?.value < 48 || char.unicodeScalars.first?.value > 57)) {
                DataStruct.beforeString = DataStruct.beforeString + display.text!.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
                self.calculatingLabel.text = DataStruct.beforeString
            }
        }

        if let result = brain.pushOperand(displayValue) {
            displayValue = result
            if(!finishedCalculation) {
                DataStruct.isPortrait = false
                DataStruct.beforeString = DataStruct.beforeString + " = " + brain.addComma(result).replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
                self.calculatingLabel.text = DataStruct.beforeString
                brain.saveCalculationHistory(calculatingLabel.text!, resultText: display.text!, resultNumber: DataStruct.beforeRealNumber)
                DataStruct.isPortrait = true
            }
        } else {
            displayValue = 0
            if(!finishedCalculation) {
                DataStruct.beforeString = DataStruct.beforeString + " = " + display.text!.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
                self.calculatingLabel.text = DataStruct.beforeString
                brain.saveCalculationHistory(calculatingLabel.text!, resultText: display.text!, resultNumber: DataStruct.beforeRealNumber)
            }
        }



        clear.setTitle("AC", for: UIControlState())
        if(style == 2) {
            let attrString: NSMutableAttributedString = NSMutableAttributedString(string: clear.currentTitle!)
            attrString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: NSMakeRange(0, attrString.length))
            attrString.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "Cochin", size: 24)!, range: NSMakeRange(0, attrString.length))
            clear.setAttributedTitle(attrString, for: UIControlState())
        }
        duplicateOp = false
        firstZero = true
        dupDot = false
        clean_Image()
        userIsInTheMiddleOfTypingANumber = false

        finishedCalculation = true
    }
    var displayValue: Double {
        get {
            if (display.text!.contains("NaN")) {
                return 0
            }
            return NumberFormatter().number(from: display.text!.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil))!.doubleValue
        } set {
            if(newValue.truncatingRemainder(dividingBy: 1) == 0 && newValue < Double(Int.max)) {

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
    @IBAction func operate(_ sender: UIButton) {
        if(display.text?.contains("∞") == true || display.text?.contains("NaN") == true) {
            return
        }

        if !duplicateOp {

            if let operation = sender.currentTitle {

                if(finishedCalculation) {
                    DataStruct.beforeString = display.text!.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
                    self.calculatingLabel.text = DataStruct.beforeString
                    finishedCalculation = false
                }

                if(DataStruct.beforeString.substring(from: DataStruct.beforeString.characters.index(DataStruct.beforeString.endIndex, offsetBy: -1)) == "(") {
                    DataStruct.beforeString = DataStruct.beforeString + display.text!.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
                    self.calculatingLabel.text = DataStruct.beforeString
                    finishedCalculation = false
                }

                let check = brain.checkOperation(operation)
                if check == 1 {
                    var dis = 0.0
                    if(userIsInTheMiddleOfTypingANumber) {
                        dis = brain.doUnaryCal(displayValue, symbol: operation)
                    } else {
                        dis = brain.doUnaryCal(DataStruct.beforeRealNumber, symbol: operation)
                    }

                    displayValue = dis
                    DataStruct.beforeRealNumber = dis
                    DataStruct.isPortrait = false
                    DataStruct.beforeString = brain.removeLastNumber(DataStruct.beforeString).0 + brain.addComma(dis).replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
                    self.calculatingLabel.text = DataStruct.beforeString
                    DataStruct.isPortrait = true

                } else if check == 2 {
                    if(userIsInTheMiddleOfTypingANumber) {
                        brain.addOperand(displayValue)
                    } else {
                        brain.addOperand(DataStruct.beforeRealNumber)
                    }
                    brain.addOperation(operation)
                    _ = setButtonImage(sender.currentTitle!)
                    duplicateOp = true
                    DataStruct.beforeString = brain.addOperation(DataStruct.beforeString, operation: operation)
                    self.calculatingLabel.text = DataStruct.beforeString
                }


                firstZero = true
                dupDot = false
                userIsInTheMiddleOfTypingANumber = false
            }
        } else {
            if let operation = sender.currentTitle {

                let check = brain.checkOperation(operation)
                if check == 2 {
                    _ = brain.popOpStack()
                    brain.addOperation(operation)
                    clean_Image()
                    _ = setButtonImage(sender.currentTitle!)
                    DataStruct.beforeString = brain.addOperation(brain.removeLastOperation(DataStruct.beforeString), operation: operation)
                    self.calculatingLabel.text = DataStruct.beforeString

                }
            }

        }

    }

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
            DataStruct.beforeRealNumber = -DataStruct.beforeRealNumber

            if(finishedCalculation) {
                DataStruct.beforeString = display.text!.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
                self.calculatingLabel.text = DataStruct.beforeString
                finishedCalculation = false
            } else {
                DataStruct.beforeString = brain.removeLastNumber(DataStruct.beforeString).0 + display.text!.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
                self.calculatingLabel.text = DataStruct.beforeString
            }

        } else {
            displayValue = 0
            display.text!.insert("-", at: display.text!.startIndex)
            DataStruct.beforeString = brain.removeLastNumber(DataStruct.beforeString).0 + "-0"
            self.calculatingLabel.text = DataStruct.beforeString
        }
    }
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        if(toInterfaceOrientation.isLandscape) {
            if(tipViewController != nil) {
                tipViewController.dismiss(animated: false, completion: {
                    self.performSegue(withIdentifier: "transform", sender: self)
                })
            } else if (historyViewConroller != nil) {
                historyViewConroller.dismiss(animated: false, completion: {
                    self.performSegue(withIdentifier: "transform", sender: self)
                })
            } else {
                self.performSegue(withIdentifier: "transform", sender: self)
            }
        }
        //self.dismissViewControllerAnimated(false, completion: nil)

    }

    @IBAction func swipeFromLeftEdge(_ sender: UIScreenEdgePanGestureRecognizer) {
        showTips()
    }

    @IBAction func swipeFromRightEdge(_ sender: AnyObject) {
        showHistories()
    }

    func showTips() {
        self.performSegue(withIdentifier: "showTips", sender: self)
    }

    func showHistories()
    {
        self.performSegue(withIdentifier: "showHistories", sender: self)
    }

    func calculationHistoryViewController(_ controller: CalculationHistoryViewController, displayHistory history: CalculateHistory) {
        display.text = history.value(forKey: "resultText") as? String
        calculatingLabel.text = history.value(forKey: "displayText") as? String
        DataStruct.beforeRealNumber = history.value(forKey: "resultNumber") as! Double
        DataStruct.beforeString = calculatingLabel.text!
        finishedCalculation = true
        clear.setTitle("AC", for: UIControlState())
        historyViewConroller = nil
    }
    func calculationHistoryViewController(_ controller: CalculationHistoryViewController, controllerWillDisappear willDisappear: Bool) {
        if willDisappear {
            historyViewConroller = nil
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        DataStruct.beforeViewControllerP = self
        if(segue.identifier == "transform") {

            DataStruct.beforeNumber = self.display.text!

            DataStruct.beforePlusWidth = self.plus.layer.borderWidth
            DataStruct.beforeMinusWidth = self.minus.layer.borderWidth
            DataStruct.beforeDivideWidth = self.divide.layer.borderWidth
            DataStruct.beforeMultipleWidth = self.multiple.layer.borderWidth

            DataStruct.beforePlusColor = self.plus.layer.borderColor
            DataStruct.beforeMinusColor = self.minus.layer.borderColor
            DataStruct.beforeDivideColor = self.divide.layer.borderColor
            DataStruct.beforeMultipleColor = self.multiple.layer.borderColor

            DataStruct.beforePlusImage = self.plus.currentBackgroundImage
            DataStruct.beforeMinusImage = self.minus.currentBackgroundImage
            DataStruct.beforeDivideImage = self.divide.currentBackgroundImage
            DataStruct.beforeMultipleImage = self.multiple.currentBackgroundImage
            DataStruct.beforeClear = self.clear.currentTitle
            DataStruct.userIsInTheMiddleOfTypingANumber = self.userIsInTheMiddleOfTypingANumber
            DataStruct.dupDot = self.dupDot
            DataStruct.duplicateOp = self.duplicateOp
            DataStruct.firstZero = self.firstZero
            DataStruct.finishedCalculation = self.finishedCalculation

            DataStruct.isPortrait = false

            self.dismiss(animated: false, completion: nil)

        } else if segue.identifier == "showTips" {
            tipViewController = segue.destination as! TipsViewController
            tipViewController.beforeViewController = self
            tipViewController.currentValue = displayValue

        } else if segue.identifier == "showHistories" {
            let controller = segue.destination as! CalculationHistoryViewController
            controller.delegate = self
            historyViewConroller = controller
            historyViewConroller.beforeViewController = self
        }
    }


}

