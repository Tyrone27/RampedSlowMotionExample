//
//  ViewController.swift
//  AVMutableCompositionExportSession
//
//  Created by Justin Winter on 9/28/15.
//  Copyright © 2015 wintercreative. All rights reserved.
//

import UIKit
import AVFoundation

class AssetConfig {
    
    var asset : AVAsset?
    
    
    func configureAssets(){
        
        let options =    [AVURLAssetPreferPreciseDurationAndTimingKey : "true"]
        let videoAsset = AVURLAsset(url: Bundle.main.url(forResource: "Push", withExtension: "mp4")! , options : options)
        
        let videoAssetSourceTrack = videoAsset.tracks(withMediaType: AVMediaTypeVideo).first! as AVAssetTrack
    //    let audioAssetSourceTrack = videoAsset.tracks(withMediaType: AVMediaTypeAudio).first! as AVAssetTrack
        
        let comp = AVMutableComposition()
        let videoCompositionTrack = comp.addMutableTrack(withMediaType: AVMediaTypeVideo, preferredTrackID: kCMPersistentTrackID_Invalid)
        
//        let audioCompositionTrack = comp.addMutableTrack(withMediaType: AVMediaTypeAudio, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        
        do {
            
            try videoCompositionTrack.insertTimeRange(
                CMTimeRangeMake(kCMTimeZero, videoAsset.duration),
                of: videoAssetSourceTrack,
                at: kCMTimeZero)
            
            downWithRamp(track: videoCompositionTrack)
            
            videoCompositionTrack.preferredTransform = videoAssetSourceTrack.preferredTransform
            
        }catch { print(error) }
        
        asset = comp
    }
    
    
    
    
    
    
    // MARK :  Slow motion 
    
    // ramped slow motion 
    
    // Description :    1) For a given TimeRange , get the start and end frame.
    //                  2) Divide this TimeRange to 10 segment
    //                  3) Scale each segment with a CMTime that
    //                     increments in each iteration of the for loop

    

    func downWithRamp(track : AVMutableCompositionTrack){
        
        
        // Initials
        let fps =               Int32(track.nominalFrameRate)
        let sumTime =           Int32(track.timeRange.duration.value)  /  track.timeRange.duration.timescale;
        let totalFrames =       sumTime * fps
        let totalTime =         Float(CMTimeGetSeconds(track.timeRange.duration))
        let frameDuration =     Double(totalTime / Float(totalFrames))
   //   let frameTime =         CMTime(seconds: frameDuration, preferredTimescale: 1000)
        let frameTime =         CMTimeMultiplyByFloat64(CMTime(value: 1, timescale: 1) , Float64(frameDuration))
        
        
        
        
        
        let x1 : Double = 50
        let x2 : Double = 150
        let x3 : Double = 250
        let x4 : Double = 350
        
        let parts =         (x2 - x1)/10
        
        let x1Time =        CMTimeMultiplyByFloat64(frameTime, x1)
        let x2Time =        CMTimeMultiplyByFloat64(frameTime, x2)
        let tenthDuration = CMTimeMultiplyByFloat64(CMTimeSubtract(x2Time, x1Time) , 1/10)
        
        var scaleFactor = 1.0
        
        var timing3 =     CMTimeMultiplyByFloat64(frameTime, Float64(x3))
        
        
 
        
        for x in Swift.stride(from: x3, to: x4, by: parts ){
            
            print("\(x)th Frame")
            let factor =    CMTimeMultiplyByFloat64( tenthDuration , 1/scaleFactor)       //scale to this time
            print("This range will be scaled by \(CMTimeGetSeconds(factor)) seconds")
            
            let timeRange =    CMTimeRange(start: timing3, duration : tenthDuration)
            print("TimeRange    =  \(CMTimeGetSeconds(timeRange.start)) - \(CMTimeGetSeconds(timeRange.end))secs ")
            
            track.scaleTimeRange(timeRange , toDuration: factor)
            if x < x3 + (x4 - x3)/2 {                                     // the parabolic ramp :to turn off , use the else cond. delete rest
                scaleFactor = scaleFactor + 0.2 }
                else {          scaleFactor = scaleFactor - 0.2 }
            
            timing3 = CMTimeAdd(timing3, factor)
            
            print()
        }
        
    }
    
    func slowDownWithRamp(asset : AVMutableComposition){
        
        
        // Initials
        let fps =               Int32(asset.tracks(withMediaType: AVMediaTypeVideo).first!.nominalFrameRate)
        let sumTime =           Int32(asset.duration.value)  /  asset.duration.timescale;
        let totalFrames =       sumTime * fps
        let totalTime =         Float(CMTimeGetSeconds(asset.duration))
        let frameDuration =     Double(totalTime / Float(totalFrames))
        let frameTime =         CMTime(seconds: frameDuration, preferredTimescale: 1000000)
       //   let frameTime =         CMTimeMultiplyByFloat64(CMTime(value: 1, timescale: 1) , Float64(frameDuration))
        
        //
        
        
        let x1 : Double = 50
        let x2 : Double = 150
       
        
        let parts =         (x2 - x1)/10
        
        let x1Time =        CMTimeMultiplyByFloat64(frameTime, x1)
        let x2Time =        CMTimeMultiplyByFloat64(frameTime, x2)
        let tenthDuration = CMTimeMultiplyByFloat64(CMTimeSubtract(x2Time, x1Time) , 1/10)
        
        var scaleFactor = 1.0

        var timing =     CMTimeMultiplyByFloat64(frameTime, Float64(x1))

        for x in Swift.stride(from: x1, to: x2, by: parts ){
            
            print("\(x)th Frame")
            let factor =    CMTimeMultiplyByFloat64( tenthDuration , 1 / scaleFactor)       //scale to this time
            print("This range will be scaled by \(CMTimeGetSeconds(factor)) seconds")
            let timeRange =    CMTimeRange(start: timing, duration : tenthDuration)
            print("TimeRange    =  \(CMTimeGetSeconds(timeRange.start)) - \(CMTimeGetSeconds(timeRange.end))secs ")
               asset.scaleTimeRange(timeRange , toDuration: factor)
            if x < x1 + (x2 - x1)/2 {                                     // the parabolic ramp :to turn off , use the else cond. delete rest
                scaleFactor = scaleFactor + 0.2 }
            else {scaleFactor = scaleFactor - 0.2  }
            timing = CMTimeAdd(timing, factor)
            print()
        }
        
        
    }

    
    
    // Segmented slow-mo without ramp : Applying scaleTime range to unit frames
    
    func slowDown( asset : AVMutableComposition , by factor : Double){
        
        let fps =               Int32(asset.tracks(withMediaType: AVMediaTypeVideo).first!.nominalFrameRate)
        let sumTime =           Int32(asset.duration.value)  /  asset.duration.timescale;
        let totalFrames =       sumTime * fps
        let totalTime =         Float(CMTimeGetSeconds(asset.duration))
        let frameDuration =     Double(totalTime / Float(totalFrames))
        let frameTime =         CMTime(seconds: frameDuration, preferredTimescale: 1000)
        
        let scaleFrames = CMTimeMultiplyByFloat64(frameTime, factor)
        
        for frame in Swift.stride(from: 0 , to: Double(150), by: 2){
            
            
            let timing =    CMTimeMultiplyByFloat64(frameTime, Float64(frame))
            
            print("Asset Duration = \(CMTimeGetSeconds(asset.duration))")
            print("")
            
            let timeRange = CMTimeRange(start: timing, duration : frameTime)
            asset.scaleTimeRange(timeRange, toDuration: scaleFrames)
            
              }
                  }
    
    
    
    // MARK : Save the file
    
    
    func createFileFromAsset(_ asset: AVAsset){
        
        func deleteFile(_ filePath:URL) {
            guard FileManager.default.fileExists(atPath: filePath.path) else {
                return
            }
            
            do {
                try FileManager.default.removeItem(atPath: filePath.path)
            }catch{
                fatalError("Unable to delete file: \(error) : \(#function).")
            }
        }

        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL
        
        let filePath = documentsDirectory.appendingPathComponent("rendered-film.mp4")
       deleteFile(filePath)
        
        if let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality){
            
            
          //  exportSession.canPerformMultiplePassesOverSourceMediaData = true
            exportSession.outputURL = filePath
            exportSession.shouldOptimizeForNetworkUse = true
            exportSession.timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration)
            exportSession.outputFileType = AVFileTypeQuickTimeMovie
            exportSession.exportAsynchronously {
                print("finished: \(filePath) :  \(exportSession.status.rawValue) ")
                
                if exportSession.status.rawValue == 4{
                
                      print("Export failed -> Reason: \(exportSession.error!.localizedDescription))")
                      print(exportSession.error!)
                    
                }
                
            }
        }
    }
    
   
}

