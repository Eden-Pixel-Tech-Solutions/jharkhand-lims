import serial

PORT = "/dev/cu.usbserial-FTB6SPL3"

try:
    ser = serial.Serial(PORT, 9600)
    print("✅ Connected successfully")

    while True:
        data = ser.read(100)
        if data:
            print("📥", data)

except Exception as e:
    print("❌ Error:", e)