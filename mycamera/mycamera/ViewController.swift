//
//  ViewController.swift
//  mycamera
//
//  Created by zsp on 2018/3/1.
//  Copyright © 2018年 zsp. All rights reserved.
//

import UIKit
import AVFoundation
class ViewController: UIViewController {

    fileprivate lazy var session:AVCaptureSession = {
        return AVCaptureSession()
    }()
    fileprivate var videoOutput:AVCaptureVideoDataOutput?
    fileprivate var audioOutput:AVCaptureAudioDataOutput?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpVideoInputAndOutput()
        setUpAudioInputAndOutput()
        setPreviewLayer()
    }
    
    
    
    
}
extension ViewController{
    @IBAction func start(_ sender: UIButton) {
        session.startRunning()
    }
    
    @IBAction func stop(_ sender: UIButton) {
        session.stopRunning()
    }
    @IBAction func change(_ sender: UIButton) {
        
    }
}


extension ViewController{
    func setUpVideoInputAndOutput() -> Void {
        //1.添加视频输入
        guard let devices = AVCaptureDevice.devices() as? [AVCaptureDevice] else {
            return
        }
        let device = (devices.filter { $0.position == .front}).last
        
        guard let input = try? AVCaptureDeviceInput(device: device!) else {return}
        //2.添加视频输出
        let outPut = AVCaptureVideoDataOutput()
        outPut.setSampleBufferDelegate(self as AVCaptureVideoDataOutputSampleBufferDelegate, queue: DispatchQueue.global())
        self.videoOutput = outPut
        //3.添加输入输出
        session.beginConfiguration()
        if self.session.canAddInput(input) {
            session.addInput(input)
        }
        if session.canAddOutput(outPut) {
            session.addOutput(outPut)
        }
        session.commitConfiguration()
    }
    func setUpAudioInputAndOutput() -> Void {
        //1.添加音频输入
        guard let device = AVCaptureDevice.default(for: .audio) else {
            return
        }
        guard let input = try? AVCaptureDeviceInput(device: device) else {return}
        //2.添加音频输出
        let outPut = AVCaptureAudioDataOutput()
        outPut.setSampleBufferDelegate(self as AVCaptureAudioDataOutputSampleBufferDelegate, queue: DispatchQueue.global())
        //3.添加输入输出
        session.beginConfiguration()
        if self.session.canAddInput(input) {
            session.addInput(input)
        }
        if session.canAddOutput(outPut) {
            session.addOutput(outPut)
        }
        session.commitConfiguration()
    }
    func setPreviewLayer() -> Void{
        let previewlayer = AVCaptureVideoPreviewLayer(sessionWithNoConnection: session)
        previewlayer.frame = UIScreen.main.bounds
//        previewlayer.backgroundColor = UIColor.red.cgColor
        view.layer.addSublayer(previewlayer)
        
    }
}

extension ViewController :AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate{
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if videoOutput?.connection(with: .video) == connection{
            print("视频数据")
        }else{
            print("音频数据")
        }
    }
}



