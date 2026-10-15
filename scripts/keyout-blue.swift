// 青地に白文字の画像から、青を透明にして白文字だけの PNG を作る: swift keyout-blue.swift <in> <out.png>
import Foundation
import CoreGraphics
import ImageIO
import UniformTypeIdentifiers
let a = CommandLine.arguments
guard a.count == 3, let src = CGImageSourceCreateWithURL(URL(fileURLWithPath: a[1]) as CFURL, nil), let img = CGImageSourceCreateImageAtIndex(src, 0, nil) else { print("usage"); exit(1) }
let w = img.width, h = img.height
let cs = CGColorSpaceCreateDeviceRGB()
guard let ctx = CGContext(data: nil, width: w, height: h, bitsPerComponent: 8, bytesPerRow: w * 4, space: cs, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else { exit(2) }
ctx.draw(img, in: CGRect(x: 0, y: 0, width: w, height: h))
guard let data = ctx.data else { exit(3) }
let p = data.bindMemory(to: UInt8.self, capacity: w * h * 4)
for i in 0..<(w * h) {
  let r = Double(p[i*4]), g = Double(p[i*4+1]), b = Double(p[i*4+2])
  // 明るさ (白さ) をアルファにする: 白=不透明、青=透明。中間はアンチエイリアス
  let lum = (0.299*r + 0.587*g + 0.114*b)
  let lo = 90.0, hi = 230.0
  var alpha = (lum - lo) / (hi - lo); if alpha < 0 { alpha = 0 }; if alpha > 1 { alpha = 1 }
  let A = UInt8(alpha * 255)
  p[i*4] = A; p[i*4+1] = A; p[i*4+2] = A; p[i*4+3] = A  // premultiplied white
}
guard let out = ctx.makeImage(), let dest = CGImageDestinationCreateWithURL(URL(fileURLWithPath: a[2]) as CFURL, UTType.png.identifier as CFString, 1, nil) else { exit(4) }
CGImageDestinationAddImage(dest, out, nil); CGImageDestinationFinalize(dest); print("ok \(w)x\(h)")
