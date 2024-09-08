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
    private var dataSource: DataSource<QRCodeData2>?
    
    var qrScans: [QRCodeData2] = []
    var isShowingScanner = false
    
    init() {
        Task { @MainActor in
            self.dataSource = DataSource<QRCodeData2>.shared(for: QRCodeData2.self)
            self.fetchItems()
        }
    }
    
    
    func appendItem(_ qrData: QRCodeData2) {
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
            let qrCode = QRCodeData2(id: UUID(), qrCodeStringData: result.string, emailAddress: "myEmail@emailMe.com", isFavorite: false, dateAdded: Date())
            
            Task { @MainActor in
                self.appendItem(qrCode)
            }
        case .failure(let error):
            print("Scanning Failed: \(error.localizedDescription)")
        }
        
        isShowingScanner = false
    }
}


    


