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
        var modelContext: ModelContext
        var qrScans = [QRData]()
        
        var inspectionOf: String
        var emailAddress: String
        var isInspected: Bool
        var dateAdded: Date
        
        init(modelContext: ModelContext, qrScans: [QRData] = [QRData](), inspectionOf: String? = nil, emailAddress: String? = nil, isInspected: Bool? = nil, dateAdded: Date? = nil) {
            self.modelContext = modelContext
            self.qrScans = qrScans
            // use nil coalescing for the optional parameters
            self.inspectionOf = inspectionOf ?? ""
            self.emailAddress = emailAddress ?? ""
            self.isInspected = isInspected ?? false
            self.dateAdded = dateAdded ?? Date()
            
            fetchData()
        }
        
        
        
        func addSampleData() {
            let data = QRData(inspectionOf: "Inspection", emailAddress: "emailAddress@test.com", isInspected: true, dateAdded: Date())
            modelContext.insert(data)
        }
        
        
        func fetchData() {
            do {
                let data = FetchDescriptor<QRData>(sortBy: [SortDescriptor(\.dateAdded)])
                qrScans = try modelContext.fetch(data)
            } catch {
                print("ScannedQRCodeDataViewModel.fetchData() failed!: \(error.localizedDescription)")
            }
        }
        

    }
    
    
    
    func handleCodeScan(result: Result<ScanResult, ScanError>) -> Bool {
         switch result {
             
         case .success(let result):
             // get the QR code string content
             let codeDataString = result.string
             print(codeDataString)
             
         case .failure(let error):
             print("Scanning Failed: \(error.localizedDescription)")
         }
         
        return false
     }
    
    
    


