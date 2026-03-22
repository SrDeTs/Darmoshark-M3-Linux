# Design System Strategy: Tactical Precision

This document outlines the visual and behavioral framework for creating a high-end, Adwaita-inspired dark mode experience. We are moving beyond a "standard" Linux utility toward a premium, focused hardware configuration suite.

## 1. Overview & Creative North Star: "The Silent Instrument"
The Creative North Star for this system is **"The Silent Instrument."** Like a high-performance tool, the UI must feel invisible until needed—quiet, authoritative, and profoundly focused. 

To break the "standard template" look, we utilize **Tonal Architecture** rather than structural lines. By leaning into the GNOME/Adwaita philosophy of soft roundedness and generous breathing room, we create a layout that feels organic and integrated with the OS, yet editorial in its execution of space and scale.

## 2. Colors: Tonal Depth over Borders
Our palette is rooted in deep charcoals and precision blues. The goal is to create a UI that "glows" from within rather than being lit from the outside.

### The Palette
- **Background**: `#0e0e0e` (Absolute base)
- **Primary (Accent)**: `#a7c8ff` (A soft, luminous blue for high-priority interactive elements)
- **Surface Tiers**:
    - `surface_container_low`: `#131313` (Main content cards)
    - `surface_container`: `#191a1a` (Input backgrounds)
    - `surface_container_high`: `#1f2020` (Hover states)
    - `surface_bright`: `#2b2c2c` (Active states or elevated pills)

### The "No-Line" Rule
Prohibit the use of 1px solid borders for sectioning or containment. Boundaries must be defined solely through background color shifts. If a card sits on the background, the difference between `#0e0e0e` and `#131313` provides the edge. 

### Glass & Texture
For floating elements like the 9-segment bottom bar, use a **Glassmorphism** approach:
- Background: `surface_container_high` at 80% opacity.
- Effect: `backdrop-filter: blur(20px)`.
- Use a subtle linear gradient on primary CTAs (`primary` to `primary_container`) to provide a "machined" satin finish.

## 3. Typography: Editorial Clarity
We use **Inter** for its neutral, technical perfection. The hierarchy is designed to feel like a high-end manual.

- **Display-LG (3.5rem)**: Used for hero numbers (e.g., current DPI). Low letter-spacing (-0.02em).
- **Headline-SM (1.5rem)**: Section headers. Bold and decisive.
- **Title-MD (1.125rem)**: Component labels and card titles.
- **Body-MD (0.875rem)**: Default state for all descriptions. High legibility.
- **Label-SM (0.6875rem)**: Used for the 9-segment pill bar labels to maintain a "micro-technical" feel.

**Asymmetric Intent:** Use `headline-sm` for titles, but pair them with `body-sm` metadata tucked into the upper right corner of a card to create a sophisticated, non-centered balance.

## 4. Elevation & Depth: Tonal Layering
Traditional shadows are too heavy for a minimalist Linux environment. We use **Ambient Lift**.

- **The Layering Principle:** Place a `surface_container_low` card on the `surface` background. Inside that card, use `surface_container` for an input field. This creates "recessed" depth without a single drop shadow.
- **The "Ghost Border":** If accessibility requires a border, use `outline_variant` at **15% opacity**. It should be felt, not seen.
- **Ambient Shadows:** For the floating bottom "pill" bar, use an extra-diffused shadow: `box-shadow: 0 24px 48px rgba(0, 0, 0, 0.5)`. The shadow must have a 0px spread to keep it soft and natural.

## 5. Components: Tactile Minimalism

### Floating Pill Bar (9 Segments)
- **Container**: `surface_container_high` with a `full` (9999px) roundedness scale.
- **Segment State**: The active segment should use `primary_container` with `on_primary_container` text.
- **Interaction**: On hover, the segment should shift to `surface_bright`. No sharp transitions; use a 200ms ease-out.

### Rounded Cards
- **Corner Radius**: Use the `lg` (2rem) or `md` (1.5rem) token.
- **Spacing**: Use `spacing-6` (1.5rem) for internal padding.
- **No Dividers**: Never use a line to separate content. Use `spacing-4` (1rem) of vertical white space to let the content breathe.

### Input Fields (DPI Sliders / Buttons)
- **Track**: `surface_container_highest`.
- **Handle/Fill**: `primary`.
- **Labeling**: Labels should be `label-md` in `on_surface_variant` color, positioned strictly above the input.

### Signature Component: The "Live Node"
- A small `primary` colored dot next to the "Connected" status or active profile. It should have a subtle 2px blur "glow" to mimic a physical LED on the hardware.

## 6. Do's and Don'ts

### Do
- **Do** use `spacing-10` and `spacing-12` for layout margins to ensure the "Modern" and "Focused" feel.
- **Do** use `surface_container_lowest` for the background of inactive segments in the pill bar to create a "hollowed out" look.
- **Do** treat typography as a graphical element. A single large DPI number is more effective than three small labels.

### Don't
- **Don't** use pure white (`#FFFFFF`). The brightest text should be `on_surface` (`#e7e5e5`).
- **Don't** use standard "drop shadows" with high opacity. They clutter the Adwaita aesthetic.
- **Don't** use sharp corners. Everything must feel smooth to the touch, echoing the ergonomic curves of a mouse.
- **Don't** crowd the screen. If the user has 9 segments, only show the content for the *active* segment. Keep the rest of the stage empty and "Quiet."