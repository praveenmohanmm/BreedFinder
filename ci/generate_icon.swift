#!/usr/bin/env swift
// generate_icon.swift — Draws a 1024×1024 app icon using CoreGraphics.
// Usage: swift ci/generate_icon.swift <output-path>
// Output: PNG with blue gradient background + white paw-print silhouette.
import Foundation
import CoreGraphics
import ImageIO

let dim = 1024
let outPath = CommandLine.arguments.count > 1
    ? CommandLine.arguments[1]
    : "AppIcon-1024.png"

let cs = CGColorSpaceCreateDeviceRGB()
guard let ctx = CGContext(
    data: nil, width: dim, height: dim,
    bitsPerComponent: 8, bytesPerRow: 0, space: cs,
    bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
) else { fatalError("Cannot create CGContext") }

// ── Clip to rounded-rect (iOS icon mask) ──────────────────────────────────
let radius: CGFloat = 224   // ≈22 % of 1024 — matches iOS icon mask
let clipPath = CGPath(
    roundedRect: CGRect(x: 0, y: 0, width: dim, height: dim),
    cornerWidth: radius, cornerHeight: radius, transform: nil
)
ctx.addPath(clipPath)
ctx.clip()

// ── Gradient background  #5B9AFF (top) → #1249B8 (bottom) ────────────────
// CG y = 0 at BOTTOM, so "top" = y = dim
let cTop = CGColor(red: 0.357, green: 0.604, blue: 1.000, alpha: 1)  // #5B9AFF
let cBot = CGColor(red: 0.071, green: 0.286, blue: 0.722, alpha: 1)  // #1249B8
let grad = CGGradient(
    colorsSpace: cs, colors: [cTop, cBot] as CFArray, locations: [0.0, 1.0]
)!
ctx.drawLinearGradient(
    grad,
    start: CGPoint(x: CGFloat(dim) / 2, y: CGFloat(dim)),
    end:   CGPoint(x: CGFloat(dim) / 2, y: 0),
    options: []
)

// ── White paw-print silhouette ────────────────────────────────────────────
ctx.setFillColor(CGColor(red: 1, green: 1, blue: 1, alpha: 0.92))

// Main pad — large oval, slightly below centre
ctx.fillEllipse(in: CGRect(x: 312, y: 220, width: 400, height: 345))

// Four toe pads — arc above main pad
// CG coords (0 = bottom); toe pads sit at higher y-values (upper part of icon)
let toes: [(CGFloat, CGFloat, CGFloat, CGFloat)] = [
    (192, 622, 162, 148),   // far-left
    (346, 694, 162, 148),   // centre-left
    (516, 694, 162, 148),   // centre-right
    (670, 622, 162, 148),   // far-right
]
for (x, y, w, h) in toes {
    ctx.fillEllipse(in: CGRect(x: x, y: y, width: w, height: h))
}

// ── Write PNG ─────────────────────────────────────────────────────────────
guard let img = ctx.makeImage() else { fatalError("Cannot make CGImage") }
let url = URL(fileURLWithPath: outPath)
guard let dst = CGImageDestinationCreateWithURL(
    url as CFURL, "public.png" as CFString, 1, nil
) else { fatalError("Cannot create image destination for \(outPath)") }
CGImageDestinationAddImage(dst, img, nil)
guard CGImageDestinationFinalize(dst) else { fatalError("Cannot finalize PNG") }
print("✅  App icon written → \(outPath)")
