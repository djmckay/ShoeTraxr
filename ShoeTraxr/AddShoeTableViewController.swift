//
//  AddShoeTableViewController.swift
//  ShoeTraxr
//
//  Created by DJ McKay on 4/18/17.
//  Copyright © 2017 DJ McKay. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds
import Charts
import HealthKit

public class AddShoeTableViewController: UITableViewController, UITextFieldDelegate, GADInterstitialDelegate {

    @IBOutlet weak var shoeDateCell: DatePickerCell!
    @IBOutlet weak var shoeBrandCell: TextCell!
    @IBOutlet weak var shoeModelCell: TextCell!
    @IBOutlet weak var shoeNicknameCell: TextCell!
    
    @IBOutlet weak var shoeMileageCell: NumberCell!
    @IBOutlet weak var shoeDistanceUnit: UISegmentedControl!
    
    @IBOutlet weak var numberOfWorkouts: NumberCell!
    @IBOutlet weak var shoeDistanceLogged: TextCell!

    @IBOutlet weak var shoeBrandPickerCell: BrandPickerCell!
    
    @IBOutlet weak var shoeAvatarColorPIckerCell: ColorPickerCell!
    
    @IBOutlet weak var defaultPickerCell: DefaultPickerCell!
    @IBOutlet weak var brandProductPickerCell: ProductPickerCell!
    
    
    @IBOutlet weak var estimatedRetirementDateCell: TextCell!
    @IBOutlet weak var shoePercentRemaining: TextCell!
    var editShoe: Shoe!

    var interstitial: GADInterstitial!
    
//    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var combinedChartView: CombinedChartView!
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        shoeDateCell.inputMode = .date
        shoeDateCell.updateDateTimeLabel()
        //shoeMileageCell.doubleValue = 500.0
        self.shoeBrandPickerCell.detailTextLabel?.text = "Required"
        self.shoeAvatarColorPIckerCell.detailTextLabel?.text = ModelController.colorNames[0]
        self.shoeAvatarColorPIckerCell.detailTextLabel?.textColor = ModelController.colors[0]
//        self.brandProductPickerCell.isHidden = true
        self.shoeBrandPickerCell.brandProductPickerCell = self.brandProductPickerCell
        self.brandProductPickerCell.otherModelCell = self.shoeModelCell
        self.shoeAvatarColorPIckerCell.detailTextLabel?.backgroundColor = UIColor.gray
        self.shoeAvatarColorPIckerCell.image( ModelController.colors[0])

        if let editShoe = editShoe {
            self.title = "Shoe Details"
            //self.shoeBrandCell.textField.text = editShoe.brand
            self.shoeBrandPickerCell.detailTextLabel?.text = editShoe.brand
            if editShoe.distanceUnit == "Kilometers" {
                self.shoeDistanceUnit.isEnabledForSegment(at: DistanceUnit.Kilometers.rawValue)
            }
            self.shoeBrandPickerCell.select()
            self.brandProductPickerCell.detailTextLabel?.text = editShoe.model
            self.shoeDistanceUnit.isEnabled = false
            self.shoeModelCell.textField.text = editShoe.model
            self.shoeNicknameCell.textField.text = editShoe.uuid
            self.shoeMileageCell.doubleValue = editShoe.distance
            self.shoeDateCell.date = editShoe.dateAdded! as Date
            self.numberOfWorkouts.integerValue = editShoe.workoutData.count
            self.shoeDistanceLogged.value = editShoe.distanceLoggedFormatted
            self.shoePercentRemaining.value = "\(editShoe.percentRemaining)%"
            self.shoeAvatarColorPIckerCell.detailTextLabel?.text = ModelController.colorNames[Int(editShoe.colorAvatarIndex)]
            self.shoeAvatarColorPIckerCell.detailTextLabel?.textColor = ModelController.colors[Int(editShoe.colorAvatarIndex)]
            self.shoeAvatarColorPIckerCell.detailTextLabel?.backgroundColor = UIColor.gray
            self.shoeAvatarColorPIckerCell.image(ModelController.colors[Int(editShoe.colorAvatarIndex)])
            self.shoeAvatarColorPIckerCell.select()
            if let defaultWorkout = editShoe.defaultWorkout {
                self.defaultPickerCell.detailTextLabel?.text = ModelController.defaultWorkoutTypes[Int(defaultWorkout.type)]
                self.defaultPickerCell.select()
            }
            
            var allHKWorkouts: [HKWorkout] = []
            ModelController.sharedInstance.getRunningWorkouts { workouts in
                allHKWorkouts.append(contentsOf: editShoe.getRunningHKWorkouts())
                
                ModelController.sharedInstance.getWalkingWorkouts { workouts in
                    allHKWorkouts.append(contentsOf: editShoe.getWalkingHKWorkouts())
                    allHKWorkouts.sort(by: { (lhs, rhs) -> Bool in
                        return lhs.endDate < rhs.endDate
                    })
                    var total = 0.0
                    var lineChartEntries = [ChartDataEntry]()
                    var bubbleChartEntries = [BubbleChartDataEntry]()
                    lineChartEntries.append(ChartDataEntry(x: Double(editShoe.dateAdded!.timeIntervalSince1970), y: 0.0, data: editShoe.dateAdded))
                    //bubbleChartEntries.append(BubbleChartDataEntry(x: Double(editShoe.dateAdded!.timeIntervalSince1970), y: 0.0, size: 0))

                    for workout in allHKWorkouts {
                        let workoutDistance = workout.totalDistance!.doubleValue(for: editShoe.getHKUnit())
                        total += workoutDistance
                        let entry = ChartDataEntry(x: Double(workout.endDate.timeIntervalSince1970), y: total, data: workout.endDate as AnyObject)
                        lineChartEntries.append(entry)
//                        let bubbleEntry = BubbleChartDataEntry(x: Double(workout.endDate.timeIntervalSince1970), y: total, size: CGFloat(workoutDistance))
//                        bubbleChartEntries.append(bubbleEntry)
                    }
                    
                    let line1 = LineChartDataSet(values: lineChartEntries, label: "Total Distance")
                    line1.label = "Distance"
                    let lineData = LineChartData()
                    lineData.addDataSet(line1)

//                    let bubbleChartDataSet = BubbleChartDataSet(values: bubbleChartEntries, label: "Total Distance")
//                    bubbleChartDataSet.setColors(ChartColorTemplates.vordiplom(), alpha: 1)
//                    //bubbleChartDataSet.valueTextColor = UIColor.white
//                    bubbleChartDataSet.drawValuesEnabled = true
//                    let bubbleData = BubbleChartData(dataSet: bubbleChartDataSet)
//                    bubbleData.setHighlightCircleWidth(1.5)
                    
                    
                    
                    //create slope
                    if let firstPoint = lineChartEntries.first, let lastPoint = lineChartEntries.last {
                        let slope = (lastPoint.y - firstPoint.y) / (lastPoint.x - firstPoint.x)
                        let x = editShoe.distance / slope + editShoe.dateAdded!.timeIntervalSince1970
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "ddMMMYY"
                        DispatchQueue.main.async {
                            self.estimatedRetirementDateCell.textField.text = dateFormatter.string(from: Date(timeIntervalSince1970: x))
                        }
                        var estimateLineChartEntry = [ChartDataEntry]()
                        estimateLineChartEntry.append(ChartDataEntry(x: Double(editShoe.dateAdded!.timeIntervalSince1970), y: 0.0, data: editShoe.dateAdded))
                        estimateLineChartEntry.append(ChartDataEntry(x: x, y: editShoe.distance, data: editShoe.dateAdded))
                        let line2 = LineChartDataSet(values: estimateLineChartEntry, label: "Average Usage")
                        line2.colors = [UIColor.orange]
                        lineData.addDataSet(line2)
                    }
                    
                    DispatchQueue.main.async {
                        
                        self.combinedChartView.setScaleEnabled(true)
                        //self.combinedChartView.maxVisibleCount = 200
                        self.combinedChartView.xAxis.valueFormatter = DateValueFormatter()
                        self.combinedChartView.chartDescription?.text = "Workouts"
                        self.combinedChartView.pinchZoomEnabled = true
//                        let rightAxis = self.combinedChartView.rightAxis
//                        rightAxis.axisMinimum = 0
//
//                        let leftAxis = self.combinedChartView.leftAxis
//                        leftAxis.axisMinimum = 0
//
//                        let xAxis = self.combinedChartView.xAxis
//                        xAxis.labelPosition = .bothSided
//                        xAxis.axisMinimum = 0
//                        xAxis.granularity = 1
                        let chartData = CombinedChartData()
                        chartData.lineData = lineData
                        total = 0.0
                        bubbleChartEntries = allHKWorkouts.map({ (workout) -> BubbleChartDataEntry in
                            let workoutDistance = workout.totalDistance!.doubleValue(for: editShoe.getHKUnit())
                            total += workoutDistance
                            return BubbleChartDataEntry(x: Double(workout.endDate.timeIntervalSince1970), y: total, size: CGFloat(workoutDistance))
                        })
                        let set = BubbleChartDataSet(values: bubbleChartEntries, label: "Total Distance")
                        set.setColors(ChartColorTemplates.vordiplom(), alpha: 1)
                        set.valueTextColor = UIColor.blue
                        set.valueFont = .systemFont(ofSize: 10)
                        set.drawValuesEnabled = true
                        chartData.bubbleData = BubbleChartData(dataSet: set)
                        self.combinedChartView.drawOrder = [DrawOrder.bubble.rawValue, DrawOrder.line.rawValue]
                        self.combinedChartView.data = chartData
                    }
                    
                }
            }

//            var lineChartEntry = [ChartDataEntry]()
//            let allWorkouts = editShoe.workoutData
//            var total = 0.0
//            lineChartEntry.append(ChartDataEntry(x: 0.0, y: 0.0))
//            for (index, workout) in allWorkouts.enumerated() {
//                total += workout.distance
//                let entry = ChartDataEntry(x: Double(index + 1), y: total)
//                lineChartEntry.append(entry)
//            }
//            let line1 = LineChartDataSet(values: lineChartEntry, label: "Total Distance")
//            let data = LineChartData()
//            data.addDataSet(line1)
//            //create slope
//            let average = total / Double(allWorkouts.count)
//            let estimatedNumberOfWorkouts = editShoe.distance / average
//            var estimateLineChartEntry = [ChartDataEntry]()
//            estimateLineChartEntry.append(ChartDataEntry(x: 0.0, y: 0.0))
//            estimateLineChartEntry.append(ChartDataEntry(x: estimatedNumberOfWorkouts, y: editShoe.distance))
//            let line2 = LineChartDataSet(values: estimateLineChartEntry, label: "Average Usage")
//            line2.colors = [UIColor.orange]
//            data.addDataSet(line2)
//            lineChartView.data = data
//            lineChartView.chartDescription?.text = "Workouts"
//            lineChartView.pinchZoomEnabled = true
            
            
        }
        else {
            //adding new shoe don't need to show a few fields.
            self.numberOfWorkouts.contentView.isHidden = true
            self.shoeDistanceLogged.contentView.isHidden = true
            self.shoePercentRemaining.contentView.isHidden = true
        }
        
        self.interstitial = self.createAndLoadAd()
        self.interstitial.delegate = self
        
    }
    
    func generateBubbleData() -> BubbleChartData {
        let entries = (0..<10).map { (i) -> BubbleChartDataEntry in
            return BubbleChartDataEntry(x: Date().addingTimeInterval(Double(i) * 10000.0).timeIntervalSince1970,
                                        y: Double(arc4random_uniform(10) + 105) + 0.5,
                                        size: CGFloat(arc4random_uniform(10)) + 0.1)
        }
        
        let set = BubbleChartDataSet(values: entries, label: "Bubble DataSet")
        set.setColors(ChartColorTemplates.vordiplom(), alpha: 1)
        set.valueTextColor = .white
        set.valueFont = .systemFont(ofSize: 10)
        set.drawValuesEnabled = true
        
        return BubbleChartData(dataSet: set)
    }
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(indexPath.row)
        
    }

    var colorAvatarIndex: Int {
        get {
            return ModelController.colorNames.index(of: (shoeAvatarColorPIckerCell.detailTextLabel?.text)!)!
        }
    }
    
    var distance:Double {
        get {
            return shoeMileageCell.doubleValue
        }
    }
    
    var brand:String {
        get {
            //print(shoeBrandPickerCell.detailTextLabel?.text!)
            return (shoeBrandPickerCell.detailTextLabel?.text)!
            //return shoeBrandCell.value
        }
    }
    
    var model:String {
        get {
            return shoeModelCell.value
        }
    }
    
    var nickname:String {
        get {
            return shoeNicknameCell.value
        }
    }
    
    var date:Date? {
        get {
            
            return shoeDateCell.date
        }
    }
    
    var defaultWorkout: DefaultShoe? {
        get {
            for type in ModelController.defaultWorkoutTypes {
                if self.defaultPickerCell.detailTextLabel?.text! == type.value {
                    
                    return ModelController.sharedInstance.defaultWorkout(forType: type.key)
                }
            }
            return nil
        }
    }
    
    var distanceUnit:DistanceUnit {
        get {
            let distanceUnitInput = DistanceUnit(rawValue: shoeDistanceUnit.selectedSegmentIndex)!
            return distanceUnitInput
        }
    }
    
    @IBAction func validateRequiredData(_ sender: Any) {
        if self.brand.characters.count == 0 || self.brand == "Required" {
            let alert = UIAlertController(title: "Required Data", message: "Brand is required.", preferredStyle: UIAlertControllerStyle.alert)
            alert.popoverPresentationController?.sourceView = self.view
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if self.model.characters.count == 0 || self.model == "Required" {
            let alert = UIAlertController(title: "Required Data", message: "Model/Product Name is required.", preferredStyle: UIAlertControllerStyle.alert)
            alert.popoverPresentationController?.sourceView = self.view
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if self.distance == 0 {
            let alert = UIAlertController(title: "Required Data", message: "Max Distance is required.", preferredStyle: UIAlertControllerStyle.alert)
            alert.popoverPresentationController?.sourceView = self.view
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            
            if interstitial.isReady {
                interstitial.present(fromRootViewController: self)
            } else {
                print("Ad wasn't ready")
                self.performSegue(withIdentifier: "addShoeSave", sender: tableView)
            }
            
//            self.performSegue(withIdentifier: "addShoeSave", sender: tableView)
            
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return false
    }
    
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if let identifier = segue.identifier {
            if identifier == "shoeWorkouts" {
                let shoeWorkouts = segue.destination as! ShoeWorkoutTableViewController
                shoeWorkouts.shoe = editShoe
            }
        }
    }
    
    func deleteShoe(_ shoe: Shoe) {
        editShoe.delete { (status, error) in
        }
    }
    
    func retireShoe(_ shoe: Shoe) {
        editShoe.retire { (status, error) in
        }
    }
    
    public func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        self.performSegue(withIdentifier: "addShoeSave", sender: tableView)
    }
    
    func createAndLoadAd() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-1011036572239562/8452208546")
        let request = GADRequest()
        //request.testDevices = ["90fc3240ee18c02d21731660481c9e7a"]
        interstitial.load(request)
        return interstitial
    }
    
    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    override open var shouldAutorotate: Bool {
        return true
    }
    
    override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
        } else {
            print("Portrait")
        }
        
    }
}

public class DateValueFormatter: NSObject, IAxisValueFormatter {
    private let dateFormatter = DateFormatter()
    
    override init() {
        super.init()
        dateFormatter.dateFormat = "ddMMMYY"
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}
