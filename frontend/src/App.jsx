import React, { useState, useEffect } from 'react'

// Backend base URL — set via env or fallback to window.location
const API_BASE = import.meta.env.VITE_API_BASE || `${window.location.origin}`

export default function App() {
  const [features, setFeatures] = useState('[[5.1,3.5,1.4,0.2]]')
  const [result, setResult] = useState(null)
  const [logs, setLogs] = useState([])
  const [error, setError] = useState('')

  async function doPredict() {
    setError('')
    try {
      const resp = await fetch(`${API_BASE}/api/predict`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ features: JSON.parse(features) })
      })
      if (!resp.ok) throw new Error(await resp.text())
      const data = await resp.json()
      setResult(data)
      loadLogs()
    } catch (e) {
      setError(String(e))
    }
  }

  async function loadLogs() {
    try {
      const resp = await fetch(`${API_BASE}/api/logs?limit=10`)
      const data = await resp.json()
      setLogs(data.logs || [])
    } catch (e) {
      // ignore
    }
  }

  useEffect(() => { loadLogs() }, [])

  return (
    <div style={{ fontFamily: 'system-ui', padding: 16, maxWidth: 900, margin: '0 auto' }}>
      <h1>FullStack Demo</h1>
      <p>Enter features as JSON list of lists, then Predict.</p>

      <textarea
        rows={6}
        style={{ width: '100%' }}
        value={features}
        onChange={e => setFeatures(e.target.value)}
      />
      <div style={{ marginTop: 8 }}>
        <button onClick={doPredict}>Predict</button>
        <a href={`${API_BASE}/health`} target="_blank" rel="noreferrer" style={{ marginLeft: 12 }}>Health</a>
        <a href={`${API_BASE}/metrics`} target="_blank" rel="noreferrer" style={{ marginLeft: 12 }}>Metrics</a>
        <a href={`${API_BASE}/docs`} target="_blank" rel="noreferrer" style={{ marginLeft: 12 }}>Docs</a>
      </div>

      {error && <pre style={{ color: 'crimson' }}>{error}</pre>}
      {result && <pre>{JSON.stringify(result, null, 2)}</pre>}

      <h3>Recent Logs</h3>
      <pre>{JSON.stringify(logs, null, 2)}</pre>
    </div>
  ); // ✅ properly close return
} // ✅ properly close function

