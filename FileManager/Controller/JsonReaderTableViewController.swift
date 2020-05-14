//
//  JsonReaderTableViewController.swift
//  FileManager
//
//  Created by Shawn Li on 5/12/20.
//  Copyright © 2020 ShawnLi. All rights reserved.
//

import UIKit

class JsonReaderTableViewController: UITableViewController
{
    var books: [Book] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupJasonParser()
    }

    // MARK: - Json Parser Setting
    func setupJasonParser()
    {
        if let filePath = Bundle.main.path(forResource: "Books", ofType: "json")
        {
            if let data = FileManager.default.contents(atPath: filePath)
            {
                do
                {
                    let jsonObj = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [[String:String]]
                    
                    for book in jsonObj
                    {
                        let aBook = Book(title: book["title"] ?? "Title", author: book["author"] ?? "Author")
                        books.append(aBook)
                    }
                }
                catch
                {
                    print(error)
                }
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        return books.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "jason", for: indexPath) as! JsonReaderTableViewCell
        cell.authorLabel.text = books[indexPath.row].author
        cell.titleLabel.text = books[indexPath.row].title
        return cell
    }
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }


}
