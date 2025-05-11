import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @Binding var isOnboardingComplete: Bool
    
    var body: some View {
        TabView(selection: $viewModel.currentPage) {
            ForEach(0..<viewModel.onboardingItems.count, id: \.self) { index in
                OnboardingPageView(item: viewModel.onboardingItems[index])
                    .tag(index)
            }
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .overlay(alignment: .bottom) {
            VStack {
                Button(viewModel.isLastPage ? "Get Started" : "Next") {
                    if viewModel.isLastPage {
                        viewModel.markOnboardingComplete()
                        isOnboardingComplete = true
                    } else {
                        viewModel.nextPage()
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .tint(.green)
            }
            .padding(.bottom, 50)
        }
    }
}

struct OnboardingPageView: View {
    let item: OnboardingItem
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: item.imageName)
                .font(.system(size: 100))
                .foregroundColor(.green)
            
            Text(item.title)
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
            
            Text(item.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 32)
            
            Spacer()
            Spacer()
        }
        .padding()
    }
}