//
//  AboutMeViewController.swift
//  Calculator
//
//  Created by Huiyuan Ren on 16/2/2.
//  Copyright © 2016年 Huiyuan Ren. All rights reserved.
//

import UIKit

class AboutMeViewController: UIViewController {

    @IBOutlet weak var selfie: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var whatIWantToSayLabel: UILabel!

    @IBOutlet weak var portfolioButton: UIButton!
    @IBOutlet weak var linkedInButton: UIButton!
    @IBOutlet weak var resumeLabel: UIButton!

    var location = CGPoint (x: 0, y: 0)
    var offsetX: CGFloat = 0
    var offsetY: CGFloat = 0
    var touchInSide = false

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch! = touches.first
        location = touch.location(in: self.view)
        if(location.x >= selfie.frame.minX && location.x <= selfie.frame.maxX) && (location.y >= selfie.frame.minY && location.y <= selfie.frame.maxY) {
            touchInSide = true
            offsetX = selfie.center.x - location.x
            offsetY = selfie.center.y - location.y
        }



    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(touchInSide == true) {
            let touch: UITouch! = touches.first
            self.location = touch.location(in: self.view)
            selfie.center = CGPoint(x: location.x + offsetX, y: location.y + offsetY)
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchInSide = false
    }

    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func Portfolio(_ sender: UIButton) {
        if let requestUrl = URL(string: "http://huiyuanr.portfoliobox.net") {
            UIApplication.shared.openURL(requestUrl)
        }
    }

    @IBAction func LinkedIn(_ sender: UIButton) {
        if let requestUrl = URL(string: "https://www.linkedin.com/in/huiyuanr") {
            UIApplication.shared.openURL(requestUrl)
        }
    }

    @IBAction func Resume(_ sender: UIButton) {
        if let requestUrl = URL(string: "https://media.cmcdn.net/00967ea6d3cb9fa6b540/30447910/download/resume.pdf") {
            UIApplication.shared.openURL(requestUrl)
        }
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
