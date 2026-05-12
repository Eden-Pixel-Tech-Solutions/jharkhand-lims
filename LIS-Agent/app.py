import tkinter as tk
from tkinter import ttk, messagebox
import json
import threading
import serial
import struct
import requests
import os

CONFIG_FILE = "config.json"
running = False

# ======================
# LOAD / SAVE CONFIG
# ======================
def load_config():
    if os.path.exists(CONFIG_FILE):
        with open(CONFIG_FILE) as f:
            return json.load(f)
    return []

def save_config(data):
    with open(CONFIG_FILE, "w") as f:
        json.dump(data, f, indent=2)

analyzers = load_config()

# ======================
# SERIAL LISTENER
# ======================
def serial_listener(config):
    global running
    try:
        ser = serial.Serial(config["port"], config["baud"], timeout=1)
        buffer = bytearray()

        log("🔌 Listening...")

        while running:
            if ser.in_waiting:
                buffer += ser.read(ser.in_waiting)

                if 0xAA in buffer and 0xF5 in buffer:
                    start = buffer.index(0xAA)
                    end = buffer.index(0xF5)
                    frame = buffer[start:end+1]

                    data = parse_data(frame)
                    if data:
                        log(f"✅ {data}")
                        send_to_server(config["server"], data)

                    buffer = bytearray()
    except Exception as e:
        log(f"❌ Error: {e}")

# ======================
# PARSER
# ======================
def parse_data(frame):
    try:
        return {
            "test_code": frame[1],
            "patient_id": frame[3:9].decode(),
            "result": struct.unpack('>f', frame[9:13])[0]
        }
    except:
        return None

# ======================
# SEND
# ======================
def send_to_server(url, data):
    try:
        requests.post(url, json=data)
        log("🚀 Sent to server")
    except:
        log("❌ Send failed")

# ======================
# UI FUNCTIONS
# ======================
def add_analyzer():
    data = {
        "name": name_var.get(),
        "type": type_var.get(),
        "port": port_var.get(),
        "baud": int(baud_var.get()),
        "server": server_var.get()
    }

    analyzers.append(data)
    save_config(analyzers)
    refresh_list()

def refresh_list():
    listbox.delete(0, tk.END)
    for a in analyzers:
        listbox.insert(tk.END, a["name"])

def start():
    global running
    if running:
        return

    selected = listbox.curselection()
    if not selected:
        messagebox.showerror("Error", "Select analyzer")
        return

    config = analyzers[selected[0]]
    running = True

    log(f"▶ Starting {config['name']}")

    threading.Thread(target=serial_listener, args=(config,), daemon=True).start()

def stop():
    global running
    running = False
    log("⏹ Stopped")

def log(msg):
    log_box.insert(tk.END, msg + "\n")
    log_box.see(tk.END)

# ======================
# UI LAYOUT
# ======================
root = tk.Tk()
root.title("LIS Agent")
root.geometry("600x500")

# Add analyzer form
tk.Label(root, text="Add Analyzer").pack()

name_var = tk.StringVar()
type_var = tk.StringVar(value="CliniQuant Micro")
port_var = tk.StringVar()
baud_var = tk.StringVar(value="9600")
server_var = tk.StringVar(value="http://localhost:3000/api")

tk.Entry(root, textvariable=name_var).pack()
tk.Entry(root, textvariable=port_var).pack()
tk.Entry(root, textvariable=baud_var).pack()
tk.Entry(root, textvariable=server_var).pack()

tk.Button(root, text="Add Analyzer", command=add_analyzer).pack()

# List
listbox = tk.Listbox(root)
listbox.pack(fill="x")

# Buttons
tk.Button(root, text="Start", command=start).pack()
tk.Button(root, text="Stop", command=stop).pack()

# Logs
log_box = tk.Text(root)
log_box.pack(fill="both", expand=True)

refresh_list()

root.mainloop()