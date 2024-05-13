//
//  UploadViewController.swift
//  Final Exam
//
//  Created by english on 2024-04-25.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.isUserInteractionEnabled = true
                let gestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
                imageView.addGestureRecognizer(gestureRecogniser)

        // Do any additional setup after loading the view.
    }
    
    @objc func chooseImage( ){
            print("Choose Image")
            let pickerController = UIImagePickerController( )
            pickerController.delegate = self
            pickerController.sourceType = .photoLibrary
            present(pickerController, animated: true, completion: nil)
        }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            imageView.image = info[.originalImage] as? UIImage
            self.dismiss(animated: true, completion: nil)
        }
    
    var images: [String] = []
    @IBAction func uploadButtonPressed(_ sender: UIButton) {
        print(sender.currentTitle ?? "Button Clicked")
                let storage = Storage.storage()
                let reference = storage.reference()
                
                let mediaFolder = reference.child("media")
                if let buffer = imageView.image?.jpegData(compressionQuality: 0.5) {
                    let uuid = UUID().uuidString
                    let imageReference = mediaFolder.child("\(uuid).jpg")
                    imageReference.putData(buffer, metadata: nil){
                        ( metaData, error) in
                        if error != nil {
                            print(error?.localizedDescription ?? "Something went wrong.")
                            self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Firebase: Something went wrong.")
                        }else{
                            imageReference.downloadURL(){
                                ( url, error) in
                                if error == nil {
                                    let imageUrl = url?.absoluteString
                                    print(imageUrl ?? "Empty String URL Present here!")
                                    let firestoreDatabase = Firestore.firestore()
                                    var firestoreReference: DocumentReference? = nil
                                    
                                    let post = [ "imageUrl": imageUrl!, "postedBy": Auth.auth().currentUser!.email!, "comment": self.commentText.text!, "date": FieldValue.serverTimestamp(), "likes": 0] as [String : Any]
                                    
                                    firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: post, completion: {
                                        (error) in
                                        print("Firestore Reference! ")
                                        if error != nil {
                                            self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Unable to store image.")
                                        }else{
                                            self.imageView.image = UIImage(named: "select")
                                            self.commentText.text = ""
                                            print("Post Uploaded Successfully!")
                                            self.tabBarController?.selectedIndex = 0
                                        }
                                    })
                                }
                            }
                        }
                    }
                }
        
    }
    
    func makeAlert(title: String, message: String ){
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okButton)
            self.present( alert, animated: true, completion: nil)
        }
 
}
