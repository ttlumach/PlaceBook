//
//  AddPlaceTableViewController.swift
//  PlaceBook
//
//  Created by MacBook on 11/3/19.
//  Copyright © 2019 Anton. All rights reserved.
//

import UIKit

class AddPlaceTableViewController: UITableViewController {
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var typeField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    
    var newPlace: Place?
    var imageIsPicked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isEnabled = false
        
        nameField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
    //MARK: TableViewDelegate
    
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            let cameraIcon = #imageLiteral(resourceName: "camera")
            let photoLibraryIcon = #imageLiteral(resourceName: "photo")
            
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
                self.chooseImagePicker(source: .camera)
            }
            cameraAction.setValue(cameraIcon, forKey: "image")
            cameraAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let photoLibAction = UIAlertAction(title: "Photo library", style: .default) { (_) in
                self.chooseImagePicker(source: .photoLibrary)
            }
            photoLibAction.setValue(photoLibraryIcon, forKey: "image")
            photoLibAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alertController.addAction(cameraAction)
            alertController.addAction(photoLibAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true)
            
        } else {
            view.endEditing(true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func saveNewPlace() {
        
        if imageIsPicked {
            newPlace = Place(name: nameField.text!, location: locationField.text, type: typeField.text, description: descriptionField.text, image: placeImage.image)
        } else {
            newPlace = Place(name: nameField.text!, location: locationField.text, type: typeField.text, description: descriptionField.text, image: #imageLiteral(resourceName: "imagePlaceholder"))
        }
        
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
}

//MARK: Text field delegate

extension AddPlaceTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Скриваєм по натисненню ентера
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func textFieldChanged(){
        if nameField.text?.isEmpty == false{
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
}

//MARK: Work with image

extension AddPlaceTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func chooseImagePicker(source: UIImagePickerController.SourceType){
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate  = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        placeImage.image = info[.editedImage] as? UIImage
        placeImage.contentMode = .scaleAspectFill
        placeImage.clipsToBounds = true
        dismiss(animated: true)
        imageIsPicked = true
    }
}
