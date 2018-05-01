//
//  Photo.swift
//  Snacktacular
//
//  Created by Juan Suarez on 4/15/18.
//  Copyright © 2018 Juan Suarez. All rights reserved.
//

import Foundation
import Firebase

class Photo {
    var image: UIImage!
    var description: String!
    var postedBy: String!
    var date: Date!
    var documentID: String!
    
    var dictionary: [String: Any] {
        return ["description": description, "postedBy": postedBy, "date": date]
    }
    
    init(image: UIImage, description: String, postedBy: String, date: Date, documentID: String) {
        self.image = image
        self.description = description
        self.postedBy = postedBy
        self.date = date
        self.documentID = documentID
    }
    
    convenience init() {
        let postedBy = Auth.auth().currentUser?.uid ?? ""
        self.init(image: UIImage(), description: "", postedBy: postedBy, date: Date(), documentID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let description = dictionary["description"] as! String? ?? ""
        let postedBy = dictionary["postedBy"] as! String? ?? ""
        let date = dictionary["date"] as! Date? ?? Date()
        self.init(image: UIImage(), description: description, postedBy: postedBy, date: date, documentID: "")
    }
    
    func saveData(spot: Spot, completed: @escaping (Bool) -> () ) {
        let db = Firestore.firestore()
        
        let dataToSave = self.dictionary
        if self.documentID != "" { // save data to an existing document
            // get the path for the exiseting document
            let ref = db.collection("spots").document(spot.documentID).collection("photos").document(self.documentID)
            ref.setData(dataToSave) { error in
                if let error = error {
                    print("*** ERROR: updating document \(self.documentID) \(error.localizedDescription)")
                    completed(false)
                } else {
                    print("Successfully updated documentID \(ref.documentID)")
                }
            }
        } else { // create a new document and save the data to that one.
            var ref: DocumentReference? = nil // Firestore will create the new documentID with a unique value, below
            ref = db.collection("spots").document(spot.documentID).collection("photos").addDocument(data: dataToSave) { error in
                if let error = error {
                    print("*** ERROR: creating document \(error.localizedDescription)")
                    completed(false)
                }
            }
            self.documentID = ref?.documentID
        }
        
        // This is my Firebase Storage code
        // convert our UIImage to a Data data type
        guard let photoData = UIImageJPEGRepresentation(self.image, 0.5) else {
            print("*** ERROR: Couuld not convert image to JPEGRepresentation.")
            return completed(false)
        }
        // Create an instance of Storage
        let storage = Storage.storage()
        let storageRef = storage.reference().child(spot.documentID)
        // Create a ref to hold the new photo that we're saving
        let photoRef = storageRef.child(self.documentID)
        photoRef.putData(photoData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("*** ERROR: couldn't save image \(self.documentID) in storage ref \(photoRef) \(error.localizedDescription)")
                return completed(false)
            }
            print(">>> Just completed saving image \(self.documentID)")
            completed(true)
        }
    }
}
