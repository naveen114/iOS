//
//  CommentViewController.swift
//  Revagro Trasport
//
//  Created by ATPL on 01/06/18.
//  Copyright © 2018 ATPL. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import PKHUD

class CommentViewController: UIViewController {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var uploadPhotoBtn: UIButton!
    @IBOutlet weak var innerView: UIView!
    
    @IBOutlet weak var hideBtn: UIButton!
    
    let imagePicker = UIImagePickerController()
    var ref:DatabaseReference!
    var storageRef:StorageReference!
    var urls = String()
    var image = UIImage()
    var date = String()
    
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
    
    //MARK:- UPDATE DATA OF FIREBASE
    func updateData(){
        HUD.show(.labeledProgress(title: nil, subtitle: "Loading...."), onView: view)
        ref = Database.database().reference()
        let newPostRef = ref.child("comment_data").childByAutoId()
        let newPostKey = newPostRef.key
        let updateUserData:[String:Any] = ["start_shift/comment_data/\(newPostKey)": true, "comment_data/\(newPostKey)": ["comment": self.commentTextView.text ?? "", "photo_url": self.urls]]
        ref.updateChildValues(updateUserData) { (error, databaseRef) in
            if let error = error {
                print(error.localizedDescription)
                AppUtils.showAlert(title: "Alert", message: error.localizedDescription, viewController: self)
            }
            HUD.flash(.labeledSuccess(title: nil, subtitle: "Saved"), onView: self.view, delay: 1.0, completion: { (true) in
                print("saved")
                self.hideViewOnClick()
            })
            
        }
    }
    
    //MARK:- SAVE MEDIA FILES TO FIREBASE
    func saveMedia(){
        HUD.show(.labeledProgress(title: nil, subtitle: "Loading...."), onView: view)
        if self.image.size == CGSize(width: 0, height: 0){
            updateData()
        } else {
            let getDate = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            self.date = formatter.string(from: getDate)
            let uid = Auth.auth().currentUser?.uid
            storageRef = Storage.storage().reference().child("comment_images").child(uid!).child("\(self.date)").child("images")
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpg"
            if let uploadData = UIImageJPEGRepresentation(self.image, 0.5){
                storageRef.putData(uploadData, metadata: metadata) { (metadata, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        AppUtils.showAlert(title: "Alert", message: error.localizedDescription, viewController: self)
                    }
                    self.storageRef.downloadURL(completion: { (url, error) in
                        if let error = error {
                            print(error.localizedDescription)
                            AppUtils.showAlert(title: "Alert", message: error.localizedDescription, viewController: self)
                        }
                        let photoUrl = url?.absoluteString
                        self.urls = photoUrl!
                        print(url)
                        print(self.urls)
                        self.updateData()
                        HUD.hide()
                    })
                }
            }
        }
    }
    
    //MARK:- ADD VALIDATION ON VIEW
    func validationOnView(){
        if self.commentTextView.text == "" || self.commentTextView.text == "Write...."{
            
            HUD.flash(.label("Please add your comment"), onView: view, delay: 2.0) { (true) in
                
            }
        } else {
            self.saveMedia()
        }
    }
    
    //MARK:- DESIGN UI
    func designUI(){
        innerView.layer.borderWidth = 1
        commentTextView.layer.borderWidth = 1
        uploadPhotoBtn.layer.borderWidth = 1
        addButton.layer.borderWidth = 1
        addButton.layer.cornerRadius = 10
        addButton.backgroundColor = UIColor(red: 21/255.0, green: 92/255.0, blue: 161/255.0, alpha: 1)
        addButton.tintColor = UIColor.white
    }
    
    func hideViewOnClick(){
        self.willMove(toParentViewController: nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
    @IBAction func hideViewBtnPressed(_ sender: UIButton) {
        //let commentView = CommentViewController.instantiateVC()
        hideViewOnClick()
    }
    
    
    @IBAction func uploadImageBtnPresed(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .savedPhotosAlbum
        self.present(imagePicker,animated: true, completion: nil)
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        self.validationOnView()
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
            self.image = pickedImage
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}



