//
//  PDFViewController.swift
//  FileManager
//
//  Created by Shawn Li on 5/9/20.
//  Copyright © 2020 ShawnLi. All rights reserved.
//

import UIKit

class PDFViewController: UIViewController, UITextFieldDelegate, UIDocumentPickerDelegate, UIDocumentInteractionControllerDelegate
{

    @IBOutlet weak var localPDFName: UITextField!
    
    var fileManager = FileManager.default

    override func viewDidLoad()
    {
        super.viewDidLoad()
        localPDFName.delegate = self
    }
    
    //MARK: - Text Field Setting
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        localPDFName.resignFirstResponder()
        return true
    }
    
    //MARK: - Open Local PDF
    
    @IBAction func OpenPDFBtn(_ sender: UIButton)
    {
        if let name = localPDFName.text, let pathUrl = Bundle.main.path(forResource: name, ofType: "pdf"),!name.isEmpty, fileManager.fileExists(atPath: pathUrl)
        {
            docCtrSetup(url: URL(fileURLWithPath: pathUrl))
        }
        else
        {
            alert()
        }
    }
    
    //MARK: - Document Picker Setting
    
    @IBAction func pdfPickerBtn(_ sender: UIButton)
    {
        // Picker setting
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.content"], in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL])
    {
          docCtrSetup(url: urls[0])
    }
        
    func docCtrSetup(url: URL)
    {
        let docController = UIDocumentInteractionController.init(url: url)
        docController.delegate = self
        docController.presentPreview(animated: true)
    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController
    {
        return self
    }
    
    //MARK: - Alert
    func alert ()
    {
        let alertCtl = UIAlertController(title: "Warning!", message: "File Not Exit or File Name is Empty.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Ok", style: .default)
        alertCtl.addAction(confirmAction)
        self.present(alertCtl, animated: true, completion: nil)
    }
    
}
