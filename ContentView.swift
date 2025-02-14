import SwiftUI
import PlaygroundSupport
import Combine

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text(" ")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                VStack(spacing: 40) {
                    NavigationButton(title: "Mindfulness Tips", destination: MindfulnessTipsView(), color: .purple)
                    NavigationButton(title: "Breathing Exercise", destination: BreathingExerciseView(), color: .indigo)
                    NavigationButton(title: "Digital Journal", destination: DigitalJournalView(), color: .blue)
                    NavigationButton(title: "Mindful Doodling", destination: DoodlingPageView(), color: .cyan)
                    NavigationButton(title: "Interactive Game", destination: GamePageView(), color: .mint) 
                }
                .padding()
                
                Spacer()
            }
            .navigationTitle("Mindfulness")
        }
    }
}

struct NavigationButton<Destination: View>: View {
    let title: String
    let destination: Destination
    let color: Color
    
    var body: some View {
        NavigationLink(destination: destination) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(color)
                .cornerRadius(10)
                .padding(.horizontal)
        }
    }
}

struct BreathingExerciseView: View {
    @State private var scale: CGFloat = 1.0
    @State private var breathText: String = "Inhale"
    @State private var breathColor: Color = .white
    @State private var breathCycleDuration: Double = 4.0
    
    var body: some View {
        VStack {
            Text(breathText)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
                .padding()
                .padding()
                .padding()
                .padding()
                .padding()
                .padding()
            
            Circle()
                .fill(breathColor)
                .frame(width: 200, height: 200)
                .scaleEffect(scale)
                .animation(.easeInOut(duration: breathCycleDuration), value: scale)
                .onAppear {
                    startBreathing()
                }
            
            Slider(value: $breathCycleDuration, in: 2...10, step: 0.5) {
                Text("Breath Duration")
            }
            .padding()
            .padding()
            .padding()
            .padding()
            .padding()
            .padding()
            
            Text("Adjust Breathing Duration")
                .font(.headline)
        }
        .padding()
        .navigationTitle("Breathing Exercise")
    }
    
    func startBreathing() {
        Timer.scheduledTimer(withTimeInterval: breathCycleDuration, repeats: true) { timer in
            withAnimation {
                if self.scale == 1.0 {
                    self.scale = 1.5
                    self.breathText = "Exhale"
                    self.breathColor = .indigo
                } else {
                    self.scale = 1.0
                    self.breathText = "Inhale"
                    self.breathColor = .mint
                }
            }
        }
    }
}

struct MindfulnessTipsView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Here are some tips to help you practice mindfulness:")
                .font(.custom("Lexend", size: 32))
                .foregroundColor(.purple)
                .padding()
            
            List {
                Text("1. Start with 5 minutes of mindful breathing (or however long you like).")
                Text("2. Focus on your senses — what can you hear, see, and feel (What are you thinking about? Is there something you are trying to avoid?)")
                Text("3. Practice meditation when you're feeling stressed - Create a mental list in your head to organise your thoughts.")
                Text("4. Take a short mindful walk each day. Use this time to appreciate yourself. Ask yourself 'is my life where I want it to be right now?' or 'Would my younger self look up to me today?'")
                Text("5. Spend time with your loved ones. Play a game or watch something together.")
                Text("6. Doodle something random! Be however crazy you like!")
                Text("7. Keep a gratitude journal & reflect on your thoughts or simply jot down what made you happy today.")
            }
        }
        .navigationTitle("Mindfulness Tips")
    }
}

struct DigitalJournalView: View {
    @State private var diaryEntries: [DiaryEntry] = []
    @State private var showingAddEntryForm = false
    
    var body: some View {
        VStack {
            List {
                ForEach(diaryEntries) { entry in
                    VStack(alignment: .leading) {
                        Text(entry.dateFormatted)
                            .font(.headline)
                        Text(entry.activityDescription)
                            .font(.body)
                    }
                    .padding(.vertical, 5)
                }
                .onDelete(perform: deleteEntry)
            }
            
            Button(action: {
                showingAddEntryForm = true
            }) {
                Text("Add New Entry")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding()
            }
        }
        .navigationTitle("Digital Journal")
        .sheet(isPresented: $showingAddEntryForm) {
            AddEntryForm(diaryEntries: $diaryEntries)
        }
    }
    
    func deleteEntry(at offsets: IndexSet) {
        diaryEntries.remove(atOffsets: offsets)
    }
}

struct AddEntryForm: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var diaryEntries: [DiaryEntry]
    
    @State private var activityDescription: String = ""
    @State private var date = Date()
    
    var body: some View {
        NavigationView {
            Form {
                DatePicker("Date", selection: $date, displayedComponents: .date)
                
                TextField("Write here:", text: $activityDescription)
                    .padding()
            }
            .navigationTitle("Dear Diary...")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveEntry()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    func saveEntry() {
        let newEntry = DiaryEntry(date: date, activityDescription: activityDescription)
        diaryEntries.append(newEntry)
    }
}

struct DiaryEntry: Identifiable {
    let id = UUID()
    let date: Date
    let activityDescription: String
    
    var dateFormatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct DoodlingPageView: View {
    @State private var lines: [Line] = []        
    @State private var selectedColor: Color = .black  
    @State private var lineWidth: CGFloat = 5.0  
    
    var body: some View {
        VStack {
            // Drawing Canvas
            CanvasView(lines: $lines, lineWidth: lineWidth, selectedColor: selectedColor)
                .border(Color.gray, width: 1)
                .background(Color.white)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            let newPoint = value.location
                            if value.translation == .zero {
                                lines.append(Line(points: [newPoint], color: selectedColor, lineWidth: lineWidth))
                            } else {
                                guard var lastLine = lines.popLast() else { return }
                                lastLine.points.append(newPoint)
                                lines.append(lastLine)
                            }
                        }
                )
            
            HStack {
                ColorPickerView(selectedColor: $selectedColor)
                
                VStack {
                    Text("Line Width: \(Int(lineWidth))")
                    Slider(value: $lineWidth, in: 1...10, step: 1)
                        .frame(width: 150)
                }
                
                Button(action: {
                    lines.removeAll()  
                }) {
                    Text("Clear")
                        .font(.headline)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .navigationTitle("Doodling Page")
    }
}

struct CanvasView: View {
    @Binding var lines: [Line] 
    let lineWidth: CGFloat
    let selectedColor: Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(lines) { line in
                    Path { path in
                        if let firstPoint = line.points.first {
                            path.move(to: firstPoint)
                            for point in line.points.dropFirst() {
                                path.addLine(to: point)
                            }
                        }
                    }
                    .stroke(line.color, lineWidth: line.lineWidth)
                }
            }
        }
    }
}

struct Line: Identifiable {
    let id = UUID()
    var points: [CGPoint]   
    var color: Color         
    var lineWidth: CGFloat  
}

struct ColorPickerView: View {
    @Binding var selectedColor: Color
    
    let colors: [Color] = [.black, .pink, .red, .orange, .yellow, .green, .mint, .cyan, .blue, .indigo, .purple, .brown]
    
    var body: some View {
        HStack {
            ForEach(colors, id: \.self) { color in
                Circle()
                    .fill(color)
                    .frame(width: 30, height: 30)
                    .onTapGesture {
                        selectedColor = color
                    }
                    .padding(2)
                    .border(selectedColor == color ? Color.gray : Color.clear, width: 2)
            }
        }
    }
}

struct GamePageView: View {
    @State private var shapePosition: CGPoint = CGPoint(x: 100, y: 100) 
    @State private var score: Int = 0
    @State private var timeRemaining: Int = 15
    @State private var gameOver = false
    @State private var shapeColor: Color = .mint
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect() 
    
    var body: some View {
        VStack {
            
            HStack {
                Text("Score: \(score)")
                    .foregroundColor(.mint)
                    .font(.largeTitle)
                    .padding()
                Spacer()
                Text("Time: \(timeRemaining)")
                    .foregroundColor(.mint)
                    .font(.largeTitle)
                    .padding()
            }
            
            Spacer()
            Circle()
                .fill(shapeColor)
                .frame(width: 100, height: 100)
                .position(shapePosition)
                .onTapGesture {
                    self.shapeTapped()
                }
            
            Spacer()
            
            if gameOver {
                Text("Game Over")
                    .font(.largeTitle)
                    .padding()
                
                Button(action: restartGame) {
                    Text("Restart Game")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
        .onReceive(timer) { _ in
            if self.timeRemaining > 0 && !self.gameOver {
                self.timeRemaining -= 1
            } else {
                self.gameOver = true
            }
        }
        .navigationTitle("Tap the Shape Game")
    }
    
    func shapeTapped() {
        
        score += 1
        shapePosition = CGPoint(x: CGFloat.random(in: 50...300), y: CGFloat.random(in: 100...600))
    }
    
    func restartGame() {
        score = 0
        timeRemaining = 15
        gameOver = false
        shapePosition = CGPoint(x: 100, y: 100) 
    }
}
