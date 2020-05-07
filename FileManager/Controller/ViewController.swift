//
//  ViewController.swift
//  FileManager
//
//  Created by Shawn Li on 5/5/20.
//  Copyright © 2020 ShawnLi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate
{

    @IBOutlet weak var fileContentDisplayView: UITextView!
    
    @IBOutlet weak var fileContentInputView: UITextView!
    
    @IBOutlet weak var fileNameInputField: UITextField!
    
    var manager = FileManager.default
    
    var url: URL?
    
    var file: URL?
    
    var exist = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupTextFieldAndView()
    }
    
    func setupTextFieldAndView()
    {
        fileContentInputView.delegate = self
        fileNameInputField.delegate = self
    }
    
// MARK: - File Manager
    
    @IBAction func createFileBtn(_ sender: UIButton)
    {
        createFile()
        operationAlert(alertType: .fileCreateSuccessAlert)
    }
    
    @IBAction func writeToFileBtn(_ sender: UIButton)
    {
        guard catchUrl() else {return}
        
        if let fileUrl = file
        {
            exist = manager.fileExists(atPath: fileUrl.path)
            
            if exist
            {
                writeToFile()
                operationAlert(alertType: .fileWriteSuccessAlert)
            }
            else
            {
                operationAlert(alertType: .fileNotExistAlert)
            }
        }
    }
            
    @IBAction func readFromFileBtn(_ sender: UIButton)
    {
        guard catchUrl() else {return}
        
        if let fileUrl = file
        {
            exist = manager.fileExists(atPath: fileUrl.path)
            
            if exist
            {
                readFromFile()
            }
            else
            {
                operationAlert(alertType: .fileNotExistAlert)
            }
        }
    }
    
    @IBAction func deleteFileBtn(_ sender: UIButton)
    {
        guard catchUrl() else {return}
         
        if let fileUrl = file
        {
            exist = manager.fileExists(atPath: fileUrl.path)
            
            if exist
            {
                deleteFile(fileUrl: fileUrl)
                operationAlert(alertType: .fileDeleteSuccessAlert)
            }
            else
            {
                operationAlert(alertType: .fileNotExistAlert)
            }
            
        }
    }
    
    @IBAction func clearTextBtn(_ sender: UIButton)
    {
        clearText()
    }
    
    func createFile()
    {
        guard catchUrl() else {return}
        
        exist = manager.fileExists(atPath: file!.path)
            
        if !exist
        {
            manager.createFile(atPath: file!.path, contents: nil, attributes: nil)
        }
        else
        {
            operationAlert(alertType: .fileExistAlert)
        }
        
    }
    
    func catchUrl() -> Bool
    {
            if let name = fileNameInputField.text, !name.isEmpty
            {
                do
                {
                    url = try manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                    file = url?.appendingPathComponent(name).appendingPathExtension("txt")
                    return true
                }
                catch
                {
                    return false
                }
            }
            else
            {
                operationAlert(alertType: .fileNameEmptyAlert)
                return false
            }
    }
    
    func readFromFile()
    {
        let readHandler = try? FileHandle(forReadingFrom: file!)
        let data = readHandler!.readDataToEndOfFile()
        fileContentDisplayView.text = String(data: data, encoding: String.Encoding.utf8)
    }
    
    func writeToFile()
    {
        let appendedData = fileContentInputView.text.data(using: String.Encoding.utf8, allowLossyConversion: true)
        let writeHandler = try? FileHandle(forWritingTo: file!)
        writeHandler?.seekToEndOfFile()
        writeHandler?.write(appendedData!)
    }
    
    func deleteFile(fileUrl: URL)
    {
        try! manager.removeItem(at: fileUrl)
        clearText()
    }
    
    func clearText()
    {
        fileContentDisplayView.text = nil
        fileContentInputView.text = nil
    }
    
// MARK: - Operation Alert
    
    func operationAlert(alertType: Alert)
    {
        var message: String
        var title: String
        
        switch alertType
        {
            case .fileCreateSuccessAlert:
                title = "Attention!"
                message = "File \(fileNameInputField.text!) is created"
            case .fileDeleteSuccessAlert:
                title = "Attention!"
                message = "File \(fileNameInputField.text!) is deleted"
            case .fileExistAlert:
                title = "Warning!"
                message = "File already exist, please use another file name"
            case .fileNotExistAlert:
                title = "Warning!"
                message = "File not exist"
            case.fileNameEmptyAlert:
                title = "Warning!"
                message = "File Name is Empty, please input a file name"
            case .fileWriteSuccessAlert:
                title = "Attention!"
                message = "File content has been written successfully"
        }
        
        let alertCtl = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Ok", style: .default)
        alertCtl.addAction(confirmAction)
        self.present(alertCtl, animated: true, completion: nil)
    }
    
// MARK: - Text field and View dismiss Keyboard
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        fileNameInputField.resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if text == "\n"
        {
            fileContentInputView.resignFirstResponder()
            
            return false
        }
        
        return true
    }
}

// MARK: - Document Picker

extension ViewController: UIDocumentPickerDelegate
{
    @IBAction func pickDocBtn(_ sender: UIButton)
    {
        // Picker setting
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.text"], in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL])
    {
        //Update File Name Area
        let name = urls[0].deletingPathExtension().lastPathComponent
        fileNameInputField.text = name
        //Assign URL
        file = urls[0]
        //Update Display Area
        readFromFile()
    }
}
