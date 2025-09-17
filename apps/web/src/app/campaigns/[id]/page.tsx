export default function Page({ params }: { params: { id: string } }) {
  const { id } = params;
  const c = { id, name: id === '1' ? 'Education 2025' : 'Health 2025', goal: '10,000 MATIC', raised: '4,200 MATIC', description: 'Supporting tuition and supplies.' };
  return (
    <main style={{ padding: 20 }}>
      <h1>{c.name}</h1>
      <p>{c.description}</p>
      <p><strong>Raised:</strong> {c.raised} / <strong>Goal:</strong> {c.goal}</p>
      <button>Donate</button>
    </main>
  );
}
