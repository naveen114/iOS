//
//  CarroSeriesViewController.swift
//  Revagro Trasport
//
//  Created by ATPL on 07/06/18.
//  Copyright © 2018 ATPL. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import PKHUD


class collectionCell: UICollectionViewCell {
    @IBOutlet weak var selectedImage: UIImageView!
}

class CarroSeriesViewController: UIViewController {
    
    @IBOutlet weak var textVieww: UITextView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var uploadPhotoBtn: UIButton!
    @IBOutlet weak var collectionVieww: UICollectionView!
    
    let imagePicker = UIImagePickerController()
    var ref:DatabaseReference!
    var storageRef:StorageReference!
    var date = String()
    var images = [UIImage]()
    var image = UIImage()
    var urls = String()
    var arrSelectedImages:[UIImage] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designUI()
        textVieww.delegate = self
        imagePicker.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let yourViewBorder = CAShapeLayer()
        yourViewBorder.strokeColor = UIColor.lightGray.cgColor
        yourViewBorder.lineDashPattern = [4, 4]
        yourViewBorder.frame = innerView.bounds
        yourViewBorder.fillColor = nil
        yourViewBorder.path = UIBezierPath(rect: innerView.bounds).cgPath
        innerView.layer.addSublayer(yourViewBorder)
    }
    
    // MARK:- DESIGN UI
    func designUI(){
        saveBtn.layer.cornerRadius = 10
        textVieww.layer.borderWidth = 0.5
        //uploadPhotoBtn.layer.borderWidth = 0.5
        textVieww.layer.cornerRadius = 2
        
        let leftBarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "1"), style: .plain, target: self, action: #selector(backButton))
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.title = "Carroseries"
        saveBtn.backgroundColor = RevagroColors.SAVE_BUTTON_BACGROUND_COLOR
    }
    // MARK:- BACK BUTTON PRESSED
    @objc func backButton(){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- UPLOAD PHOTO BUTTON PRESSED
    @IBAction func uploadPhotoBtnPressed(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .savedPhotosAlbum
        self.present(imagePicker,animated: true, completion: nil)
    }
    
    // MARK:- SAVE DATA TO FIREBASE
    func saveData(){
        HUD.show(.labeledProgress(title: nil, subtitle: "Loading...."), onView: view)
        ref = Database.database().reference()
        let userid = Auth.auth().currentUser?.uid
        let getDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        self.date = formatter.string(from: getDate)
        
        let carroseriesDetails:[String:Any] = ["comment":self.textVieww.text == "Add Comments.." ? "No Data" : self.textVieww.text!,
                                               "upload_photo": self.urls]
        
        ref.child(Constants.NODE_MAINTENANCE).child(userid!).child(Constants.NODE_MAINTENANCE_DATE).child("\(self.date)").child(Constants.NODE_CARROSERIES).setValue(carroseriesDetails){(error,databaseRef) in
            
            if let error = error{
                print(error.localizedDescription)
            }
            HUD.hide()
            HUD.flash(.labeledSuccess(title: nil, subtitle: "Saved"), onView: self.view, delay: 1.0, completion: { (true) in
                print("saved")
                self.navigationController?.popViewController(animated: true)
            })
        }
        
    }
    
    // MARK:- UPLOAD PHOTO TO FIREBASE
    func uploadMeadia() {
        HUD.show(.labeledProgress(title: nil, subtitle: "Loading...."), onView: view)
        if self.image.size == CGSize(width: 0, height: 0){
            saveData()
        } else {
            let getDate = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            self.date = formatter.string(from: getDate)
            let uid = Auth.auth().currentUser?.uid
            storageRef = Storage.storage().reference().child("carroseries_uploaded_images").child(uid!).child("\(self.date)").child("images")
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpg"
            if let uploadData = UIImageJPEGRepresentation(self.image, 0.5){
                storageRef.putData(uploadData, metadata: metadata) { (metadata, error) in
                    if let error = error{
                        print(error.localizedDescription)
                        return }
                    self.storageRef.downloadURL(completion: { (url, error) in
                        if let error = error{
                            print(error.localizedDescription)
                        }
                        let urlOfPhoto = url?.absoluteString
                        self.urls = urlOfPhoto!
                        print(url!)
                        HUD.hide()
                        self.saveData()
                    })
                }
            }
        }
    }
    
    
//    func deleteCarroseriesData(){
//        storageRef = Storage.storage().reference()
//        storageRef.child("")
//    }
    
    // MARK:- SAVE BUTTON PRESSED
    @IBAction func saveBtnPressed(_ sender: UIButton) {
        uploadMeadia()
    }
    
}
extension CarroSeriesViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textVieww.text == "Add Comments.."){
            textVieww.text = ""
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textVieww.text == ""){
            textVieww.text = "Add Comments.."
        }
    }
    
}

extension CarroSeriesViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.image = pickedImage
            self.arrSelectedImages.append(pickedImage)
            self.collectionVieww.reloadData()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CarroSeriesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrSelectedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath)
            as! collectionCell
        cell.selectedImage.image = self.arrSelectedImages[indexPath.row]
        return cell
    }
    
    
}
