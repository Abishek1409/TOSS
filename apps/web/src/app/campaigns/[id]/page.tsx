"use client";
import { useState } from "react";

export default function Page({ params }: { params: { id: string } }) {
  const { id } = params;
  const c = { id, name: id === '1' ? 'Education 2025' : 'Health 2025', goal: '10,000 MATIC', raised: '4,200 MATIC', description: 'Supporting tuition and supplies.' };
  const [amount, setAmount] = useState('');
  const [status, setStatus] = useState<string | null>(null);

  const onSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!amount) return;
    setStatus(`Simulated donation of ${amount} MATIC submitted!`);
    setAmount('');
  };

  return (
    <main style={{ padding: 20 }}>
      <h1>{c.name}</h1>
      <p>{c.description}</p>
      <p><strong>Raised:</strong> {c.raised} / <strong>Goal:</strong> {c.goal}</p>

      <section style={{ marginTop: 24 }}>
        <h2>Donate</h2>
        <form onSubmit={onSubmit} style={{ display: 'flex', gap: 12 }}>
          <input
            type="number"
            step="0.01"
            min="0"
            placeholder="Amount (MATIC)"
            value={amount}
            onChange={(e) => setAmount(e.target.value)}
          />
          <button type="submit">Donate</button>
        </form>
        {status && (
          <p style={{ color: 'green', marginTop: 12 }}>{status}</p>
        )}
      </section>
    </main>
  );
}
