//
//  URLSessionViewController.swift
//  FileManager
//
//  Created by Shawn Li on 5/14/20.
//  Copyright © 2020 ShawnLi. All rights reserved.
//

import UIKit

class URLSessionViewController: UIViewController {

    var container = [[String:String]]()
    
    @IBAction func getReqBtnTapped(_ sender: UIButton)
    {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos") else {return}
        let session = URLSession.shared.dataTask(with: url)
        { (data, response, error) in
            if let response = response
            {
                // Status Code between 200 - 299 is good response
                print(response)
            }
            if let data = data
            {
                do
                {
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                        print(json)
                }
                catch
                {
                    print(error)
                }
            }
        } 
        
        session.resume() // Have to call, or nothing happend
        
    }
    
    @IBAction func postReqBtnTapped(_ sender: UIButton)
    {
        let personalInfo = ["username":"LightOwlGG" , "password":"shawnli"]
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: personalInfo, options: []) else {return}
        request.httpBody = httpBody
        
        let session = URLSession.shared.dataTask(with: request)
        { (data, response, error) in
            if let response = response
            {
                print(response)
            }
            if let data = data
            {
                do
                {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                }
                catch
                {
                    print(error)
                }
            }
        }
            session.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
