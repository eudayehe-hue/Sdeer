# Active Context: Next.js Starter Template

## Current State

**Template Status**: ✅ Ready for development

The template is a clean Next.js 16 starter with TypeScript and Tailwind CSS 4. It's ready for AI-assisted expansion to build any type of application.

## Recently Completed

- [x] Base Next.js 16 setup with App Router
- [x] TypeScript configuration with strict mode
- [x] Tailwind CSS 4 integration
- [x] ESLint configuration
- [x] Memory bank documentation
- [x] Recipe system for common features

## Current Structure

| File/Directory | Purpose | Status |
|----------------|---------|--------|
| `src/app/page.tsx` | Home page | ✅ Ready |
| `src/app/layout.tsx` | Root layout | ✅ Ready |
| `src/app/globals.css` | Global styles | ✅ Ready |
| `.kilocode/` | AI context & recipes | ✅ Ready |

## Current Focus

The template is ready. Next steps depend on user requirements:

1. What type of application to build
2. What features are needed
3. Design/branding preferences

## Quick Start Guide

### To add a new page:

Create a file at `src/app/[route]/page.tsx`:
```tsx
export default function NewPage() {
  return <div>New page content</div>;
}
```

### To add components:

Create `src/components/` directory and add components:
```tsx
// src/components/ui/Button.tsx
export function Button({ children }: { children: React.ReactNode }) {
  return <button className="px-4 py-2 bg-blue-600 text-white rounded">{children}</button>;
}
```

### To add a database:

Follow `.kilocode/recipes/add-database.md`

### To add API routes:

Create `src/app/api/[route]/route.ts`:
```tsx
import { NextResponse } from "next/server";

export async function GET() {
  return NextResponse.json({ message: "Hello" });
}
```

## Available Recipes

| Recipe | File | Use Case |
|--------|------|----------|
| Add Database | `.kilocode/recipes/add-database.md` | Data persistence with Drizzle + SQLite |

## Pending Improvements

- [ ] Add more recipes (auth, email, etc.)
- [ ] Add example components
- [ ] Add testing setup recipe

## Session History

| Date | Changes |
|------|---------|
| Initial | Template created with base setup |
| 2026-03-04 | Modified Getfish.lua: replaced Blatant Mode 2 with RemoteAutofishing→throw→ReelFinished→Reel→stop loop, added parallel BobberFire every 0.01s, removed mode dropdown, skipped key system
| 2026-03-04 | Created autofarm-rayfield.lua for SAWAH Indo Voice Chat game with 7 tabs: Auto Farm, Auto Collect, Auto Plant, Auto Sell, Utilities (Speed/Noclip/InfJump/AntiAFK), Teleport, Settings. |
| 2026-03-04 | Pulled UnknownGame_Bulk_Part1_2026-03-04_05-21-46.lua (35k line decompile) from remote. Created UnknownFarm-autofarm.lua with 7 tabs using actual remotes (PlantCrop, HarvestCrop, RequestSell, ToggleAutoHarvest) and CropConfig data (Padi/Jagung/Tomat/Terong/Strawberry/Sawit/Durian) from decompile. |
| 2026-03-04 | Created UPD_Titan_Fishing_Bulk_2026-03-04_17-25-17.lua for Titan Fishing game with Rayfield UI. Features: Auto Fish (with delay settings), Auto Sell, Shop (bait & rods), Teleport (fishing spots & NPCs), Utilities (Speed Hack, Noclip, InfJump, Anti AFK), Settings. |
| 2026-03-04 | Created Getfish.lua for Sdeer fishing game. Single blatant mode (no dropdown): sequence RemoteAutofishing→throw→ReelFinished→Reel→stop, repeat. Parallel BobberFire remote every 0.01s. Includes Teleport and Utilities tabs. |
| 2026-03-04 | Modified root Getfish.lua (Duality Hub Premium, 1858 lines): replaced Blatant Mode 2 logic with new sequence (RemoteAutofishing→throw→ReelFinished→Reel→stop→repeat) + parallel BobberFire loop every 0.01s via task.spawn. Removed Blatant Mode Type dropdown from UI. |
