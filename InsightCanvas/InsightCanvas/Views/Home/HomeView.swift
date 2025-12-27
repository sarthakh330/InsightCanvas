//
//  HomeView.swift
//  InsightCanvas
//
//  Created on December 26, 2024.
//

import SwiftUI
import UniformTypeIdentifiers

struct HomeView: View {
    var onDocumentSelected: ((URL) -> Void)?

    @State private var isDropTargeted = false
    @State private var showingFilePicker = false
    @State private var youtubeURL = ""

    var body: some View {
        ZStack {
            // Background - Warm beige
            Color(red: 0.992, green: 0.988, blue: 0.976)
                .ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                // App Icon (placeholder)
                Image(systemName: "doc.text.magnifyingglass")
                    .font(.system(size: 64))
                    .foregroundColor(Color(red: 0.184, green: 0.561, blue: 0.420))

                // Title
                Text("Insight Canvas")
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundColor(Color(red: 0.067, green: 0.075, blue: 0.090))

                // Subtitle
                Text("Drop a document to understand it")
                    .font(.system(size: 17))
                    .foregroundColor(Color(red: 0.361, green: 0.380, blue: 0.408))

                // Drop Zone
                VStack(spacing: 32) {
                    // File Drop Area
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(
                                        style: StrokeStyle(lineWidth: 2, dash: [8, 4])
                                    )
                                    .foregroundColor(isDropTargeted ?
                                        Color(red: 0.184, green: 0.561, blue: 0.420) :
                                        Color(red: 0.886, green: 0.875, blue: 0.839))
                            )
                            .frame(width: 480, height: 220)

                        VStack(spacing: 20) {
                            Image(systemName: "arrow.down.doc")
                                .font(.system(size: 48))
                                .foregroundColor(Color(red: 0.561, green: 0.537, blue: 0.494))

                            Text("Drop files here")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(Color(red: 0.067, green: 0.075, blue: 0.090))

                            Text("or")
                                .font(.system(size: 14))
                                .foregroundColor(Color(red: 0.561, green: 0.537, blue: 0.494))

                            Button(action: {
                                showingFilePicker = true
                            }) {
                                Text("Import document...")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(Color(red: 0.184, green: 0.561, blue: 0.420))
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(Color(red: 0.898, green: 0.949, blue: 0.925))
                                    )
                            }
                            .buttonStyle(.plain)

                            Text(".txt · .md · .html · .docx")
                                .font(.system(size: 12))
                                .foregroundColor(Color(red: 0.561, green: 0.537, blue: 0.494))
                        }
                        .padding(44)
                    }
                    .onDrop(of: [.fileURL], isTargeted: $isDropTargeted) { providers in
                        handleFileDrop(providers: providers)
                        return true
                    }

                    // YouTube Input - More Prominent
                    VStack(spacing: 8) {
                        Text("Or analyze from the web")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(Color(red: 0.067, green: 0.075, blue: 0.090))

                        HStack(spacing: 12) {
                            Image(systemName: "link.circle.fill")
                                .font(.system(size: 20))
                                .foregroundColor(Color(red: 0.184, green: 0.561, blue: 0.420))

                            TextField("Paste YouTube URL and press Enter", text: $youtubeURL)
                                .textFieldStyle(.plain)
                                .font(.system(size: 15))
                                .foregroundColor(Color(red: 0.067, green: 0.075, blue: 0.090))
                                .onSubmit {
                                    handleYouTubeURL()
                                }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(Color(red: 0.184, green: 0.561, blue: 0.420).opacity(0.3), lineWidth: 1.5)
                        )
                    }
                    .frame(width: 480)
                }

                Spacer()

                // Footer
                Text("No accounts. Your content stays on your Mac.")
                    .font(.system(size: 13))
                    .foregroundColor(Color(red: 0.561, green: 0.537, blue: 0.494))

                Spacer()
                    .frame(height: 40)
            }
        }
        .fileImporter(
            isPresented: $showingFilePicker,
            allowedContentTypes: [.plainText, .text, .html, .data],
            allowsMultipleSelection: false
        ) { result in
            handleFileSelection(result: result)
        }
    }

    private func handleFileDrop(providers: [NSItemProvider]) {
        guard let provider = providers.first else { return }

        provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { item, error in
            guard let data = item as? Data,
                  let url = URL(dataRepresentation: data, relativeTo: nil) else {
                return
            }

            DispatchQueue.main.async {
                processDocument(url: url)
            }
        }
    }

    private func handleFileSelection(result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            if let url = urls.first {
                processDocument(url: url)
            }
        case .failure(let error):
            print("Error selecting file: \(error.localizedDescription)")
        }
    }

    private func handleYouTubeURL() {
        guard !youtubeURL.isEmpty else { return }
        print("Processing YouTube URL: \(youtubeURL)")
        // TODO: Implement YouTube transcript extraction
    }

    private func processDocument(url: URL) {
        onDocumentSelected?(url)
    }
}

#Preview {
    HomeView()
}
