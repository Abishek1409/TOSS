import type { Metadata } from 'next'
import './globals.css'
import Nav from './Nav'

export const metadata: Metadata = {
  title: 'TOSS',
  description: 'Transparent Orphanage Support System'
}

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>
        <Nav />
        {children}
      </body>
    </html>
  )
}
