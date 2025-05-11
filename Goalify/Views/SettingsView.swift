import SwiftUI
import StoreKit

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        Form {
            Section {
                Toggle(isOn: $isDarkMode) {
                    Label("Dark Mode", systemImage: "moon.fill")
                }
            }
            
            Section {
                Button {
                    if let url = URL(string: "https://apps.apple.com/app/id123456789") {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    Label("Rate this app", systemImage: "star.fill")
                }
                
                Button {
                    let items = ["Check out Goalify - A simple but powerful goal tracking app!"]
                    let av = UIActivityViewController(activityItems: items, applicationActivities: nil)
                    UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true)
                } label: {
                    Label("Share this app", systemImage: "square.and.arrow.up")
                }
            }
            
            Section {
                NavigationLink {
                    PrivacyPolicyView()
                } label: {
                    Label("Privacy Policy", systemImage: "hand.raised.fill")
                }
                
                NavigationLink {
                    TermsOfUseView()
                } label: {
                    Label("Terms of Use", systemImage: "doc.text.fill")
                }
            }
        }
        .navigationTitle("Settings")
    }
}

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            Text("""
            Privacy Policy
            
            Last updated: [Date]
            
            This Privacy Policy describes how Goalify ("we," "us," or "our") collects, uses, and discloses your information when you use our mobile application (the "App").
            
            Information We Collect
            
            The App does not collect any personal information. All goal and task data is stored locally on your device.
            
            How We Use Your Information
            
            Since we don't collect any personal information, we don't use your information for any purpose.
            
            Data Storage
            
            All data is stored locally on your device using iOS's built-in UserDefaults system. This data is not transmitted to any external servers.
            
            Changes to This Privacy Policy
            
            We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.
            
            Contact Us
            
            If you have any questions about this Privacy Policy, please contact us.
            """)
            .padding()
        }
        .navigationTitle("Privacy Policy")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TermsOfUseView: View {
    var body: some View {
        ScrollView {
            Text("""
            Terms of Use
            
            Last updated: [Date]
            
            Please read these Terms of Use ("Terms") carefully before using the Goalify mobile application (the "App").
            
            Acceptance of Terms
            
            By accessing or using the App, you agree to be bound by these Terms. If you disagree with any part of the terms, then you may not access the App.
            
            Use License
            
            Permission is granted to use the App for personal, non-commercial purposes. This is the grant of a license, not a transfer of title.
            
            Restrictions
            
            You are specifically restricted from:
            - Publishing any App material in any other media
            - Selling, sublicensing and/or otherwise commercializing any App material
            - Publicly performing and/or showing any App material
            - Using this App in any way that is or may be damaging to this App
            - Using this App contrary to applicable laws and regulations
            
            Disclaimer
            
            The App is provided "as is," with all faults, and we make no express or implied representations or warranties of any kind.
            
            Contact Us
            
            If you have any questions about these Terms, please contact us.
            """)
            .padding()
        }
        .navigationTitle("Terms of Use")
        .navigationBarTitleDisplayMode(.inline)
    }
}