import SwiftUI

struct LetterGroup: View {
    @Binding var letters: [Letter]
    var onRearrangeLetters: ([Letter]) -> Void
    
    var tileColor: Color = Color(
        red: Double(0xFF) / 255.0,
        green: Double(0xF3) / 255.0,
        blue: Double(0xE0) / 255.0
    )
    
    @State var boxSize = CGSize.zero
    @State var startCellIndex: Int? = nil
    @State var blankCellIndex: Int? = nil
    @State var pointerIndex: Float? = nil
    @State var dragOffset = CGPoint.zero
    @State var draggedLetter: Letter? = nil
    @State var startPointerPosition = CGPoint.zero
    @GestureState var what = false
    var body: some View {
        ZStack {
            let letterSize = min(80, (UIScreen.main.bounds.width - 32) / CGFloat(letters.count))
            // The extra BigLetter position aligns with the center
            // of the HStack. So the dragoffset must be adjusted by
            // the relative position of the starting drag point w.r.t
            // to the HStack center
            if let draggedLetter {
                BigLetter(letter: draggedLetter, size: letterSize, tileColor: tileColor)
                    .offset(x: dragOffset.x + startPointerPosition.x - boxSize.width / 2, y: dragOffset.y)
            }
            VStack {
                HStack(spacing: 2) {
                    if letters.count > 0 {
                        ForEach(Array(self.letters.enumerated()), id: \.offset) {  pos, letter in
                            BigLetter(letter: letter, size: letterSize, tileColor: tileColor)
                        }
                    } else {
                        // Show a blank box if there are no letters
                        BigLetter(letter: Letter(), size: letterSize, tileColor: tileColor)
                    }
                }
                .onGeometryChange(for: CGSize.self,
                                  of: { $0.size as CGSize},
                                  action: {
                    boxSize = $0
                })
                .gesture(DragGesture()
                    .onChanged { drag in
                        guard letters.count > 0 else { return }
                        // Determine the letter box index from the current position
                        // of the pointer
                        let percentage = drag.location.x / boxSize.width
                        var index = percentage * CGFloat(letters.count)
                        startPointerPosition = drag.startLocation
                        // Make sure that index in inbound [0,N-1]
                        if index < 0 {
                            index = 0
                        } else if index > CGFloat(letters.count - 1) {
                            index = CGFloat(letters.count - 1)
                        }
                        if draggedLetter == nil { // Not currently dragging
                            blankCellIndex = Int(index)
                            draggedLetter = letters[blankCellIndex!]
                            // replace the spot with a blank letter
                            letters[blankCellIndex!] = Letter()
                        }
                        // remember the start index, in case we cancel dropping
                        if startCellIndex == nil {
                            startCellIndex = Int(index)
                        }
                        // If the pointer is no longer on the "blank" box
                        if blankCellIndex != Int(index) {
                            letters[blankCellIndex!] = letters[Int(index)]
                            letters[Int(index)] = Letter()
                            blankCellIndex = Int(index)
                        }
                        pointerIndex = Float(index)
                        // Compute the amount of total drag
                        dragOffset = CGPoint(x: drag.location.x - drag.startLocation.x,
                                             y: drag.location.y - drag.startLocation.y)
                    }
                    .onEnded { _ in
                        guard letters.count > 0, blankCellIndex != nil else {
                            draggedLetter = nil
                            pointerIndex = nil
                            startCellIndex = nil
                            blankCellIndex = nil
                            startPointerPosition = CGPoint.zero
                            dragOffset = CGPoint.zero
                            return
                        }
                        letters[blankCellIndex!] = draggedLetter!
                        draggedLetter = nil
                        pointerIndex = nil
                        startCellIndex = nil
                        blankCellIndex = nil
                        startPointerPosition = CGPoint.zero
                        dragOffset = CGPoint.zero
                        // Inform the viewmodel to readjust array
                        self.onRearrangeLetters(letters)
                    }
                )
            }
        }
    }
}

struct BigLetter: View {
    private let ch: String
    private let pt: Int
    let size: CGFloat
    let tileColor: Color
    
    init(letter: Letter, size: CGFloat = 44, tileColor: Color) {
        self.ch = String(letter.text)
        self.pt = letter.point
        self.size = size
        self.tileColor = tileColor
    }
    var body: some View {
        ZStack{
            Text(self.ch)
                .font(.system(size: 0.75 * self.size, weight: .bold))
                .padding(.trailing, size * 0.12)
                .padding(.bottom, size * 0.12)
        }
        .frame(width: self.size, height: self.size)
        .background(
            self.pt == 0
            ? .clear
            : tileColor
        )
        .cornerRadius(10)
        .overlay(alignment: .bottomTrailing) {
            if pt > 0 {
                Text("\(pt)")
                    .font(.system(size: size * 0.18, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.horizontal, size * 0.06)
                    .padding(.vertical, size * 0.03)
                    .background(
                        RoundedRectangle(cornerRadius: size * 0.12, style: .continuous)
                            .fill(
                                  tileColor.opacity(0.9)
                              )
                              .stroke(Color.black.opacity(0.1), lineWidth: 1)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: size * 0.12, style: .continuous)
                            .stroke(Color.black.opacity(0.15), lineWidth: 1) 
                    )
                    .padding(.trailing, size * 0.12)
                    .padding(.bottom, size * 0.10)
            }
        }
    }
}
