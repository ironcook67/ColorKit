//
//  ContentView.swift
//  ColorKitCodableDemo
//
//  Created by Chon Torres on 6/3/25.
//

import SwiftUI
import ColorKit
import UniformTypeIdentifiers

struct ContentView: View {
    @StateObject private var paletteManager = PaletteManager()
    @State private var showingFilePicker = false
    @State private var showingExportPicker = false
    @State private var alertMessage = ""
    @State private var showingAlert = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                VStack {
                    Text("ColorKit Demo")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Swift Package Color Management")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top)

                // Action Buttons
                VStack(spacing: 12) {
                    Button("Create Sample Colors") {
                        paletteManager.createSampleColors()
                    }
                    .buttonStyle(.borderedProminent)

                    HStack {
                        Button("Import JSON") {
                            showingFilePicker = true
                        }
                        .buttonStyle(.bordered)

                        Button("Export JSON") {
                            showingExportPicker = true
                        }
                        .buttonStyle(.bordered)
                        .disabled(paletteManager.colors.isEmpty)
                    }

                    Button("Clear Palette") {
                        paletteManager.clearColors()
                    }
                    .buttonStyle(.bordered)
                    .foregroundColor(.red)
                    .disabled(paletteManager.colors.isEmpty)
                }
                .padding(.horizontal)

                // Color Palette Display
                if paletteManager.colors.isEmpty {
                    Spacer()
                    VStack {
                        Image(systemName: "paintpalette")
                            .font(.system(size: 50))
                            .foregroundColor(.secondary)
                        Text("No colors in palette")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text("Create sample colors or import a JSON file to get started")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    Spacer()
                } else {
                    ColorPaletteView(colors: paletteManager.colors)
                }

                Spacer()
            }
            #if os(iOS)
            .navigationBarHidden(true)
            #endif // os(iOS)
            .fileImporter(
                isPresented: $showingFilePicker,
                allowedContentTypes: [.json],
                allowsMultipleSelection: false
            ) { result in
                paletteManager.handleFileImport(result: result) { message in
                    alertMessage = message
                    showingAlert = true
                }
            }
            .fileExporter(
                isPresented: $showingExportPicker,
                document: JSONDocument(data: paletteManager.exportColorsAsJSON()),
                contentType: .json,
                defaultFilename: "ColorPalette"
            ) { result in
                switch result {
                case .success(let url):
                    alertMessage = "Colors exported successfully to \(url.lastPathComponent)"
                case .failure(let error):
                    alertMessage = "Export failed: \(error.localizedDescription)"
                }
                showingAlert = true
            }
            .alert("ColorKit Demo", isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
        }
        #if os(macOS)
            .frame(minWidth: 800, maxWidth: .infinity, minHeight: 400, maxHeight: .infinity)
        #endif // os(macOS)
    }
}

/// Displays a grid of colors in the palette
struct ColorPaletteView: View {
    let colors: [NamedColor]

    private let columns = [
        GridItem(.adaptive(minimum: 120, maximum: 200), spacing: 16)
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(colors, id: \.self) { namedColor in
                    ColorCardView(namedColor: namedColor)
                }
            }
            .padding()
        }
        #if os(iOS)
        .background(Color(.systemGroupedBackground))
        #endif // os(iOS)
    }
}

/// Individual color card showing color, name, and hex value
struct ColorCardView: View {
    let namedColor: NamedColor

    var body: some View {
        VStack(spacing: 8) {
            // Color swatch
            RoundedRectangle(cornerRadius: 12)
                .fill(namedColor.color)
                .frame(height: 80)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                )

            // Color information
            VStack(spacing: 4) {
                Text(namedColor.name)
                    .font(.headline)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)

                Text(namedColor.color.asHexString())
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .monospaced()
            }
        }
        .padding(12)
        #if os(iOS)
        .background(Color(.systemBackground))
        #endif // os(iOS)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

/// Manages the color palette and handles import/export operations
@MainActor
class PaletteManager: ObservableObject {
    @Published var colors: [NamedColor] = []

    /// Creates a diverse set of sample colors showcasing different ColorKit features
    func createSampleColors() {
        let sampleColors: [NamedColor] = [
            // Hex string colors
            NamedColor("Cherry Red", hexString: "#DC143C"),
            NamedColor("Ocean Blue", hexString: "#006994"),
            NamedColor("Forest Green", hexString: "#228B22"),

            // System colors
            NamedColor("System Teal", color: .teal),
            NamedColor("System Mint", color: .mint),
            NamedColor("System Orange", color: .orange),

            // Colors with intensity
            NamedColor("Faded Purple", color: .purple, intensity: .tertiary),
            NamedColor("Subtle Pink", color: .pink, intensity: .quaternary),
            NamedColor("Light Blue", color: .blue, intensity: .secondary),

            // Mixed colors
            NamedColor("Sunset", color: .orange, with: .red, by: 0.3, in: .perceptual),
            NamedColor("Ocean Mist", color: .blue, with: .cyan, by: 0.6, in: .device),
            NamedColor("Spring Green", color: .green, with: .yellow, by: 0.4),

            // Enhanced static methods
            NamedColor.mixedColor("Lavender Mix", baseColor: .purple, mixColor: .white, fraction: 0.7),
            NamedColor.colorWithIntensity("Muted Red", baseColor: .red, intensity: .quinary),

            // Predefined colors from ColorKit
            NamedColor.namedColors[24], // Maraschino
            NamedColor.namedColors[11], // Snow
            NamedColor.namedColors[40], // Flora
        ]

        addColors(sampleColors)
    }

    /// Adds colors to the palette, avoiding duplicates based on color values
    /// - Parameter newColors: Array of NamedColor instances to add
    func addColors(_ newColors: [NamedColor]) {
        for newColor in newColors {
            // Check if a color with the same RGBA values already exists
            let newColorTuple = newColor.color.asTuple()
            let isDuplicate = colors.contains { existingColor in
                let existingTuple = existingColor.color.asTuple()
                return abs(newColorTuple.red - existingTuple.red) < 0.001 &&
                abs(newColorTuple.green - existingTuple.green) < 0.001 &&
                abs(newColorTuple.blue - existingTuple.blue) < 0.001 &&
                abs(newColorTuple.alpha - existingTuple.alpha) < 0.001
            }

            if !isDuplicate {
                colors.append(newColor)
            }
        }
    }

    /// Clears all colors from the palette
    func clearColors() {
        colors.removeAll()
    }

    /// Exports the current color palette as JSON data
    /// - Returns: Data containing the JSON representation of the colors
    func exportColorsAsJSON() -> Data {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            return try encoder.encode(colors)
        } catch {
            print("Failed to encode colors: \(error)")
            return Data()
        }
    }

    /// Handles file import results and processes JSON color data
    /// - Parameters:
    ///   - result: Result from the file picker
    ///   - completion: Callback with status message
    func handleFileImport(result: Result<[URL], Error>, completion: @escaping (String) -> Void) {
        switch result {
        case .success(let urls):
            guard let url = urls.first else {
                completion("No file selected")
                return
            }

            importColorsFromJSON(url: url, completion: completion)

        case .failure(let error):
            completion("File selection failed: \(error.localizedDescription)")
        }
    }

    /// Imports colors from a JSON file
    /// - Parameters:
    ///   - url: URL of the JSON file to import
    ///   - completion: Callback with status message
    private func importColorsFromJSON(url: URL, completion: @escaping (String) -> Void) {
        do {
            // Start accessing the security-scoped resource
            let hasAccess = url.startAccessingSecurityScopedResource()
            defer {
                if hasAccess {
                    url.stopAccessingSecurityScopedResource()
                }
            }

            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let importedColors = try decoder.decode([NamedColor].self, from: data)

            let originalCount = colors.count
            addColors(importedColors)
            let newColorCount = colors.count - originalCount

            if newColorCount > 0 {
                completion("Successfully imported \(newColorCount) new colors from \(url.lastPathComponent)")
            } else {
                completion("No new colors found in \(url.lastPathComponent) - all colors were duplicates")
            }

        } catch let decodingError as DecodingError {
            completion("Invalid JSON format: \(decodingError.localizedDescription)")
        } catch {
            completion("Import failed: \(error.localizedDescription)")
        }
    }
}

/// Document wrapper for JSON export functionality
struct JSONDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.json] }

    let data: Data

    init(data: Data) {
        self.data = data
    }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self.data = data
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: data)
    }
}

#Preview {
    ContentView()
}
