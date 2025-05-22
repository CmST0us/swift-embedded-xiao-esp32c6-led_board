# ESP32-C6 LED Matrix Controller

[![Swift](https://img.shields.io/badge/Swift-6.1-orange.svg)](https://swift.org)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![ESP32-C6](https://img.shields.io/badge/ESP32--C6-ESP32C6-green.svg)](https://www.espressif.com/en/products/socs/esp32-c6)

A Swift-based LED matrix controller for ESP32-C6, featuring multiple stunning animation effects. This project demonstrates the power of Swift in embedded systems development.

## ✨ Features

- 🎨 Multiple animation effects:
  - Rainbow wave effect with smooth color transitions
  - Matrix rain effect (Matrix-style)
  - Spiral pattern with color cycling
- ⚡ Smooth animation transitions
- 🛠️ Modern Swift codebase
- 📱 10x6 LED matrix support

## 🛠️ Hardware Requirements

- Seeed XIAO ESP32C6 board
- WS2812B LED strip (60 LEDs)
- 5V power supply
- Data wire (connected to GPIO0)

## 📊 LED Matrix Layout

```
0  1  2  3  4  5
6  7  8  9  10 11
12 13 14 15 16 17
18 19 20 21 22 23
24 25 26 27 28 29
30 31 32 33 34 35
36 37 38 39 40 41
42 43 44 45 46 47
48 49 50 51 52 53
54 55 56 57 58 59
```

## 🚀 Getting Started

### Prerequisites

- Swift 6.1 or later
- ESP-IDF (Espressif IoT Development Framework)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/CmST0us/swift-embedded-xiao-esp32c6-led_board.git
cd swift-embedded-xiao-esp32c6-led_board
```

2. Install dependencies:
```bash
idf.py set-target esp32c6
```

3. Build the project:
```bash
idf.py build
```

4. Flash to ESP32-C6:
```bash
idf.py flash
```

## 💻 Usage

1. Hardware Setup:
   - Connect the LED strip data wire to GPIO0
   - Ensure proper 5V power supply

2. Running the Program:
   - The program automatically starts and cycles through animations
   - Each effect has a 500ms transition delay

## 🎨 Customization

You can customize the animations by modifying `Main.swift`:

### Adjusting Brightness
```swift
// Current brightness setting (5)
ledStrip.setPixel(index: i, r: 5, g: 5, b: 5)
```

### Modifying Animation Speed
```swift
// Current delay between frames (50ms)
delay_ms(50)
```

### Adding New Effects
Create a new function following the pattern:
```swift
func newEffect(ledStrip: LEDStrip) {
    // Your animation code here
}
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [ESP32-C6 Development Team](https://www.espressif.com)
- [Swift Embedded Development Community](https://swift.org)
- [WS2812B LED Strip Manufacturers](https://www.worldsemi.com)

## 📫 Contact

Project Link: [https://github.com/CmST0us/swift-embedded-xiao-esp32c6-led_board](https://github.com/CmST0us/swift-embedded-xiao-esp32c6-led_board) 