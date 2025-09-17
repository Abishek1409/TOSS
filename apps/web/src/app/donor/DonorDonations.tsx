export default function DonorDonations() {
  const items = [
    { id: 'd1', campaign: 'Education', amount: '100 MATIC', date: '2025-09-01' },
    { id: 'd2', campaign: 'Health', amount: '50 MATIC', date: '2025-09-10' }
  ]
  return (
    <section>
      <h2>My Donations</h2>
      <ul>
        {items.map(x => (
          <li key={x.id} style={{ display: 'flex', gap: 12 }}>
            <span>{x.campaign}</span>
            <span>{x.amount}</span>
            <span>{x.date}</span>
          </li>
        ))}
      </ul>
    </section>
  )
}
