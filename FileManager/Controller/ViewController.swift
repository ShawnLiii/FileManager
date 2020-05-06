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

    @IBOutlet weak var displayArea: UITextView!
    
    @IBOutlet weak var inputArea: UITextView!
    
    @IBOutlet weak var fileName: UITextField!
    
    var manager = FileManager.default
    
    var url: URL?
    
    var file: URL?
    
    var exist = false
    
    let confirmAction = UIAlertAction(title: "Ok", style: .default)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupTextFieldAndView()
    }
    
    func setupTextFieldAndView()
    {
        inputArea.delegate = self
        fileName.delegate = self
    }
        
    @IBAction func createFileBtn(_ sender: UIButton)
    {
        createFile()
        fileCreateSuccessAlert()
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
            }
            else
            {
                fileNotExistAlert()
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
                fileNotExistAlert()
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
                fileDeleteSuccessAlert()
            }
            else
            {
                fileNotExistAlert()
            }
            
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if text == "\n"
        {
            inputArea.resignFirstResponder()
            
            return false
        }
        
        return true
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
            fileExistAlert()
        }
        
    }
    
    func catchUrl() -> Bool
    {
        do
        {
            if let name = fileName.text, !name.isEmpty
            {
                url = try manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                file = url?.appendingPathComponent(name).appendingPathExtension("txt")
                return true
            }
            else
            {
                fileNameEmptyAlert()
                return false
            }
        }
        catch
        {
           print(error)
           return false
        }
    }
    
    func readFromFile()
    {
        let readHandler = try? FileHandle(forReadingFrom: file!)
        let data = readHandler!.readDataToEndOfFile()
        displayArea.text = String(data: data, encoding: String.Encoding.utf8)
    }
    
    func writeToFile()
    {
        let appendedData = inputArea.text.data(using: String.Encoding.utf8, allowLossyConversion: true)
        let writeHandler = try? FileHandle(forWritingTo: file!)
        writeHandler?.seekToEndOfFile()
        writeHandler?.write(appendedData!)
    }
    
    func deleteFile(fileUrl: URL)
    {
        try! manager.removeItem(at: fileUrl)
        displayArea.text = nil
        inputArea.text = nil
    }
    
    func fileNameEmptyAlert()
    {
        let alertCtl = UIAlertController(title: "Warning!", message: "File Name is Empty, please input a file name", preferredStyle: .alert)
        alertCtl.addAction(confirmAction)
        self.present(alertCtl, animated: true, completion: nil)
    }
    
    func fileNotExistAlert()
    {
        let alertCtl = UIAlertController(title: "Warning!", message: "File not exist", preferredStyle: .alert)
        alertCtl.addAction(confirmAction)
        self.present(alertCtl, animated: true, completion: nil)
    }
    
    func fileExistAlert()
    {
        let alertCtl = UIAlertController(title: "Warning!", message: "File already exist, please use another file name", preferredStyle: .alert)
        alertCtl.addAction(confirmAction)
        self.present(alertCtl, animated: true, completion: nil)
    }
    
    func fileCreateSuccessAlert()
    {
        let alertCtl = UIAlertController(title: "Attention!", message: "File \(fileName.text!) is created", preferredStyle: .alert)
        alertCtl.addAction(confirmAction)
        self.present(alertCtl, animated: true, completion: nil)
    }
    
    func fileDeleteSuccessAlert()
    {
        let alertCtl = UIAlertController(title: "Attention!", message: "File \(fileName.text!) is deleted", preferredStyle: .alert)
        alertCtl.addAction(confirmAction)
        self.present(alertCtl, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        fileName.resignFirstResponder()
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
        fileName.text = name
        //Assign URL
        file = urls[0]
        //Update Display Area
        readFromFile()
    }
}
