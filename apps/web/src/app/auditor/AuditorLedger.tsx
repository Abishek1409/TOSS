export default function AuditorLedger() {
  const items = [
    { id: 't1', type: 'Donation', amount: '100 MATIC', hash: '0xabc...1' },
    { id: 't2', type: 'Disbursement', amount: '60 MATIC', hash: '0xabc...2' }
  ]
  return (
    <section>
      <h2>Ledger Summary</h2>
      <ul>
        {items.map(x => (
          <li key={x.id} style={{ display: 'flex', gap: 12 }}>
            <span>{x.type}</span>
            <span>{x.amount}</span>
            <span>{x.hash}</span>
          </li>
        ))}
      </ul>
    </section>
  )
}
