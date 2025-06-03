//
//  ContentView.swift
//  ColorKitDemo2
//
//  Created by Chon Torres on 5/31/25.
//

import ColorKit
import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            PredefinedColorsView()
                .tabItem {
                    Image(systemName: "paintpalette")
                    Text("Predefined Colors")
                }
                .tag(0)

            ColorCreationView()
                .tabItem {
                    Image(systemName: "plus.circle")
                    Text("Create Colors")
                }
                .tag(1)

            ColorMixingView()
                .tabItem {
                    Image(systemName: "drop.triangle")
                    Text("Color Mixing")
                }
                .tag(2)

            IntensityDemoView()
                .tabItem {
                    Image(systemName: "slider.horizontal.3")
                    Text("Intensity Levels")
                }
                .tag(3)
        }
    }
}

struct PredefinedColorsView: View {
    let columns = [
        GridItem(.adaptive(minimum: 120), spacing: 16)
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(NamedColor.namedColors.indices, id: \.self) { index in
                        let namedColor = NamedColor.namedColors[index]
                        ColorTileView(namedColor: namedColor)
                    }
                }
                .padding()
            }
            .navigationTitle("Predefined Colors")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - Color Creation View
struct ColorCreationView: View {
    @State private var hexInput = "#FF5733"
    @State private var colorName = "Custom Color"
    @State private var createdColors: [NamedColor] = []
    @State private var selectedColor = Color.blue

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Hex Color Creation Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Create from Hex")
                            .font(.headline)
                            .foregroundColor(.primary)

                        VStack(spacing: 8) {
                            TextField("Color Name", text: $colorName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())

                            TextField("Hex Code (e.g., #FF5733)", text: $hexInput)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .autocapitalization(.allCharacters)

                            Button("Create from Hex") {
                                let newColor = NamedColor(colorName, hexString: hexInput)
                                createdColors.append(newColor)
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)

                    // Color Picker Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Create from Color Picker")
                            .font(.headline)
                            .foregroundColor(.primary)

                        VStack(spacing: 8) {
                            ColorPicker("Pick a Color", selection: $selectedColor)

                            Button("Create from Picker") {
                                let newColor = NamedColor("Picked Color \(createdColors.count + 1)", color: selectedColor)
                                createdColors.append(newColor)
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)

                    // Created Colors Display
                    if !createdColors.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Your Created Colors")
                                .font(.headline)
                                .foregroundColor(.primary)

                            LazyVGrid(columns: [
                                GridItem(.adaptive(minimum: 120), spacing: 16)
                            ], spacing: 16) {
                                ForEach(createdColors.indices, id: \.self) { index in
                                    ColorTileView(namedColor: createdColors[index])
                                }
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Create Colors")
        }
    }
}

// MARK: - Color Mixing View
struct ColorMixingView: View {
    @State private var color1 = Color.red
    @State private var color2 = Color.blue
    @State private var mixFraction: Double = 0.5
    @State private var mixedColors: [NamedColor] = []
    @State private var selectedColorSpace: Gradient.ColorSpace = .perceptual

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Color Mixing Controls
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Mix Two Colors")
                            .font(.headline)
                            .foregroundColor(.primary)

                        HStack {
                            VStack {
                                Text("Color 1")
                                    .font(.caption)
                                ColorPicker("Color 1", selection: $color1)
                                    .labelsHidden()
                                    .frame(width: 60, height: 60)
                            }

                            Spacer()

                            VStack {
                                Text("Mix Result")
                                    .font(.caption)
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(color1.mix(with: color2, by: mixFraction, in: selectedColorSpace))
                                    .frame(width: 60, height: 60)
                            }

                            Spacer()

                            VStack {
                                Text("Color 2")
                                    .font(.caption)
                                ColorPicker("Color 2", selection: $color2)
                                    .labelsHidden()
                                    .frame(width: 60, height: 60)
                            }
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Mix Fraction: \(mixFraction, specifier: "%.2f")")
                                .font(.caption)
                            Slider(value: $mixFraction, in: 0...1)
                        }

                        Picker("Color Space", selection: $selectedColorSpace) {
                            Text("Perceptual").tag(Gradient.ColorSpace.perceptual)
                            Text("Device").tag(Gradient.ColorSpace.device)
                        }
                        .pickerStyle(SegmentedPickerStyle())

                        Button("Save Mixed Color") {
                            let mixedColor = NamedColor(
                                "Mixed Color \(mixedColors.count + 1)",
                                color: color1,
                                with: color2,
                                by: mixFraction,
                                in: selectedColorSpace
                            )
                            mixedColors.append(mixedColor)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)

                    // Mixed Colors Display
                    if !mixedColors.isEmpty {
                        VStack(alignment: .l       eading, spacing: 12) {
                            Text("Your Mixed Colors")
                                .font(.headline)
                                .foregroundColor(.primary)

                            LazyVGrid(columns: [
                                GridItem(.adaptive(minimum: 120), spacing: 16)
                            ], spacing: 16) {
                                ForEach(mixedColors.indices, id: \.self) { index in
                                    ColorTileView(namedColor: mixedColors[index])
                                }
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                }
                .padding()
            }
            .navigationTitle("Color Mixing")
        }
    }
}

// MARK: - Intensity Demo View
struct IntensityDemoView: View {
    let baseColors = [
        Color.red, Color.blue, Color.green, Color.orange, Color.purple
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    Text("Color Intensity Levels")
                        .font(.title2)
                        .fontWeight(.semibold)

                    Text("Each color is shown at different intensity levels, from primary (100% opacity) to quinary (20% opacity).")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)

                    ForEach(baseColors.indices, id: \.self) { colorIndex in
                        let baseColor = baseColors[colorIndex]

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Color \(colorIndex + 1)")
                                .font(.headline)

                            HStack(spacing: 12) {
                                ForEach(ColorIntensity.allCases, id: \.self) { intensity in
                                    VStack(spacing: 4) {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(baseColor.opacity(intensity.opacity))
                                            .frame(width: 50, height: 50)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                            )

                                        Text(intensity.rawValue.capitalized)
                                            .font(.caption2)
                                            .foregroundColor(.secondary)

                                        Text("\(Int(intensity.opacity * 100))%")
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                }
                .padding()
            }
            .navigationTitle("Intensity Levels")
        }
    }
}

// MARK: - Color Tile View Component
struct ColorTileView: View {
    let namedColor: NamedColor
    @State private var showingDetails = false

    var body: some View {
        VStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 12)
                .fill(namedColor.color)
                .frame(height: 80)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)

            VStack(spacing: 2) {
                Text(namedColor.name)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)

                Text(namedColor.color.asHexString())
                    .font(.caption2)
                    .monospaced()
                    .foregroundColor(.secondary)
            }
        }
        .onTapGesture {
            showingDetails = true
        }
        .sheet(isPresented: $showingDetails) {
            ColorDetailView(namedColor: namedColor)
        }
    }
}

// MARK: - Color Detail View
struct ColorDetailView: View {
    let namedColor: NamedColor
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Large Color Display
                RoundedRectangle(cornerRadius: 20)
                    .fill(namedColor.color)
                    .frame(height: 200)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)

                // Color Information
                VStack(spacing: 16) {
                    VStack(spacing: 8) {
                        Text("Color Information")
                            .font(.headline)

                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("Name:")
                                    .fontWeight(.medium)
                                Spacer()
                                Text(namedColor.name)
                                    .foregroundColor(.secondary)
                            }

                            HStack {
                                Text("Hex:")
                                    .fontWeight(.medium)
                                Spacer()
                                Text(namedColor.color.asHexString())
                                    .monospaced()
                                    .foregroundColor(.secondary)
                            }

                            HStack {
                                Text("Luminance:")
                                    .fontWeight(.medium)
                                Spacer()
                                Text(String(format: "%.3f", namedColor.color.luminance()))
                                    .monospaced()
                                    .foregroundColor(.secondary)
                            }

                            HStack {
                                Text("Light/Dark:")
                                    .fontWeight(.medium)
                                Spacer()
                                Text(namedColor.color.isLight() ? "Light" : "Dark")
                                    .foregroundColor(.secondary)
                            }

                            HStack {
                                Text("Best Text Color:")
                                    .fontWeight(.medium)
                                Spacer()
                                Text("Sample Text")
                                    .foregroundColor(namedColor.color.adaptedTextColor())
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(namedColor.color)
                                    .cornerRadius(6)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Color Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
