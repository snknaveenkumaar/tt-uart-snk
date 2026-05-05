## How it works

This design is a simple UART-controlled multi-channel PWM generator.

A UART receiver listens for incoming bytes using a standard 8N1 protocol.
Each PWM update consists of two bytes:
- The first byte selects the channel (0–6)
- The second byte sets the duty cycle (0–255)

Internally, a small state machine tracks these two steps:
- First byte → store channel index
- Second byte → update the selected PWM register

Each PWM channel is generated using a shared 8-bit counter:
- The counter continuously increments from 0 to 255
- Each output compares the counter against its stored duty value
- If `counter < duty`, the output is HIGH, otherwise LOW

This produces a clean PWM signal for each channel, all running in parallel.

Whenever a byte is received, the UART transmitter sends back `0xAA`
as a simple acknowledgment signal.

The entire design is fully synchronous and uses minimal logic,
making it compact and reliable for silicon implementation.

---

## How to test

1. Connect a UART source (USB-to-UART, microcontroller, etc.) to `ui_in[0]`
2. Set the clock to 50 MHz
3. Assert and release reset (`rst_n`)
4. Set `ui_in[1] = 1` to enable the controller

Now send UART data:

- Send two bytes:
