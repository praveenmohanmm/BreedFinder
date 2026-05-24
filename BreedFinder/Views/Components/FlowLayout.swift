import SwiftUI

// MARK: - Flow layout (wraps children like a flex-wrap row)
/// A custom `Layout` that arranges subviews in left-to-right rows,
/// wrapping to the next row when the available width is exhausted.
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var curX: CGFloat = 0
        var curY: CGFloat = 0
        var rowH: CGFloat = 0

        for sv in subviews {
            let sz = sv.sizeThatFits(.unspecified)
            if curX + sz.width > maxWidth, curX > 0 {
                curY += rowH + spacing
                curX  = 0
                rowH  = 0
            }
            curX += sz.width + spacing
            rowH  = max(rowH, sz.height)
        }
        return CGSize(width: maxWidth, height: curY + rowH)
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        var curX = bounds.minX
        var curY = bounds.minY
        var rowH: CGFloat = 0

        for sv in subviews {
            let sz = sv.sizeThatFits(.unspecified)
            if curX + sz.width > bounds.maxX, curX > bounds.minX {
                curY += rowH + spacing
                curX  = bounds.minX
                rowH  = 0
            }
            sv.place(at: CGPoint(x: curX, y: curY),
                     proposal: ProposedViewSize(sz))
            curX += sz.width + spacing
            rowH  = max(rowH, sz.height)
        }
    }
}
