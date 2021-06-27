//
//  SearchViewController.swift
//  KanBagisla
//
//  Created by Rumeysa Yücel on 27.02.2021.
//

import UIKit
import Firebase

class SearchViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let picker = UIPickerView()
    let kanGrupları = ["O-", "O+", "A-", "A+", "B-", "B+", "AB-", "AB+"]
    
    var showingAlert = false
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var districtTextField: UITextField!
    @IBOutlet weak var hospitalTextField: UITextField!
    @IBOutlet weak var bloodTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        picker.dataSource = self
        
        bloodTextField.inputView = picker
        picker.backgroundColor = .black
        
        createToolbar()

        
    }
    
    @IBAction func findButtonPressed(_ sender: UIButton) {
        
        searcherRegister()
        showAlert()
    }
    
    
    func searcherRegister() {
        
        if let name = nameTextField.text, let email = emailTextField.text,let city = cityTextField.text,let district = districtTextField.text,let blood = bloodTextField.text, let hospital = hospitalTextField.text  {
            db.collection("searchers").addDocument(data: [
                "name": name,
                "email": email,
                "blood": blood,
                "city": city,
                "district": district,
                "hospital": hospital,
                "date": Date().timeIntervalSince1970
            ]) { (error) in
                if let e = error {
                    print("There was an issue saving data to firestore from SearchViewCont., \(e)")
                } else {
                    print("Successfully saved data to searchers collection.")
                    
                }
            }
        }
    }
    
    func showAlert() {
        
        showingAlert = true
        
        let showingAlert = UIAlertController(title: "Başarılı!", message:
                "Kan Arayışınız Sistemimize Kayıt Edildi.", preferredStyle: .alert)
            showingAlert.addAction(UIAlertAction(title: "Kapat", style: .default))

            self.present(showingAlert, animated: true, completion: nil)
    }
    
    //pickerview elementlerinin yazı rengini değiştirmek için
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        
        label.textColor = .white
        label.textAlignment = .center
        label.text = kanGrupları[row]
        
        return label
    }
    
    //pickerview den çıkış için
    func createToolbar() {
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barTintColor = .black
        toolBar.tintColor = .white
        
        let doneButton = UIBarButtonItem(title: "Bitti", style: .plain, target: self, action: #selector(SearchViewController.dismissPicker))
        toolBar.setItems([doneButton], animated: false)
        
        toolBar.isUserInteractionEnabled = true
        bloodTextField.inputAccessoryView = toolBar
    }
    
    @objc func dismissPicker() {
        view.endEditing(true)
    }
    

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return kanGrupları.count

    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
             return kanGrupları[row]
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            bloodTextField.text = kanGrupları[row]

    }

    
  

}
