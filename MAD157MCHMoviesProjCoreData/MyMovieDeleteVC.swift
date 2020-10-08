//
//  MyMovieDeleteVC.swift
//  MAD157MCHMoviesProj
//
//  Created by Karen Mathes on 9/25/20.
//  Copyright © 2020 TygerMatrix Software. All rights reserved.
//

import UIKit
import Foundation
import CoreData

//.. For deleting movies from my movies that are saved in the PLIST
class MyMovieDeleteVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet var myMoviePicker: UIPickerView!
    @IBOutlet var deleteMyMovieButtonObj: UIButton!
    @IBOutlet var myView: UIView!
    
    var dataManager : NSManagedObjectContext!
    //.. array to hold the database info for loading/saving
    var listArray = [NSManagedObject]()
    
    var myMovieChosen: String = ""
    var myMovieIMDBChosen: String = ""
    var myMovieTypeChosen: String = ""
    var myMovieYearChosen: String = ""
    var myMoviePosterChosen: String = ""
    var myMovieCommentsChosen: String = ""
    
    var pickerTypeIndex = 0
    var pickerLabel = UILabel()
    
    var mymovies = [
        (name: "", year: "", type: "", imdb: "", poster: "", comments: "")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        myMoviePicker.dataSource = self
        myMoviePicker.delegate = self
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataManager = appDelegate.persistentContainer.viewContext
        
        mymovies.removeAll()
        fetchData()
        
        //.. this code is used to set initial values before pickers move
        self.pickerLabel.text = self.mymovies[0].name
        myMovieChosen = mymovies[0].name
        myMovieYearChosen = mymovies[0].year
        myMovieTypeChosen = mymovies[0].type
        myMovieIMDBChosen = mymovies[0].imdb
        myMovieCommentsChosen = mymovies[0].comments
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return mymovies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        pickerLabel = UILabel()
    
        pickerLabel.text = mymovies[row].name
        
        print("pickerlabel \(pickerLabel.text) - \(mymovies[row].name)")

        if UIDevice.current.userInterfaceIdiom == .pad {
            pickerLabel.font = UIFont.systemFont(ofSize: 18)
            //pickerLabel.text = "Row \(row)"  //.. not needed bc set above
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            pickerLabel.font = UIFont.systemFont(ofSize: 18)
//            pickerLabel.font = UIFont.systemFont(ofSize: 14)
            //pickerLabel.text = "Row \(row)"  //.. not needed bc set above
        }
        
        return pickerLabel
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        pickerTypeIndex = myMoviePicker.selectedRow(inComponent: 0)
    }

    @IBAction func deleteMyMoviePressed(_ sender: Any) {
        
        //********* THIS NEEDS TO BE HERE TO GET CORRECT ALERT MSG
        //.. LEAVE the print statements for debugging
        //.. set the values for the picker row chosen so they can be displayed in the alert
        print("@@@@@@@@@ pickerTypeIndex BEFORE = \(pickerTypeIndex)")
        //** MUST reset pickerTypeIndex or you'll get an error when deleting 2nd to last row and then...
        //    trying to delete the last row -> index out of bounds
        pickerTypeIndex = myMoviePicker.selectedRow(inComponent: 0)
        print("@@@@@@@@@ pickerTypeIndex AFTER = \(pickerTypeIndex)")
        self.myMovieChosen = self.mymovies[self.pickerTypeIndex].name
        self.myMovieYearChosen = self.mymovies[self.pickerTypeIndex].year
        self.myMovieTypeChosen = self.mymovies[self.pickerTypeIndex].type
        self.myMovieIMDBChosen = self.mymovies[self.pickerTypeIndex].imdb
        self.myMovieCommentsChosen = self.mymovies[self.pickerTypeIndex].comments
        
        let msg = "Are you sure you want to delete... \n\n- Movie: \(myMovieChosen) \n\n- Year: \(myMovieYearChosen) \n- Type: \(myMovieTypeChosen) \n- Imdb: \(myMovieIMDBChosen) \n- Comments: \(myMovieCommentsChosen)\n???"
            
        let alert = UIAlertController(title: "Confirm", message: msg, preferredStyle: .alert)
            
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { action -> Void in
            //Just dismiss the action sheet
            })
            
        let okAction = UIAlertAction(title: "Delete", style: .default, handler: { action -> Void in
            
            //.. remove the key
            print("movie to delete = \(self.myMovieChosen)  \(self.myMovieIMDBChosen)")
            
            //*********
            print("$$$ mymovies BEFORE key removed = \(self.mymovies)")
            self.mymovies.remove(at: self.pickerTypeIndex)
            print("$$$ mymovies AFTER key removed = \(self.mymovies)")
            
            self.mymovies = self.mymovies.sorted { $0.name < $1.name }
            print("$$$ mymovies AFTER key removed and after SORT = \(self.mymovies)")
            
            //.. redisplay the "newly updated" picker (since a row was deleted)
            self.myMoviePicker.reloadAllComponents()
            self.myView.reloadInputViews()
            
            //.. set the String of what you want to delete
            let deleteItemName = self.myMovieChosen
            let deleteItemComments = self.myMovieCommentsChosen
            //.. go through entire array to search for the string you want to delete (deleteItem above)
            for item in self.listArray {
                //.. if the value for the attribute/field "name" equals deleteItemName...
                if (item.value(forKey: "name") as! String == deleteItemName) &&
                    (item.value(forKey: "comments") as! String == deleteItemComments) {
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
            
            
        })
            
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self .present(alert, animated: true, completion: nil )
        
    }
    
    //.. read from db
        func fetchData() {
            
            mymovies.removeAll()
            
            //.. setup fetch from "Item" in xcdatamodeld
            let fetchRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "MyMovieTable")
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
                    
                    mymovies.append((name: dName, year: dYear, type: dType, imdb: dImdb, poster: dPoster, comments: dComments))
                    
                }
            } catch {
                print ("Error retrieving data")
            }
            
            mymovies = mymovies.sorted { $0.name < $1.name }
            
        }
    

}
