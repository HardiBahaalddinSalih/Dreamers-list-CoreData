//
//  DreamerCell.swift
//  Dreamers list
//
//  Created by HardiB.Salih on 5/27/18.
//  Copyright © 2018 HardiB.Salih. All rights reserved.
//

import UIKit

protocol DreamerDelegate {
    func dreamHasBeenRemoved (Remove : Dreamer)
}

class DreamerCell: UITableViewCell {

    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var captionLbl: UILabel!
    @IBOutlet weak var bodyLbl: UILabel!
    @IBOutlet weak var deleteImg: UIImageView!
    @IBOutlet weak var timestampLbl: UILabel!


//    @IBOutlet weak var photoHeightConstraint: NSLayoutConstraint!

    
    var dreams : Dreamer!
    var delegate : DreamerDelegate!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        deleteImg.layer.cornerRadius = 15
        deleteDidTapped()
        
    }
    
    
    func configureCell (_ dreams : Dreamer, delegate : DreamerDelegate) {
        self.dreams = dreams
        self.delegate = delegate
        
        nameLbl.text = dreams.name
        captionLbl.text = dreams.caption
        bodyLbl.text = dreams.body
        mainImage.image = UIImage(data: dreams.image!)
        
        
        // calculate post date
        let from = dreams.date
        let now = Date()
        let components : NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfMonth]
        let difference = (Calendar.current as NSCalendar).components(components, from: from!, to: now, options: [])
        
        // logic what to show: seconds, minuts, hours, days or weeks
        if difference.second! <= 0 {
            timestampLbl.text = "just now"
        }
        if difference.second! > 0 && difference.minute! == 0 {
            timestampLbl.text = "\(difference.second!)s. ago"
        }
        if difference.minute! > 0 && difference.hour! == 0 {
            timestampLbl.text = "\(difference.minute!)m. ago"
        }
        if difference.hour! > 0 && difference.day! == 0 {
            timestampLbl.text = "\(difference.hour!)h. ago"
        }
        if difference.day! > 0 && difference.weekOfMonth! == 0 {
            timestampLbl.text = "\(difference.day!)d. ago"
        }
        if difference.weekOfMonth! > 0 {
            timestampLbl.text = "\(difference.weekOfMonth!)w.ago"
        }
        
    }
    
    func deleteDidTapped() {
        
        let delete_Tap = UITapGestureRecognizer(target: self, action: #selector(dreamIsGoneForGood))
        delete_Tap.numberOfTapsRequired = 1
        deleteImg.isUserInteractionEnabled = true
        deleteImg.addGestureRecognizer(delete_Tap)
        
    }
    
    @objc func dreamIsGoneForGood(){
        delegate.dreamHasBeenRemoved(Remove: dreams)
    }
}
