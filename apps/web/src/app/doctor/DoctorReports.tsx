export default function DoctorReports() {
  const items = [
    { id: 'r1', child: 'C-001', cid: 'bafy...1', status: 'Pending' },
    { id: 'r2', child: 'C-014', cid: 'bafy...2', status: 'Pending' }
  ]
  return (
    <section>
      <h2>Reports to Verify</h2>
      <ul>
        {items.map(x => (
          <li key={x.id} style={{ display: 'flex', gap: 12 }}>
            <span>{x.child}</span>
            <span>{x.cid}</span>
            <span>{x.status}</span>
            <button>Sign</button>
          </li>
        ))}
      </ul>
    </section>
  )
}
