//
//  XMLReaderTableViewController.swift
//  FileManager
//
//  Created by Shawn Li on 5/12/20.
//  Copyright © 2020 ShawnLi. All rights reserved.
//

import UIKit

class XMLReaderTableViewController: UITableViewController
{

    var books: [Book] = []
    var elementName = String()
    var bookTitle = String()
    var bookAuthor = String()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupXML()
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
          let cell = tableView.dequeueReusableCell(withIdentifier: "xml", for: indexPath) as! XMLReaderTableViewCell
          cell.authorLabel.text = books[indexPath.row].author
          cell.titleLabel.text = books[indexPath.row].title
          return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
          tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

    //MARK: - XML Parser
extension XMLReaderTableViewController: XMLParserDelegate
{
    func setupXML()
    {
        if let path = Bundle.main.url(forResource: "Books", withExtension: "xml")
        {
            if let parser = XMLParser(contentsOf: path)
            {
                parser.delegate = self
                parser.parse()
            }
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
    {

        if elementName == "book"
        {
            // Reset to empty
            bookTitle = String()
            bookAuthor = String()
        }

        self.elementName = elementName
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if elementName == "book"
        {
            let book = Book(title: bookTitle, author: bookAuthor)
            books.append(book)
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        let data = string.trimmingCharacters(in: .whitespacesAndNewlines)

        if (!data.isEmpty)
        {
            if self.elementName == "title"
            {
                bookTitle = data
            }
            else if self.elementName == "author"
            {
                bookAuthor = data
            }
        }
    }
}
