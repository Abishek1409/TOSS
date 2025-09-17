export default function AdminCampaigns() {
  const items = [
    { id: 'c1', name: 'Education 2025', goal: '10,000 MATIC', raised: '4,200 MATIC' },
    { id: 'c2', name: 'Health 2025', goal: '8,000 MATIC', raised: '2,500 MATIC' }
  ]
  return (
    <section>
      <h2>Campaigns</h2>
      <table>
        <thead><tr><th>Name</th><th>Goal</th><th>Raised</th></tr></thead>
        <tbody>
          {items.map(x => (
            <tr key={x.id}><td>{x.name}</td><td>{x.goal}</td><td>{x.raised}</td></tr>
          ))}
        </tbody>
      </table>
    </section>
  )
}
