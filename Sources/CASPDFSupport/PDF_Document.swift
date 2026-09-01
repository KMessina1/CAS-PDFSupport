/*-------------------------------------------------------------------------------------------------------------------------
     File: PDF_Document.swift
   Author: Kevin Messina
  Created: 4/26/25
 Modified: 09/01/2026 10:42 PM EDT
  Version: 4
   Source: CODEX: (GPT-5) 🤖AI Code a portion or all of this code.

©2026 Creative App Solutions, LLC. - All Rights Reserved.
--------------------------------------------------------------------------------------------------------------------------
NOTES:
-------------------------------------------------------------------------------------------------------------------------*/

import TPPDF
import SwiftUI
import CASExternalFoundations

public extension PDFVals {
    // MARK: - *** ENUMS ***
    enum NotesImagesTypes { case notes, status }
    enum orientationType: Int { case landscape,portrait,square }
    
    // MARK: - *** DOCUMENT FUNCTIONS ***
    func generatePDF(doc: PDFDocument, filename: String) {
        generatePDF(doc: doc, filename: filename, in: .reportsDir)
    }

    /// Generates a PDF in the requested app-support directory.
    /// The existing overload remains reports-backed for compatibility.
    func generatePDF(doc: PDFDocument, filename: String, in directory: Files.directories) {
        let url = Files().returnPathForFilename(filename, in: directory).url
        let generator = PDFGenerator(document: doc)
        
        do {
            try generator.generate(to: url)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func docSetup(rptTitle: String, subject: String, bodySize: bodySizes = .body_12) -> PDFDocument {
        let doc = PDFDocument(layout: PDFVals.layout().USLetter_HalfInchBorder)
        doc.info.author = AppInfo.appName
        doc.info.subject = subject
        doc.info.title = rptTitle
        doc.set(font: UIFont.systemFont(ofSize: bodySize.rawValue))
        doc.set(textColor: UIColor.black)
        doc.pagination.style = .customClosure({ page, total in
            return "Page \(page) of \(total)"
        })
        doc.pagination.container = .footerRight
        
        return doc
    }

    // MARK: - *** LAYOUT SETTINGS ***
    struct pageSize {
        public static let USLetter: CGSize = CGSize(width: 612, height: 792)
        public static let USLegal: CGSize = CGSize(width: 612, height: 1008)
    }
    
    struct marginEdgeInset {
        public static let halfInch: UIEdgeInsets = UIEdgeInsets(top: 36, left: 36, bottom: 36, right: 36)
    }
    
    struct lineStyle {
        public static let solid: PDFLineStyle = PDFLineStyle(type: .full, color: .darkGray, width: 0.5)
        public static let bold: PDFLineStyle = PDFLineStyle(type: .full, color: .black, width: 1.0)
    }
    
    struct layout {
        public var USLetter_HalfInchBorder: PDFPageLayout {
            var layout = PDFPageLayout()
            layout.margin = PDFVals.marginEdgeInset.halfInch
            layout.size = PDFVals.pageSize.USLetter
            
            return layout
        }

        public init() {}
    }

    // MARK: - *** REPORT FUNCTIONS ***
    func dividerLine(thickness: CGFloat, style: PDFLineType, doc: PDFDocument) {
        doc.add(.contentCenter, space: 10)
        doc.addLineSeparator(PDFContainer.contentLeft, style: PDFLineStyle(type: style, color: .black, width: thickness))
        doc.add(.contentCenter, space: 15)
    }

    func reportDetailTitle(title: String, doc: PDFDocument, underline: Bool = false) {
        doc.add(.contentCenter, space: 5)
        if underline {
            doc.add(attributedText: PDFVals().attribTitleUnderline("\(title)"))
        }else{
            doc.add(textObject: PDFSimpleText(text: "\(title)", style: PDFVals.textStyle.title))
        }
        
        doc.add(.contentCenter, space: 2)
    }

    func reportDetailSubTitle(title: String, doc: PDFDocument) {
        doc.add(.contentCenter, space: 5)
        doc.add(.contentLeft, attributedText: PDFVals().attribSubTitle("\(title)"))
        doc.add(.contentCenter, space: 2)
    }

    func dividerTitleWithLines(title: String, thickness: CGFloat, style: PDFLineType, doc: PDFDocument) {
        doc.add(.contentCenter, space: 10)
        doc.addLineSeparator(PDFContainer.contentLeft, style: PDFLineStyle(type: style, color: .black, width: thickness))
        doc.add(.contentCenter, space: 2.5)
        doc.add(textObject: PDFVals().reportListItemTitle(title))
        doc.addLineSeparator(PDFContainer.contentLeft, style: PDFLineStyle(type: style, color: .black, width: thickness))
        doc.add(.contentCenter, space: 15)
    }

    func dividerLineIfNotLast(count: Int, maxCount: Int, style: PDFLineType = .full, doc: PDFDocument) {
        if count < (maxCount - 1) {
            doc.add(.contentCenter, space: 10)
            doc.addLineSeparator(PDFContainer.contentLeft, style: PDFLineStyle(type: style, color: .black, width: 1.0))
            doc.add(.contentCenter, space: 5)
        }
    }

    func reportTitle(_ rptTitle: String, dbID: String = "") -> PDFSection {
        let section = PDFSection(columnWidths: [0.08, 0.92])
        section.columns[0].add(.left, image: PDFVals().appImg)
        section.columns[1].add(.left, attributedText: PDFVals().title(rptTitle: rptTitle, dbID: dbID))
        
        return section
    }
    
    func reportListItemTitle(_ title: String, style: PDFTextStyle = PDFVals.textStyle.header2) -> PDFSimpleText {
        let title = PDFSimpleText(text: title, style: style)
        
        return title
    }
}
