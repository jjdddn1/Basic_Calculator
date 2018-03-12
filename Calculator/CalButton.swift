//
//  CalButton.swift
//  Calculator
//
//  Created by Huiyuan Ren on 16/1/26.
//  Copyright © 2016年 Huiyuan Ren. All rights reserved.
//

import UIKit

class CalButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //print(UIScreen.mainScreen().bounds.width * UIScreen.mainScreen().bounds.height )

        if(style == 1) {
            self.layer.borderWidth = 0.5
            self.layer.borderColor = UIColor.black.cgColor
        } else if(style == 2) {
            self.showsTouchWhenHighlighted = true
            let attrString: NSMutableAttributedString = NSMutableAttributedString(string: self.currentTitle!)
            attrString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: NSMakeRange(0, attrString.length))
            attrString.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "Cochin", size: 24)!, range: NSMakeRange(0, attrString.length))

            self.layer.borderWidth = 1

            var offset: CGFloat = 0

            if UIScreen.main.bounds.width * UIScreen.main.bounds.height > 181760.0 {
                offset = 15
            }

            if(DataStruct.isPortrait) {
                self.layer.cornerRadius = 80 + offset
            } else {
                self.layer.cornerRadius = 50 + offset

            }
            self.layer.borderColor = DataStruct.red
            self.setAttributedTitle(attrString, for: UIControlState())
//            self.setTitleColor(UIColor.whiteColor(), forState: .Normal)

//            Cochin
            if(self.currentTitle == "+" || self.currentTitle == "−" || self.currentTitle == "×" || self.currentTitle == "/" || self.currentTitle == "=") {
                self.layer.backgroundColor = DataStruct.red

            } else if(self.currentTitle == "+/-" || self.currentTitle == "%" || self.currentTitle == "√" || self.currentTitle == "ⁿ√" || self.currentTitle == ")" || self.currentTitle == "x²" || self.currentTitle == "x³" || self.currentTitle == "xⁿ" || self.currentTitle == "tan" || self.currentTitle == "cos" || self.currentTitle == "sin" || self.currentTitle == "(" || self.currentTitle == "10ⁿ" || self.currentTitle == "e" || self.currentTitle == "Rd" || self.currentTitle == "m-" || self.currentTitle == "m+" || self.currentTitle == "mc" || self.currentTitle == "mr" || self.currentTitle == "π") {

                self.layer.backgroundColor = UIColor.clear.cgColor
                self.layer.borderColor = DataStruct.blue

            } else if(self.currentTitle == "AC") {
                if(!DataStruct.isPortrait) {
                    self.layer.backgroundColor = DataStruct.red
                } else {
                    self.layer.backgroundColor = UIColor.clear.cgColor

                }
            } else {
                self.layer.backgroundColor = UIColor.clear.cgColor
            }


        }
        // The resetMe function sets up the values for this button. It is
        // called here when the button first appears and is also called
        // from the main ViewController when all the buttons have been tapped
        // and the app is reset.
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
