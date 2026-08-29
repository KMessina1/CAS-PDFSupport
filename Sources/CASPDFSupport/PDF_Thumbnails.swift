/*-------------------------------------------------------------------------------------------------------------------------
     File: PDF_Thumbnails.swift
   Author: Kevin Messina
  Created: 4/16/25
 Modified: 08/21/2026 06:13 PM EDT
  Version: 4
   Source: CODEX: (GPT-5) 🤖AI Code a portion or all of this code.
 
©2026 Creative App Solutions, LLC. - All Rights Reserved.
--------------------------------------------------------------------------------------------------------------------------
NOTES:
-------------------------------------------------------------------------------------------------------------------------*/

import SwiftUI
import PDFKit
import CASExternalFoundations

public func PDF_GenerateUIImage(
    filename: String,
    in inDir: Files.directories,
    size thumbnailSize: CGSize = CGSize(width: 80, height: 100),
    atPage pageIndex: Int = 0
) -> UIImage {
    let noImageFile = UIImage(systemName: "photo.badge.exclamationmark") ?? UIImage()
    let documentURL: URL = Files().getPathForFilename(filename, in: inDir).url
    let pdfDocument = PDFDocument(url: documentURL)
    let pdfDocumentPage = pdfDocument?.page(at: pageIndex)

    return pdfDocumentPage?.thumbnail(of: thumbnailSize, for: PDFDisplayBox.trimBox) ?? noImageFile
}

public func PDF_GenerateUIImageFromURL(_ fileURL: URL) -> UIImage? {
    let fileManager = FileManager.default
    let fileName = fileURL.lastPathComponent
    let documentsDirectory = Files().getPathURL(in: .docsDir)
    let newPDFURL = documentsDirectory.appendingPathComponent(fileName)

    guard fileURL.startAccessingSecurityScopedResource() else {
        return nil
    }

    defer {
        fileURL.stopAccessingSecurityScopedResource()
    }

    do {
        try fileManager.copyItem(at: fileURL, to: newPDFURL)
        let tempImage = PDF_GenerateUIImage(filename: fileName, in: .docsDir)
        try fileManager.removeItem(at: newPDFURL)
        return tempImage
    } catch {
        return nil
    }
}

public func PDF_GenerateUIImageWithResults(
    filename: String,
    fileURL: URL,
    size thumbnailSize: CGSize = CGSize(width: 80, height: 100),
    atPage pageIndex: Int = 0
) -> (uiImage: UIImage, success: Bool) {
    let noImageFile = UIImage(systemName: "photo.badge.exclamationmark") ?? UIImage()
    let pdfDocument = PDFDocument(url: fileURL)
    let pdfDocumentPage = pdfDocument?.page(at: pageIndex)
    let pdfImage = pdfDocumentPage?.thumbnail(of: thumbnailSize, for: PDFDisplayBox.trimBox)
    let isSuccess = pdfImage != nil
    let finalImage = isSuccess ? pdfImage! : noImageFile

    return (finalImage, isSuccess)
}
