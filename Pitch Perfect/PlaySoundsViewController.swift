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
    
    
    func playAudio(rate: Float, pitch:Float, echo:Float, reverb:Float) {
        resetAudioEngine()
        audioPlayer.currentTime = 0.0
        
        if rate != 1 {
            audioPlayer.rate = rate
            audioPlayer.play()
        } else if pitch != 0 {
            playAudioWithVariablePitch(pitch)
        } else if echo != 0 {
            playAudioWithEcho(echo)
        } else {
            print("It broke.")
        }
        
    }
    
    @IBAction func stopPlaying(sender: UIButton) {
        resetAudioEngine()
    }
    
    @IBAction func slowSound(sender: AnyObject) {
        playAudio(0.5, pitch: 0, echo: 0, reverb: 0)
    }
    
    @IBAction func fastSound(sender: UIButton) {
        playAudio(2.0, pitch: 0, echo: 0, reverb: 0)

    }
    
    @IBAction func chipmunkSound(sender: AnyObject) {
        playAudio(1, pitch: 1000, echo: 0, reverb: 0)
    }
    
    @IBAction func darthSound(sender: UIButton) {
        playAudio(1, pitch: -1000, echo: 0, reverb: 0)
    }
    
    @IBAction func echoSound(sender: AnyObject) {
        playAudio(1, pitch: 0, echo: 50, reverb: 0)
    }
}
