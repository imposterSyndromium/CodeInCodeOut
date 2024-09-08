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


@Observable
class QRData_ViewModel {
    
    @ObservationIgnored
    private var dataSource: DataSource<QRCodeData3>?
    
    var qrScans: [QRCodeData3] = []
    var isShowingScanner = false {
        didSet {
            if !isShowingScanner {
                fetchItems()
            }
        }
    }
    
    init() {
        Task { @MainActor in
            self.dataSource = DataSource<QRCodeData3>.shared(for: QRCodeData3.self)
            self.fetchItems()
        }
    }
    
    
    func appendItem(_ qrData: QRCodeData3) {
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
            let image = result.image
            let qrCode = QRCodeData3(id: UUID(), qrCodeStringData: result.string, emailAddress: "myEmail@emailMe.com", isFavorite: false, dateAdded: Date(), notes: "This is some data that belongs in notes")
            
            Task { @MainActor in
                self.appendItem(qrCode)
            }
        case .failure(let error):
            print("Scanning Failed: \(error.localizedDescription)")
        }
        
        isShowingScanner = false
    }
    
    

}


    
extension UIImage {
    func toData() -> Data? {
        return self.pngData()
    }
}



