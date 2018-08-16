//
//  CommentViewController.swift
//  Revagro Trasport
//
//  Created by ATPL on 01/06/18.
//  Copyright © 2018 ATPL. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var uploadPhotoBtn: UIButton!
    @IBOutlet weak var innerView: UIView!
    
    @IBOutlet weak var hideBtn: UIButton!
    
    let imagePicker = UIImagePickerController()
    
    static func instantiateVC() -> CommentViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
        return controller
    }
    
    private func showCommentVC() {
        if let appDelegate = UIApplication.shared.delegate, let window = appDelegate.window, let rootViewController = window?.rootViewController {
            
            var topViewController = rootViewController
            while topViewController.presentedViewController != nil {
                topViewController = topViewController.presentedViewController!
            }
            
            topViewController.addChildViewController(self)
            topViewController.view.addSubview(view)
            //viewWillAppear(true)
            didMove(toParentViewController: topViewController)
        }
    }
    
    public func showVC() {
        showCommentVC()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designUI()
        imagePicker.delegate = self
        commentTextView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func designUI(){
        innerView.layer.borderWidth = 1
        commentTextView.layer.borderWidth = 1
        uploadPhotoBtn.layer.borderWidth = 1
        addButton.layer.borderWidth = 1
        addButton.layer.cornerRadius = 10
        addButton.backgroundColor = UIColor(red: 21/255.0, green: 92/255.0, blue: 161/255.0, alpha: 1)
        addButton.tintColor = UIColor.white
    }
    
    @IBAction func hideViewBtnPressed(_ sender: UIButton) {
        //let commentView = CommentViewController.instantiateVC()
        self.willMove(toParentViewController: nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
    
    @IBAction func uploadImageBtnPresed(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .savedPhotosAlbum
        self.present(imagePicker,animated: true, completion: nil)
    }
    
    
    
}
extension CommentViewController: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (commentTextView.text == "Write...."){
            commentTextView.text = ""
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if (commentTextView.text == ""){
            commentTextView.text = "Write...."
        }
    }
    
}

extension CommentViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}



