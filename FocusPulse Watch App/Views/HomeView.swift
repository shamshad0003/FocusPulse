import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = TimerViewModel()
    
    var body: some View {
        VStack(spacing: 4) {
            // Timer with Circular Progress
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.1), lineWidth: 10)
                Circle()
                    .trim(from: 0, to: viewModel.progress)
                    .stroke(viewModel.sessionMode.color, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.linear, value: viewModel.progress)
                
                VStack(spacing: 0) {
                    Text(viewModel.timeString)
                        .font(.system(size: 24, weight: .bold, design: .monospaced))
                    
                    Text("\(viewModel.sessionMode.label)")
                        .font(.caption2)
                        .foregroundColor(viewModel.sessionMode.color)
                    
                    Text("Cycle \(viewModel.cycleManager.cycleCount)")
                        .font(.system(size: 8))
                        .foregroundColor(.gray)
                }
            }
            .frame(width: 110, height: 110)
            .padding(.top, 4)
            
            // Auto Mode Indicator
            HStack {
                Circle()
                    .fill(viewModel.cycleManager.isAutoCycleEnabled ? Color.green : Color.red)
                    .frame(width: 6, height: 6)
                Text("Auto Cycle: \(viewModel.cycleManager.isAutoCycleEnabled ? "ON" : "OFF")")
                    .font(.system(size: 8))
            }
            .onTapGesture {
                viewModel.cycleManager.toggleAutoCycle()
            }
            
            // Controls
            HStack(spacing: 12) {
                Button(action: {
                    if viewModel.isActive {
                        viewModel.pause()
                    } else {
                        viewModel.start()
                    }
                }) {
                    Image(systemName: viewModel.isActive ? "pause.fill" : "play.fill")
                        .font(.body)
                }
                .buttonStyle(.borderedProminent)
                .tint(viewModel.isActive ? .orange : .green)
                .frame(width: 50)
                
                Button(action: viewModel.reset) {
                    Image(systemName: "arrow.clockwise")
                        .font(.body)
                }
                .buttonStyle(.bordered)
                .tint(.red)
                .frame(width: 50)
            }
            
            // Navigation
            HStack(spacing: 16) {
                NavigationLink(destination: AnalyticsView()) {
                    Image(systemName: "chart.bar.xaxis")
                        .font(.caption)
                }
                .buttonStyle(.plain)
                
                NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gearshape.fill")
                        .font(.caption)
                }
                .buttonStyle(.plain)
            }
            .padding(.top, 4)
        }
        .padding(.horizontal)
        .onAppear {
            NotificationManager.shared.requestAuthorization()
        }
    }
}

#Preview {
    HomeView()
}
