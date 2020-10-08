//
//  MyMovieListVC.swift
//  MAD157MCHMoviesProj
//
//  Created by Karen Mathes on 9/25/20.
//  Copyright © 2020 TygerMatrix Software. All rights reserved.
//

import UIKit
import Foundation
import CoreData

//.. For displaying the list of my movies that I have saved..
class MyMovieListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var myMoviesTableViewObj: UITableView!
    
    var dataManager : NSManagedObjectContext!
    //.. array to hold the database info for loading/saving
    var listArray = [NSManagedObject]()
    
    let defaultImageArray = ["posternf.png","pearl.jpg","gitcat.jpg"]
    
    //.. array to display in tableView... need this so you can sort entries to display
//    var mymovies = [
//        (name: "", year: "", type: "", imdb: "", poster: "", comments: "")
//    ]
    
    let cellID = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //..tableView.rowHeight = 40
        myMoviesTableViewObj.rowHeight = 200
        //myMoviesTableViewObj.separatorColor = UIColor.blue

        // Do any additional setup after loading the view.
       
        myMoviesTableViewObj.dataSource = self
        myMoviesTableViewObj.delegate = self
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataManager = appDelegate.persistentContainer.viewContext
        
        fetchData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {

        fetchData()
        self.myMoviesTableViewObj.reloadData()
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return mymovies.count
        return listArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: MyMoviesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "customCell2") as! MyMoviesTableViewCell
            
            if (cell == nil ) {
                //cell = UITableViewCell(style: UITableViewCell.CellStyle.default,
                cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle,reuseIdentifier: cellID) as! MyMoviesTableViewCell
                }

        //mymovies = mymovies.sorted { $0.name < $1.name }
        
//        let mmRow = mymoviesSorted[indexPath.row]
        //let mmRow = mymovies[indexPath.row]
        let mmRow = listArray[indexPath.row]
        
//        cell.myMovieName?.text = mmRow.name
//        cell.myMovieYear?.text = mmRow.year
//        cell.myMovieType?.text = mmRow.type
//        cell.myMovieComments?.text = mmRow.comments
        cell.myMovieName?.text = (mmRow.value(forKey: "name") as! String)
        cell.myMovieYear?.text = (mmRow.value(forKey: "year") as! String)
        cell.myMovieType?.text = (mmRow.value(forKey: "type") as! String)
        cell.myMovieComments?.text = (mmRow.value(forKey: "comments") as! String)
        
        print("****************** myMovieComments = \(mmRow.value(forKey: "comments") as! String)")
        
        //let url = mmRow.poster
        let url = mmRow.value(forKey: "poster") as! String
        var myImage = UIImage(named: defaultImageArray[0])
        
        if url == "" {
            myImage = UIImage(named: defaultImageArray[0])
        } else {
            let imageURL = URL(string: url)
            if let imageData = try? Data(contentsOf: imageURL!) {
               
                myImage = UIImage(data: imageData)
                //print(myImage)
                DispatchQueue.main.async {
                    return myImage
                }
            } else {
                //myImage = UIImage(named: defaultImageArray[0])
                myImage = UIImage(named: "posternotfound.JPG")
            }
        }
     
        //.. this is referenced in TableViewCell.swift; if you just use cell.imageView?.image (commented out line below), the pictures just "default" to whatever size they come in as
        cell.myMovieImage.image = myImage
        //cell.imageView?.image = myImage
       
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        
        //********* maybe use same type of code in MovieDetailVC
        //var mmRowSelected = mymovies[indexPath.row]
        var mmRowSelected = listArray[indexPath.row]
        //let movieNameSelected = mmRowSelected.name
        let movieNameSelected = mmRowSelected.value(forKey: "name") as! String
        //var movieYearSelected = mmRowSelected.year
        //let movieCommentsSelected = mmRowSelected.comments
        let movieCommentsSelected = mmRowSelected.value(forKey: "comments") as! String
        
        let alert = UIAlertController(title: "Your Choice", message: "\(movieNameSelected)", preferredStyle: .alert)

        alert.addTextField(configurationHandler: {(textField) in textField.placeholder = "Enter new comments here..."
            //textField.isSecureTextEntry = true
        })

        //.. defines Cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { action -> Void in
                //Just dismiss the action sheet
        })
    
       //.. defines OK button
       let okAction = UIAlertAction(title: "OK", style: .default, handler: { action -> Void in
               //.. called savedText, which represents the first text field (note the index value of 0) on the alert controller. If you add more than one text field to an alert controller, you’ll need to define additional constants to represent those other text fields

                let savedText = alert.textFields![0] as UITextField

                //self.mymovies[indexPath.row].comments = savedText.text ?? movieCommentsSelected
        
                //.. do a delete, then add until you can figure out how to update
                for item in self.listArray {
                    //.. if the value for the attribute/field "name" equals deleteItem...
                    if (item.value(forKey: "name") as! String == movieNameSelected) &&
                        (item.value(forKey: "comments") as! String == movieCommentsSelected) {
                        //.. try to delete the row from what's there
                        self.dataManager.delete(item)
                    }
                    do {
                        //**** not sure why you're re-saving this ??? Doesn't the above do that already?
                        //.. re-save to the db
                        try self.dataManager.save()
                    } catch {
                        print ("Error deleting data")
                    }

                }
        
        
                //.. Now save the "new row" with the new comments --- it would be better to just update it
                do{
                    //.. try to save in db
                    try self.dataManager.save()
                    //.. add new entity to array
                    //********************* may need to update comments in listArray here
                    let newEntity = NSEntityDescription.insertNewObject(forEntityName:"MyMovieTable", into: self.dataManager)
                    //.. for "about" attribute/field in table "Item" in xcdatamodeld
//                    newEntity.setValue(self.mymovies[indexPath.row].name, forKey: "name")
//                    newEntity.setValue(self.mymovies[indexPath.row].year, forKey: "year")
//                    newEntity.setValue(self.mymovies[indexPath.row].type, forKey: "type")
//                    newEntity.setValue(self.mymovies[indexPath.row].imdb, forKey: "imdb")
//                    newEntity.setValue(self.mymovies[indexPath.row].poster, forKey: "poster")
//                    newEntity.setValue(self.mymovies[indexPath.row].comments, forKey: "comments")
                     newEntity.setValue(self.listArray[indexPath.row].value(forKey: "name"), forKey: "name")
                     newEntity.setValue(self.listArray[indexPath.row].value(forKey: "year"), forKey: "year")
                     newEntity.setValue(self.listArray[indexPath.row].value(forKey: "type"), forKey: "type")
                     newEntity.setValue(self.listArray[indexPath.row].value(forKey: "imdb"), forKey: "imdb")
                     newEntity.setValue(self.listArray[indexPath.row].value(forKey: "poster"), forKey: "poster")
                     newEntity.setValue(self.listArray[indexPath.row].value(forKey: "comments"), forKey: "comments")
                    
                    
                    self.listArray.append(newEntity)
                    
                    //print("$$$ MovieDetailVC - mymovies coreData save attempt - \(self.mymovies)")
                    
                } catch{
                    print ("Error saving data")
                    print("$$$ MovieDetailVC ..tried to save coreData but it didn't work")
                    //print("$$$ MovieDetailVC - mymovies coreData save attempt - \(self.mymovies)")
                }
                
                //print("$$$$$$ newEntity = \(newEntity)")
        
           })

               //..adds the button to the alert controller and next line presents or displays the alert controller
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                self.present(alert, animated: true , completion: nil)
        }
    
    
    //.. read from db
    func fetchData() {
        
        //mymovies.removeAll()
        
        //.. from https://stackoverflow.com/questions/35417012/sorting-nsmanagedobject-array
//        let fetchRequest = NSFetchRequest(entityName: CoreDataValues.EntityName)
//        let sortDescriptor = NSSortDescriptor(key: CoreDataValues.CreationDateKey, ascending: true)
//        fetchRequest.sortDescriptors = [sortDescriptor]
//        do {
        
        //.. setup fetch from "Item" in xcdatamodeld
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "MyMovieTable")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            //.. try to fetch data
            let result = try dataManager.fetch(fetchRequest)
            //.. set the array equal to the results fetched
            listArray = result as! [NSManagedObject]
            
            //.. for each item in the array, do the following..
            for item in listArray {
                //.. get the value for "name, year, type, imdb, poster, comments" (attribute/field "name", etc. in xcdatamodeld) and set it equal to var product
                //var product = item.value(forKey: "about") as! String
                let dName = item.value(forKey: "name") as! String
                let dYear = item.value(forKey: "year") as! String
                let dType = item.value(forKey: "type") as! String
                let dImdb = item.value(forKey: "imdb") as! String
                let dPoster = item.value(forKey: "poster") as! String
                let dComments = item.value(forKey: "comments") as! String
                
                let myMovieNameRetrieved = item.value(forKey: "name") as! String
                
                print("====> myMovieNameRetrieved in listArray/CoreData: \(myMovieNameRetrieved)")
                
//                mymovies.append((name: dName, year: dYear, type: dType, imdb: dImdb, poster: dPoster, comments: dComments))
                
            }
        } catch {
            print ("Error retrieving data")
        }
        
    }



}
