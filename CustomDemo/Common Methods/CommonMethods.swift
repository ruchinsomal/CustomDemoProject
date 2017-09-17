//
//  CommonMethods.swift
//  CustomDemo
//
//  Created by Ruchin Somal on 17/09/17.
//  Copyright © 2017 Ruchin Somal. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

func addShadowOnViews(_ view : AnyObject) {
    view.layer.shadowColor = UIColor.lightGray.cgColor
    view.layer.shadowOffset = CGSize.zero
    view.layer.shadowRadius = 2
    view.layer.shadowOpacity = 1.0
    //view.layer.masksToBounds = true
}

// To add layer on any UIView element Bottom side
func addLayerOnViewBottom(textField: AnyObject,color: UIColor,width: CGFloat) {
    let border = CALayer()
    border.frame = CGRect(x: 0, y: textField.bounds.size.height, width:  textField.bounds.size.width, height: 0)
    border.borderColor = color.cgColor
    border.frame = CGRect(x: width/2.0, y: textField.bounds.size.height - 0.5, width:  textField.bounds.size.width - width, height: 0.5)
    border.borderWidth = 1.0
    textField.layer.addSublayer(border)
    textField.layer.masksToBounds = true
}

// To add layer on any UIView element Upper side
func addLayerOnViewUpper(textField: AnyObject,color: UIColor,width: CGFloat) {
    let border = CALayer()
    border.frame = CGRect(x: 0, y: 0, width:  textField.bounds.size.width, height: 0)
    border.borderColor = color.cgColor
    border.frame = CGRect(x: width/2.0, y: 0, width:  textField.bounds.size.width - width, height: 0.5)
    border.borderWidth = 1.0
    textField.layer.addSublayer(border)
    textField.layer.masksToBounds = true
}

// To convert shape into rounded view
func roundedView(anyView: AnyObject,width: CGFloat,mastkBound:Bool) {
    anyView.layer.cornerRadius = width
    anyView.layer.masksToBounds = mastkBound
}

// To add border on view
func addBorderToView(anyView: AnyObject,width: CGFloat,color: UIColor) {
    anyView.layer.borderWidth = width
    anyView.layer.borderColor = color.cgColor
    anyView.layer.masksToBounds = true
}

// To show alert message
func showAlertView(title: String, message: String, ref:UIViewController) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
    }
    alertController.addAction(okAction)
    ref.present(alertController, animated: true, completion: nil)
}

// To convert Date(In Mili's) to normal date format
func dateConvertor_Milis(date:Double,format:String) -> String {
    let date = NSDate(timeIntervalSince1970: date/1000.0)
    let dayTimePeriodFormatter = DateFormatter()
    
    dayTimePeriodFormatter.dateFormat = format
    let dateString = dayTimePeriodFormatter.string(from: date as Date)
    return dateString
}

// To convert NSDate to normal date format
func dateConvertor_NSDate(date:NSDate,format:String) -> String {
    let dayTimePeriodFormatter = DateFormatter()
    
    dayTimePeriodFormatter.dateFormat = format
    let dateString = dayTimePeriodFormatter.string(from: date as Date)
    return dateString
}

// To convert hex code to UIColor
func hexStringToUIColor(hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    if ((cString.characters.count) != 6) {
        return UIColor.gray
    }
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

// get Image From URL
func setImageFromURLonImageView(url: URL, imageView: UIImageView) {
    // check from cache
    if let cachedImage = imageCache.object(forKey: url as AnyObject) as? UIImage {
        imageView.image = cachedImage
    } else {
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
            }
            else {
                DispatchQueue.main.async(execute: {
                    if let downloadedImage = UIImage(data: data!) {
                        imageCache.setObject(downloadedImage, forKey: url as AnyObject)
                        imageView.image = downloadedImage
                    }
                })
            }
        }).resume()
    }
}
