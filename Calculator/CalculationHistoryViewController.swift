//
//  CalculationHistoryViewController.swift
//  Calculator
//
//  Created by Huiyuan Ren on 16/8/23.
//  Copyright © 2016年 Huiyuan Ren. All rights reserved.
//

import UIKit
import Spring

protocol CalculationHistoryViewControllerDelegate {
    func calculationHistoryViewController(_ controller: CalculationHistoryViewController, displayHistory history: CalculateHistory)
    func calculationHistoryViewController(_ controller: CalculationHistoryViewController, controllerWillDisappear willDisappear: Bool)
}

class CalculationHistoryViewController: UIViewController {

    @IBOutlet var historyButtons: [SpringButton]!
    var delegate: CalculationHistoryViewControllerDelegate!
    weak var beforeViewController: ViewControllerP!

    override func viewDidLoad() {
        super.viewDidLoad()
        let histories = brain.retrieveCalculationHistory()
//        histories.sortInPlace { (first, second) -> Bool in
//            return ((first.valueForKey("date") as! NSDate).compare(second.valueForKey("date") as! NSDate) == NSComparisonResult.OrderedDescending)
//        }
        for button in historyButtons {
            button.layer.cornerRadius = 5
            button.layer.borderColor = UIColor.lightGray.cgColor
            button.layer.borderWidth = 0.5
        }

        for i in 0..<(min(historyButtons.count, histories.count)) {
            let button = historyButtons[i]
            let item = histories[histories.count - i - 1]
            button.setTitle(item.value(forKey: "displayText") as? String, for: .normal)
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func closeButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {
            self.delegate.calculationHistoryViewController(self, controllerWillDisappear: true)
        })

    }

    @IBAction func historyButtonTapped(_ sender: UIButton) {
        let tag = sender.tag
        let histories = brain.retrieveCalculationHistory()

        if(histories.count >= tag) {
            delegate.calculationHistoryViewController(self, displayHistory: histories[histories.count - tag])
            closeButtonPressed(sender)
        }
    }
}
