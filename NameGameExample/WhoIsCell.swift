//
//  WhoIsCell.swift
//  NameGameExample
//
//  Created by Zach Chandler on 6/23/17.
//  Copyright © 2017 Mad Men Software. All rights reserved.
//

import UIKit

class WhoIsCell: UICollectionViewCell {
   
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tintView: UIView!

    var isCorrect = false
    
    let cellSize = CGSize(width: 243.0 , height: 35.0)

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    func setUp(person: Person) {
        nameLabel.text = person.firstName + " " + person.lastName
        isCorrect = person.isCorrect
        if person.isCorrect{
            tintView.backgroundColor = UIColor.green
        }else{
            tintView.backgroundColor = UIColor.red
        }
        tintView.alpha = 0.6
        tintView.isHidden = true
        
    }
    
    func reveal() -> Bool{
        tintView.isHidden  = false
        return isCorrect
        
    }
    
    
}

