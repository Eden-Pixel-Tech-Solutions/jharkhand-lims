import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import axios from "axios";

const API_BASE = 'https://lims.poxiatechnologies.com';

const ShortcutCard = ({ title, icon, desc, onClick, color, borderColor }) => (
    <div 
        onClick={onClick}
        style={{
            background: color,
            border: `1px solid ${borderColor}`,
            borderRadius: '16px',
            padding: '16px',
            cursor: 'pointer',
            transition: 'all 0.2s',
            boxShadow: '0 1px 2px rgba(0,0,0,0.05)',
            display: 'flex',
            flexDirection: 'column',
            gap: '4px'
        }}
        onMouseEnter={e => { e.currentTarget.style.transform = 'translateY(-2px)'; e.currentTarget.style.boxShadow = '0 4px 6px rgba(0,0,0,0.1)'; }}
        onMouseLeave={e => { e.currentTarget.style.transform = 'translateY(0)'; e.currentTarget.style.boxShadow = '0 1px 2px rgba(0,0,0,0.05)'; }}
    >
        <div style={{ fontSize: '24px', marginBottom: '4px' }}>{icon}</div>
        <div style={{ fontWeight: '800', color: '#1e293b', fontSize: '15px' }}>{title}</div>
        <div style={{ fontSize: '12px', color: '#64748b' }}>{desc}</div>
    </div>
);

export default function Dashboard() {
    const navigate = useNavigate();
    const [machines, setMachines] = useState([]);
    const [selectedMachine, setSelectedMachine] = useState(null);
    const [isListening, setIsListening] = useState(false);
    const [logs, setLogs] = useState([]);
    const [testResults, setTestResults] = useState([]);
    const [showPicker, setShowPicker] = useState(false);

    const [localIp, setLocalIp] = useState("");

    // Incoming data from serialManager
    useEffect(() => {
        fetchMachines();
        window.electronAPI.getLocalIp().then(setLocalIp);
        const cleanup = window.electronAPI.onTestCompleted((data) => {
            console.log("Test Completed Data:", data);
            setTestResults(prev => [data, ...prev]);
            setLogs(prev => [`[${data.test_name}] Result: ${data.result_value} ${data.unit}`, ...prev]);
        });
        return cleanup;
    }, []);

    const fetchMachines = async () => {
        const configs = await window.electronAPI.getConfig();
        setMachines(Array.isArray(configs) ? configs : []);
        if (configs && configs.length === 1) {
            setSelectedMachine(configs[0]);
        }
    };

    const handleToggleListening = async () => {
        if (isListening) {
            await window.electronAPI.stopListening();
            setIsListening(false);
            setLogs(prev => ["🔴 Stopped listening", ...prev]);
        } else {
            if (!selectedMachine && machines.length > 1) {
                setShowPicker(true);
                return;
            }

            const machineToUse = selectedMachine || machines[0];
            if (!machineToUse) {
                alert("Please configure a machine in Setup first.");
                return;
            }

            startEngine(machineToUse);
        }
    };

    const startEngine = async (machine) => {
        setLogs(prev => [`🔵 Starting listener on ${machine.port}...`, ...prev]);
        const success = await window.electronAPI.startListening({
            port: machine.port,
            baud: machine.baud,
            machineId: machine.id
        });

        if (success) {
            setIsListening(true);
            setSelectedMachine(machine);
            setShowPicker(false);
        } else {
            alert("Failed to open port. Check connection.");
        }
    };

    return (
        <div style={{ padding: '24px', maxWidth: '1200px', margin: '0 auto' }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: '32px' }}>
                <div>
                    <h1 style={{ fontSize: '28px', fontWeight: '900', color: '#0f172a', margin: 0 }}>Laboratory Dashboard</h1>
                    <p style={{ color: '#64748b', marginTop: '4px' }}>
                        {selectedMachine ? `Connected to ${selectedMachine.unique_id} (${selectedMachine.model})` : 'No analyzer selected'}
                    </p>
                    <p style={{ color: '#2563eb', fontWeight: '600', marginTop: '4px', fontSize: '14px' }}>
                        LIS Server IP (for Wi-Fi Analyzers): {localIp}
                    </p>
                </div>

                <button
                    onClick={handleToggleListening}
                    style={{
                        padding: '12px 28px',
                        background: isListening ? '#ef4444' : '#2563eb',
                        color: 'white',
                        border: 'none',
                        borderRadius: '12px',
                        fontWeight: '800',
                        cursor: 'pointer',
                        boxShadow: '0 4px 6px -1px rgba(0,0,0,0.1)'
                    }}
                >
                    {isListening ? '⏹ Stop Capture' : '▶ Start Capture'}
                </button>
            </div>

            {/* Quick Actions Shortcuts */}
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: '16px', marginBottom: '24px' }}>
                <ShortcutCard title="Worklist" icon="📋" desc="Manage pending tests" onClick={() => navigate('/worklist')} color="#eff6ff" borderColor="#bfdbfe" />
                <ShortcutCard title="Sample List" icon="🧪" desc="View patient samples" onClick={() => navigate('/sample-list')} color="#f0fdf4" borderColor="#bbf7d0" />
                <ShortcutCard title="Analyzer Setup" icon="⚙️" desc="Configure machines" onClick={() => navigate('/setup')} color="#fff7ed" borderColor="#fed7aa" />
                <ShortcutCard title="Reports" icon="📊" desc="Generate lab reports" onClick={() => navigate('/reports')} color="#faf5ff" borderColor="#e9d5ff" />
            </div>



            {/* Machine Picker Modal */}
            {showPicker && (
                <div style={{ position: 'fixed', top: 0, left: 0, right: 0, bottom: 0, background: 'rgba(0,0,0,0.6)', backdropFilter: 'blur(4px)', display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 1000 }}>
                    <div style={{ background: 'white', padding: '32px', borderRadius: '24px', width: '450px', boxShadow: '0 20px 25px -5px rgba(0,0,0,0.1)' }}>
                        <h2 style={{ margin: '0 0 8px 0', fontSize: '24px', fontWeight: '900' }}>Select Analyzer</h2>
                        <p style={{ color: '#64748b', marginBottom: '24px' }}>Multiple machines detected. Which one are you running?</p>

                        <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
                            {machines.map(m => (
                                <button
                                    key={m.id}
                                    onClick={() => startEngine(m)}
                                    style={{
                                        padding: '16px', borderRadius: '12px', border: '2.5px solid #f1f5f9', background: 'white', textAlign: 'left', cursor: 'pointer', transition: 'all 0.2s',
                                        ':hover': { borderColor: '#2563eb', background: '#eff6ff' }
                                    }}
                                    onMouseOver={(e) => { e.currentTarget.style.borderColor = '#2563eb'; e.currentTarget.style.background = '#eff6ff'; }}
                                    onMouseOut={(e) => { e.currentTarget.style.borderColor = '#f1f5f9'; e.currentTarget.style.background = 'white'; }}
                                >
                                    <div style={{ fontWeight: '800', color: '#1e293b' }}>{m.unique_id}</div>
                                    <div style={{ fontSize: '12px', color: '#64748b' }}>{m.manufacturer} {m.model} • {m.port}</div>
                                </button>
                            ))}
                        </div>

                        <button
                            onClick={() => setShowPicker(false)}
                            style={{ width: '100%', marginTop: '20px', padding: '12px', background: '#f1f5f9', border: 'none', borderRadius: '10px', fontWeight: '700', color: '#475569', cursor: 'pointer' }}
                        >
                            Cancel
                        </button>
                    </div>
                </div>
            )}
        </div>
    );
}