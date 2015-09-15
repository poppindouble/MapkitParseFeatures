//
//  Model.swift
//  WeBeam
//
//  Created by Shuangshuang Zhao on 2015-09-10.
//  Copyright (c) 2015 Shuangshuang Zhao. All rights reserved.
//

import Foundation
import Parse

class WeBeamUser: PFUser, PFSubclassing {
    @NSManaged var image: PFFile
    @NSManaged var status: String?
    @NSManaged var location: PFGeoPoint?
    
    
    override class func initialize() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    
    init(image: PFFile, status: String?, location: PFGeoPoint?) {
        super.init()
        self.location = location
        self.image = image
        self.status = status
    }
    
    override init() {
        super.init()
    }
    

}