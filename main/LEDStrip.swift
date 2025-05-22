/// A class that manages LED strip operations for ESP32-C6.
///
/// This class provides a high-level interface for controlling LED strips using the ESP32-C6's RMT peripheral.
/// It supports various LED models, color formats, and configuration options.
public class LEDStrip {
    
    /// Defines the color component format for the LED strip.
    ///
    /// The format determines how the RGB(W) values are mapped to the LED strip's data format.
    public enum FormatLayout {
        /// Green-Red-Blue format (3 components)
        case grb
        /// Green-Red-Blue-White format (4 components)
        case grbw
        /// Red-Green-Blue format (3 components)
        case rgb
        /// Red-Green-Blue-White format (4 components)
        case rgbw
        /// Custom format with specified component positions
        case custom(r: UInt32, g: UInt32, b: UInt32, w: UInt32)

        var rawValue: led_color_component_format_t {
            switch self {
            case .grb:
                return led_color_component_format_t(format: format_layout(r_pos: 0, g_pos: 1, b_pos: 2, w_pos: 3, reserved: 0, num_components: 3))
            case .grbw:
                return led_color_component_format_t(format: format_layout(r_pos: 0, g_pos: 1, b_pos: 2, w_pos: 3, reserved: 0, num_components: 4))
            case .rgb:
                return led_color_component_format_t(format: format_layout(r_pos: 0, g_pos: 1, b_pos: 2, w_pos: 3, reserved: 0, num_components: 3))
            case .rgbw:
                return led_color_component_format_t(format: format_layout(r_pos: 0, g_pos: 1, b_pos: 2, w_pos: 3, reserved: 0, num_components: 4))
            case .custom(let r, let g, let b, let w):
                return led_color_component_format_t(format: format_layout(r_pos: r, g_pos: g, b_pos: b, w_pos: w, reserved: 0, num_components: 4))
            }
        }
    }
    
    /// The handle to the underlying LED strip device
    private let ledStrip: led_strip_handle_t?

    /// Initializes a new LED strip controller.
    ///
    /// - Parameters:
    ///   - gpioPin: The GPIO pin number to use for the LED strip data line
    ///   - maxLEDs: The maximum number of LEDs in the strip
    ///   - ledModel: The LED model type (default: WS2812)
    ///   - formatLayout: The color component format (default: GRB)
    ///   - invertOut: Whether to invert the output signal (default: false)
    ///   - resolutionHz: The RMT resolution in Hz (default: 10MHz)
    ///   - withDMA: Whether to use DMA for data transfer (default: false)
    public init(gpioPin: gpio_num_t, maxLEDs: UInt32, ledModel: led_model_t = LED_MODEL_WS2812, 
                formatLayout: FormatLayout = .grb, invertOut: Bool = false, resolutionHz: UInt32 = 10 * 1000 * 1000, withDMA: Bool = false) {
        var led_strip_config = led_strip_config_t(
            strip_gpio_num: gpioPin.rawValue,
            max_leds: maxLEDs,
            led_model: ledModel,
            color_component_format: formatLayout.rawValue,
            flags: led_strip_extra_flags(invert_out: invertOut ? 1 : 0)
        )

        var rmt_config = led_strip_rmt_config_t(
            clk_src: RMT_CLK_SRC_DEFAULT,
            resolution_hz: resolutionHz,
            mem_block_symbols: 0,
            flags: led_strip_rmt_extra_config(with_dma: withDMA ? 1 : 0)
        )
        
        var ledStrip: led_strip_handle_t?
        led_strip_new_rmt_device(&led_strip_config, &rmt_config, &ledStrip)

        self.ledStrip = ledStrip
    }
    
    /// Sets the color of a single LED using RGBW values.
    ///
    /// - Parameters:
    ///   - index: The index of the LED to set
    ///   - r: Red component (0-255)
    ///   - g: Green component (0-255)
    ///   - b: Blue component (0-255)
    ///   - w: White component (0-255, default: 0)
    /// - Returns: ESP error code
    @discardableResult
    public func setPixel(index: UInt32, r: UInt32, g: UInt32, b: UInt32, w: UInt32 = 0) -> esp_err_t {
        return led_strip_set_pixel_rgbw(ledStrip, index, r, g, b, w)
    }

    /// Sets the color of a single LED using HSV values.
    ///
    /// - Parameters:
    ///   - index: The index of the LED to set
    ///   - h: Hue value (0-360)
    ///   - s: Saturation value (0-255)
    ///   - v: Value/Brightness (0-255)
    /// - Returns: ESP error code
    @discardableResult
    public func setPixel(index: UInt32, h: UInt16, s: UInt8, v: UInt8) -> esp_err_t {
        return led_strip_set_pixel_hsv(ledStrip, index, h, s, v)
    }

    /// Sets the color of a single LED using RGB values.
    ///
    /// - Parameters:
    ///   - index: The index of the LED to set
    ///   - r: Red component (0-255)
    ///   - g: Green component (0-255)
    ///   - b: Blue component (0-255)
    /// - Returns: ESP error code
    @discardableResult
    public func setPixel(index: UInt32, r: UInt32, g: UInt32, b: UInt32) -> esp_err_t {
        return led_strip_set_pixel(ledStrip, index, r, g, b)
    }   

    /// Refreshes the LED strip, sending the current color values to all LEDs.
    public func refresh() {
        led_strip_refresh(ledStrip)
    }
}