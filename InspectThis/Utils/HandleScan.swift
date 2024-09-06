//
//  HandleScan.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-05.
//
import CodeScanner
import Foundation

func handleScan(result: Result<ScanResult, ScanError>) {
     // dismiss the sheet
     //isShowingScanner = false
     
     // work with the scan result
     switch result {
     case .success(let result):
         // get the qr code string content and split the result using /n
         let details = result.string.components(separatedBy: "/n")
         // ensure we have 2 pieces of info from the QR code string
         guard details.count == 2 else { return }
         // store the QR data
         let qrData = [details[0], details[1]]
         print(qrData)
         
     case .failure(let error):
         print("Scanning Failed: \(error.localizedDescription)")
     }
     
 }

