//
//  ScannedQRCodeDataViewModel.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-05.
//
import CodeScanner
import Foundation
import SwiftData



import SwiftUI
import SwiftData

@Observable
class ScannedQRDataList_ViewModel {
    
    @ObservationIgnored
    private var dataSource: DataSource<QRCodeData>?
    
    var qrScans: [QRCodeData] = []
    var isShowingScanner = false
    
    init() {
        Task { @MainActor in
            self.dataSource = DataSource<QRCodeData>.shared(for: QRCodeData.self)
            self.fetchItems()
        }
    }
    
    
    func appendItem(_ qrData: QRCodeData) {
        dataSource?.appendItem(item: qrData)
        fetchItems()
    }
    
    
    func removeItem(_ index: Int) {
        if index < qrScans.count {
            dataSource?.removeItem(qrScans[index])
            fetchItems()
        }
    }
    
    
    func fetchItems() {
        qrScans = dataSource?.fetchItems() ?? []
    }
    
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        switch result {
        case .success(let result):
            let qrCode = QRCodeData(inspectionOf: result.string, emailAddress: "myEmail@emailMe.com", isInspected: true, dateAdded: Date())
            
            Task { @MainActor in
                self.appendItem(qrCode)
            }
        case .failure(let error):
            print("Scanning Failed: \(error.localizedDescription)")
        }
        
        isShowingScanner = false
    }
}


    


