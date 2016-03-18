//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Eric Aichele on 3/15/16.
//  Copyright © 2016 Eric Aichele. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    func playAudioWithVariableRate(rate: Float) {
        resetAudioEngine()
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = rate
        audioPlayer.play()
    }
    
    func resetAudioEngine() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        resetAudioEngine()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        // CREATE PITCH EFFECT
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        
        // ATTACH PITCH TO NODE
        audioEngine.attachNode(changePitchEffect)
        
        // CONNECT AVAUDIOPLAYERNODE TO AVAUDIOUNITTIMEPITCH
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        // CONNECT AVAUDIOUNITTIMEPITCH TO OUTPUT
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
    
    func playAudioWithEcho(reverb: Float) {
        resetAudioEngine()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changeEchoEffect = AVAudioUnitReverb()
        changeEchoEffect.loadFactoryPreset(AVAudioUnitReverbPreset.Cathedral)
        changeEchoEffect.wetDryMix = reverb
        
        audioEngine.attachNode(changeEchoEffect)
        audioEngine.connect(audioPlayerNode, to: changeEchoEffect, format: nil)
        audioEngine.connect(changeEchoEffect, to: audioEngine.outputNode, format: nil)
        
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func stopPlaying(sender: UIButton) {
        audioPlayer.stop()
    }
    
    @IBAction func slowSound(sender: AnyObject) {
        playAudioWithVariableRate(0.5)
    }
    
    @IBAction func fastSound(sender: UIButton) {
        playAudioWithVariableRate(2.0)

    }
    
    @IBAction func chipmunkSound(sender: AnyObject) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func darthSound(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func echoSound(sender: AnyObject) {
        playAudioWithEcho(50)
    }
}
