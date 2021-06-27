//
//  HomeViewController.swift
//  KanBagisla
//
//  Created by Rumeysa Yücel on 27.02.2021.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var searchersTableView: UITableView!
    
    let db = Firestore.firestore()
    
    var searchers: [Searcher] = []
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchersTableView.dataSource = self
        searchersTableView.register(UINib(nibName: "SearcherCell", bundle: nil), forCellReuseIdentifier: "SearcherCell")
        
        loadUsers()
        
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        
    }
    
    
    func loadUsers() {
        
        db.collection("users")
            .order(by: "date")
            .addSnapshotListener { (querySnapshot, error) in
            
            self.users = []
            
            if let e = error {
                print("There was an issue retrieving data to users collection from Firestore. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let userdata = doc.data()
                        if userdata["email"] as? String == Auth.auth().currentUser?.email {
                            
                            self.db.collection("searchers")
                                .order(by: "date")
                                .addSnapshotListener { (querySnapshot, error) in
                                
                                self.searchers = []
                                
                                if let e = error {
                                    print("There was an issue retrieving data to searchers collection from Firestore. \(e)")
                                } else {
                                    if let snapshotDocuments = querySnapshot?.documents {
                                        for doc in snapshotDocuments {
                                            let searcherdata = doc.data()
                                            if userdata["blood"] as? String  == searcherdata["blood"] as? String && userdata["city"] as? String  == searcherdata["city"] as? String && userdata["district"] as? String  == searcherdata["district"] as? String && userdata["email"] as? String  != searcherdata["email"] as? String {
                        
                                                if let name = searcherdata["name"] as? String, let blood = searcherdata["blood"] as? String, let city = searcherdata["city"] as? String, let district = searcherdata["district"] as? String, let hospital = searcherdata["hospital"] as? String, let email = searcherdata["email"] as? String {
                                                    let newSearcher = Searcher(name: name, email: email, blood: blood, city: city, district: district, hospital: hospital)
                                                    self.searchers.append(newSearcher)
                                                    
                                                    DispatchQueue.main.async {
                                                        
                                                        self.searchersTableView.reloadData()
                                                        let indexPath = IndexPath(row: self.searchers.count - 1, section: 0)
                                                        self.searchersTableView.scrollToRow(at: indexPath, at: .top, animated: false)
                                                    }
                                                }
                                              }

                                        }
                                   }
                               }
                        }
                     }
                   }
               }
           }
       }
        
        
    }

}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let searcher = searchers[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearcherCell", for: indexPath) as! SearcherCell
        
        cell.nameLabel.text = searcher.name
        cell.bloodLabel.text = searcher.blood
        cell.hospitalLabel.text = searcher.hospital
        cell.emailLabel.text = searcher.email
        
        return cell
    }
    
}

