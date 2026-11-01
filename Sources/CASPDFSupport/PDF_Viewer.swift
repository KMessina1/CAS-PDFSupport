/*-------------------------------------------------------------------------------------------------------------------------
     File: PDF_Viewer.swift
   Author: Kevin Messina
  Created: 6/19/22
 Modified: 11/01/2026 03:08 PM EST
  Version: 8
   Source: CODEX: (GPT-5) 🤖AI Code a portion or all of this code.
 
©2026 Creative App Solutions, LLC. - All Rights Reserved.
--------------------------------------------------------------------------------------------------------------------------
NOTES:
-------------------------------------------------------------------------------------------------------------------------*/

import SwiftUI
import CASExternalFoundations
import CASExternalBasics

/// Usage:
///
///     PDFViewer(
///         pdfURL: url,
///         pdfName: name,
///         backgroundView: gradientBackgroundView(),
///         txtColor: CT.lightest
///     )
///
///     Params:
///         pdfURL: URL of the path + filename
///         pdfName: STRING of the filename to be displayed.
///         backgroundView: View displayed behind the PDF.
///         txtColor: Color used for the PDF filename information.
///
public struct PDFViewer<BackgroundView: View>: View {
    @Environment(\.dismiss) private var dismiss

    private let pdfURL: URL
    private let pdfName: String
    private let backgroundView: BackgroundView
    private let txtColor: Color
    private let needsPurchasable: Bool
    private let subscriptionDestination: AnyView?
    @State private var showSubscriptionRequired = false
    @State private var showSubscriptions = false
    private let isRemoteFile: Bool
    private let pdfData: Data?

    @State private var showShareSheet: Bool = false

    // Progress selections
    @State private var showProgress: Bool = false
    @State private var progress: Double = 0.0

    public init(
        pdfURL: URL,
        pdfName: String,
        backgroundView: BackgroundView,
        txtColor: Color,
        isRemoteFile: Bool = false,
        pdfData: Data? = nil,
        needsPurchasable: Bool = false,
        subscriptionDestination: AnyView? = nil
    ) {
        self.pdfURL = pdfURL
        self.pdfName = pdfName
        self.backgroundView = backgroundView
        self.txtColor = txtColor
        self.needsPurchasable = needsPurchasable
        self.subscriptionDestination = subscriptionDestination
        self.isRemoteFile = isRemoteFile
        self.pdfData = pdfData
    }

    private func loadingView() -> some View {
        VStack {
            Spacer()
            ProgressView(value: progress, total: 1.0, label: {
                Text("Loading...")
                    .font(.headline)
                    .foregroundStyle(.yellow)
            })
            .progressViewStyle(.circular)
            .tint(.yellow)
            .scaleEffect(2)
            Spacer()
        }
    }

    @ViewBuilder
    private func fileInfo(txtColor: Color) -> some View {
        if pdfName.count > 15 {
            let dateTxt = pdfName
                .substring(fromTo: 0...8)
                .toConvertedDate(from: .yyyyMMdd, to: .MMM_d_yyyy)
            let timeTxt = pdfName
                .substring(fromTo: 9...15)
                .toConvertedDate(from: .hhmmss, to: .h_m_a)
            
            VStack(alignment: .center) {
                Spacer()
                
                HStack(spacing: 3) {
                    Image(systemName: "calendar")
                        .font(.title)
                    Text("\(dateTxt) @ \(timeTxt)")
                        .font(.headline)
                }
                .foregroundStyle(txtColor)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .glassEffect(.regular.tint(.black.opacity(0.6)))
            }
        } else {
            EmptyView()
        }
    }
    
    // MARK: - BODY
    public var body: some View {
        NavigationStack {
            ZStack {
                backgroundView
                
                PDFDetailView(pdfURL, isRemoteFile: isRemoteFile, pdfData: pdfData)
                    .ignoresSafeArea(edges: .bottom)

                fileInfo(txtColor: txtColor)
                
                loadingView()
                    .opacity(showProgress ? 1 : 0)
            }
            .toolbar {
                TB().title("DOCUMENT VIEWER")
                TB().subtitle(pdfName)

                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        TB().buttonImg(.cancel)
                    }
                    .modifier(TB.buttonColor(color: .clear))
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        guard !needsPurchasable else {
                            showSubscriptionRequired = true
                            return
                        }
                        showShareSheet.toggle()
                    } label: {
                        TB().buttonImg(.share)
                    }
                    .modifier(TB.buttonColor(color: .orange))
                }
            }
            .sheet(isPresented: $showShareSheet, content: {
                ActivityViewController(itemsToShare: [pdfURL])
            })
            .alert("Subscription Required", isPresented: $showSubscriptionRequired) {
                if subscriptionDestination != nil {
                    Button("Subscriptions") { showSubscriptions = true }
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This choice requires a subscription.")
            }
            .navigationDestination(isPresented: $showSubscriptions) {
                if let subscriptionDestination {
                    subscriptionDestination
                }
            }
            .onAppear {
                if isRemoteFile {
                    DispatchQueue.main.async {
                        showProgress = true
                        progress = 0.0
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        showProgress = false
                        progress = 1.0
                    }
                } else {
                    showProgress = false
                    progress = 1.0
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Document Viewer")
    }
}

#Preview {
    PDFViewer(
        pdfURL: URL(fileURLWithPath: "/tmp/20251101@085127_123-inv.pdf"),
        pdfName: "20251101@085127_123-inv.pdf",
        backgroundView: Color.black,
        txtColor: Color.white
    )
}
