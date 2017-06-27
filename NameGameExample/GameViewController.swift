//
//  GameViewController.swift
//  NameGameExample
//
//  Created by Zach Chandler on 6/23/17.
//  Copyright © 2017 Mad Men Software. All rights reserved.
//

import UIKit
import Spruce

class GameViewController: ChandlerViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var faceCells: [FaceCollectionViewCell] = []
    var whoIsCells: [WhoIsCell] = []
    var gameClock = Timer() 
    var timeCount = 0.0
    var mode = 1
    
    var revealedCells: [Int] = [0,0,0,0,0,0]
    
    var curRound: Round?
    var nextRound: Round?
    
    var correctAnswer: Person?
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?,round: Round, animations: [StockAnimation], mode:Int) {
        super.init(animations: animations, nibName: "GameViewController")
        self.mode = mode
        self.curRound = round
        self.title = "Who is .."
        
        
        sortFunction = CorneredSortFunction(corner: .topLeft, interObjectDelay: 0.05)
    }
    
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        collectionView.delegate = self
        self.collectionView!.alwaysBounceVertical = true
        setup()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        prepareAnimation()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if mode == FIFTY{
            return 3
        }
        return 7
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if mode == REVERSE{
            if indexPath.row == 0{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FaceCollectionViewCell", for: indexPath) as! FaceCollectionViewCell
                if let content = correctAnswer{
                    cell.setUp(person: content)
                }
                faceCells.insert(cell, at: 0)
                return cell
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WhoIsCell", for: indexPath) as! WhoIsCell
            cell.setUp(person: (curRound?.faces[indexPath.row - 1])!)
            whoIsCells.insert(cell, at: indexPath.row - 1)

            return cell
            
        }
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WhoIsCell", for: indexPath) as! WhoIsCell
            if let content = correctAnswer{
                cell.setUp(person: content)
            }
            whoIsCells.insert(cell, at: 0)
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FaceCollectionViewCell", for: indexPath) as! FaceCollectionViewCell
        
        cell.setUp(person: (curRound?.faces[indexPath.row - 1])!)
        
        faceCells.insert(cell, at: indexPath.row - 1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if mode == REVERSE{
            if indexPath.row == 0{
                return FaceCollectionViewCell().cellSize
                
            }
            return WhoIsCell().cellSize
        }
        if indexPath.row == 0{
            return WhoIsCell().cellSize
            
        }
        return FaceCollectionViewCell().cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row != 0{
            revealedCells.insert(1, at: indexPath.row - 1)
            
            if mode == REVERSE{
                if whoIsCells[indexPath.row - 1].reveal(){
                    curRound?.stats.addCorrectTap()
                    getNextRound()
                }else{
                    curRound?.stats.addIncorrectTap()
                    
                }
            }else{
                if faceCells[indexPath.row - 1].reveal(){
                    curRound?.stats.addCorrectTap()
                    getNextRound()
                }else{
                    curRound?.stats.addIncorrectTap()
                }
            }
            
            
        }
    }
    
    override func setup() {
        
        let menuItem = UIBarButtonItem(title: "Menu", style: UIBarButtonItemStyle.plain, target: self, action: #selector(backToMenu(sender:)))
        
        self.navigationItem.leftBarButtonItem = menuItem
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        var width = UIScreen.main.bounds.width
        layout.sectionInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 0.0, right: 10.0)
        width = width - 10
        layout.itemSize = CGSize(width: width / 2, height: width / 2)
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        collectionView!.collectionViewLayout = layout
        
        collectionView.register(UINib(nibName: "FaceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FaceCollectionViewCell")
        collectionView.register(UINib(nibName: "WhoIsCell", bundle: nil), forCellWithReuseIdentifier: "WhoIsCell")

        animationView = collectionView
        
        findCorrectAnswer()
        
        
        
    }
    
    override func reload(){
        var range = 6
        if mode == FIFTY{
            range = 2
        }
        
        for i in 0 ..< range {
            
            print (i)
            if mode != REVERSE{
                faceCells[i].setUp(person: (curRound?.faces[i])!)
                if curRound?.faces[i].isCorrect == true{
                    whoIsCells[0].setUp(person: (curRound?.faces[i])!)
                }
            }else{
                whoIsCells[i].setUp(person: (curRound?.faces[i])!)
                if curRound?.faces[i].isCorrect == true{
                    faceCells[0].setUp(person: (curRound?.faces[i])!)
                }
            }
            
            
        }
        
        startTimer()

        nextRound = NameGame.sharedInstance.loadNextRound(mode: mode)

    }
    
    
    func getNextRound() {
        let nextItem = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.plain, target: self, action: #selector(startNextRound(sender:)))
        
        self.navigationItem.rightBarButtonItem = nextItem
        
        stopTimer()
        curRound?.stats.setTime(time: timeCount)
        
    }
    func startNextRound(sender: UIBarButtonItem)
    {
        self.navigationItem.rightBarButtonItem = nil
        NameGame.sharedInstance.addRound(round: curRound!)
        curRound = nextRound
        findCorrectAnswer()
        
        NSLog("Starting next Round")
        prepareAnimation()
        
    }
    func findCorrectAnswer(){
        if let people = curRound?.faces{
            for person in people{
                if person.isCorrect{
                    correctAnswer = person
                }
            }
        }
        
    }
    func backToMenu(sender: UIBarButtonItem)
    {
        let menuVC = MenuViewController(nibName: "MenuViewController", bundle: nil)
        let menuNav = ChandlerNavigationController(rootViewController: menuVC)
        
        self.view.window?.rootViewController = menuNav
        
    }
    func startTimer(){
        timeCount = 0
        gameClock = Timer.scheduledTimer(timeInterval: 1,
                                                       target: self,
                                                       selector:  #selector(timerDidUpdate(timer:)),
                                                       userInfo: nil,
                                                       repeats: true)
        
    }
    func timerDidUpdate(timer:Timer){
        timeCount = timeCount + 1
        
        if timeCount.truncatingRemainder(dividingBy: 2)  == 0{
            revealHint()
            
        }
        
    }
    func stopTimer(){
        gameClock.invalidate()
        //reset revealed cells
        for i in 0 ..< revealedCells.count{
            revealedCells[i] = 0
        }
    }
    func revealHint(){
        if mode  ==  HINT{
            //formal check that 5 have been used
            var flag = 0
            for cell in revealedCells{
                flag = flag + cell
            }
            if flag < 5 {
                let randomIndex:UInt32 = arc4random_uniform(6) // range is 0 to 5
                let index:Int = Int(randomIndex)
                //is this cell correct
                if faceCells[index].isCorrect{
                    //then dont reveal this one
                    revealHint()
                }else{
                    //have I been here before
                    if revealedCells[index] == 0 {
                        let _ = faceCells[index].reveal()
                        revealedCells[index] = 1
                    }
                    else{
                        revealHint()
                    }
                }
            }
            
        }
    }
}
