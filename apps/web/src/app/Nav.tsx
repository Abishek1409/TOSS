import Link from "next/link";

export default function Nav() {
  return (
    <nav style={{ display: 'flex', gap: 12, padding: 12, borderBottom: '1px solid #eee' }}>
      <Link href="/">Home</Link>
      <Link href="/donor">Donor</Link>
      <Link href="/admin">Admin</Link>
      <Link href="/doctor">Doctor</Link>
      <Link href="/auditor">Auditor</Link>
    </nav>
  );
}
