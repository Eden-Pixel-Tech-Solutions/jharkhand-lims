import { useState, useEffect, useMemo } from 'react';

function MasterSheet() {
  const [sheet, setSheet] = useState({});
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [search, setSearch] = useState('');
  const [selectedMachine, setSelectedMachine] = useState('all');

  useEffect(() => {
    window.electronAPI.getMasterSheet()
      .then((data) => setSheet(data || {}))
      .catch((err) => {
        console.error('Failed to load master sheet', err);
        setError('Could not load the master sheet.');
      })
      .finally(() => setLoading(false));
  }, []);

  const machines = Object.keys(sheet);

  const rows = useMemo(() => {
    const q = search.trim().toLowerCase();
    const list = [];
    for (const machine of machines) {
      if (selectedMachine !== 'all' && machine !== selectedMachine) continue;
      for (const row of sheet[machine] || []) {
        if (q && !row.code.toLowerCase().includes(q) && !row.name.toLowerCase().includes(q)) continue;
        list.push({ machine, ...row });
      }
    }
    return list;
  }, [sheet, machines, search, selectedMachine]);

  return (
    <div style={{ padding: '40px', background: '#f8fafc', minHeight: '100vh' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: '32px', flexWrap: 'wrap', gap: '16px' }}>
        <div>
          <h1 style={{ fontSize: '28px', fontWeight: '900', color: '#0f172a', margin: 0 }}>Master Sheet</h1>
          <p style={{ color: '#64748b', fontSize: '15px', marginTop: '4px' }}>
            Reference table of the numeric/code values each analyzer sends for each parameter — use this to program new machines correctly.
          </p>
        </div>
        <div className="no-print" style={{ display: 'flex', gap: '12px' }}>
          <select
            value={selectedMachine}
            onChange={(e) => setSelectedMachine(e.target.value)}
            style={{ padding: '10px 14px', border: '1px solid #e2e8f0', borderRadius: '10px', fontSize: '14px', background: '#fff' }}
          >
            <option value="all">All Machines</option>
            {machines.map((m) => <option key={m} value={m}>{m}</option>)}
          </select>
          <div style={{ display: 'flex', background: '#fff', border: '1px solid #e2e8f0', borderRadius: '10px', padding: '4px 12px', alignItems: 'center', width: '260px' }}>
            <span style={{ fontSize: '14px', color: '#64748b', marginRight: '8px' }}>🔍</span>
            <input
              type="text"
              placeholder="Search code or parameter..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              style={{ border: 'none', outline: 'none', fontSize: '14px', padding: '8px 0', width: '100%' }}
            />
          </div>
          <button
            onClick={() => window.print()}
            style={{ padding: '10px 18px', border: '1px solid #2563eb', borderRadius: '10px', fontSize: '14px', fontWeight: '700', background: '#2563eb', color: '#fff', cursor: 'pointer', display: 'flex', alignItems: 'center', gap: '8px' }}
          >
            🖨️ Print
          </button>
        </div>
      </div>

      <div style={{ background: '#fff', borderRadius: '16px', border: '1px solid #e2e8f0', overflow: 'hidden' }}>
        <table style={{ width: '100%', borderCollapse: 'collapse', textAlign: 'left' }}>
          <thead>
            <tr style={{ background: '#f8fafc', borderBottom: '1px solid #e2e8f0' }}>
              <th style={{ padding: '16px 24px', fontSize: '12px', fontWeight: '700', color: '#64748b', textTransform: 'uppercase' }}>Machine</th>
              <th style={{ padding: '16px 24px', fontSize: '12px', fontWeight: '700', color: '#64748b', textTransform: 'uppercase' }}>Code / Number</th>
              <th style={{ padding: '16px 24px', fontSize: '12px', fontWeight: '700', color: '#64748b', textTransform: 'uppercase' }}>Parameter Name</th>
            </tr>
          </thead>
          <tbody>
            {loading ? (
              <tr><td colSpan="3" style={{ padding: '40px', textAlign: 'center' }}>Loading master sheet...</td></tr>
            ) : error ? (
              <tr><td colSpan="3" style={{ padding: '40px', textAlign: 'center', color: '#dc2626' }}>{error}</td></tr>
            ) : rows.length === 0 ? (
              <tr><td colSpan="3" style={{ padding: '40px', textAlign: 'center' }}>No matching entries.</td></tr>
            ) : (
              rows.map((row, i) => (
                <tr key={`${row.machine}-${row.code}-${i}`} style={{ borderBottom: '1px solid #f1f5f9' }}>
                  <td style={{ padding: '14px 24px', fontSize: '13px', color: '#64748b', fontWeight: '600' }}>{row.machine}</td>
                  <td style={{ padding: '14px 24px', fontWeight: '800', color: '#2563eb', fontFamily: 'monospace' }}>{row.code}</td>
                  <td style={{ padding: '14px 24px', fontWeight: '700', color: '#0f172a' }}>{row.name}</td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>

      <style>{`
        @media print {
          .no-print { display: none !important; }
          html, body, #root, main { height: auto !important; overflow: visible !important; }
        }
      `}</style>
    </div>
  );
}

export default MasterSheet;
