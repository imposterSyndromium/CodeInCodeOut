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
    var sortNewestFirst = true
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
        if sortNewestFirst {
            qrScans.sort { $0.dateAdded > $1.dateAdded }
        } else {
            qrScans.sort { $0.dateAdded < $1.dateAdded }
        }
    }
    

    

}


    




