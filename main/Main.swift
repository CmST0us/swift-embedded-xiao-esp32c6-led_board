//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift open source project
//
// Copyright (c) 2024 Apple Inc. and the Swift project authors.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
//
//===----------------------------------------------------------------------===//

// 彩虹波浪效果
func rainbowWave(ledStrip: LEDStrip) {
    for offset in 0..<60 {
        for i: UInt32 in 0..<60 {
            let hue = (Float(i) + Float(offset)) / 60.0
            let (r, g, b) = hsvToRgb(h: hue, s: 1.0, v: 0.02)
            ledStrip.setPixel(index: i, r: UInt32(r * 255), g: UInt32(g * 255), b: UInt32(b * 255))
        }
        ledStrip.refresh()
        delay_ms(50)
    }
}

// 矩阵雨效果
func matrixRain(ledStrip: LEDStrip) {
    var drops = [Int](repeating: 0, count: 6)
    
    for _ in 0..<100 {
        // 更新每个雨滴
        for col in 0..<6 {
            if drops[col] >= 10 {
                drops[col] = 0
            }
            
            // 清除旧位置
            if drops[col] > 0 {
                let pos = (drops[col] - 1) * 6 + col
                ledStrip.setPixel(index: UInt32(pos), r: 0, g: 0, b: 0)
            }
            
            // 设置新位置
            let pos = drops[col] * 6 + col
            ledStrip.setPixel(index: UInt32(pos), r: 0, g: 5, b: 0)
            
            drops[col] += 1
        }
        ledStrip.refresh()
        delay_ms(100)
    }
}

// 螺旋效果
func spiralEffect(ledStrip: LEDStrip) {
    let colors: [(UInt32, UInt32, UInt32)] = [
        (5, 0, 0),    // 红
        (0, 5, 0),    // 绿
        (0, 0, 5),    // 蓝
        (5, 5, 0),    // 黄
        (5, 0, 5),    // 紫
        (0, 5, 5)     // 青
    ]
    
    for _ in 0..<3 {
        for colorIndex in 0..<colors.count {
            let (r, g, b) = colors[colorIndex]
            for row in 0..<10 {
                for col in 0..<6 {
                    let pos = row * 6 + col
                    if (row + col) % colors.count == colorIndex {
                        ledStrip.setPixel(index: UInt32(pos), r: r, g: g, b: b)
                    } else {
                        ledStrip.setPixel(index: UInt32(pos), r: 0, g: 0, b: 0)
                    }
                }
            }
            ledStrip.refresh()
            delay_ms(200)
        }
    }
}

// HSV转RGB辅助函数
func hsvToRgb(h: Float, s: Float, v: Float) -> (Float, Float, Float) {
    let i = Int(h * 6)
    let f = h * 6 - Float(i)
    let p = v * (1 - s)
    let q = v * (1 - f * s)
    let t = v * (1 - (1 - f) * s)
    
    switch i % 6 {
    case 0: return (v, t, p)
    case 1: return (q, v, p)
    case 2: return (p, v, t)
    case 3: return (p, q, v)
    case 4: return (t, p, v)
    case 5: return (v, p, q)
    default: return (0, 0, 0)
    }
}

@_cdecl("app_main")
func main() {
    print("Hello from Swift on ESP32-C6!")

    print("Starting LED strip")
    let ledStrip = LEDStrip(gpioPin: GPIO_NUM_0, maxLEDs: 60)
    print("LED strip created")

    while true {
        // 彩虹波浪效果
        rainbowWave(ledStrip: ledStrip)
        delay_ms(500)
        
        // 矩阵雨效果
        matrixRain(ledStrip: ledStrip)
        delay_ms(500)
        
        // 螺旋效果
        spiralEffect(ledStrip: ledStrip)
        delay_ms(500)
    }
}
