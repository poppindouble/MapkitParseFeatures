//
//  TableViewCell.swift
//  WeBeam
//
//  Created by Shuangshuang Zhao on 2015-09-13.
//  Copyright (c) 2015 Shuangshuang Zhao. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myUserName: UILabel!
    @IBOutlet weak var myStatus: UILabel!
    
    
    
    var weBeamUser: WeBeamUser? {
        didSet{
            updateUI()
        }
    }
    
    func updateUI() {
        self.myUserName.text = weBeamUser?.username
        self.myStatus.text = weBeamUser?.status
        weBeamUser?.image.getDataInBackgroundWithBlock{(imageData, error) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                let image = UIImage(data:imageData!)
                self.myImageView.image = image
            }
        }
    }
}
