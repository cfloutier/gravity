# gravity

Processing sketch that traces particle trajectories under simulated gravity — plotter-ready line drawings of orbits, slingshots, and flow fields around one or more "planets".

---

## Getting a Release

No Processing, Java, or ControlP5 installation is required to run a release build — everything needed is bundled in the zip.

1. Download the release zip (see `releases/` or wherever it was shared with you).
2. Unzip it anywhere.
3. Run the `.exe` inside — that's it.

---

## Tabs

- **Files**: load/save settings, export (SVG/PDF/DXF), page scale and clipping.
- **Spawners**: where and how particles are emitted.
- **Planets**: gravity sources that attract (or repel) particles.
- **Style**: background/line colour and width.

## Spawners Parameters

A spawner emits `nb_particles` at simulation start, each from a random point inside its circle, with a random speed/direction within the given ranges.

| Parameter | Role |
|-----------|------|
| `nb_particles` | Number of particles emitted by this spawner |
| `center_x` / `center_y` | Spawner position |
| `radius` | Particles start at a random point inside this circle |
| `direction` | Central emission angle (degrees) |
| `range_direction` | ± spread around `direction` (degrees) — each particle's initial heading is randomised within this cone |
| `min_speed` / `max_speed` | Initial speed range (randomised per particle) |

Click a spawner's circle on canvas to select it, then drag to move it. The **Center** button snaps it back to the origin.

## Planets Parameters

Each planet exerts an inverse-square gravitational force on every particle: `force = gravity / distance²`, pulling particles toward it — or pushing them away if `gravity` is negative.

| Parameter | Role |
|-----------|------|
| `center_x` / `center_y` | Planet position |
| `radius` | Visual/collision radius (drawn at least 20px even if smaller) |
| `min_distance_to_planets` | A particle that gets closer than this is stopped — treated as "absorbed" |
| `gravity` | Attraction strength; negative repels instead of attracting |
| `drag` | Extra braking force applied to particles passing within `radius / 2` of the planet |

Click a planet's circle on canvas to select it, then drag to move it. The **Center** button snaps it back to the origin.

## Canvas (Simulation) Parameters

| Parameter | Role |
|-----------|------|
| `steps` | Number of simulation steps computed per particle |
| `steps_size` | Time step scale — larger steps move particles further per simulation tick (faster but less precise trajectories) |
| `max_distance_to_page` | A particle that drifts further than this from the origin is stopped |

---

## Usage Tips

- A particle's traced path stops early if it gets within `min_distance_to_planets` of a planet (absorbed), or wanders past `max_distance_to_page` (lost) — so `steps` alone doesn't guarantee full-length lines.
- Negative `gravity` on a planet creates a repulsive "deflector" instead of an attractor — combine attractors and repellers for more complex flow patterns.
- `drag` only applies within `radius / 2` of a planet, letting particles fly past freely until they get close.
- Increase `steps_size` for a quick low-fidelity preview of the overall flow, then lower it for the final, smoother trajectories.

---

For the algorithm principle, file architecture, and how to build a release yourself, see [DEVELOPMENT.md](DEVELOPMENT.md).

---

## Changelog

### 2026-08-19 — xLib 3.13.4
- **README**: first version of this project's documentation, split into a user-facing README and a [DEVELOPMENT.md](DEVELOPMENT.md) for implementation/build details.
- **Load / Save**: no longer opens a separate OS file-picker window (which could occasionally open hidden behind the main window) — replaced by an in-app file browser in the **Files** tab. Load and "Save as..." show buttons for every settings file and folder inside `Settings/`, with a `..` button to go up a level and Prev/Next if there are many files. Saving over an existing file asks for confirmation first; saving under a new name uses a text field pre-filled with the current file's name.
- **Clip Ratio**: the Files tab's clipping controls gained a ratio lock — pick `None` (free width/height, as before), `A4`, `16:9`, `4:3`, `Raisin`, or `1:1`, plus a `Landscape`/portrait toggle. With a ratio selected, dragging either the width or height slider keeps the other in proportion automatically.
- **`export_app.ps1`**: new build script — exports the sketch as a standalone application (embeds a JRE and all libraries, including ControlP5), copies `Settings/` into the export (not included by `processing-java --export`, and required at startup), and zips the result into `releases/` as a ready-to-share release. Same script copied verbatim across projects, same convention as the shared `xLib_*.pde` files.
- **`.gitignore`**: ignore `build_*/` and `releases/` (generated build output).
