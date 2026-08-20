# gravity — Development

Implementation notes, algorithm details, and build procedure for `gravity`. For usage/parameters, see [README.md](README.md).

---

## Development Setup

Only needed to open/edit/run the sketch from source — not needed to just run a release build (see [README.md](README.md#getting-a-release)).

1. **Install Processing**: download from https://processing.org/download and install (Java Mode, the default one).
2. **Install ControlP5**: in the Processing IDE, go to `Sketch > Import Library... > Manage Libraries...`, search for **ControlP5**, and click Install. This puts it straight into your sketchbook's `libraries/` folder — no manual download/unzip needed. (Library home page, for reference: http://www.sojamo.de/libraries/controlP5)
3. Open `gravity.pde` in Processing and press Run.

---

## Principle

Each particle is a point-mass released from a spawner with a random initial position (inside the spawner's circle) and a random initial velocity (direction within `direction ± range_direction`, magnitude within `[min_speed, max_speed]`). At every simulation step, every planet exerts an inverse-square gravitational force on the particle (`force = gravity / distance²`, directed toward the planet — or away from it if `gravity` is negative); the accumulated force updates the particle's velocity, and the velocity updates its position, both scaled by `steps_size`. The full sequence of positions visited becomes the particle's traced polyline.

A particle stops being simulated (its trajectory ends) as soon as it:
- comes within `min_distance_to_planets` of any planet ("absorbed"), or
- drifts further than `max_distance_to_page` from the origin ("lost").

A planet's `drag` only applies to particles currently within `radius / 2` of it — a mild braking force on top of the gravitational pull, letting particles otherwise pass by unaffected until they get close.

The simulation is deterministic per run (`randomSeed(0)` at the start of `buildLines()`), and always recomputed from scratch (all `steps` for all particles) whenever any parameter changes — there is no incremental/progressive simulation.

---

## Architecture

| File | Role |
|------|------|
| `gravity.pde` | Setup, draw loop |
| `DataGlobal.pde` | `GravityData` + `DataGUI` — aggregates particles (canvas/simulation params), spawners, planets, style |
| `DataCanvas.pde` | Simulation-wide parameters (`steps`, `steps_size`, `max_distance_to_page`) + Canvas tab GUI |
| `DataSpawner.pde` | `DataSpawner` + `DataSpawners` + `SpawnersGui` — particle emitters, click-to-select/drag-to-move on canvas |
| `DataPlanets.pde` | `DataPlanet` + `DataPlanets` + `PlanetsGui` — gravity sources, click-to-select/drag-to-move on canvas |
| `ParticlesGenerator.pde` | `Particle` + `ParticlesGenerator` — the physics simulation and line tracing described above |

---

## Building a Release

`export_app.ps1` (project root) builds a standalone, installer-free application and packages it as a release zip.

```powershell
.\export_app.ps1
```

This will:
1. Export the sketch as a standalone application via `processing-java --export` (embeds a JRE and all libraries, including ControlP5 — end users install nothing).
2. Copy `Settings/` into the export (the Processing export step does **not** include it, and the sketch crashes on startup without a `Settings/default.json` to load).
3. Zip the result into `releases/gravity_<variant>_<date>.zip`, ready to hand out.

Useful options:
```powershell
.\export_app.ps1 -ProcessingPath "D:\tools\processing-4.3\processing-java.exe"  # different Processing install
.\export_app.ps1 -Zip $false                                                    # skip the release zip
```

**Note:** the build always targets the OS you run the script on — `-Variant` does not cross-compile for another platform (verified empirically: requesting `linux-amd64` from Windows still produced a Windows build). To produce a macOS or Linux build, run this script on a machine running that OS.
