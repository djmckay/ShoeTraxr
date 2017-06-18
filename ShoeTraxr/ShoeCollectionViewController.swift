//
//  ShoeCollectionViewController.swift
//  ShoeTraxr
//
//  Created by DJ McKay on 5/14/17.
//  Copyright © 2017 DJ McKay. All rights reserved.
//

import UIKit

class ShoeCollectionViewController: ViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var shoeCollectionView: ShoeCollectionView!
    var shoes: [Shoe]!
    var retiredShoes: [Shoe]!
    
    var shoeType = ShoeTypes.Active
    var editShoe: Shoe!
    var addShoe: Bool = false

    fileprivate let reuseIdentifier = "ShoeCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        shoes = ModelController.sharedInstance.shoes
        retiredShoes = ModelController.sharedInstance.retiredShoes
        
        shoeCollectionView.backgroundColor = UIColor.black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async(execute: {
            self.shoeCollectionView.reloadData()
        })
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unitsChanged(sender:UISegmentedControl) {
        
        shoeType  = ShoeTypes(rawValue: sender.selectedSegmentIndex)!
        shoeCollectionView.reloadData()
        
    }

    @IBAction func addShoe(_ sender: Any) {
        //editShoe = nil
        addShoe = true
    }
    
    // MARK: - Navigation

    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "editShoeDetails" {
                let navigation = segue.destination as! UINavigationController
                let editShoeDetails = navigation.viewControllers[0] as! AddShoeTableViewController
                editShoeDetails.editShoe = self.editShoe
                addShoe = false
            }
            if identifier == "addShoe" {
                addShoe = true
            }
        }
        super.prepare(for: segue, sender: sender)
    }
    
    // MARK: - Segues
    @IBAction func unwindToSegue (_ segue : UIStoryboardSegue) {
        
        if( segue.identifier == "addShoeSave" )
        {
            
            if let addShoeController:AddShoeTableViewController = segue.source as? AddShoeTableViewController {
                //if editShoe == nil {
                if addShoe {
                    editShoe = Shoe()
                    
                }
                editShoe.brand = addShoeController.brand
                editShoe.model = addShoeController.model
                editShoe.uuid = addShoeController.nickname
                editShoe.distance = addShoeController.distance
                editShoe.colorAvatarIndex = Int16(addShoeController.colorAvatarIndex)
                editShoe.defaultWorkout = addShoeController.defaultWorkout
                
                healthManager.authorizeHealthKit { (authorized,  error) -> Void in
                    if authorized {
                        print("HealthKit authorization received.")
                        self.healthManager.observeWorkOuts(completion: { (success, error) in
                            if( error != nil )
                            {
                                print("Error observing workouts: \(String(describing: error?.localizedDescription))")
                                return;
                            }
                            else
                            {
                                print("Workouts observed successfully!")
                            }
                        })
                        
                    }
                }
                    
                editShoe.distanceUnit = "Miles"
                if addShoeController.distanceUnit == .Kilometers {
                    editShoe.distanceUnit = "Kilometers"
                }
                
                editShoe.dateAdded = addShoeController.date! as NSDate
                if editShoe.retired && editShoe.distance > editShoe.distanceLogged {
                    editShoe.unRetire(completion: nil)
                }
//                self.shoes = ModelController.sharedInstance.shoes
//                self.retiredShoes = ModelController.sharedInstance.retiredShoes
//                DispatchQueue.main.async(execute: {
//                    self.shoeCollectionView.reloadData()
//                })
                
                
            }
        }
        self.shoes = ModelController.sharedInstance.shoes
        self.retiredShoes = ModelController.sharedInstance.retiredShoes
        DispatchQueue.main.async(execute: {
            self.shoeCollectionView.reloadData()
        })
    }

}

extension ShoeCollectionViewController {
    
    //1
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //2
    func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        if shoeType == .Active {
            return shoes.count
        }
        else {
            return retiredShoes.count
        }
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! ShoeCollectionViewCell
        // Configure the cell
        var shoe: Shoe!
        if shoeType == .Active {
            shoe  = shoes[indexPath.row]
            cell.longPressCallback = promptRetire(shoe:)

        }
        else {
            shoe = retiredShoes[indexPath.row]
            cell.longPressCallback = promptDelete(shoe:)

        }
        cell.setupShoe(shoe:shoe)

        return cell
    }
    
    func promptRetire(shoe: Shoe) {
        let alert = UIAlertController(title: shoe.getTitle(), message: "Would you like to retire \(shoe.getTitle()) now?", preferredStyle: UIAlertControllerStyle.alert)
        alert.popoverPresentationController?.sourceView = self.view
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: nil))
        var shoeBrand: Brand?
        
        for brand in ModelController.sharedInstance.brands {
            if brand.name == shoe.brand! {
                shoeBrand = brand
            }
        }
        if let website = shoeBrand?.website {
            if let websiteURL = URL(string:website) {
                
                alert.addAction(UIAlertAction(title: "Visit \(shoeBrand?.name ?? "")", style: UIAlertActionStyle.default, handler: { action in
                    UIApplication.shared.open(websiteURL, options: [:], completionHandler: nil)
                    
                }))
            }
        }
        alert.addAction(UIAlertAction(title: "Retire", style: UIAlertActionStyle.default, handler: { action in
            shoe.retire(completion: { (status, error) in
                self.shoes = ModelController.sharedInstance.shoes
                self.retiredShoes = ModelController.sharedInstance.retiredShoes
                DispatchQueue.main.async(execute: {
                    self.shoeCollectionView.reloadData()
                })
            })
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func promptDelete(shoe: Shoe) {
        let alert = UIAlertController(title: shoe.getTitle(), message: "Would you like to delete \(shoe.getTitle()) now or move to active shoes?", preferredStyle: UIAlertControllerStyle.alert)
        alert.popoverPresentationController?.sourceView = self.view
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.default, handler: { action in
            shoe.delete(completion: { (status, error) in
                self.shoes = ModelController.sharedInstance.shoes
                self.retiredShoes = ModelController.sharedInstance.retiredShoes
                DispatchQueue.main.async(execute: {
                    self.shoeCollectionView.reloadData()
                })
            })
        }))
        alert.addAction(UIAlertAction(title: "Active", style: UIAlertActionStyle.default, handler: { action in
            shoe.unRetire(completion: { (status, error) in
                self.shoes = ModelController.sharedInstance.shoes
                self.retiredShoes = ModelController.sharedInstance.retiredShoes
                DispatchQueue.main.async(execute: {
                    self.shoeCollectionView.reloadData()
                })
            })
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
}

extension ShoeCollectionViewController {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if (shoeType == .Active) {
            editShoe = shoes[indexPath.row]
        }
        else {
            editShoe = retiredShoes[indexPath.row]
        }
        self.performSegue(withIdentifier: "editShoeDetails", sender: collectionView)
        
        //self.performSegue(withIdentifier: "ShowShoes", sender: self)
    }

    
}
