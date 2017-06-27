//
//  MenuViewController.swift
//  NameGameExample
//
//  Created by Zach Chandler on 6/23/17.
//  Copyright © 2017 Mad Men Software. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var faceGame: UIButton!
    @IBOutlet weak var mattGame: UIButton!
    @IBOutlet weak var hintGame: UIButton!
    @IBOutlet weak var teamGame: UIButton!
    @IBOutlet weak var reversedGame: UIButton!
    @IBOutlet weak var fiftyfifty: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var avgTimeLabel: UILabel!
    @IBOutlet weak var totalTapsLabel: UILabel!
    @IBOutlet weak var incorrectTapsLabel: UILabel!
    @IBOutlet weak var correctTapsLabel: UILabel!
    @IBOutlet weak var clickRatioLabel: UILabel!

    var stats: Statistics?
    
    @IBAction func gameModeSelected (_ sender: AnyObject) {
        startGame(mode: sender.tag)
        
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
        //SET BUTTON TAGS
        faceGame.tag = NORMAL
        mattGame.tag = MATT
        reversedGame.tag = REVERSE
        fiftyfifty.tag = FIFTY
        teamGame.tag = TEAM
        hintGame.tag = HINT
        
        
        var flag = 0
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
                        if flag == 1{
                            self.showErrorAlert()
                        }
                        flag += 1
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
        stats = NameGame.sharedInstance.getStats()
        if let avgTime = stats?.getTime(){
            avgTimeLabel.text = String(format: "Avg Time: %.1f sec", avgTime)
        }
        if let clickRatio = stats?.getClickRatio(){
            clickRatioLabel.text = String(format: "Tap Ratio C/I: %.1f", clickRatio)
        }
        if let totalTaps = stats?.getTotalTaps(){
            totalTapsLabel.text = "Total Taps: \(totalTaps)"
        }
        if let correctTaps = stats?.getCorrectTaps(){
            correctTapsLabel.text = "Correct Taps: \(correctTaps)"
        }
        if let incorrectTaps = stats?.getIncorrectTaps(){
            incorrectTapsLabel.text = "Incorrect Taps: \(incorrectTaps)"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setStats()

    }
    func hideUI(){
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        mattGame.isHidden = true
        reversedGame.isHidden = true
        teamGame.isHidden = true
        faceGame.isHidden = true
        fiftyfifty.isHidden = true
        hintGame.isHidden = true
    }
    
    func showUI(){
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        mattGame.isHidden = false
        reversedGame.isHidden = false
        teamGame.isHidden = false
        faceGame.isHidden = false
        hintGame.isHidden = false
        fiftyfifty.isHidden = false
    }

}
