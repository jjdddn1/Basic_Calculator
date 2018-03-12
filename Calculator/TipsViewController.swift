//
//  TipsViewController.swift
//  Calculator
//
//  Created by Huiyuan Ren on 16/5/29.
//  Copyright © 2016年 Huiyuan Ren. All rights reserved.
//

import UIKit
import Spring

class TipsViewController: UIViewController {

    var currentValue: Double!
    weak var beforeViewController: ViewControllerP!

    @IBOutlet var TipButtons: [SpringButton]!

    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0..<TipButtons.count {
            let button = TipButtons[i]
            button.layer.cornerRadius = 5
            button.layer.borderColor = UIColor.lightGray.cgColor
            button.layer.borderWidth = 0.5
            let numberFormatter = NumberFormatter()
            numberFormatter.maximumFractionDigits = 2
            switch i {
            case 0:
                let priceNumber = currentValue * 1.1 as NSNumber
                button.setTitle("10%: \(numberFormatter.string(from: priceNumber)!)", for: .normal)
                break
            case 1:
                let priceNumber = currentValue * 1.13 as NSNumber
                button.setTitle("13%: \(numberFormatter.string(from: priceNumber)!)", for: .normal)
                break
            case 2:
                let priceNumber = currentValue * 1.15 as NSNumber
                button.setTitle("15%: \(numberFormatter.string(from: priceNumber)!)", for: .normal)
                break
            case 3:
                let priceNumber = currentValue * 1.18 as NSNumber
                button.setTitle("18%: \(numberFormatter.string(from: priceNumber)!)", for: .normal)
                break
            case 4:
                let priceNumber = currentValue * 1.2 as NSNumber
                button.setTitle("20%: \(numberFormatter.string(from: priceNumber)!)", for: .normal)
                break
            default:
                break
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func closeButtonPressed(_ sender: UIButton) {
        beforeViewController.tipViewController = nil
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
