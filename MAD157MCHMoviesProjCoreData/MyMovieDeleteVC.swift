//
//  MyMovieDeleteVC.swift
//  MAD157MCHMoviesProj
//
//  Created by Karen Mathes on 9/25/20.
//  Copyright © 2020 TygerMatrix Software. All rights reserved.
//

import UIKit

//.. For deleting movies from my movies that are saved in the PLIST
class MyMovieDeleteVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet var myMoviePicker: UIPickerView!
    @IBOutlet var deleteMyMovieButtonObj: UIButton!
    @IBOutlet var myView: UIView!
    
    var myMovieChosen: String = ""
    var myMovieIMDBChosen: String = ""
    var myMovieTypeChosen: String = ""
    var myMovieYearChosen: String = ""
    var myMoviePosterChosen: String = ""
    var myMovieCommentsChosen: String = ""
    
    var pickerTypeIndex = 0
    var pickerLabel = UILabel()
    
    var mymovies = [
        PlistStuff2.MyMovie(name: "", year: "", type: "", imdb: "", poster: "", comments: "")
    ]

    //.. instantiate plist class
    let myPlist = PlistStuff2()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        myMoviePicker.dataSource = self
        myMoviePicker.delegate = self
        
        mymovies.removeAll()
        //.. try to load existing plist... if it doesn't exist, "save"/create it
        do {
            //.. try to load
            let dictionaryPlistLoad1 = try myPlist.loadPropertyList()
            mymovies = dictionaryPlistLoad1
            
            mymovies = mymovies.sorted { $0.name < $1.name }
        
            } catch {
                    //.. if not loaded (ie. not found bc it's new), try to save a new one
                    do {
                        var dictionaryPlistInitSave = try myPlist.savePropertyList(mymovies)
                        } catch {
                            print("..tried to save a 'new' plist but it didn't work")
                        }
                    print(error)
                    print(".. tried to load an existing plist but it didn't load or wasn't there")
            }
        
        //.. this code is used to set initial values before pickers move
        self.pickerLabel.text = self.mymovies[0].name
        myMovieChosen = mymovies[0].name
        myMovieYearChosen = mymovies[0].year
        myMovieTypeChosen = mymovies[0].type
        myMovieIMDBChosen = mymovies[0].imdb
        myMovieCommentsChosen = mymovies[0].comments
    }
    
    override func viewWillAppear(_ animated: Bool) {
            mymovies.removeAll()
            //.. try to load existing plist... if it doesn't exist, "save"/create it
            do {
                //.. try to load
                let dictionaryPlistLoad1 = try myPlist.loadPropertyList()
                mymovies = dictionaryPlistLoad1
                
                mymovies = mymovies.sorted { $0.name < $1.name }
            
                } catch {
                        //.. if not loaded (ie. not found bc it's new), try to save a new one
                        do {
                            var dictionaryPlistInitSave = try myPlist.savePropertyList(mymovies)
                            } catch {
                                print("..tried to save a 'new' plist but it didn't work")
                            }
                        print(error)
                        print(".. tried to load an existing plist but it didn't load or wasn't there")
                }
            
            //.. this code is used to set initial values before pickers move
            self.pickerLabel.text = self.mymovies[0].name
            myMovieChosen = mymovies[0].name
            myMovieYearChosen = mymovies[0].year
            myMovieTypeChosen = mymovies[0].type
            myMovieIMDBChosen = mymovies[0].imdb
            myMovieCommentsChosen = mymovies[0].comments
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//
//        mymovies.removeAll()
//
//        //.. try to load existing plist... if it doesn't exist, "save"/create it
//        do {
//            //.. try to load
//            let dictionaryPlistLoad2 = try myPlist.loadPropertyList()
//            //movieDictionary = dictionaryload
//            mymovies = dictionaryPlistLoad2
//
//            mymovies = mymovies.sorted { $0.name < $1.name }
//
//            } catch {
//                    //.. if not loaded (ie. not found bc it's new), try to save a new one
//                    do {
//                        var dictionaryPlistInitSave = try myPlist.savePropertyList(mymovies)
//                        } catch {
//                            print("..tried to save a 'new' plist but it didn't work")
//                        }
//                    print(error)
//                    print(".. tried to load an existing plist but it didn't load or wasn't there")
//            }
//
//        self.myMoviePicker.reloadAllComponents()
//    }
    
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
            
            //.. save the plist
            do {
                try self.myPlist.savePropertyList(self.mymovies)
            } catch {
                print("..not able to resave plist after attempted delete..")
            }
        })
            
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self .present(alert, animated: true, completion: nil )
        
    }
    

}
