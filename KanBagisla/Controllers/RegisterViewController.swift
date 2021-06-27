//
//  RegisterViewController.swift
//  KanBagisla
//
//  Created by Rumeysa Yücel on 27.02.2021.
//

import UIKit
import Firebase



class RegisterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    let db = Firestore.firestore()
    
    let picker = UIPickerView()
    
    var showingAlert = false

    
    let kanGrupları = ["O-", "O+", "A-", "A+", "B-", "B+", "AB-", "AB+"]
    

    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var districtTextField: UITextField!
    @IBOutlet weak var bloodTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        picker.dataSource = self

        
        bloodTextField.inputView = picker

        
        picker.backgroundColor = .black
        
        createToolbar()
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e)
                    self.showAlert()
                } else {
                    self.userRegister()
                    self.performSegue(withIdentifier: "RegisterToHome", sender: self)
                }
            }
        }
    }
    
    func userRegister() {
        
        if let name = nameTextField.text, let email = emailTextField.text,let city = cityTextField.text,let district = districtTextField.text,let blood = bloodTextField.text  {
            db.collection("users").addDocument(data: [
                "name": name,
                "email": email,
                "blood": blood,
                "city": city,
                "district": district,
                "date": Date().timeIntervalSince1970
            ]) { (error) in
                if let e = error {
                    print("There was an issue saving data to firestore, \(e)")
                } else {
                    print("Successfully saved data to users collection.")
                    
                }
            }
        }
    }
    

    func showAlert() {
        
        showingAlert = true
        
        let showingAlert = UIAlertController(title: "Hata!", message:
                "Lütfen bilgilerinizi kontrol ediniz, en az altı haneli bir şifre belirleyiniz.", preferredStyle: .alert)
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
        
        let doneButton = UIBarButtonItem(title: "Bitti", style: .plain, target: self, action: #selector(RegisterViewController.dismissPicker))
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
