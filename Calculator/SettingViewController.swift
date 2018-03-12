//
//  SettingViewController.swift
//  Calculator
//
//  Created by Huiyuan Ren on 16/2/2.
//  Copyright © 2016年 Huiyuan Ren. All rights reserved.
//

import UIKit
import MessageUI

class SettingViewController: UIViewController, MFMailComposeViewControllerDelegate, CAAnimationDelegate {

    var x: CGFloat = 0
    var y: CGFloat = 0

    var firstTime = true


    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!

    @IBOutlet weak var changeSkinButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isHidden = true
        infoLabel.isHidden = true
        if style == 1 {
            changeSkinButton.setTitle("Change skins: Classic (test)", for: UIControlState())

        } else if style == 2 {
            changeSkinButton.setTitle("Change skins: Starry Sky (test)", for: UIControlState())
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        let am = anim as! CABasicAnimation

        if am.value(forKeyPath: "path") != nil && am.value(forKeyPath: "path") as! String == "back" {

            if(UIDeviceOrientationIsLandscape(UIDevice.current.orientation)) {
                self.dismiss(animated: false, completion: nil)
                DataStruct.enterSetting = false
            } else {
                self.dismiss(animated: false, completion: nil)
                DataStruct.enterSetting = false

                DataStruct.beforeViewController!.willRotate(to: UIInterfaceOrientation.portrait, duration: 0.3)

            }

        }
    }

    override func viewDidAppear(_ animated: Bool) {

        self.view.isHidden = false

        if(firstTime) {
            let circleMaskPathInitial = UIBezierPath(ovalIn: CGRect(x: x, y: y, width: 30, height: 30))
            let extremePoint = CGPoint(x: self.view.frame.maxX, y: self.view.frame.maxY)
            let radius = sqrt((extremePoint.x * extremePoint.x) + (extremePoint.y * extremePoint.y))
            let circleMaskPathFinal = UIBezierPath(ovalIn: CGRect(x: x, y: y, width: 30, height: 30).insetBy(dx: -radius, dy: -radius))

            let maskLayer = CAShapeLayer()
            maskLayer.path = circleMaskPathFinal.cgPath
            self.view.layer.mask = maskLayer

            let maskLayerAnimation = CABasicAnimation(keyPath: "path")
            maskLayerAnimation.fromValue = circleMaskPathInitial.cgPath
            maskLayerAnimation.toValue = circleMaskPathFinal.cgPath
            maskLayerAnimation.duration = 0.7
            maskLayerAnimation.delegate = self
            maskLayer.add(maskLayerAnimation, forKey: "go")

            firstTime = false
        }
    }

    func backToPrevious() {

        let circleMaskPathInitial = UIBezierPath(ovalIn: CGRect(x: 30, y: 30, width: 30, height: 30))
        let extremePoint = CGPoint(x: self.view.frame.maxX, y: self.view.frame.maxY)
        let radius = sqrt((extremePoint.x * extremePoint.x) + (extremePoint.y * extremePoint.y))
        let circleMaskPathFinal = UIBezierPath(ovalIn: CGRect(x: 30, y: 30, width: 30, height: 30).insetBy(dx: -radius, dy: -radius))

        let maskLayer = CAShapeLayer()
        maskLayer.path = circleMaskPathFinal.cgPath
        self.view.layer.mask = maskLayer


        let maskLayerAnimation = CABasicAnimation(keyPath: "path")
        maskLayerAnimation.setValue("back", forKeyPath: "path")
        maskLayerAnimation.fromValue = circleMaskPathFinal.cgPath
        maskLayerAnimation.toValue = circleMaskPathInitial.cgPath
        maskLayerAnimation.duration = 0.5

        maskLayerAnimation.delegate = self
        maskLayerAnimation.fillMode = kCAFillModeForwards
        maskLayerAnimation.isRemovedOnCompletion = false

        maskLayer.add(maskLayerAnimation, forKey: "path")

    }

    @IBAction func feedBackButton(_ sender: UIButton) {
        let Subject = "Feedback for calculator \(versionLabel.text!)"
        let toRecipients = ["huiyuanr@usc.edu"]
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setSubject(Subject)
        mc.setToRecipients(toRecipients)
        if MFMailComposeViewController.canSendMail() {
            self.present(mc, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }

    }

    func showSendMailErrorAlert() {
        let alert = UIAlertController(title: "Could Not Send Email", message: "Please check e-mail configuration and try again.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func backButton(_ sender: UIButton) {
        backToPrevious()
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            NSLog("Mail Cancelled")
        case MFMailComposeResult.failed.rawValue:
            NSLog("Mail sent failure: %@", [error!.localizedDescription])
        case MFMailComposeResult.saved.rawValue:
            NSLog("Mail Saved")
        case MFMailComposeResult.sent.rawValue:
            NSLog("Mail Sent")
        default:
            break
        }
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func changeSkin(_ sender: UIButton) {
        if sender.currentTitle == "Change skins: Classic (test)" {
//            style = 2
            UserDefaults.standard.set(2, forKey: "Style")
            sender.setTitle("Change skins: Starry Sky (test)", for: UIControlState())
            infoLabel.isHidden = false
        } else {
//            style = 1

            UserDefaults.standard.set(1, forKey: "Style")
            sender.setTitle("Change skins: Classic (test)", for: UIControlState())
            infoLabel.isHidden = false
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
