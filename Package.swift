// swift-tools-version: 6.2
/*-------------------------------------------------------------------------------------------------------------------------
     File: Package.swift
   Author: Kevin Messina
  Created: 8/21/26
 Modified: 08/21/2026 06:10 PM EDT
  Version: 1
   Source: CODEX: (GPT-5) 🤖AI Code a portion or all of this code.
 
©2026 Creative App Solutions, LLC. - All Rights Reserved.
--------------------------------------------------------------------------------------------------------------------------
NOTES:
-------------------------------------------------------------------------------------------------------------------------*/

import PackageDescription

let package = Package(
    name: "CAS-PDFSupport",
    platforms: [
        .iOS(.v26),
        .macCatalyst(.v26)
    ],
    products: [
        .library(
            name: "CASPDFSupport",
            targets: ["CASPDFSupport"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/KMessina1/CAS-External-Foundations.git",
            from: "1.1.5"
        ),
        .package(
            url: "https://github.com/KMessina1/CAS-External-Basics.git",
            from: "1.1.2"
        ),
        .package(
            url: "https://github.com/techprimate/TPPDF.git",
            from: "2.6.1"
        )
    ],
    targets: [
        .target(
            name: "CASPDFSupport",
            dependencies: [
                .product(
                    name: "CASExternalFoundations",
                    package: "CAS-External-Foundations"
                ),
                .product(
                    name: "CASExternalBasics",
                    package: "CAS-External-Basics"
                ),
                .product(
                    name: "TPPDF",
                    package: "TPPDF"
                )
            ]
        ),
        .testTarget(
            name: "CASPDFSupportTests",
            dependencies: ["CASPDFSupport"]
        )
    ],
    swiftLanguageModes: [.v5]
)
