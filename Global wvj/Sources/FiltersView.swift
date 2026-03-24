import SwiftUI

struct FiltersView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: JobListingsViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                themeManager.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        filterSection(
                            title: "Country",
                            icon: "flag",
                            items: viewModel.availableCountries,
                            selectedItems: $viewModel.selectedCountries
                        )
                        
                        Divider()
                            .background(themeManager.dividerColor)
                        
                        filterSection(
                            title: "Category",
                            icon: "tag",
                            items: viewModel.availableCategories,
                            selectedItems: $viewModel.selectedCategories
                        )
                        
                        Divider()
                            .background(themeManager.dividerColor)
                        
                        filterSection(
                            title: "Visa Type",
                            icon: "doc.text",
                            items: viewModel.availableVisaTags,
                            selectedItems: $viewModel.selectedVisaTags
                        )
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 20)
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(themeManager.accentColor)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        dismiss()
                    }
                    .foregroundColor(themeManager.accentColor)
                    .fontWeight(.semibold)
                }
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button(action: {
                        viewModel.clearFilters()
                    }) {
                        Text("Clear All Filters")
                            .font(.system(size: 16, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(themeManager.errorColor.opacity(0.2))
                            .foregroundColor(themeManager.errorColor)
                            .cornerRadius(10)
                    }
                    .disabled(!viewModel.hasActiveFilters)
                    .opacity(viewModel.hasActiveFilters ? 1.0 : 0.5)
                }
            }
        }
        .tint(themeManager.navigationText)
    }
    
    private func filterSection(
        title: String,
        icon: String,
        items: [String],
        selectedItems: Binding<Set<String>>
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(themeManager.accentColor)
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(themeManager.primaryText)
            }
            
            FlowLayout(spacing: 8) {
                ForEach(items.sorted(), id: \.self) { item in
                    FilterButton(
                        text: item,
                        isSelected: selectedItems.wrappedValue.contains(item),
                        action: {
                            if selectedItems.wrappedValue.contains(item) {
                                selectedItems.wrappedValue.remove(item)
                            } else {
                                selectedItems.wrappedValue.insert(item)
                            }
                        }
                    )
                }
            }
        }
    }
}

struct FilterButton: View {
    @EnvironmentObject var themeManager: ThemeManager
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: 14, weight: .medium))
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(isSelected ? themeManager.accentColor : themeManager.secondaryBackground)
                .foregroundColor(isSelected ? .white : themeManager.primaryText)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isSelected ? Color.clear : themeManager.borderColor, lineWidth: 1)
                )
        }
    }
}

struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x, y: bounds.minY + result.positions[index].y), proposal: .unspecified)
        }
    }
    
    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var lineHeight: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                
                if currentX + size.width > maxWidth && currentX > 0 {
                    currentX = 0
                    currentY += lineHeight + spacing
                    lineHeight = 0
                }
                
                positions.append(CGPoint(x: currentX, y: currentY))
                currentX += size.width + spacing
                lineHeight = max(lineHeight, size.height)
            }
            
            self.size = CGSize(width: maxWidth, height: currentY + lineHeight)
        }
    }
}