//
//  ScannerVC.swift
//  SwiftUI-BarcodeScanner
//
//  Created by Omar Khalifa on 20/02/2026.
//

import UIKit
internal import AVFoundation

// Error Messages
enum CameraError: String {
    case invalidDeviceInput     = "Something went wrong when accessing the camera. We are unable to capture the input."
    case invalidScannedValue    = "The code scanned doesn't match supported code formats. Supported code formats are EAN-8 and EAN-13."
    case unableToZoomCamera     = "Unable to zoom the camera. Camera zoom feature not supported."
}

protocol ScannerVCDelegate: AnyObject {
    func didScan(code: String)
    func didSurface(error: CameraError)
}

final class ScannerVC: UIViewController{
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    var player: AVAudioPlayer?
    weak var scannerDelegate: ScannerVCDelegate?
    
    init(scannerDelegate: ScannerVCDelegate){
        super.init(nibName: nil, bundle: nil)
        self.scannerDelegate = scannerDelegate
    }
    
    // required for AVCaptureSession()
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        guard let previewLayer = previewLayer else{
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        previewLayer.frame = view.layer.bounds
    }
    
    private func setupCaptureSession(){
        // Capture Device Input needs a Capture Device
        // Cature Device
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        do {
            try videoCaptureDevice.lockForConfiguration()
            videoCaptureDevice.videoZoomFactor = videoCaptureDevice.maxAvailableVideoZoomFactor
            videoCaptureDevice.unlockForConfiguration()
        } catch {
            //Catch error from lockForConfiguration
            scannerDelegate?.didSurface(error: .unableToZoomCamera)
        }
        
        // Capture Device Input
        let videoInput: AVCaptureDeviceInput
        
        do{
            try videoInput = AVCaptureDeviceInput(device: videoCaptureDevice)
        }catch{
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        // Add input to capture session (= adding the camera as a video capture device)
        if captureSession.canAddInput(videoInput){
            captureSession.addInput(videoInput)
        }else{
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        // Capture Metadata Output
        let metaDataOutput = AVCaptureMetadataOutput()
        
        // Add output to capture session
        if captureSession.canAddOutput(metaDataOutput){
            captureSession.addOutput(metaDataOutput)
            
            // set metadata objects delegate to self
            metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            // metadata object types (.ean8, .ean13) to scan standard barcodes
            metaDataOutput.metadataObjectTypes = [.ean8, .ean13]
        }else{
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        // set previewLayer to capture session
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = .resizeAspectFill
        guard let safePreview = previewLayer else { return }
        view.layer.addSublayer(safePreview)
        
        // run capture session
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }
}

extension ScannerVC: AVCaptureMetadataOutputObjectsDelegate{
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // get first object
        guard let object = metadataObjects.first else {
            scannerDelegate?.didSurface(error: .invalidScannedValue)
            return
        }
        
        // conform to machine readable?
        guard let machineReadableObject = object as? AVMetadataMachineReadableCodeObject else {
            scannerDelegate?.didSurface(error: .invalidScannedValue)
            return
        }
        
        // extract string from the object
        guard let barcode = machineReadableObject.stringValue else {
            scannerDelegate?.didSurface(error: .invalidScannedValue)
            return
        }
        
        // pass to delegate
        scannerDelegate?.didScan(code: barcode)
        playSound()
        captureSession.stopRunning()
    }
}

extension ScannerVC {
    private func playSound(){
        guard let path = Bundle.main.path(forResource: "beep", ofType:"mp3") else {
                return }
            let url = URL(fileURLWithPath: path)

            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.play()
                
            } catch let error {
                print(error.localizedDescription)
            }
    }
}
