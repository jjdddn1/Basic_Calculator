//
//  instructionViewController.swift
//  Calculator
//
//  Created by Huiyuan Ren on 16/2/2.
//  Copyright © 2016年 Huiyuan Ren. All rights reserved.
//

import UIKit

class instructionViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
