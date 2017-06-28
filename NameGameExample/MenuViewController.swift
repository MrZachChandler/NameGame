//
//  MenuViewController.swift
//  NameGameExample
//
//  Created by Zach Chandler on 6/23/17.
//  Copyright © 2017 Mad Men Software. All rights reserved.
//

import UIKit
import CoreData

class MenuViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var gameButtons: [UIButton]!
    @IBOutlet var statsLabel: [UILabel]!

    var flag = 0
    
    @IBAction func gameModeSelected (_ sender: AnyObject) {
        startGame(mode: sender.tag)
        
    }
    
    @IBAction func GitHubDocs(sender: AnyObject) {
        if let url = URL(string: "https://github.com/MrZachChandler/NameGame"){
            UIApplication.shared.openURL(url as URL)
            UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                func showErrorAlert(){
                    let alert = UIAlertController(title: "Something Went Wrong! Try this link", message: "https://github.com/MrZachChandler/NameGame", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Got It!", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideUI()
        loadData()
        
    }
    
    func startGame(mode: Int){
        let firstRound = NameGame.sharedInstance.loadNextRound(mode: mode)
        
        let gameVC = GameViewController(nibName: "GameViewController", bundle: nil,round: firstRound, animations: [.slide(.down, .severely), .fadeIn], mode: mode)
        let gameNav = ChandlerNavigationController(rootViewController: gameVC)
        
        self.view.window?.rootViewController = gameNav
    }
    
    func loadData(){
        
        if NameGame.sharedInstance.completedLoad == false {
            DispatchQueue.main.async( execute: {
                NameGame.sharedInstance.getGameData { (result) in
                    if result{
                        self.showUI()
                        self.setStats()

                    }
                    else{
                        //first failure free 
                        //connection can be slow
                        if self.flag == 1{
                            self.showErrorAlert()
                        }
                        self.flag += 1
                    }
                }
            })
            
        }else {
            self.showUI()
            setStats()

        }
        
        
        
    }
    
    func showErrorAlert(){
        let alert = UIAlertController(title: "Something Went Wrong!", message: "Please check your network status and try again.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default, handler: { action in
        
            self.loadData()
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setStats(){
        let stats = NameGame.sharedInstance.getStats()

        
        for label in statsLabel{
            switch label.tag {
            case 0:
                let avgTime = stats.getTime()
                label.text = String(format: "Avg Time: %.1f sec", avgTime)
                break
            case 1:
                let clickRatio = stats.getClickRatio()
                label.text = String(format: "Tap Ratio C/I: %.1f", clickRatio)
                break
            case 2:
                let totalTaps = stats.getTotalTaps()
                label.text = "Total Taps: \(totalTaps)"
                break
            case 3:
                let correctTaps = stats.getCorrectTaps()
                label.text = "Correct Taps: \(correctTaps)"
                break
            default:
                let incorrectTaps = stats.getIncorrectTaps()
                label.text = "Incorrect Taps: \(incorrectTaps)"
                break
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setStats()

    }
    func hideUI(){
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        for button in gameButtons{
            button.isHidden = true
        }
    }
    
    func showUI(){
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        for button in gameButtons{
            button.isHidden = false
        }
    }

}
