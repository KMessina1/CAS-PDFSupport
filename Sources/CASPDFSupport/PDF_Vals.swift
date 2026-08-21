/*-------------------------------------------------------------------------------------------------------------------------
     File: PDF_Vals.swift
   Author: Kevin Messina
  Created: 4/26/25
 Modified: 08/21/2026 06:11 PM EDT
  Version: 2
   Source: CODEX: (GPT-5) 🤖AI Code a portion or all of this code.

©2026 Creative App Solutions, LLC. - All Rights Reserved.
--------------------------------------------------------------------------------------------------------------------------
NOTES:
-------------------------------------------------------------------------------------------------------------------------*/

import Foundation
import UIKit
import TPPDF
import SwiftUI
import CASExternalFoundations
import CASExternalBasics

public struct PDFVals {
    // 72 DPI * size in inches
    public let createdBy = "Created by \( AppInfo().returnCompanyInfo().name )'s \( AppInfo.appName )"
    public let appImg = PDFImage(
        image: UIImage(named: AppInfo.logo) ?? UIImage(named: "NoPhotoText")!,
        size: PDFVals.inlineLogoSize,
        sizeFit: PDFImageSizeFit.widthHeight
    )
    
    // Sizes
    public static let inlineImgSize = CGSize(width: 12, height: 12)
    public static let inlineLogoSize = CGSize(width: 35, height: 35)
    public let thumbnailSize_Square = CGSize(width: 60, height: 60)
    public let thumbnailSize_Landscape = CGSize(width: 90, height: 60)
    public let thumbnailSize_Portrait = CGSize(width: 60, height: 90)
    public let indent: CGFloat = 0.01
    public let lgIndent: CGFloat = 0.05
    public let image: CGFloat = 0.15
    public let icon: CGFloat = 0.03
    public let title: CGFloat = 0.15
    public let lgTitle: CGFloat = 0.2
    public let field: CGFloat = 0.30
    //Font Sizes
    public enum bodySizes: CGFloat {
        case body_10 = 10.0
        case body_12 = 12.0
    }

    // Images
    public static let urlImg = PDFImage(image: UIImage(systemName: "globe")!, size: inlineImgSize)
    public static let emailImg = PDFImage(image: UIImage(systemName: "envelope")!, size: inlineImgSize)
    public static let phoneImg = PDFImage(image: UIImage(systemName: "phone.fill")!, size: inlineImgSize)
    public static let notesImg = PDFImage(image: UIImage(systemName: "note.text")!, size: inlineImgSize)
    public static let statusNotesImg = PDFImage(image: UIImage(systemName: "questionmark.app.dashed")!, size: inlineImgSize)
    
    public struct bodyValues {
        public let title1: String
        public let val1: String
        public let title2: String
        public let val2: String

        public init(title1: String, val1: String, title2: String, val2: String) {
            self.title1 = title1
            self.val1 = val1
            self.title2 = title2
            self.val2 = val2
        }
    }

    public struct indentBodyValues {
        public let title1: String
        public let val1: String

        public init(title1: String, val1: String) {
            self.title1 = title1
            self.val1 = val1
        }
    }
    
    public struct textStyle {
        public static let header1 = PDFTextStyle(name: "Header1", font: UIFont.systemFont(ofSize: 28.0, weight: .heavy), color: .black)
        public static let header2 = PDFTextStyle(name: "Header2", font: UIFont.systemFont(ofSize: 16.0, weight: .bold), color: .black)
        public static let header3 = PDFTextStyle(name: "header3", font: UIFont.systemFont(ofSize: 14.0, weight: .bold), color: .black)
        public static let title = PDFTextStyle(name: "title", font: UIFont.systemFont(ofSize: 13.0, weight: .semibold), color: .black)
        public static let body = PDFTextStyle(name: "body", font: UIFont.systemFont(ofSize: 12.0, weight: .regular), color: .black)
        public static let body2 = PDFTextStyle(name: "body2", font: UIFont.systemFont(ofSize: 10.0, weight: .regular), color: .black)
        public static let footer = PDFTextStyle(name: "footer", font: UIFont.systemFont(ofSize: 10.0, weight: .regular), color: .black)
    }
    
    public struct attribs {
        public static let header1: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 28.0, weight: .heavy),
            .foregroundColor: UIColor.black,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]

        public static let header1_dbID: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 28.0, weight: .heavy),
            .foregroundColor: UIColor.black
        ]

        public static let header2: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 14.0, weight: .semibold),
            .foregroundColor: UIColor.black,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        public static let subTitle_noUnderline: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 13.0, weight: .semibold),
            .foregroundColor: UIColor.black
        ]

        public static let subTitle: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 13.0, weight: .semibold),
            .foregroundColor: UIColor.black,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        public static let body: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 12.0, weight: .regular),
            .foregroundColor: UIColor.black
        ]
        
        public static let body2: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 10.0, weight: .regular),
            .foregroundColor: UIColor.black
        ]

        public static let caption: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 9.0, weight: .medium),
            .foregroundColor: UIColor.black
        ]

        public static let notes: [NSAttributedString.Key : Any] = [
            .font: UIFont(name: FontName.CourierNew.regular.rawValue, size: 9.0)!,
            .foregroundColor: UIColor.black
        ]

        public static let smallText: [NSAttributedString.Key : Any] = [
            .font: UIFont(
                descriptor: UIFont.systemFont(ofSize: 9.0).fontDescriptor.addingAttributes([
                    .traits: [
                        UIFontDescriptor.TraitKey.weight: UIFont.Weight.regular,
                        UIFontDescriptor.TraitKey.width: UIFont.Width.standard
                    ]
                ]),
                size: 9.0
            ),
            .foregroundColor: UIColor.black
        ]
    }

    public init() {}
}
