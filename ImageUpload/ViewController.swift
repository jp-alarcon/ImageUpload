//
//  ViewController.swift
//  ImageUpload
//
//  Created by Pablo Alarcon on 1/26/24.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    private var manager: ImageManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        manager = ImageManager()
        activityIndicator.isHidden = true
        // Do any additional setup after loading the view.
    }

    @IBAction func selectImageTapped(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true)
        }
    }
    
    @IBAction func uploadTapped(_ sender: UIButton) {
        if imgView.image != nil {
            self.activityIndicator.isHidden = false
            manager?.uploadImage(data: (imgView.image?.pngData())!, completionHandler: { result in
                if result.path.isEmpty == false {
                    DispatchQueue.main.async {
                        self.activityIndicator.isHidden = true
                        let alert = UIAlertController(title: "Image", message: "Uploaded", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default)
                        alert.addAction(okAction)
                        self.present(alert, animated: true)
                    }
                }
            })
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imgView.image = image
        } else {
            debugPrint("error")
        }
        self.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
}

