/*-------------------------------------------------------------------------------------------------------------------------
     File: PDF_DetailViewer.swift
   Author: Kevin Messina
  Created: 6/19/22
 Modified: 08/21/2026 06:13 PM EDT
  Version: 4
   Source: CODEX: (GPT-5) 🤖AI Code a portion or all of this code.
 
©2026 Creative App Solutions, LLC. - All Rights Reserved.
--------------------------------------------------------------------------------------------------------------------------
NOTES:
-------------------------------------------------------------------------------------------------------------------------*/

import SwiftUI
import PDFKit

public struct PDFDetailView: UIViewRepresentable {
    public let url: URL
    public let isRemoteFile: Bool
    public let pdfData: Data?

    private let pdfView = PDFView()

    public init(_ url: URL, isRemoteFile: Bool, pdfData: Data?) {
        self.url = url
        self.isRemoteFile = isRemoteFile
        self.pdfData = pdfData
    }

    public func makeUIView(context: Context) -> PDFView {
        if isRemoteFile {
            guard url.startAccessingSecurityScopedResource() else {
                return PDFView()
            }
            defer { url.stopAccessingSecurityScopedResource() }
            pdfView.document = PDFDocument(url: url)
        } else if let pdfData {
            pdfView.document = PDFDocument(data: pdfData)
        } else {
            pdfView.document = PDFDocument(url: url)
        }

        pdfView.backgroundColor = .clear
        pdfView.displayDirection = .vertical
        pdfView.displaysPageBreaks = true
        pdfView.autoScales = true

        return pdfView
    }

    public func updateUIView(_ uiView: PDFView, context: Context) {
    }
}
