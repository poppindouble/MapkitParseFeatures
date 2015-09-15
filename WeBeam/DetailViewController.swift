//
//  DetailViewController.swift
//  WeBeam
//
//  Created by Shuangshuang Zhao on 2015-09-14.
//  Copyright (c) 2015 Shuangshuang Zhao. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var myImage: UIImageView!
    
    
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userStatus: UILabel!
    
    var weBeamUser: WeBeamUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myImage.layer.cornerRadius = myImage.layer.frame.width/2
        myImage.clipsToBounds = true
        
        userEmail?.text = weBeamUser?.email
        userStatus.text = weBeamUser?.status
        weBeamUser?.image.getDataInBackgroundWithBlock{(imageData, error) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                let image = UIImage(data:imageData!)
                self.myImage?.image = image
            }
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
