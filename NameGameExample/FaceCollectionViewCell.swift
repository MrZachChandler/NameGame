//
//  FaceCollectionViewCell.swift
//  NameGameExample
//
//  Created by Zach Chandler on 6/23/17.
//  Copyright © 2017 Mad Men Software. All rights reserved.
//

import UIKit

class FaceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var faceImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tintView: UIView!

    let cellSize = CGSize(width: 172.0, height: 172.0)
    var isCorrect = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    func setUp(person: Person){
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        nameLabel.isHidden = true
        faceImage.isHidden = true
        
        tintView.alpha = 0.6
        tintView.isHidden = true
        
        self.isCorrect = person.isCorrect
        
        nameLabel.text = person.firstName + " " + person.lastName

        
        switch isCorrect {
        case true:
            tintView.backgroundColor = UIColor.green
        default:
            tintView.backgroundColor = UIColor.red

        }
        
        imageFromURL(urlString: person.imageUrl)
        

        
    }
    
    func reveal() -> Bool{
        tintView.isHidden  = false
        nameLabel.isHidden = false
        return isCorrect
        
    }
    
    func imageFromURL(urlString: String) {
        let result = "http:" + urlString
    
        print(result)
        URLSession.shared.dataTask(with: NSURL(string: result)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error.debugDescription)
                DispatchQueue.main.async {
                    self.faceImage.image = UIImage(named: "WTPlaceholder")
                    self.activityIndicator.stopAnimating()
                    self.faceImage.isHidden = false
                    self.activityIndicator.isHidden = true
                }
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data!)
                self.faceImage.image = image
                self.activityIndicator.stopAnimating()
                self.faceImage.isHidden = false
                self.activityIndicator.isHidden = true
            }
            
            
        }).resume()
    }
    
    
    
}
