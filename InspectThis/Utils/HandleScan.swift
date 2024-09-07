//
//  HandleScan.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-05.
//
import CodeScanner
import Foundation



func handleCodeScan(result: Result<ScanResult, ScanError>)  {
    switch result {
    case .success(let result):
        // get the QR code string content
        let codeDataString = result.string
        print(codeDataString)
        
    case .failure(let error):
        print("Scanning Failed: \(error.localizedDescription)")
    }
    

}


