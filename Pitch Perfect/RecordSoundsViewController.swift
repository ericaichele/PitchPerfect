//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Eric Aichele on 3/14/16.
//  Copyright © 2016 Eric Aichele. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        recordLabel.hidden = true
        stopButton.hidden = true
        recordButton.enabled = true
        pauseButton.hidden = true
        resumeButton.hidden = true
        infoLabel.hidden = false
        infoLabel.text = "Tap to Record"
    }

    @IBAction func recordAudio(sender: UIButton) {
        recordLabel.hidden = false
        stopButton.hidden = false
        recordButton.enabled = false
        pauseButton.hidden = false
        resumeButton.hidden = false
        resumeButton.enabled = false
        
        print("in recordAudio")
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let recordingName = "myaudio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        // SETUP AUDIO SESSION
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        // INITIALIZE AND PREPARE THE RECORDER
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        infoLabel.hidden = true
        recordLabel.text = "Recording..."
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag) {
        recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
        performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }

    @IBAction func pauseRecording(sender: UIButton) {
        audioRecorder.pause()
        resumeButton.enabled = true
        pauseButton.enabled = false
        recordLabel.text = "Recording Paused"

    }
    
    @IBAction func resumeRecording(sender: UIButton) {
        audioRecorder.record()
        resumeButton.enabled = false
        pauseButton.enabled = true
        recordLabel.text = "Recording..."

    }
    
    
    @IBAction func stopRecording(sender: UIButton) {
        recordLabel.hidden = true
        stopButton.hidden = true
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
}

