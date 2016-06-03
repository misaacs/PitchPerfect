//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Michael Isaacs on 4/11/16.
//  Copyright © 2016 Mike Isaacs Software. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingStatusLabel: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!

    func canRecordNow(recordNow: Bool=true){
        
        recordingStatusLabel.text = recordNow ? "Tap to Record" : "Recording in progress"
        recordButton.enabled = recordNow
        stopRecordingButton.enabled = !recordNow
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        canRecordNow()
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        canRecordNow()
        audioRecorder.stop()
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        canRecordNow(false)
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool){
        if flag {
            self.performSegueWithIdentifier("recordingDoneSegue", sender: audioRecorder.url)
        }
        else{
            print("Problem saving audio file")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "recordingDoneSegue"){
            let playSoundsVC = segue.destinationViewController as! PlaySoundsViewController
            playSoundsVC.recordedAudioURL = sender as! NSURL
        }
    }
}
