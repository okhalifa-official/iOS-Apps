//
//  ContentView.swift
//  SwiftUI-BarcodeScanner
//
//  Created by Omar Khalifa on 20/02/2026.
//

import SwiftUI

struct BarcodeScannerView: View {
    @State var scannedBarcode: String? = nil
    @State var isScanning: Bool = true
    @State var isShowingAlert: Bool = false
    @State var errorMessage: String? = nil
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    Spacer()
                    
                    ZStack {
                        ScannerView(isScanning: $isScanning, scannedCode: $scannedBarcode, isShowingAlert: $isShowingAlert, errorMessage: $errorMessage)
                    }
                    .frame(maxWidth: .infinity , maxHeight: 300)
                    .padding()
                    Spacer()
                    
                    Label("Scanned Barcode", systemImage: "barcode.viewfinder")
                        .font(.title2)
                        .fontWeight(.medium)
                    barcodeText(text: scannedBarcode)
                    Image(systemName: "lightspectrum.horizontal")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 50)
                        .onTapGesture {
                            // reload
                            isScanning = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                isScanning = true
                            }
                        }
                    
                    Spacer()
                }
                .navigationTitle("Barcode Scanner")
                .alert(isPresented: $isShowingAlert) {
                    Alert(
                        title: Text("Note"),
                        message: Text(errorMessage ?? "Something went wrong."),
                        dismissButton: .default(Text("OK")) {
                            isShowingAlert = false
                        }
                    )
                }
            }
        }
    }
    
}

#Preview {
    BarcodeScannerView()
        .preferredColorScheme(.dark)
}

struct barcodeText: View {
    var text: String?
    var color: Color = Color(.red)
    
    var body: some View {
        Text(text ?? "Not Yet Scanned")
            .font(.title)
            .bold()
            .foregroundStyle(text != nil ? .green : color)
            .padding(1)
    }
}
