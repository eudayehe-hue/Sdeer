"use client";

import { useState } from "react";

export default function Home() {
  const [menuOpen, setMenuOpen] = useState(false);

  return (
    <main className="min-h-screen bg-[#0a0a0f] text-white overflow-x-hidden">
      {/* Navbar */}
      <nav className="fixed top-0 left-0 right-0 z-50 bg-[#0a0a0f]/80 backdrop-blur-md border-b border-white/5">
        <div className="max-w-7xl mx-auto px-6 py-4 flex items-center justify-between">
          <div className="flex items-center gap-2">
            <div className="w-8 h-8 rounded-lg bg-gradient-to-br from-violet-500 to-indigo-600 flex items-center justify-center">
              <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                <path d="M8 2L14 5.5V10.5L8 14L2 10.5V5.5L8 2Z" fill="white" fillOpacity="0.9" />
              </svg>
            </div>
            <span className="font-semibold text-lg tracking-tight">Nexus</span>
          </div>

          {/* Desktop Nav */}
          <div className="hidden md:flex items-center gap-8">
            {["Features", "Pricing", "Docs", "Blog"].map((item) => (
              <a
                key={item}
                href="#"
                className="text-sm text-white/60 hover:text-white transition-colors duration-200"
              >
                {item}
              </a>
            ))}
          </div>

          <div className="hidden md:flex items-center gap-3">
            <button className="text-sm text-white/60 hover:text-white px-4 py-2 transition-colors duration-200">
              Sign in
            </button>
            <button className="text-sm bg-violet-600 hover:bg-violet-500 text-white px-4 py-2 rounded-lg transition-colors duration-200 font-medium">
              Get started
            </button>
          </div>

          {/* Mobile menu button */}
          <button
            className="md:hidden text-white/60 hover:text-white"
            onClick={() => setMenuOpen(!menuOpen)}
          >
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              {menuOpen ? (
                <path d="M18 6L6 18M6 6l12 12" />
              ) : (
                <path d="M4 6h16M4 12h16M4 18h16" />
              )}
            </svg>
          </button>
        </div>

        {/* Mobile menu */}
        {menuOpen && (
          <div className="md:hidden border-t border-white/5 px-6 py-4 flex flex-col gap-4">
            {["Features", "Pricing", "Docs", "Blog"].map((item) => (
              <a key={item} href="#" className="text-sm text-white/60 hover:text-white transition-colors">
                {item}
              </a>
            ))}
            <div className="flex flex-col gap-2 pt-2 border-t border-white/5">
              <button className="text-sm text-white/60 hover:text-white py-2 text-left transition-colors">Sign in</button>
              <button className="text-sm bg-violet-600 hover:bg-violet-500 text-white px-4 py-2 rounded-lg transition-colors font-medium">
                Get started
              </button>
            </div>
          </div>
        )}
      </nav>

      {/* Hero Section */}
      <section className="relative pt-32 pb-24 px-6 flex flex-col items-center text-center">
        {/* Background glow */}
        <div className="absolute top-0 left-1/2 -translate-x-1/2 w-[800px] h-[500px] bg-violet-600/10 rounded-full blur-[120px] pointer-events-none" />
        <div className="absolute top-20 left-1/2 -translate-x-1/2 w-[400px] h-[300px] bg-indigo-600/10 rounded-full blur-[80px] pointer-events-none" />

        <div className="relative z-10 max-w-4xl mx-auto">
          <div className="inline-flex items-center gap-2 bg-white/5 border border-white/10 rounded-full px-4 py-1.5 mb-8">
            <span className="w-2 h-2 rounded-full bg-violet-400 animate-pulse" />
            <span className="text-sm text-white/70">Now in public beta — try it free</span>
          </div>

          <h1 className="text-5xl md:text-7xl font-bold tracking-tight leading-tight mb-6">
            Build faster with{" "}
            <span className="bg-gradient-to-r from-violet-400 via-purple-400 to-indigo-400 bg-clip-text text-transparent">
              modern tools
            </span>
          </h1>

          <p className="text-lg md:text-xl text-white/50 max-w-2xl mx-auto mb-10 leading-relaxed">
            A powerful platform designed for developers who want to ship beautiful products without the complexity. Start building in minutes.
          </p>

          <div className="flex flex-col sm:flex-row items-center justify-center gap-4">
            <button className="w-full sm:w-auto bg-violet-600 hover:bg-violet-500 text-white px-8 py-3.5 rounded-xl font-medium text-base transition-all duration-200 hover:shadow-lg hover:shadow-violet-500/25 active:scale-95">
              Start for free
            </button>
            <button className="w-full sm:w-auto flex items-center justify-center gap-2 bg-white/5 hover:bg-white/10 border border-white/10 text-white px-8 py-3.5 rounded-xl font-medium text-base transition-all duration-200 active:scale-95">
              <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                <circle cx="8" cy="8" r="7" stroke="currentColor" strokeWidth="1.5" />
                <path d="M6 5.5l4 2.5-4 2.5V5.5z" fill="currentColor" />
              </svg>
              Watch demo
            </button>
          </div>

          {/* Stats */}
          <div className="mt-16 grid grid-cols-3 gap-8 max-w-lg mx-auto">
            {[
              { value: "50K+", label: "Developers" },
              { value: "99.9%", label: "Uptime" },
              { value: "2ms", label: "Avg latency" },
            ].map((stat) => (
              <div key={stat.label} className="flex flex-col items-center">
                <span className="text-2xl md:text-3xl font-bold text-white">{stat.value}</span>
                <span className="text-sm text-white/40 mt-1">{stat.label}</span>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section className="py-24 px-6">
        <div className="max-w-7xl mx-auto">
          <div className="text-center mb-16">
            <h2 className="text-3xl md:text-4xl font-bold mb-4">
              Everything you need
            </h2>
            <p className="text-white/50 text-lg max-w-xl mx-auto">
              Powerful features built for modern development workflows.
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {[
              {
                icon: (
                  <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
                    <path d="M10 2L17 6V14L10 18L3 14V6L10 2Z" stroke="currentColor" strokeWidth="1.5" strokeLinejoin="round" />
                    <path d="M10 2V18M3 6L17 14M17 6L3 14" stroke="currentColor" strokeWidth="1.5" />
                  </svg>
                ),
                color: "from-violet-500/20 to-violet-600/5",
                iconColor: "text-violet-400",
                title: "Component Library",
                desc: "Hundreds of pre-built, accessible components ready to drop into your project.",
              },
              {
                icon: (
                  <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
                    <path d="M2 10C2 5.58 5.58 2 10 2s8 3.58 8 8-3.58 8-8 8-8-3.58-8-8z" stroke="currentColor" strokeWidth="1.5" />
                    <path d="M10 6v4l3 3" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" />
                  </svg>
                ),
                color: "from-blue-500/20 to-blue-600/5",
                iconColor: "text-blue-400",
                title: "Real-time Sync",
                desc: "Keep your data in sync across all clients with sub-millisecond latency.",
              },
              {
                icon: (
                  <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
                    <path d="M4 4h12v12H4z" stroke="currentColor" strokeWidth="1.5" strokeLinejoin="round" />
                    <path d="M8 8h4M8 12h4" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" />
                  </svg>
                ),
                color: "from-emerald-500/20 to-emerald-600/5",
                iconColor: "text-emerald-400",
                title: "Type Safe APIs",
                desc: "End-to-end type safety from your database to your frontend components.",
              },
              {
                icon: (
                  <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
                    <path d="M10 2l2.5 5 5.5.8-4 3.9.9 5.5L10 14.5l-4.9 2.7.9-5.5L2 7.8l5.5-.8L10 2z" stroke="currentColor" strokeWidth="1.5" strokeLinejoin="round" />
                  </svg>
                ),
                color: "from-amber-500/20 to-amber-600/5",
                iconColor: "text-amber-400",
                title: "AI-Powered",
                desc: "Intelligent suggestions and auto-completions powered by the latest AI models.",
              },
              {
                icon: (
                  <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
                    <path d="M3 5h14M3 10h14M3 15h14" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" />
                  </svg>
                ),
                color: "from-pink-500/20 to-pink-600/5",
                iconColor: "text-pink-400",
                title: "Flexible Layouts",
                desc: "Build any layout with our powerful grid and flexbox utilities.",
              },
              {
                icon: (
                  <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
                    <path d="M10 2a8 8 0 100 16A8 8 0 0010 2z" stroke="currentColor" strokeWidth="1.5" />
                    <path d="M10 6v4l2 2" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" />
                  </svg>
                ),
                color: "from-cyan-500/20 to-cyan-600/5",
                iconColor: "text-cyan-400",
                title: "Performance First",
                desc: "Optimized for Core Web Vitals with automatic code splitting and lazy loading.",
              },
            ].map((feature) => (
              <div
                key={feature.title}
                className="group relative bg-white/[0.03] hover:bg-white/[0.06] border border-white/[0.06] hover:border-white/[0.12] rounded-2xl p-6 transition-all duration-300"
              >
                <div className={`w-10 h-10 rounded-xl bg-gradient-to-br ${feature.color} flex items-center justify-center mb-4 ${feature.iconColor}`}>
                  {feature.icon}
                </div>
                <h3 className="font-semibold text-white mb-2">{feature.title}</h3>
                <p className="text-sm text-white/50 leading-relaxed">{feature.desc}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="py-24 px-6">
        <div className="max-w-4xl mx-auto relative">
          <div className="absolute inset-0 bg-gradient-to-r from-violet-600/20 to-indigo-600/20 rounded-3xl blur-xl" />
          <div className="relative bg-gradient-to-br from-violet-600/10 to-indigo-600/10 border border-white/10 rounded-3xl p-12 text-center">
            <h2 className="text-3xl md:text-4xl font-bold mb-4">
              Ready to get started?
            </h2>
            <p className="text-white/50 text-lg mb-8 max-w-xl mx-auto">
              Join thousands of developers building with Nexus. Free forever for personal projects.
            </p>
            <div className="flex flex-col sm:flex-row items-center justify-center gap-4">
              <button className="w-full sm:w-auto bg-violet-600 hover:bg-violet-500 text-white px-8 py-3.5 rounded-xl font-medium text-base transition-all duration-200 hover:shadow-lg hover:shadow-violet-500/25 active:scale-95">
                Create free account
              </button>
              <button className="w-full sm:w-auto text-white/60 hover:text-white px-8 py-3.5 rounded-xl font-medium text-base transition-colors duration-200">
                View documentation →
              </button>
            </div>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="border-t border-white/5 py-12 px-6">
        <div className="max-w-7xl mx-auto">
          <div className="grid grid-cols-2 md:grid-cols-4 gap-8 mb-12">
            <div className="col-span-2 md:col-span-1">
              <div className="flex items-center gap-2 mb-4">
                <div className="w-7 h-7 rounded-lg bg-gradient-to-br from-violet-500 to-indigo-600 flex items-center justify-center">
                  <svg width="14" height="14" viewBox="0 0 16 16" fill="none">
                    <path d="M8 2L14 5.5V10.5L8 14L2 10.5V5.5L8 2Z" fill="white" fillOpacity="0.9" />
                  </svg>
                </div>
                <span className="font-semibold">Nexus</span>
              </div>
              <p className="text-sm text-white/40 leading-relaxed">
                Building the future of web development, one component at a time.
              </p>
            </div>

            {[
              {
                title: "Product",
                links: ["Features", "Pricing", "Changelog", "Roadmap"],
              },
              {
                title: "Developers",
                links: ["Documentation", "API Reference", "GitHub", "Status"],
              },
              {
                title: "Company",
                links: ["About", "Blog", "Careers", "Contact"],
              },
            ].map((col) => (
              <div key={col.title}>
                <h4 className="text-sm font-medium text-white mb-4">{col.title}</h4>
                <ul className="space-y-3">
                  {col.links.map((link) => (
                    <li key={link}>
                      <a href="#" className="text-sm text-white/40 hover:text-white/70 transition-colors">
                        {link}
                      </a>
                    </li>
                  ))}
                </ul>
              </div>
            ))}
          </div>

          <div className="border-t border-white/5 pt-8 flex flex-col sm:flex-row items-center justify-between gap-4">
            <p className="text-sm text-white/30">© 2025 Nexus. All rights reserved.</p>
            <div className="flex items-center gap-6">
              {["Privacy", "Terms", "Cookies"].map((item) => (
                <a key={item} href="#" className="text-sm text-white/30 hover:text-white/60 transition-colors">
                  {item}
                </a>
              ))}
            </div>
          </div>
        </div>
      </footer>
    </main>
  );
}
