//
//  NameGame.swift
//  NameGameExample
//
//  Created by Zach Chandler on 6/23/17.
//  Copyright © 2017 Mad Men Software. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class NameGame: NSObject {
    
    static let sharedInstance = NameGame()

    private var people: [Person] = []
    private var matt: [Person] = []
    private var team: [Person] = []

    private var rounds: [Round] = []
    private var statistics: Statistics = Statistics()
    
    var completedLoad = false
    
    fileprivate override init() {
        super.init()
        
    }
    
    func getGameData(completion: @escaping (_ result: Bool) -> Void){
        
        let willowTreeUrl = "https://willowtreeapps.com/api/v1.0/profiles/"
        
        Alamofire.request(willowTreeUrl).responseJSON { response in
            
            if let result = response.result.value {
                let json = JSON(result)
                print("JSON: \(result)") // serialized json response
                
                if let data = json["items"].arrayObject {
                    let employees = data as! [[String:Any]]
                    for employee in employees{
                        var person = Person()
                        if let firstName = employee["firstName"] {
                            person.firstName = firstName as! String

                        }
                        if let lastName = employee["lastName"] {
                            person.lastName = lastName as! String
                            
                        }
                        let headshot = employee["headshot"] as! [String: Any]
                        if let url = headshot["url"] {
                            person.imageUrl = url as! String
                            
                            
                            //if they dont have a real picture I discard them
                            //ie the sample image contains test1
                            if person.imageUrl.range(of:"TEST1") == nil {
                                if person.imageUrl.isEmpty == false {
                                    self.people.append(person)

                                }
                            }

                        }
                        //check to see if the person is a matt
                        if person.firstName.range(of:"Mat") != nil{
                            self.matt.append(person)
                        }
                        //check to see if they currently have a job title then they're on the team
                        if let jobTitle = employee["jobTitle"] {
                            person.jobTitle = jobTitle as! String
                            self.team.append(person)
                        }
                    }
                    
                    print("people \(self.people.count)")
                    print("Matt\(self.matt.count)")
                    print("team \(self.team.count)")

                    self.completedLoad = true
                    completion(true)
                }
                
            }
            
        
        }
        completion(false)
        
    }
    
    func addRound(round:Round){
        rounds.append(round)
    }
    
    func loadNextRound(mode: Int) -> Round{
        var source: [Person] = []
        var numberOfPeople = 6
        switch mode{
        case NORMAL:
            source = people
            break
        case MATT:
            source = matt
            break
        case TEAM:
            source = team
            break
        case FIFTY:
            numberOfPeople = 2
            source = people
            break
        default:
            source = people
            break;
        }
        var nextRound = Round()
        var indexArray: [Int] = []
        

        
        //Get n random people
        for i in 0 ..< numberOfPeople {
            
            let randomNum:UInt32 = arc4random_uniform(UInt32(source.count))

            var index:Int = Int(randomNum)
            if i != 0{
                index = noDuplicatePeople(indexArray: indexArray, testIndex: index, source: source)
            }
            indexArray.append(index)
            nextRound.faces.append(source[index])
            
        }
        
        // choose correct person
        
        let correctIndex:UInt32 = arc4random_uniform(UInt32(numberOfPeople)) // range is 0 to n
        let correctFace:Int = Int(correctIndex)
        
        nextRound.faces[correctFace].isCorrect = true
        
        
        
        
        return nextRound
        
        
    }
    //recursive duplicate function
    //if duplicate is found
    //it creates a sub array of pervious elements 
    //until it doesnt match any prev elements in subarray
    //returns int that is individual to index array list
    func noDuplicatePeople(indexArray: [Int], testIndex:Int ,source:[Person])->Int{
        var returnIndex = testIndex
        var subArray: [Int] = []
        for index in 0 ..< indexArray.count {
            subArray.append(indexArray[index])
            if indexArray[index] == returnIndex{
                let randomNum:UInt32 = arc4random_uniform(UInt32(source.count))
                let newIndex:Int = Int(randomNum)
                returnIndex = noDuplicatePeople(indexArray: subArray, testIndex: newIndex,source: source)
            }
        }
        return returnIndex
    }
    func getStats()-> Statistics{
        if rounds.count == 0{
            return statistics
        }
        var totalTime = 0.0
        for round in rounds{
            statistics.addCorrectTaps(taps: round.stats.getCorrectTaps())
            statistics.addIncorrectTaps(taps: round.stats.getIncorrectTaps())
            totalTime = totalTime + round.stats.getTime()

        }
        let avgTime = totalTime / Double(rounds.count)
        
        statistics.setTime(time: avgTime)
        return statistics
    }
}
