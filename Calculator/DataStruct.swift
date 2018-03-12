//
//  DataStruct.swift
//  Calculator
//
//  Created by Huiyuan Ren on 16/2/2.
//  Copyright © 2016年 Huiyuan Ren. All rights reserved.
//

import Foundation
import UIKit

// a struct used to store some public data
struct DataStruct {
    static var isPortrait = true


    static var DigitLimit: Int {
        get {
            switch isPortrait {
            case true:
                return 9
            case false:
                return Int.max == 2147483647 ? 9 : 15
            }

        }
    }

    static var userIsInTheMiddleOfTypingANumber: Bool = false
    static var duplicateOp = false
    static var dupDot = false
    static var firstZero = true
    static var finishedCalculation: Bool = true

    static var beforeNumber = "0"
    static var beforeRealNumber = 0.0

    static var beforePlusImage: UIImage? = nil
    static var beforeMinusImage: UIImage? = nil
    static var beforeDivideImage: UIImage? = nil
    static var beforeMultipleImage: UIImage? = nil
    static var beforexPownImage: UIImage? = nil
    static var beforenSqrtImage: UIImage? = nil
    static var beforenMrImage: UIImage? = nil

    static var beforePlusWidth: CGFloat? = 1
    static var beforeMinusWidth: CGFloat? = 1
    static var beforeDivideWidth: CGFloat? = 1
    static var beforeMultipleWidth: CGFloat? = 1
    static var beforexPownWidth: CGFloat? = 1
    static var beforenSqrtWidth: CGFloat? = 1
    static var beforenMrWidth: CGFloat? = 1

    static var beforePlusColor: CGColor? = red
    static var beforeMinusColor: CGColor? = red
    static var beforeDivideColor: CGColor? = red
    static var beforeMultipleColor: CGColor? = red
    static var beforexPownColor: CGColor? = blue
    static var beforenSqrtColor: CGColor? = blue
    static var beforenMrColor: CGColor? = blue

    static var before: UIImage? = nil
    static var beforeClear: String? = "AC"
    static var beforeString = ""
    static var enterSetting = false

    static var beforeViewController: ViewControllerL? = nil
    static var beforeViewControllerP: ViewControllerP? = nil
    static let red = UIColor(red: 255 / 255, green: 53 / 255, blue: 89 / 255, alpha: 1).cgColor
    static let blue = UIColor(red: 0 / 255, green: 182 / 255, blue: 248 / 255, alpha: 1).cgColor

}
