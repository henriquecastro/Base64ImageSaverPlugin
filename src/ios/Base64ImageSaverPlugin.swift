//
//  Base64ImageSaver.swift
//  Lectio+
//
//  Created by August Heegaard on 16/11/15.
//  Copyright © 2015 Totus Labs. All rights reserved.
//

import Foundation
import Photos

@objc(Base64ImageSaverPlugin)
public class Base64ImageSaverPlugin: CDVPlugin {
    
//    public func savePNGImage(command: CDVInvokedUrlCommand) -> Void {
//        
//        if let base64String = command.argumentAtIndex(0) as? String {
//            
//            let toBeReplaced = "data:image/png;base64,"
//            let endIndex = toBeReplaced.startIndex.advancedBy(min(base64String.characters.count, toBeReplaced.characters.count))
//            
//            let dataString = base64String.stringByReplacingOccurrencesOfString(toBeReplaced, withString: "", options: [], range: base64String.startIndex...endIndex)
//            
//            saveImage(command, base64String: dataString)
//            
//        }
//        
//        let result = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: "Error: Invalid base64 string")
//        self.commandDelegate?.sendPluginResult(result, callbackId: command.callbackId)
//        
//    }
//    
//    public func saveJPEGImage(command: CDVInvokedUrlCommand) -> Void {
//        
//        if let base64String = command.argumentAtIndex(0) as? String {
//            
//            let toBeReplaced = "data:image/jpeg;base64,"
//            let endIndex = toBeReplaced.startIndex.advancedBy(min(base64String.characters.count, toBeReplaced.characters.count))
//            
//            let dataString = base64String.stringByReplacingOccurrencesOfString(toBeReplaced, withString: "", options: [], range: base64String.startIndex...endIndex)
//            
//            saveImage(command, base64String: dataString)
//            
//        }
//        
//        let result = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: "Error: Invalid base64 string")
//        self.commandDelegate?.sendPluginResult(result, callbackId: command.callbackId)
//        
//    }
    
    public func saveImageDataToLibrary(command: CDVInvokedUrlCommand) -> Void {
        
        if let base64String = command.argumentAtIndex(0) as? String, imageData = NSData(base64EncodedString: base64String, options: []), image = UIImage(data: imageData) {
            
            PHPhotoLibrary.sharedPhotoLibrary().performChanges({ () -> Void in
                // Attempt to save photo
                PHAssetChangeRequest.creationRequestForAssetFromImage(image)
                
            }) { (success: Bool, error: NSError?) -> Void in
                
                if let error = error {
                    let result = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: error.description)
                    self.commandDelegate?.sendPluginResult(result, callbackId: command.callbackId)
                    return
                } else if !success {
                    let result = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: "An error occurred")
                    self.commandDelegate?.sendPluginResult(result, callbackId: command.callbackId)
                    return
                }
                
                let result = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: "Image saved to photo library")
                self.commandDelegate?.sendPluginResult(result, callbackId: command.callbackId)
                
            }
            
        }
        
    }
    
}