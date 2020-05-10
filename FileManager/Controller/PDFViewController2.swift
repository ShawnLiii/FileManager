//
//  PDFViewController2.swift
//  FileManager
//
//  Created by Shawn Li on 5/9/20.
//  Copyright © 2020 ShawnLi. All rights reserved.
//

import UIKit
import PDFKit

class PDFViewController2: UIViewController, UITextFieldDelegate, UIDocumentPickerDelegate
{
  
    @IBOutlet weak var pdfSuperView: UIView!
    
    let pdfView = PDFView()
    
    var fileManager = FileManager.default
    
    @IBOutlet weak var localPDFName: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        localPDFName.delegate = self
        pdfViewSetup()
    }
    
    //MARK: - Text Field Setting
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        localPDFName.resignFirstResponder()
        return true
    }
    
    // MARK: - Open Stored PDF
    
    @IBAction func openPDFBtn(_ sender: UIButton)
    {
        
        if let name = localPDFName.text, let pathUrl = Bundle.main.path(forResource: name, ofType: "pdf"),!name.isEmpty, fileManager.fileExists(atPath: pathUrl)
        {
            pdfDisplay(url: URL(fileURLWithPath: pathUrl))
        }
        else
        {
            alert()
        }
    }
    
    // MARK: - Document Picker Setting
    
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
        pdfDisplay(url: urls[0])
    }

    // MARK: - PDF View Setting
    
    func pdfViewSetup()
    {
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        pdfSuperView.addSubview(pdfView)
        pdfView.leadingAnchor.constraint(equalTo: pdfSuperView.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: pdfSuperView.trailingAnchor).isActive = true
        pdfView.topAnchor.constraint(equalTo: pdfSuperView.topAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: pdfSuperView.bottomAnchor).isActive = true
        pdfView.autoScales = true
    }
    
    func pdfDisplay(url: URL)
    {
        if let document = PDFDocument(url: url)
        {
            pdfView.document = document
        }
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
