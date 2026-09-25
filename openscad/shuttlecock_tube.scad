// Shuttlecock tube with two identical screw caps. Units: mm.
// Self-contained: no external thread libraries required.

/* [View] */
part = "assembly"; // [assembly, exploded, print, tube, cap, cap_detail, thread_test]
explosion = 25; // [0:1:80]

/* [Tube] */
// Clear bore. Check against your shuttlecock skirt diameter.
inner_diameter = 70;
// Overall tube length, excluding cap roofs.
tube_length = 210;
wall = 2.4;

/* [Spiral waves] */
wave_count = 10; // [3:1:24]
// Radial height of the waves; zero gives a smooth tube.
wave_depth = 5.5; // [0:0.1:8]
// Rotation per 200 mm of body length, degrees. Negative reverses direction.
wave_twist = 120; // [-360:5:360]
// Negative = stronger twist at the ends; positive = stronger in the middle.
wave_center_bias = 0.3; // [-0.95:0.05:0.95]

/* [Screw connection] */
thread_pitch = 4;
thread_depth = 1.2;
neck_length = 14;
// Radial clearance, not diametral.
radial_clearance = 0.35;
// Clearance on each axial flank.
axial_clearance = 0.2;
end_gap = 0.6;

/* [Caps] */
cap_wall = 2.4;
cap_roof = 2.4;
// Rounded crown above the solid roof, mm.
cap_round_height = 12; // [1:0.5:20]
// Additional sweep of the ribs across the rounded end, degrees.
cap_end_twist = 0; // [-90:5:90]
// Recessed channels on the rounded end; the standing disk stays flat.
cap_end_groove = 2; // [0:0.25:4]
// Depth of the central concave dish, mm.
cap_center_depth = 4; // [0:0.5:10]
// Flat standing surface on each cap, diameter in mm.
cap_stand_diameter = 56; // [20:1:75]

/* [Quality] */
facets = 128;
thread_steps_per_turn = 96;

/* [Hidden] */
$fn = facets;
eps = 0.02;
bore_r = inner_diameter / 2;
neck_r = bore_r + wall;
body_r = neck_r + thread_depth + radial_clearance + cap_wall;
cap_r = neck_r + thread_depth + radial_clearance + cap_wall;
cap_flat_h = neck_length + end_gap + cap_roof;
cap_h = cap_flat_h + cap_round_height;
stand_r = cap_stand_diameter / 2;
// Visual overlap used only for the assembled preview; printed parts remain
// dimensioned by the screw thread and are not shortened.
assembly_overlap = 0;
thread_start = thread_pitch * 0.6;
thread_finish = neck_length - thread_pitch * 0.6;
// Stop the cap bore just above the last thread so the concave roof remains
// solid instead of opening through at its centre.
cap_bore_h = thread_finish + axial_clearance + 0.4;

assert(inner_diameter > 0 && wall >= 1.2);
assert(tube_length > 2 * neck_length + 2);
assert(thread_pitch > 0 && thread_depth > 0);
assert(neck_length >= thread_pitch * 3);
assert(radial_clearance > 0 && axial_clearance >= 0);
assert(cap_wall >= 1.2 && cap_roof >= 1.2 && end_gap > 0);
assert(cap_round_height > 0);
assert(cap_end_groove >= 0 && cap_end_groove < cap_round_height/2);
assert(cap_center_depth >= 0 && cap_center_depth < cap_round_height);
assert(cap_stand_diameter > 0 && cap_stand_diameter < 2*body_r,
       "Standing diameter must be smaller than the cap valley diameter");
assert(thread_pitch * 0.65 + 2 * axial_clearance < thread_pitch);
assert(wave_count >= 3 && wave_depth >= 0);
assert(abs(wave_center_bias) < 1);

function twist_fraction(u) = u - wave_center_bias*sin(360*u)/(2*PI);
function body_twist(height) = wave_twist*height/200;

// Nonlinear twist with a continuous slope and exact endpoint phases.
module waved_body(height) {
    n = max(facets, wave_count*24);
    total_twist = body_twist(height);
    rows = max(ceil(height/1.5), ceil(abs(total_twist)*(1+abs(wave_center_bias))/2), 1);
    points = [for (j = [0:rows], i = [0:n-1])
        let(u = j/rows, a = 360*i/n,
            angle = a-total_twist*twist_fraction(u),
            r = body_r+wave_depth*(1+cos(wave_count*a))/2)
        [r*cos(angle), r*sin(angle), height*u]];
    faces = concat(
        [[for (i = [0:n-1]) i]],
        [for (j = [0:rows-1], i = [0:n-1], tri = [0:1])
            let(a = j*n+i, b = j*n+(i+1)%n,
                c = (j+1)*n+(i+1)%n, d = (j+1)*n+i)
            tri == 0 ? [a,d,c] : [a,c,b]],
        [[for (i = [n-1:-1:0]) rows*n+i]]);
    polyhedron(points = points, faces = faces, convexity = 12);
}

// Continuous spiral pitch across the body and both identical caps.
module waved_shell(height, twist) {
    segments = max(facets, wave_count * 24);
    if (wave_depth == 0) cylinder(r = body_r, h = height);
    else linear_extrude(height = height, twist = twist,
                        slices = max(1, ceil(height / 1.5), ceil(abs(twist) / 2)),
                        convexity = 12)
        polygon([for (i = [0:segments-1])
            let(a = 360*i/segments,
                r = body_r + wave_depth*(1 + cos(wave_count*a))/2)
            [r*cos(a), r*sin(a)]]);
}

// Trapezoidal right-hand helix; each end uses a local outward Z axis.
// Winding follows OpenSCAD's clockwise-outside polyhedron convention.
module thread_ridge(radial_extra = 0, axial_extra = 0) {
    turns = (thread_finish - thread_start) / thread_pitch;
    steps = ceil(turns * thread_steps_per_turn);
    profile = [
        [neck_r - 0.15, -thread_pitch * 0.325 - axial_extra],
        [neck_r + thread_depth + radial_extra, -thread_pitch * 0.10 - axial_extra],
        [neck_r + thread_depth + radial_extra, thread_pitch * 0.10 + axial_extra],
        [neck_r - 0.15, thread_pitch * 0.325 + axial_extra]
    ];
    points = [for (i = [0:steps], p = profile)
        let(a = 360 * turns * i / steps,
            z = thread_start + thread_pitch * a / 360)
        [p[0] * cos(a), p[0] * sin(a), z + p[1]]];
    faces = concat(
        [[3, 2, 1], [3, 1, 0]],
        // Helical quads are not planar. Explicit triangles are required
        // by the CGAL backend used in older desktop OpenSCAD releases.
        [for (i = [0:steps-1], j = [0:3], triangle = [0:1])
            let(a = 4*i+j, b = 4*i+(j+1)%4,
                c = 4*(i+1)+(j+1)%4, d = 4*(i+1)+j)
            triangle == 0 ? [a, b, c] : [a, c, d]],
        [[4*steps, 4*steps+1, 4*steps+2],
         [4*steps, 4*steps+2, 4*steps+3]]
    );
    polyhedron(points = points, faces = faces, convexity = 12);
}

module neck() {
    union() {
        cylinder(r = neck_r, h = neck_length - 0.8);
        translate([0, 0, neck_length - 0.8])
            cylinder(r1 = neck_r, r2 = neck_r - 0.5, h = 0.8);
        thread_ridge();
    }
}

module tube(length = tube_length) {
    difference() {
        union() {
            translate([0, 0, neck_length])
                waved_body(length - 2 * neck_length);
            translate([0, 0, neck_length]) rotate([180, 0, 0]) neck();
            translate([0, 0, length - neck_length]) rotate([0, 0, -body_twist(length-2*neck_length)]) neck();
        }
        translate([0, 0, -eps]) cylinder(r = bore_r, h = length + 2 * eps);
    }
}

// Rounded lobes roll onto the end and blend tangentially into a flat
// standing disk. No raised ridge extends beyond the standing plane.
module cap_outer() {
    n = max(facets, wave_count * 24);
    rings = 24;
    lower_rings = 8;
    total_rings = lower_rings + rings;
    rate = wave_twist * (1-wave_center_bias) / 200;
    points = concat(
        // Lower side and crown share this exact boundary ring.  Keeping
        // them in one mesh prevents a separate smooth band at the join.
        [for (j = [0:lower_rings], i = [0:n-1])
            let(u = j/lower_rings,
                a = 360*i/n,
                z = cap_flat_h*u,
                r = body_r + wave_depth*(1+cos(wave_count*a))/2,
                angle = a-rate*z)
            [r*cos(angle), r*sin(angle), z]],
        [for (j = [1:rings], i = [0:n-1])
            let(t = 90*j/rings,
                a = 360*i/n,
                // Ridges rise through the outer half of the cap, then fall
                // back toward the central concave dish.
                // Squared sine gives zero slope where the body meets the
                // cap and again at the centre, producing a rounded blend.
                z = cap_flat_h + cap_round_height*pow(sin(2*t), 2)
                    - cap_center_depth*pow(sin(t),2)
                    - cap_end_groove*(1-cos(wave_count*a))/2*pow(sin(2*t),2),
                r = stand_r + (body_r - stand_r + wave_depth*(1+cos(wave_count*a))/2)*cos(t),
                // Keep the ridge direction almost unchanged at the body
                // junction; the optional extra sweep only appears near the
                // rounded centre of the cap.
                angle = a-rate*z-cap_end_twist*pow(sin(t),4))
            [r*cos(angle), r*sin(angle), z]]);
    faces = concat(
        [[for (i = [0:n-1]) i]],
        [for (j = [0:total_rings-1], i = [0:n-1], tri = [0:1])
            let(a = j*n+i, b = j*n+(i+1)%n,
                c = (j+1)*n+(i+1)%n, d = (j+1)*n+i)
            tri == 0 ? [a, d, c] : [a, c, b]],
        [[for (i = [n-1:-1:0]) total_rings*n+i]]);
    polyhedron(points = points, faces = faces, convexity = 12);
}

// Local mouth at Z=0, rounded roof at positive Z.
module cap() {
    difference() {
        cap_outer();
        translate([0, 0, -eps])
            cylinder(r = neck_r + radial_clearance, h = cap_bore_h + eps);
        thread_ridge(radial_clearance, axial_clearance);
        // Lead-in opening clears the first thread flank.
        translate([0, 0, -eps])
            cylinder(r1 = neck_r + thread_depth + radial_clearance,
                     r2 = neck_r + radial_clearance, h = 1.2 + eps);
    }
}

module cap_for_print() {
    // Stand on the flat end with the threaded cavity facing up.
    translate([0, 0, cap_h]) rotate([180, 0, 0]) cap();
}

module assembly(gap = 0) {
    color("#df9c47") tube();
    color("#374b63") {
        translate([0, 0, tube_length - neck_length + gap - assembly_overlap])
            rotate([0, 0, -body_twist(tube_length-2*neck_length)]) cap();
        translate([0, 0, neck_length - gap + assembly_overlap])
            rotate([180, 0, 0]) cap();
    }
}

if (part == "tube") tube();
else if (part == "cap") cap_for_print();
else if (part == "cap_detail") cap();
else if (part == "assembly") assembly();
else if (part == "exploded") assembly(explosion);
else if (part == "print") {
    tube();
    for (y = [-cap_r-wave_depth-5, cap_r+wave_depth+5])
        translate([body_r + 2*wave_depth + cap_r + 10, y, 0]) cap_for_print();
}
else if (part == "thread_test") {
    // One matching neck plus a short shoulder, placed flat on the bed.
    difference() {
        union() {
            cylinder(r = body_r, h = 3);
            translate([0, 0, 3]) neck();
        }
        translate([0, 0, -eps]) cylinder(r = bore_r, h = neck_length + 3 + 2*eps);
    }
    translate([2*(cap_r + wave_depth) + 10, 0, 0]) cap_for_print();
}
else assert(false, "Unknown part selection");
