//
//  ChandlerViewController.swift
//  NameGameExample
//
//  Created by Zach Chandler on 6/23/17.
//  Copyright © 2017 Mad Men Software. All rights reserved.
//

import UIKit
import Spruce

class ChandlerViewController: UIViewController {
    let animations: [StockAnimation]
    var sortFunction: SortFunction?
    var animationView: UIView?
    var timer: Timer?
    
    init(animations: [StockAnimation], nibName: String?) {
        self.animations = animations
        super.init(nibName: nibName, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
    }
    
    func setup() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func prepareAnimation() {
        animationView?.spruce.prepare(with: animations)
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(callAnimation), userInfo: nil, repeats: false)
        
    }
    
    func callAnimation() {
        guard let sortFunction = sortFunction else {
            return
        }
        let animation = SpringAnimation(duration: 0.7)
        DispatchQueue.main.async {
            self.animationView?.spruce.animate(self.animations, animationType: animation, sortFunction: sortFunction)
            self.reload()
        }
    }
    
    func reload(){
        
    }
}
