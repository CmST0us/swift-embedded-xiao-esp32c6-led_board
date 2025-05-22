
public class LEDStrip {
    
    public enum FormatLayout {
        case grb
        case grbw
        case rgb
        case rgbw
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
    
    private let ledStrip: led_strip_handle_t?

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
    
    @discardableResult
    public func setPixel(index: UInt32, r: UInt32, g: UInt32, b: UInt32, w: UInt32 = 0) -> esp_err_t {
        return led_strip_set_pixel_rgbw(ledStrip, index, r, g, b, w)
    }

    @discardableResult
    public func setPixel(index: UInt32, h: UInt16, s: UInt8, v: UInt8) -> esp_err_t {
        return led_strip_set_pixel_hsv(ledStrip, index, h, s, v)
    }

    @discardableResult
    public func setPixel(index: UInt32, r: UInt32, g: UInt32, b: UInt32) -> esp_err_t {
        return led_strip_set_pixel(ledStrip, index, r, g, b)
    }   

    public func refresh() {
        led_strip_refresh(ledStrip)
    }
}