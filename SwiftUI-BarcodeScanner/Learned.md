# UIKit in SwiftUI

------------------------------------------------------------------------

## 1. Wrapping UIKit with UIViewControllerRepresentable

To use a UIKit `UIViewController` inside SwiftUI, we conform to
`UIViewControllerRepresentable`.

``` swift
struct ScannerView: UIViewControllerRepresentable {

    @Binding public var isScanning: Bool
    @Binding public var scannedCode: String?
    @Binding public var isShowingAlert: Bool
    @Binding public var errorMessage: String?

    func makeUIViewController(context: Context) -> ScannerVC {
        ScannerVC(scannerDelegate: context.coordinator)
    }

    func updateUIViewController(_ uiViewController: ScannerVC, context: Context) {
        // can be left empty if no updates on the VC side
        if isScanning && !uiViewController.captureSession.isRunning {
            DispatchQueue.global(qos: .userInitiated).async {
                uiViewController.captureSession.startRunning()
            }
        }
    }
}
```

## 2. Coordinator (Bridge Between SwiftUI & UIKit)

UIKit uses delegates. SwiftUI uses bindings. Coordinator connects both.

``` swift
func makeCoordinator() -> Coordinator {
    Coordinator(scannedCode: $scannedCode,
                errorMessage: $errorMessage,
                isShowingAlert: $isShowingAlert)
}
```

``` swift
final class Coordinator: NSObject, ScannerVCDelegate {

    @Binding var scannedCode: String?
    @Binding var errorMessage: String?
    @Binding var isShowingAlert: Bool

    // the following are ScannerVCDelegate user-defined functions
    func didScan(code: String) {
        scannedCode = code
    }

    func didSurface(error: CameraError) {
        errorMessage = error.rawValue
        isShowingAlert = true
    }
}
```

## 3. Protocols & Delegates

``` swift
protocol ScannerVCDelegate: AnyObject {
    func didScan(code: String)
    func didSurface(error: CameraError)
}
```

Inside `ScannerVC`:

``` swift
weak var scannerDelegate: ScannerVCDelegate?
```

## 4. Passing Data Between SwiftUI & UIKit

### SwiftUI → UIKit

``` swift
@Binding public var isScanning: Bool
```

### UIKit → SwiftUI

Flow:

ScannerVC → Delegate → Coordinator → Binding → UI Update


## 5. Enum-Based Error Handling

``` swift
enum CameraError: String {
    case invalidDeviceInput
    case invalidScannedValue
    case unableToZoomCamera
}
```


## 6. Camera Session Setup (AVCaptureSession)

### 1️⃣ Get Camera Device

``` swift
AVCaptureDevice.default(for: .video)
```

### 2️⃣ Configure Zoom ( if needed )

``` swift
try videoCaptureDevice.lockForConfiguration()
videoCaptureDevice.videoZoomFactor = videoCaptureDevice.maxAvailableVideoZoomFactor
videoCaptureDevice.unlockForConfiguration()
```

### 3️⃣ Add Input

``` swift
let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
captureSession.addInput(videoInput)
```

### 4️⃣ Add Metadata Output

``` swift
let metaDataOutput = AVCaptureMetadataOutput()
captureSession.addOutput(metaDataOutput)
metaDataOutput.setMetadataObjectsDelegate(self, queue: .main)
metaDataOutput.metadataObjectTypes = [.ean8, .ean13]
```

### 5️⃣ Add Preview Layer

``` swift
previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
previewLayer?.videoGravity = .resizeAspectFill
view.layer.addSublayer(previewLayer!)
```

### 6️⃣ Start Session

``` swift
// wrap in dispatch queue to prevent blocking
DispatchQueue.global(qos: .userInitiated).async {
    captureSession.startRunning()
}
```

## 7. Handling Scanned Barcode

``` swift
func metadataOutput(_ output: AVCaptureMetadataOutput,
                    didOutput metadataObjects: [AVMetadataObject],
                    from connection: AVCaptureConnection) {

    guard let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
          let barcode = object.stringValue else {
        scannerDelegate?.didSurface(error: .invalidScannedValue)
        return
    }

    scannerDelegate?.didScan(code: barcode)
    captureSession.stopRunning()
}
```

## 8. Presenting Alerts in SwiftUI

``` swift
.alert(isPresented: $isShowingAlert) {
    Alert(
        title: Text("Note"),
        message: Text(errorMessage ?? "Something went wrong."),
        dismissButton: .default(Text("OK"))
    )
}
```

SwiftUI automatically updates when bindings change.
