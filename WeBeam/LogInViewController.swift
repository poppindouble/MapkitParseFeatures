//
//  LogInViewController.swift
//  WeBeam
//
//  Created by Shuangshuang Zhao on 2015-09-08.
//  Copyright (c) 2015 Shuangshuang Zhao. All rights reserved.
//

import UIKit
import Parse
import MobileCoreServices


class LogInViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var myImageView: UIImageView!
    
    @IBOutlet weak var userName: UITextField!
    
    
    @IBOutlet weak var userEmail: UITextField!
    
    @IBOutlet weak var userPassword: UITextField!
    
    @IBOutlet weak var userStatus: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // add getsture to dismiss keybord
        var tab = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tab)
        
        //set the image view as round, add getsture recognizer to upload photo
        myImageView.layer.cornerRadius = myImageView.layer.frame.width/2
        myImageView.layer.shadowColor = UIColor.blackColor().CGColor
        myImageView.clipsToBounds = true
        myImageView.layer.shadowOpacity = 0.8
        
        var tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped"))
        myImageView.addGestureRecognizer(tapGestureRecognizer)
        myImageView.userInteractionEnabled = true

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func SignUp(sender: UIButton) {
        var alert = UIAlertController(title: "Alert", message: "Missing Information", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
        
        
        
        
        //user image
        let myImage = myImageView.image
        let myimageData = UIImageJPEGRepresentation(myImage, 1.0)
        if myimageData != nil && userName.text != nil && userPassword.text != nil && userEmail.text != nil{
            let myimageFile = PFFile(name: "myImage", data: myimageData)
            // user name
            let myUserName = userName.text
            //user password
            let myPassword = userPassword.text
            //user email
            let myUserEmail = userEmail.text
            // user status
            let myUserStatus = userStatus.text
            
            SwiftSpinner.show("SignUp...", animated: true)
            var myWeBeamUser = WeBeamUser(image: myimageFile, status: myUserStatus, location: nil)
            myWeBeamUser.email = myUserEmail
            myWeBeamUser.password = myPassword
            myWeBeamUser.username = myUserName
            myWeBeamUser.signUpInBackgroundWithBlock{ succeeded, error in
                if (succeeded) {
                    SwiftSpinner.hide{}
                    self.performSegueWithIdentifier("MapTableSegue", sender: nil)
                }
                else {
                    
                }
            }
            
        } else {
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    

    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var image = info[UIImagePickerControllerEditedImage] as? UIImage
        if image == nil {
            image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        let scaleImage = scaleUIImageToSize(image!, size: myImageView.bounds.size)
        myImageView.image = scaleImage
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func LogIn(sender: UIButton) {
        performSegueWithIdentifier("MapTableSegue", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "MapTableSegue" {

        }
    }
    
    func imageTapped(){
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let picker = UIImagePickerController()
            picker.sourceType = .Camera
            picker.delegate = self
            picker.mediaTypes = [kUTTypeImage]
            presentViewController(picker, animated: true, completion: nil)
        }
    }
    
    
    
    func scaleUIImageToSize(let image: UIImage, let size: CGSize) -> UIImage {
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image.drawInRect(CGRect(origin: CGPointZero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    func DismissKeyboard(){
        view.endEditing(true)
    }
    

}
