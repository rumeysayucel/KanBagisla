//
//  MyRequestsViewController.swift
//  KanBagisla
//
//  Created by Rumeysa Yücel on 27.02.2021.
//

import UIKit
import Firebase


class MyRequestsViewController: UIViewController {
    
    @IBOutlet weak var requestsTableView: UITableView!
    
    let db = Firestore.firestore()
    
    var myrequests: [Searcher] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestsTableView.dataSource = self
        requestsTableView.register(UINib(nibName: "SearcherCell", bundle: nil), forCellReuseIdentifier: "SearcherCell")

        loadRequests()
        
    }
    
    
    func loadRequests() {
        
        db.collection("searchers")
            .order(by: "date")
            .addSnapshotListener { (querySnapshot, error) in
            
            self.myrequests = []
            
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let requestdata = doc.data()
                        if requestdata["email"] as? String == Auth.auth().currentUser?.email {
                            if let name = requestdata["name"] as? String, let email = requestdata["email"] as? String, let blood = requestdata["blood"] as? String, let city = requestdata["city"] as? String, let district = requestdata["district"] as? String, let hospital = requestdata["hospital"] as? String {
                                let newRequest = Searcher(name: name, email: email, blood: blood, city: city, district: district, hospital: hospital)
                                self.myrequests.append(newRequest)
                                
                                DispatchQueue.main.async {
                                    self.requestsTableView.reloadData()
                                    let indexPath = IndexPath(row: self.myrequests.count - 1, section: 0)
                                    self.requestsTableView.scrollToRow(at: indexPath, at: .top, animated: false)
                                }
                            }
                        }
                    }
                }
            }
        }
    }



}

extension MyRequestsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myrequests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myrequest = myrequests[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearcherCell", for: indexPath) as! SearcherCell
        
        cell.nameLabel.text = myrequest.name
        cell.bloodLabel.text = myrequest.blood
        cell.hospitalLabel.text = myrequest.hospital
        cell.emailLabel.text = myrequest.email
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            tableView.beginUpdates()
            myrequests.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            
        }
        
    }
    
 
   
    
}
