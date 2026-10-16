# Parametric OpenSCAD Models

This repository contains six configurable OpenSCAD projects and a browser-based playground for previewing, rendering, and exporting them. All model dimensions are in millimetres, and the models are self-contained without external OpenSCAD libraries.

## Online playground

Open the [live configurator](https://afinageny.github.io/drillbox/) and select a model from the file menu. The controls are generated from the parameter groups in each `.scad` file. Changes are reflected in the preview and retained in the page URL, which can be copied with the **Link** button.

Direct links:

- [Drill plate and water cover](https://afinageny.github.io/drillbox/?file=drillbox.scad)
- [Sliding-lid storage box](https://afinageny.github.io/drillbox/?file=lidbox.scad)
- [Shuttlecock tube](https://afinageny.github.io/drillbox/?file=shuttlecock_tube.scad)
- [Tile scoring carriage](https://afinageny.github.io/drillbox/?file=tile_carriage.scad)
- [Tile scoring carriage — next version](https://afinageny.github.io/drillbox/?file=tile-carriage-next.scad)
- [Tile cutter carriage variant](https://afinageny.github.io/drillbox/?file=tile-cutter.scad)

Use **Preview** while adjusting parameters, **Render** for final geometry, **STL** to export the currently selected part, and **PNG** to save the current camera view.

## Models

### Drill plate and water cover

File: [`openscad/drillbox.scad`](openscad/drillbox.scad)

![Drill plate water cover preview](docs/images/drillbox-waterCover.png)

A matched drilling template and raised water cover for one or more circular openings. The cover includes two G 1/2 threaded ports, with matching printable hose and drain fittings.

Available parts:

- `assembly` — all parts arranged for inspection.
- `drillTemplate` — plate with the main openings and four corner mounting holes.
- `waterCover` — hollow raised cover with top openings and two threaded ports.
- `hoseFitting` — G 1/2 female fitting with 22 mm and 19 mm hose barbs.
- `drainPlug` — hexagonal G 1/2 female plug.

Main parameters control the hole count and spacing, plate margins and fillets, cover height and wall thickness, and hose fitting dimensions. Set `show_threads` to `false` for a faster simplified preview.

### Sliding-lid storage box

File: [`openscad/lidbox.scad`](openscad/lidbox.scad)

![Sliding-lid storage box preview](docs/images/lidbox-assembly.png)

A rounded storage box with a two-piece sliding sandwich lid. The lid halves use matching trapezoidal profiles and alignment pegs, and can hold transparent sheet inserts in configurable window openings.

Available parts:

- `print` — box and both lid halves laid out for printing.
- `assembly` — closed or partially opened box preview.
- `box` — box body only.
- `lidSandwichTop` — upper lid half in its printing orientation.
- `lidSandwichBottom` — lower lid half in its printing orientation.

Use `lid_open` to inspect the sliding action. The box size, wall thickness, lid clearance, window grid, sheet thickness, and internal divider grid are all configurable. A small calibration print is recommended before committing to a large box because the best sliding clearance depends on the printer and material.

### Shuttlecock tube

File: [`openscad/shuttlecock_tube.scad`](openscad/shuttlecock_tube.scad)

![Shuttlecock tube preview](docs/images/shuttlecock_tube-assembly.png)

A protective tube for badminton shuttlecocks with identical screw caps at both ends. The default body is 210 mm long with a 70 mm clear bore. Spiral ribs continue smoothly from the body across the rounded caps, while each cap retains a flat standing area.

Available views and parts:

- `assembly` — closed tube with both caps installed.
- `exploded` — caps separated by the `explosion` distance.
- `print` — tube and two caps arranged for printing.
- `tube` — tube body only.
- `cap` — one cap in its printing orientation.
- `cap_detail` — one cap with its local opening at Z = 0.
- `thread_test` — a short neck and matching cap for checking thread fit.

The body diameter, length, wall, wave count, wave depth, twist rate, and twist distribution are configurable. Thread pitch, depth, and clearances can be tuned for a specific printer. Cap controls adjust the rounded end, spiral grooves, standing diameter, and the internal head pocket. `cap_headroom_height` reserves extra space for the cork head and blends the pocket directly into the threaded cavity.

### Tile scoring carriage

File: [`openscad/tile_carriage.scad`](openscad/tile_carriage.scad)

A compact, hand-pressed three-point carriage for scoring a large tile alongside a rectangular guide rule. Two matching front wheels and a rear scoring disc contact the tile. The rounded upper shell and perimeter skirt form one continuous body, with the same rounded outline carried down the skirt and a rounded upper edge. Viewed from below, a narrow U-shaped rear skirt wraps around the cutter and opens toward the rear so the cutter is visible from behind. Tapered ties connect the U to the side skirts. Wheels and cutter ride on smooth, separate axle pins that press upward from below into snap-fit fork seats. Integral heads on each axle end keep it from sliding sideways, and the washers are separate parts. The preview omits the tile so the carriage underside remains visible. Select whether the rule is on the left, right, or both sides. The browser preview colors the rule, carriage, wheels, cutter, washers, and axles separately, with each color adjustable in the customizer.

The rule defaults to 50 × 10 mm, the front wheels to 20 mm diameter, and the cutting line to the middle of the 55 mm carriage width. Wheel and cutter dimensions, guide clearance, skirt clearance, top edge radius, corner radius, and axle/fork sizes are editable in the browser customizer. The body and guide are conceptual first-pass geometry; verify the actual cutter and wheel dimensions before printing a functional part.

### Tile scoring carriage — next version

File: [`openscad/tile-carriage-next.scad`](openscad/tile-carriage-next.scad)

The next version uses identical 22 mm outside diameter, 8 mm width and 8 mm bore bearings for the two support wheels and two side rollers. Their dimensions share the bearing_diameter, bearing_width and bearing_bore parameters. The rectangular body is 114 mm long, 57 mm wide and has a 10 mm upper plate, without edge rounding. Side skirt walls are 3 mm thick; front and rear bands are 14 mm thick. The scoring offset is 30 mm to the near face of the rule at zero guide_clearance. The rule defaults to 50 mm wide and 20 mm high.

The side bearings sit under the skirt at Y = -28 and +24 mm (52 mm apart), on rectangular mounting blocks; there are no external balconies or reinforcing ribs. The side walls run above the bearings with 0.5 mm clearance. The bearings and magnets are centered at Z = 10 mm, halfway up the rule. Side-bearing blocks have blind 6.8 mm pilot holes, 14 mm deep, for tapping M8 from below. Lower screw heads and spacers are shown as simplified hardware. The side_front_gap and side_rear_gap parameters set the projected longitudinal wheel-to-roller gaps.

The main wheel and cutter axes are 100 mm apart. Each 22 mm disc projects 4 mm beyond the 114 mm body, giving a 122 mm total wheel envelope. Wheel pockets and closed axle bores are built into the end bands. Plastic screw axles enter from the side opposite the rule, with one hex head, a smooth shank and a custom printed 2 mm pitch thread at the far end. Insert the wheels and washers from below, then screw the axles in from the side. Use axle_print for the screw print layout. With guide_side set to both, remove the left rule for screw access.

Two optional magnets sit in separate corner blocks at Y = -50 and +44 mm, spreading attraction over 94 mm. The front block is inset 6 mm from the support-wheel axle to avoid crossing its screw; magnet_front_corner_inset and magnet_rear_corner_inset adjust the positions. The Magnets group defaults to 10 mm diameter, 3 mm thickness, a 3 mm through-hole, a 6 mm countersink and a 45-degree wall angle to the axis (90-degree included cone). Hole dimensions are estimates from the reference photo. Magnets load from the rule side and are retained with printed countersunk screws: 2.7 mm shank, 4 mm thread length and 1 mm pitch by default. Magnet faces are recessed 0.1 mm behind the body, leaving 1.6 mm to the rule. The holders extend to the upper plate and maintain at least 2 mm tile clearance. Use enable_magnets to omit them, magnets or magnet_screws to inspect, and magnet_screws_print for printing the screws. Thread fit, screw strength and holding force need a physical trial.

### Tile cutter bearing trolley

File: [`openscad/tile-cutter.scad`](openscad/tile-cutter.scad)

This is a shape-only prototype of the first trolley piece. It sits directly on the rectangular guide and follows the reference top outline: a central plate as wide as the guide, narrower tabs at both ends, and short side wings. The plate is 10 mm thick by default; guide and outline dimensions are adjustable in the customizer. Wheels and their fasteners are intentionally omitted at this stage.

## Printing workflow

1. Select an individual part or a print layout in the `part` control.
2. Adjust the dimensions and clearances for the intended printer and material.
3. Use **Render** before exporting complex threads or high-detail wave surfaces.
4. Export the result with **STL** and slice it in the normal way.

For the shuttlecock tube, print `thread_test` first and adjust `radial_clearance` and `axial_clearance` if necessary. The two caps are identical, so the same exported cap STL is used twice.

## Local development

Requirements:

- Node.js 22 or newer
- npm

Install dependencies and start the playground:

```bash
npm ci
npm run dev
```

Then open <http://127.0.0.1:5173/>. The development server watches the files in `openscad/` and reloads the selected model when it changes.

Run the production checks and build with:

```bash
npm run build
```

The GitHub Pages workflow publishes the `dist/` directory after each push to `master`.
