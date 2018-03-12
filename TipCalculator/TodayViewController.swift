//
//  TodayViewController.swift
//  TipCalculator
//
//  Created by Course Hero on 5/31/16.
//  Copyright © 2016 Huiyuan Ren. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet var tipsResultLabel: [UILabel]!
    var userIsInTheMiddleOfTypingANumber = false
    var dupDot = false
    var displayValue: Double {
        get{
            if(!displayLabel.text!.contains("/")){
                return NumberFormatter().number(from: displayLabel.text!)!.doubleValue
            }else{
                return NumberFormatter().number(from: displayLabel.text!.substring(to: displayLabel.text!.characters.index(displayLabel.text!.endIndex, offsetBy: -2)))!.doubleValue
            }
        }set{
            displayLabel.text = newValue.truncatingRemainder(dividingBy: 1) != 0 ? "\(newValue)" : "\(Int(newValue))"
            userIsInTheMiddleOfTypingANumber = false
            calcualteResult()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOSApplicationExtension 10.0, *) {
            self.extensionContext?.widgetLargestAvailableDisplayMode = NCWidgetDisplayMode.expanded
        } else {
            // Fallback on earlier versions
        }
        // Do any additional setup after loading the view from its nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    @IBAction func digitButtonPressed(_ sender: UIButton) {
        if(!divideMode){
            if(displayLabel.text!.characters.count > 9){
                return
            }
            
            if(displayLabel.text! == "0" && sender.currentTitle == "0"){
                return
            }
            
            if(userIsInTheMiddleOfTypingANumber){
                displayLabel.text = displayLabel.text! + sender.currentTitle!
            }
            else{
                displayLabel.text = sender.currentTitle!
                userIsInTheMiddleOfTypingANumber = true
            }
            calcualteResult()
        }else{
            if(sender.currentTitle != "0"){
                displayValue = displayValue / (NumberFormatter().number(from: sender.currentTitle!)!.doubleValue)
                divideMode = false
            }
        }
    }
    
    @IBAction func dotButtonPressed(_ sender: UIButton) {
        if !dupDot{
            displayLabel.text = displayLabel.text! + "."
            dupDot = true
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        if(sender.currentTitle == "AC"){
            displayValue = 0
            dupDot = false
        }else{
            if(displayLabel.text!.characters.count == 1){
                displayLabel.text = "0"
                userIsInTheMiddleOfTypingANumber = false
                calcualteResult()
                divideMode = false
                return
            }
            if (displayLabel.text![displayLabel.text!.characters.index(displayLabel.text!.endIndex, offsetBy: -1)] == "." ){
                dupDot = false
            }else if displayLabel.text![displayLabel.text!.characters.index(displayLabel.text!.endIndex, offsetBy: -1)] == "/" {
                displayLabel.text = (displayLabel.text! as NSString).substring(to: displayLabel.text!.characters.count - 1)
            }

            displayLabel.text = (displayLabel.text! as NSString).substring(to: displayLabel.text!.characters.count - 1)
        }
        divideMode = false
        calcualteResult()

    }
    
    var divideMode = false
    @IBAction func divideButtonPressed(_ sender: UIButton) {
        if(!divideMode){
            divideMode = true
            displayLabel.text = displayLabel.text! + " /"
        }
    }
    
    func calcualteResult(){
        let currentValue = displayValue
        let times = [1.1, 1.13, 1.15, 1.18, 1.2]
        let finalPrice = times.map({$0 * currentValue as NSNumber})
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 2
        for i in 0 ..< 5{
            let label = tipsResultLabel[i]
            label.text = numberFormatter.string(from: finalPrice[i])
        }
    }
    @available(iOSApplicationExtension 10.0, *)
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize){
        if (activeDisplayMode == NCWidgetDisplayMode.compact) {
            self.preferredContentSize = maxSize
        }
        else {
            self.preferredContentSize = CGSize(width: maxSize.width, height: 430)
        }
    }


    
}
