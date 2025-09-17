export default function Nav() {
  return (
    <nav style={{ display: 'flex', gap: 12, padding: 12, borderBottom: '1px solid #eee' }}>
      <a href="/">Home</a>
      <a href="/donor">Donor</a>
      <a href="/admin">Admin</a>
      <a href="/doctor">Doctor</a>
      <a href="/auditor">Auditor</a>
    </nav>
  );
}
