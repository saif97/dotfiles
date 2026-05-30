---
name: visualize
description: Generate a single self-contained HTML page of diagrams (Mermaid + hand-built SVG) to understand something complex, write it to /tmp/, and open it in the browser. Use when the user wants to visualize, diagram, map out, or "see" something complex — a system, call flow, architecture, algorithm, state machine, data model, sequence, or abstract concept — or says "diagram this", "visualize this", "draw me a diagram", "help me picture X".
---

# Visualize

Turn something complex into a single self-contained HTML page of diagrams, then open it. The diagrams carry the weight — prose is sparse.

## Workflow

1. **Understand the thing.** If it's in the codebase, read the relevant files first (use `subagent_type=Explore` to locate them). If it's a concept the user described, make sure you can explain it before drawing it. Don't diagram what you don't understand.
2. **Pick the diagram type(s)** — see below. Mix them when one page benefits; don't force everything into one Mermaid graph.
3. **Write one self-contained HTML file** to `/tmp/visualize-<slug>-<timestamp>.html` (`slug` = topic, `timestamp` = `$(date +%s)`).
4. **Open it** and tell the user the absolute path: `open <path>` (macOS).
5. Give a one- or two-sentence pointer to what the page shows. No essay — the page is the deliverable.

## Choosing a diagram

- **Call flow / dependencies / "X calls Y calls Z"** → Mermaid `flowchart`.
- **Time-ordered interaction / round-trips** → Mermaid `sequenceDiagram`.
- **State machine / lifecycle** → Mermaid `stateDiagram-v2`.
- **Data model / relationships** → Mermaid `erDiagram` or `classDiagram`.
- **Layered / cross-section structure** → hand-built stacked Tailwind bands (`border-l-4`), not Mermaid.
- **Editorial / "feel the weight" visuals** (mass, nesting, before/after collapse) → hand-built `<div>`s + inline SVG arrows.

Reach past Mermaid only when its auto-layout fights the point you're making. For most asks, one or two focused Mermaid blocks is the whole page.

## Scaffold

```html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <title>{{topic}}</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script type="module">
      import mermaid from "https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs";
      mermaid.initialize({ startOnLoad: true, theme: "neutral", securityLevel: "loose" });
    </script>
  </head>
  <body class="bg-stone-50 text-slate-900 font-sans">
    <main class="max-w-4xl mx-auto px-6 py-10 space-y-8">
      <header>
        <h1 class="text-2xl font-semibold">{{topic}}</h1>
        <p class="text-slate-600">{{one sentence: what this page shows}}</p>
      </header>
      <section class="rounded-lg border border-slate-200 bg-white p-6">
        <pre class="mermaid">
          flowchart LR
            A[...] --> B[...]
        </pre>
      </section>
    </main>
  </body>
</html>
```

## Style

- Self-contained: only the Tailwind CDN and the Mermaid ESM import. No app code, no other interactivity.
- Editorial, not corporate-dashboard. Generous whitespace, one accent colour, red only for problem edges.
- Label nodes inside diagrams with `text-xs uppercase tracking-wider` so they read as schematic.
- Each diagram ≤ ~360px tall so before/after pairs sit side by side without scrolling.
- Colour leakage/problem edges and deep/important nodes with `classDef` so the eye lands there first.
- If a diagram needs a paragraph to be understood, redraw the diagram.
