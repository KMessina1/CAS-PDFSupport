/*-------------------------------------------------------------------------------------------------------------------------
     File: PDF_ReportFunctions.swift
   Author: Kevin Messina
  Created: 4/26/25
 Modified: 08/21/2026 06:12 PM EDT
  Version: 2
   Source: CODEX: (GPT-5) 🤖AI Code a portion or all of this code.

©2026 Creative App Solutions, LLC. - All Rights Reserved.
--------------------------------------------------------------------------------------------------------------------------
NOTES:
-------------------------------------------------------------------------------------------------------------------------*/

import TPPDF
import SwiftUI
import CASExternalFoundations

public extension PDFVals {
    func itemsOnPage(counter: Int, page: Int, doc: PDFDocument, title: String) -> (items: Int, page: Int) {
        var counter_Item = counter
        var counter_Page = page

        counter_Item += 1
        if counter_Item > 3 {
            counter_Page += 1
            counter_Item = 1
            doc.createNewPage()
            
            //Report Title
            doc.add(section: PDFVals().reportTitle(title))
            doc.add(.contentCenter, space: 20)
        }
        
        return (items: counter_Item, page: counter_Page)
    }
    
    func attribTxt(_ txt: String, attribs: [NSAttributedString.Key : Any] = PDFVals.attribs.body)
    -> NSMutableAttributedString
    {
        NSMutableAttributedString(string: txt,attributes: attribs)
    }

    func attribTitleUnderline(_ txt: String) -> NSMutableAttributedString {
        let attributedText: NSMutableAttributedString = NSMutableAttributedString(
            string: txt,
            attributes: PDFVals.attribs.subTitle_noUnderline
        )
        let rangeToUnderline: NSRange = (txt as NSString).range(of: txt)

        attributedText.addAttribute(NSAttributedString.Key.underlineStyle,value: NSUnderlineStyle.single.rawValue,range: rangeToUnderline)
        
        return attributedText
    }

    func attribSubTitle(_ txt: String) -> NSMutableAttributedString {
        let fullStringText: String = " └ \(txt)"
        let attributedText: NSMutableAttributedString = NSMutableAttributedString(
            string: fullStringText,
            attributes: PDFVals.attribs.subTitle_noUnderline
        )
        let rangeToUnderline: NSRange = (fullStringText as NSString).range(of: txt)

        attributedText.addAttribute(NSAttributedString.Key.underlineStyle,value: NSUnderlineStyle.single.rawValue,range: rangeToUnderline)
        
        return attributedText
    }
    
    func attribDetailTxt(_ txt: String, attribs: [NSAttributedString.Key : Any] = PDFVals.attribs.header2)
    -> NSMutableAttributedString {
        NSMutableAttributedString(string: txt,attributes: attribs)
    }

    func attribNotesTxt(
        _ txt: String,
        maxLength: Int = 89,
        attribs: [NSAttributedString.Key : Any] = PDFVals.attribs.notes
    ) -> NSMutableAttributedString {
        var newString = txt
        
        if newString.count > 89 {
            newString = newString.substringFromStart(maxLength)
            newString += "..."
        }
        
        return NSMutableAttributedString(string: newString,attributes: attribs)
    }

    func attribSmallTxt(
        _ txt: String,
        maxLength: Int = 100,
        attribs: [NSAttributedString.Key : Any] = PDFVals.attribs.smallText
    ) -> NSMutableAttributedString {
        var newString = txt
        
        if newString.count > 100 {
            newString = newString.substringFromStart(maxLength)
            newString += "..."
        }
        
        return NSMutableAttributedString(string: newString,attributes: attribs)
    }

    func title(rptTitle: String, dbID: String = "", attribs: [NSAttributedString.Key : Any] = PDFVals.attribs.header1)
    -> NSMutableAttributedString {
        let titleString = NSMutableAttributedString(string: rptTitle.uppercased(),attributes: attribs)
        titleString.append(NSMutableAttributedString(string: dbID,attributes: PDFVals.attribs.header1_dbID))
        
        return titleString
    }
    
    func imgCaption(_ txt: String, attribs: [NSAttributedString.Key : Any] = PDFVals.attribs.caption) -> PDFAttributedText {
        PDFAttributedText(text: NSAttributedString(string: txt, attributes: attribs))
    }
    
    func reportBodySection(_ vals: bodyValues, bodySize: bodySizes) -> PDFSection {
        let remainder = 1.0 - indent - image - title - field - title
        let sectionColumns = [indent, image, title, field, title, remainder]
        let bodySection = PDFSection(columnWidths: sectionColumns)
        let attribs: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: bodySize.rawValue,weight: .regular)
        ]

        //Col1
        bodySection.columns[2].add(.right, attributedText: PDFVals().attribTxt(vals.title1, attribs: attribs))
        bodySection.columns[3].add(.left, text: vals.val1)
        //Col2
        bodySection.columns[4].add(.right, attributedText: PDFVals().attribTxt(vals.title2, attribs: attribs))
        bodySection.columns[5].add(.left, text: vals.val2)
        
        return bodySection
    }

    func reportIndentedBodySection(_ vals: indentBodyValues, bodySize: bodySizes) -> PDFSection {
        let remainder = 1.0 - indent - title
        let sectionColumns = [indent, title, remainder]
        let bodySection = PDFSection(columnWidths: sectionColumns)
        let attribs: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: bodySize.rawValue,weight: .regular)
        ]
        
        //Col1
        bodySection.columns[1].add(.right, attributedText: PDFVals().attribTxt(vals.title1, attribs: attribs))
        bodySection.columns[2].add(.left, text: vals.val1)
        
        return bodySection
    }

    func reportDetailTitleSection(txt: String) -> PDFSection {
        let remainder = 1.0 - indent
        let sectionColumns = [indent, remainder]
        let bodyDetailTitleSection = PDFSection(columnWidths: sectionColumns)
        bodyDetailTitleSection.columns[1].add(.left, attributedText: PDFVals().attribDetailTxt(txt))
        
        return bodyDetailTitleSection
    }

    func reportDetailSubTitleSection(txt: String) -> PDFSection {
        let remainder = 1.0 - indent
        let sectionColumns = [indent, remainder]
        let bodyDetailTitleSection = PDFSection(columnWidths: sectionColumns)
        bodyDetailTitleSection.columns[1].add(.left, attributedText: PDFVals().attribDetailTxt(txt,attribs: PDFVals.attribs.subTitle))
        
        return bodyDetailTitleSection
    }

    enum underlineArea { case prefix, suffix }
    
    func reportDetailHeaderSection(prefix: String, suffix: String, underline: underlineArea) -> PDFSection {
        let remainder = 1.0 - indent
        let sectionColumns = [indent, remainder]
        let bodyDetailTitleSection = PDFSection(columnWidths: sectionColumns)
        let line = PDFVals.attribs.subTitle
        let noLine = PDFVals.attribs.subTitle_noUnderline
        
        let finalTxt = PDFVals().attribDetailTxt(prefix, attribs: underline == .prefix ? line :noLine)
        finalTxt.append(PDFVals().attribDetailTxt(" ", attribs: noLine))
        finalTxt.append(PDFVals().attribDetailTxt(suffix, attribs: underline == .suffix ? line :noLine))
        
        bodyDetailTitleSection.columns[1].add(.left, attributedText: finalTxt)
        
        return bodyDetailTitleSection
    }

    func reportDetailTextSection(txt: String) -> PDFSection {
        let sectionColumns:[CGFloat] = [0.05, 0.95]
        let bodyDetailTextSection = PDFSection(columnWidths: sectionColumns)
        bodyDetailTextSection.columns[1].add(.left, attributedText: PDFVals().attribTxt(txt))
        
        return bodyDetailTextSection
    }

    func reportImgDetailSection(txt: String, val: String) -> PDFSection {
        let leftMargin: CGFloat = 0.3
        let remainder = 1.0 - indent - leftMargin
        let sectionColumns = [indent, leftMargin, remainder]
        let bodyDetailSection = PDFSection(columnWidths: sectionColumns)
        
        bodyDetailSection.columns[1].add(.right, attributedText: PDFVals().attribTxt(txt))
        bodyDetailSection.columns[2].add(.left, attributedText: PDFVals().attribTxt(val.dashesIfEmpty))
        
        return bodyDetailSection
    }

    func reportDetailSection(txt: String, val: String, leftMargin: CGFloat = 0.2) -> PDFSection {
        let remainder = 1.0 - indent - leftMargin
        let sectionColumns = [indent, leftMargin, remainder]
        let bodyDetailSection = PDFSection(columnWidths: sectionColumns)
        
        bodyDetailSection.columns[1].add(.right, attributedText: PDFVals().attribTxt(txt))
        bodyDetailSection.columns[2].add(.left, text: val.isEmpty ?dashesTxt :val)
        
        return bodyDetailSection
    }
    
    struct SubSection {
        public let title: String
        public let bullet: String
        public let subTitle: String
        public let text: String

        public init(title: String, bullet: String, subTitle: String, text: String) {
            self.title = title
            self.bullet = bullet
            self.subTitle = subTitle
            self.text = text
        }
    }

    func reportDetailSubSection(
        title: String,
        subTitle: String,
        subTitleWidth: CGFloat = 0.15,
        text: String,
        leftMargin: CGFloat = 0.2
    ) -> PDFSection {
        let remainder = 1.0 - indent - leftMargin - subTitleWidth
        let sectionColumns = [indent, leftMargin, subTitleWidth, remainder]
        let subSection = PDFSection(columnWidths: sectionColumns)
        
        subSection.columns[1].add(.right, attributedText: PDFVals().attribTxt(title))
        subSection.columns[2].add(.right, attributedText: PDFVals().attribSmallTxt(subTitle.isEmpty ?dashesTxt :subTitle))
        subSection.columns[3].add(.left, attributedText: PDFVals().attribSmallTxt(text.isEmpty ?dashesTxt :text))

        return subSection
    }
    
    func reportNotes(_ notes: String, img: NotesImagesTypes = .notes) -> PDFSection {
        let iconImg = (img == .notes) ?PDFVals.notesImg :PDFVals.statusNotesImg
        let remainder_Notes = 1.0 - indent - icon
        let notesColumns = [indent,icon,remainder_Notes]
        let noteSection = PDFSection(columnWidths: notesColumns)
        noteSection.columns[1].add(.right, image: iconImg)
        noteSection.columns[2].add(.left, attributedText: PDFVals().attribNotesTxt(notes.isEmpty ?dashesTxt :notes))
        
        return noteSection
    }
    
    func imgFromResource(_ name: String, imgSize: CGSize =  inlineImgSize) -> PDFImage {
        let img = PDFImage(
            image: UIImage(named: name) ?? UIImage(named: "NoPhotoText")!,
            size: imgSize,
            sizeFit: PDFImageSizeFit.widthHeight
        )

        return img
    }

    func imgFromFile(_ fileName: String, in dir: Files.directories)
    -> (img: PDFImage, uImg: UIImage,  orientation: orientationType, size: CGSize, sizeFit: PDFImageSizeFit)
    {
        let filePath = Files().getPathForFilename(fileName, in: dir).path
        let imgFile: UIImage = UIImage(contentsOfFile: filePath) ?? UIImage(named: "NoPhotoText")!
        let imgFileSize: CGSize = imgFile.size
        var imgSize: CGSize = thumbnailSize_Square
        var sizeFit: PDFImageSizeFit = PDFImageSizeFit.widthHeight
        var orientation:orientationType = .landscape
        
        if imgFileSize.width > imgFileSize.height {
            imgSize = thumbnailSize_Landscape
            sizeFit = .width
            orientation = .landscape
        } else if imgFileSize.width < imgFileSize.height {
            imgSize = thumbnailSize_Portrait
            sizeFit = .height
            orientation = .portrait
        } else {
            imgSize = thumbnailSize_Square
            sizeFit = .widthHeight
            orientation = .square
        }
        
        let img = PDFImage(image: imgFile,size: imgSize,sizeFit: sizeFit)
        
        return (img: img, uImg: imgFile, orientation: orientation, size: imgSize, sizeFit: sizeFit)
    }
}

