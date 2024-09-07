//
//  ScannedQRCodeDataViewModel.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-05.
//
import CodeScanner
import Foundation
import SwiftData




@Observable
class ScannedQRDataList_ViewModel {
    
    @ObservationIgnored
    private let dataSource: DataSource
    
    var qrScans: [QRData] = []
    var isShowingScanner = false

    init(dataSource: DataSource = DataSource.shared) {
        self.dataSource = dataSource
        qrScans = dataSource.fetchItems()
    }
    
    
    func appendItem(_ qrData: QRData) {
        // mock append just a date
        dataSource.appendItem(item: qrData)
    }
    
    
    func removeItem(_ index: Int) {
        dataSource.removeItem(qrScans[index])
    }
    
    func fetchItems() {
        qrScans = dataSource.fetchItems()
    }
    
    
    
    
    
    func handleScan(result: Result<ScanResult, ScanError>)  {
        switch result {
        case .success(let result):
            // get the QR code string content
            //let codeDataString = result.string
            let qrCode = QRData(inspectionOf: result.string, emailAddress: "myEmail@emailMe.com", isInspected: true, dateAdded: Date())
            
            appendItem(qrCode)
            fetchItems()
        case .failure(let error):
            print("Scanning Failed: \(error.localizedDescription)")
        }
        
        isShowingScanner = false
    }
    
}



//func handleCodeScan(result: Result<ScanResult, ScanError>) -> Bool {
//    switch result {
//        
//    case .success(let result):
//        // get the QR code string content
//        let codeDataString = result.string
//        print(codeDataString)
//        
//    case .failure(let error):
//        print("Scanning Failed: \(error.localizedDescription)")
//    }
//    
//    return false
//}


    


