//
//  ScannerView.swift
//  SwiftUI-BarcodeScanner
//
//  Created by Omar Khalifa on 20/02/2026.
//

import SwiftUI
internal import AVFoundation

struct ScannerView: UIViewControllerRepresentable {
    @Binding public var isScanning: Bool
    @Binding public var scannedCode: String?
    @Binding public var isShowingAlert: Bool
    @Binding public var errorMessage: String?
    
    func makeUIViewController(context: Context) -> ScannerVC {
        ScannerVC(scannerDelegate: context.coordinator)
    }
    
    func updateUIViewController(_ uiViewController: ScannerVC, context: Context) {
        if isScanning && !uiViewController.captureSession.isRunning {
            DispatchQueue.global(qos: .userInitiated).async {
                uiViewController.captureSession.startRunning()
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(scannedCode: $scannedCode, errorMessage: $errorMessage, isShowingAlert: $isShowingAlert)
    }
    
    final class Coordinator: NSObject, ScannerVCDelegate {
        @Binding var scannedCode: String?
        @Binding var errorMessage: String?
        @Binding var isShowingAlert: Bool

        init(scannedCode: Binding<String?>, errorMessage: Binding<String?>, isShowingAlert: Binding<Bool>) {
            self._scannedCode = scannedCode
            self._errorMessage = errorMessage
            self._isShowingAlert = isShowingAlert
        }

        func didScan(code: String) {
            scannedCode = code
        }

        func didSurface(error: CameraError) {
            errorMessage = error.rawValue
            isShowingAlert = true
        }
    }
}
