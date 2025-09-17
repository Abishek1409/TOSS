import AuditorLedger from './AuditorLedger'
export default function Page() {
  return (
    <main style={{ padding: 20 }}>
      <h1>Auditor Dashboard</h1>
      <p>Review immutable donation and disbursement records.</p>
      <AuditorLedger />    </main>
  )
}


