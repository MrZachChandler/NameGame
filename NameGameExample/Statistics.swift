//
//  Statistics.swift
//  NameGameExample
//
//  Created by Zach Chandler on 6/23/17.
//  Copyright © 2017 Mad Men Software. All rights reserved.
//

import Foundation

public class Statistics {
    
    private var correctTaps: Int
    private var incorrectTaps: Int
    private var totalTaps: Int
    private var time: Double
    
    init() {
        correctTaps = 0
        incorrectTaps = 0
        totalTaps = 0
        time = 0.0
    }
    
    func addCorrectTap(){
        correctTaps = correctTaps + 1
    }
    
    func addIncorrectTap(){
        incorrectTaps = incorrectTaps + 1
    }
    func addCorrectTaps(taps: Int){
        correctTaps = correctTaps + taps
    }
    
    func addIncorrectTaps(taps: Int){
        incorrectTaps = incorrectTaps + taps
    }
    func getTotalTaps() -> Int{
        return incorrectTaps + correctTaps
    }
    func setTime(time: Double){
        self.time = time
    }
    func getTime() -> Double{
        return time
    }
    func getClickRatio() -> Double{
        // zero on top = 0
        if correctTaps == 0{
            return 0.0
        }
        //zero on bottom mean perfect ratio
        if incorrectTaps == 0 {
            return Double(correctTaps)

        }
        //otherwise do math
        return Double(correctTaps) / Double(incorrectTaps)
    }
    func getCorrectTaps()-> Int{
        return correctTaps
    }
    
    func getIncorrectTaps()-> Int{
        return incorrectTaps
    }
}
