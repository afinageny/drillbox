// Compact three-point scoring carriage for a large-format tile guide.
// Units: millimetres. The wheels are simplified as one-piece annular discs.

/* [View] */
part = "assembly"; // [assembly, guide, carriage, front_wheels, cutter, front_axle, rear_axle, axles, washers, front_wheel, side_bearings, side_fasteners, axle_print]

/* [Guide rule] */
// Rectangular rule lies flat on the tile: width across the tile, height above it.
rail_width = 50; // [20:1:100]
rail_height = 10; // [5:1:30]
guide_clearance = 0; // [0:0.1:1]
guide_side = "right"; // [right, left, both]

/* [Shared wheel bearings] */
bearing_diameter = 22; // [12:1:32] Outside diameter of both support and side bearings.
bearing_width = 8; // [4:0.5:12] Width of all four bearings.
bearing_bore = 8; // [3:1:12] Bore of all four bearings.

/* [Side guide bearings] */
side_front_gap = 5; // [1.5:0.5:15] Longitudinal edge gap to the front wheels.
side_rear_gap = 1; // [0.5:0.5:15] Longitudinal edge gap to the rear cutter.
side_plastic_clearance = 1.5; // [0.5:0.1:3] Plastic setback from the rule face.
side_bearing_clearance = 0.5; // [0.2:0.1:1] Radial pocket and outer-ring axial clearance.
side_mount_diameter = 14; // [8:0.5:20]
side_bolt_clearance = 0.4; // [0.2:0.1:0.8] Clearance through the inner-ring shoulder.
side_thread_depth = 14; // [8:1:20] Blind pilot depth for tapping from below.
side_thread_pilot = 6.8; // [5:0.1:8] Pilot diameter for the M8 tapped mount.

/* [Carriage] */
// Deck length along the guide. Its width is twice cut_offset, keeping the cutter centered.
body_width = 100; // [70:1:180]
body_height = 10; // [8:1:16]
wheel_drop = 1; // [0:0.25:4] Lower wheels and cutter relative to the body.
// Distance from the rule's near long side to the scoring line.
cut_offset = 27.5; // [26.5:0.5:40]
wheel_overhang = 0.5; // [0:0.05:0.5] Fraction of wheel diameter outside the deck at each end.
front_wheel_spacing = 29.5; // [16:0.5:29.5] Spacing left/right across the carriage.
rear_u_clearance = 0.25; // [0:0.05:2] Axial clearance between cutter spacers and U-wall forks.
rear_fork_thickness = 5; // [3:0.5:8] Reinforced cutter support walls and bridge.
rear_u_opening_scale = 2; // [1:0.1:3] U-opening width relative to its previous width.

/* [Rectangular skirt] */
skirt_side_thickness = 3; // [2:0.5:6]
skirt_end_thickness = 14; // [12:1:22] Front and rear bands centered on the wheel axes.
skirt_tile_clearance = 2; // [1:0.5:4]

/* [Rear scoring wheel] */
cutter_radius = 11; // [6:0.5:18]
cutter_width = 5; // [1:0.25:8]
cutter_hole_radius = 3; // [1:0.25:6] 6 mm cutter bore.

/* [Plastic screw axles] */
axle_diameter = 5.5; // [3:0.5:10] Cutter axle with clearance in its 6 mm bore.
front_axle_diameter = 7.5; // [3:0.5:10] Bearing axle with clearance in its 8 mm bore.
axle_hole_clearance = 0.25; // [0:0.05:0.8] Clearance in wheel bores and axle seats.
fork_thickness = 3; // [2:0.5:6]
axle_head_diameter = 11; // [7:0.5:14] Integral end heads retain the axle laterally.
axle_head_thickness = 3; // [2:0.5:5]

axle_thread_pitch = 2; // [1.5:0.25:3] Coarse printable thread, not a standard metric thread.
axle_thread_depth = 0.6; // [0.4:0.1:0.9] Radial depth.
axle_thread_clearance = 0.2; // [0.1:0.05:0.4] Radial thread clearance.
axle_thread_axial_clearance = 0.15; // [0.05:0.05:0.25]
front_thread_length = 5; // [4:0.5:6]
rear_thread_length = 8; // [5:0.5:12]

/* [Washers] */
washer_outer_radius = 8; // [5:0.5:12] Outer radius of each separate washer disc.
washer_disc_thickness = 0.8; // [0.5:0.1:2] Axial thickness of each washer disc.

/* [Display] */
show_guide = true;
guide_color = "#1677e8";
carriage_color = "#ed8b35";
front_wheel_color = "#424b54";
cutter_color = "#b8bec4";
axle_color = "#252a30";
washer_color = "#b9bec4";
side_bearing_color = "#b8bec4";

/* [Hidden] */
$fn = $preview ? 48 : 96;
eps = 0.02;
front_wheel_radius = bearing_diameter/2;
front_wheel_width = bearing_width;
front_wheel_hole_radius = bearing_bore/2;
side_bearing_diameter = bearing_diameter;
side_bearing_width = bearing_width;
side_bearing_bore = bearing_bore;
wheel_left_x = -front_wheel_spacing/2;
wheel_right_x = front_wheel_spacing/2;
cut_x = 0;
front_z = front_wheel_radius;
cutter_z = cutter_radius;
deck_z = 2 * max(front_wheel_radius, cutter_radius)+wheel_drop;
body_span = 2 * cut_offset;
body_mid_x = 0;
rail_length = 190;
fork_span_y = 14;
wheel_clearance = 0.8;
// Travel is +Y: place the two front wheels and the rear cutter near opposite ends.
front_axle_y = body_width/2-front_wheel_radius+2*front_wheel_radius*wheel_overhang;
// At half-diameter overhang, the wheel axes lie on the deck end edges.
cutter_axle_y = -body_width/2+cutter_radius-2*cutter_radius*wheel_overhang;
fork_top = deck_z;
// The U-wall forks sit just outside the rear cutter washers.
rear_fork_side_reach = cutter_width/2 + washer_disc_thickness + 0.1;
rear_u_inner_x = (rear_fork_side_reach + rear_u_clearance)*rear_u_opening_scale;
rear_u_outer_x = rear_u_inner_x + rear_fork_thickness;
rear_u_inner_y = cutter_radius+wheel_clearance;
rear_u_outer_y = rear_u_inner_y+rear_fork_thickness;
rear_axle_spacer_thickness = rear_u_inner_x-rear_fork_side_reach-rear_u_clearance;
front_ear_offset = front_wheel_width/2 + washer_disc_thickness + fork_thickness/2 + 0.25;
front_axle_halfspan = front_wheel_spacing/2 + front_ear_offset + fork_thickness/2;
rear_axle_halfspan = rear_u_inner_x + rear_fork_thickness;
side_bearing_r = side_bearing_diameter/2;
side_bearing_x = cut_offset-side_bearing_r;
// Keep room below for the bolt head even with an 8 mm wide bearing on a 10 mm rule.
side_bearing_z = max(rail_height/2, side_bearing_width/2+2.5);
side_bearing_bottom = side_bearing_z-side_bearing_width/2;
side_bearing_top = side_bearing_z+side_bearing_width/2;
side_mount_bottom = side_bearing_top+side_bearing_clearance;
side_sides = guide_side == "both" ? [-1, 1] : guide_side == "left" ? [-1] : [1];
side_spacer_diameter = side_bearing_bore+2;
side_front_y = front_axle_y-front_wheel_radius-side_bearing_r-side_front_gap;
side_rear_y = cutter_axle_y+cutter_radius+side_bearing_r+side_rear_gap;
side_bearing_positions = [side_rear_y, side_front_y];
assert(side_front_y-side_rear_y > side_bearing_diameter+side_bearing_clearance,
       "Side bearings overlap; increase body length or reduce the end gap");
assert(side_front_gap > wheel_clearance+side_bearing_clearance);
assert(side_rear_gap > 0);
assert(side_front_y+side_bearing_r+side_bearing_clearance < front_axle_y-skirt_end_thickness/2,
       "Front side bearing overlaps the end skirt band");
assert(side_rear_y-side_bearing_r-side_bearing_clearance > cutter_axle_y+skirt_end_thickness/2,
       "Rear side bearing overlaps the end skirt band");
// With both rules shown, remove the left rule for screw access.
axle_receiving_side = guide_side == "left" ? -1 : 1;
axle_outer_halfspan = body_span/2-side_plastic_clearance;
front_thread_x = front_wheel_spacing/2+front_wheel_width/2+washer_disc_thickness+0.75;
rear_thread_x = rear_u_inner_x+0.7;
assert(front_thread_x+front_thread_length+0.2 < axle_outer_halfspan,
       "Front thread does not fit in the outer skirt wall");
assert(rear_thread_x+rear_thread_length+0.2 < axle_outer_halfspan);
assert(axle_thread_pitch*0.65+2*axle_thread_axial_clearance < axle_thread_pitch);
assert(axle_thread_depth < axle_diameter/3);

assert(skirt_end_thickness > max(front_axle_diameter, axle_diameter)+3);
assert(skirt_end_thickness > skirt_side_thickness);
assert(skirt_tile_clearance < min(front_z, cutter_z));
assert(side_bearing_bottom > 2, "Raise the rule height or reduce side bearing width to clear the tile and bolt heads");
assert(side_bearing_bottom < rail_height-1, "Side bearings must overlap the rule face");
assert(side_mount_bottom < deck_z && side_bearing_r > side_mount_diameter/2);
assert(side_spacer_diameter < side_mount_diameter && side_spacer_diameter < side_bearing_diameter);
assert(side_bearing_x-side_mount_diameter/2 > 0,
       "Side bearing mounts cross the carriage centerline; increase cut_offset");
assert(side_bearing_x+side_mount_diameter/2 < cut_offset-side_plastic_clearance,
       "Side bearing mounts extend into the plastic-to-rule clearance");


assert(rail_width > 0 && rail_height > 0);
assert(front_wheel_radius > front_wheel_hole_radius);
assert(cutter_radius > cutter_hole_radius);
assert(front_wheel_width > 0 && cutter_width > 0);
assert(cut_offset >= 0 && guide_clearance >= 0);
assert(cut_offset > front_wheel_spacing/2 + front_wheel_width/2 +
                   fork_thickness + wheel_clearance,
       "Carriage is too narrow for the front wheel forks");
assert(body_width >= 2*max(front_wheel_radius,cutter_radius));
assert(wheel_overhang >= 0 && wheel_overhang <= 0.5,
       "Wheel overhang must be between zero and half the diameter");
assert(side_mount_bottom+side_thread_depth < deck_z+body_height-2, "Blind thread needs at least 2 mm of closed roof");
assert(side_thread_pilot > 0 && side_thread_pilot < side_bearing_bore);
assert(rear_u_inner_x > rear_fork_side_reach,
       "Rear U skirt does not clear the cutter fork stack");
assert(rear_axle_spacer_thickness >= 0,
       "Rear U opening is too narrow for the cutter axle spacers");
assert(rear_u_outer_x < body_span/2,
       "Increase carriage width or reduce the rear U clearance/fork dimensions");
assert(axle_diameter/2 + axle_hole_clearance <= min(front_wheel_hole_radius,cutter_hole_radius),
       "Axle does not fit through the wheel bores");
assert(front_axle_diameter/2+axle_hole_clearance <= front_wheel_hole_radius);
assert(axle_head_diameter > max(axle_diameter, front_axle_diameter) && axle_head_thickness > 0,
       "Screw heads must be larger than both axle shafts");
assert(washer_outer_radius > axle_diameter/2 + axle_hole_clearance,
       "Washer outer radius must exceed its axle hole radius");

module annular_wheel(radius, width, hole_radius) {
    difference() {
        rotate([0, 90, 0]) cylinder(h=width, r=radius, center=true);
        rotate([0, 90, 0]) cylinder(h=width+2*eps, r=hole_radius, center=true);
    }
}

// Deck and skirt share one rectangular outer contour without end ledges.
module flat_deck() {
    translate([0, (front_axle_y+cutter_axle_y)/2, deck_z+body_height/2])
        cube([body_span-2*side_plastic_clearance,
              front_axle_y-cutter_axle_y+skirt_end_thickness, body_height], center=true);
}

module carriage_body() {
    difference() {
        union() {
            flat_deck();
            integrated_skirt();
            for (side = side_sides, y = side_bearing_positions)
                translate([side*side_bearing_x, y, 0]) {
                    translate([0, 0, side_mount_bottom])
                        cylinder(d=side_mount_diameter, h=deck_z-side_mount_bottom+0.2);
                    translate([0, 0, side_bearing_top])
                        cylinder(d=side_spacer_diameter, h=side_bearing_clearance+eps);
                }
        }
        side_mount_holes();
    }
}

module side_mount_holes() {
    for (side = side_sides, y = side_bearing_positions)
        translate([side*side_bearing_x, y, 0]) {
            // Shoulder clearance followed by a blind pilot for tapping from below.
            translate([0, 0, side_bearing_top-eps])
                cylinder(d=side_bearing_bore+side_bolt_clearance, h=side_bearing_clearance+eps);
            translate([0, 0, side_mount_bottom-eps])
                cylinder(d=side_thread_pilot, h=side_thread_depth+eps);
        }
}

module side_bearings() {
    color(side_bearing_color)
        for (side = side_sides, y = side_bearing_positions)
            translate([side*side_bearing_x, y, side_bearing_bottom])
                difference() {
                    cylinder(d=side_bearing_diameter, h=side_bearing_width);
                    translate([0, 0, -eps]) cylinder(d=side_bearing_bore, h=side_bearing_width+2*eps);
                }
}

// Simplified screws enter blind tapped mounts from below; no upper nuts.
module side_fasteners() {
    color(axle_color)
        for (side = side_sides, y = side_bearing_positions)
            translate([side*side_bearing_x, y, 0]) {
                translate([0, 0, side_bearing_bottom-2])
                    cylinder(d=side_bearing_bore*1.6, h=1.5, $fn=6);
                translate([0, 0, side_bearing_bottom-0.5])
                    cylinder(d=side_spacer_diameter, h=0.5);
                translate([0, 0, side_bearing_bottom-0.5])
                    cylinder(d=side_bearing_bore, h=side_mount_bottom+side_thread_depth-1-side_bearing_bottom+0.5);
            }
}

// Thick end bands contain bottom-open wheel pockets and side-inserted screw axles.
module integrated_skirt() {
    skirt_halfspan = body_span/2-side_plastic_clearance;
    band_height = deck_z-skirt_tile_clearance+0.2;
    side_bottom = max(skirt_tile_clearance, side_mount_bottom);
    side_height = deck_z-side_bottom+0.2;
    difference() {
        union() {
            for (side = [-1, 1])
                translate([side*(skirt_halfspan-skirt_side_thickness/2),
                           (front_axle_y+cutter_axle_y)/2,
                           side_bottom+side_height/2])
                    cube([skirt_side_thickness, front_axle_y-cutter_axle_y,
                          side_height], center=true);
            for (y = [front_axle_y, cutter_axle_y])
                translate([0, y, skirt_tile_clearance+band_height/2])
                    cube([2*skirt_halfspan, skirt_end_thickness, band_height], center=true);
        }
        // Wheel and washer cavities leave solid walls for the axle seats.
        for (x = [wheel_left_x, wheel_right_x])
            translate([x, front_axle_y, front_z]) rotate([0, 90, 0])
                cylinder(r=front_wheel_radius+wheel_clearance,
                         h=front_wheel_width+2*washer_disc_thickness+0.5, center=true);
        translate([0, cutter_axle_y, cutter_z]) rotate([0, 90, 0])
            cylinder(r=cutter_radius+wheel_clearance, h=2*rear_u_inner_x, center=true);
        screw_axle_socket(front_axle_y, front_z, front_axle_diameter, front_thread_x, front_thread_length);
        screw_axle_socket(cutter_axle_y, cutter_z, axle_diameter, rear_thread_x, rear_thread_length);
    }
}

// Local Z follows screw insertion from the free side toward the rule.
module axle_frame(y, z) {
    translate([-axle_receiving_side*axle_outer_halfspan, y, z])
        rotate([0, axle_receiving_side*90, 0]) children();
}

module screw_axle_socket(y, z, diameter, thread_x, thread_length) {
    thread_start = axle_outer_halfspan+thread_x;
    axle_frame(y, z) {
        translate([0, 0, -eps])
            cylinder(d=diameter+2*axle_hole_clearance, h=thread_start+2*eps);
        translate([0, 0, thread_start])
            printable_thread(diameter, thread_length+0.2,
                             axle_thread_clearance, axle_thread_axial_clearance);
    }
}

// Swept trapezoidal thread, with identical phase on screw and socket.
module printable_thread(diameter, length, radial_extra=0, axial_extra=0) {
    core_r = diameter/2-axle_thread_depth;
    pitch = axle_thread_pitch;
    start = pitch*0.4;
    finish = length-pitch*0.4;
    turns = (finish-start)/pitch;
    steps = ceil(turns*($preview ? 32 : 64));
    profile = [[core_r-0.1, -pitch*0.325-axial_extra],
               [diameter/2+radial_extra, -pitch*0.10-axial_extra],
               [diameter/2+radial_extra, pitch*0.10+axial_extra],
               [core_r-0.1, pitch*0.325+axial_extra]];
    points = [for (i=[0:steps], p=profile)
        let(a=360*turns*i/steps, z=start+pitch*a/360)
        [p[0]*cos(a), p[0]*sin(a), z+p[1]]];
    faces = concat([[3,2,1],[3,1,0]],
        [for(i=[0:steps-1],j=[0:3],t=[0:1])
            let(a=4*i+j,b=4*i+(j+1)%4,c=4*(i+1)+(j+1)%4,d=4*(i+1)+j)
            t==0 ? [a,b,c] : [a,c,d]],
        [[4*steps,4*steps+1,4*steps+2],[4*steps,4*steps+2,4*steps+3]]);
    union() {
        cylinder(r=core_r+radial_extra, h=length);
        polyhedron(points=points, faces=faces, convexity=12);
    }
}

module plastic_screw_axle(y, z, diameter, thread_x, thread_length) {
    color(axle_color) axle_frame(y, z)
        screw_axle_shape(diameter, thread_x, thread_length);
}

module screw_axle_shape(diameter, thread_x, thread_length) {
    thread_start = axle_outer_halfspan+thread_x;
    union() {
        // Single accessible hex head; the smooth shank passes through all wheel bores.
        translate([0, 0, -axle_head_thickness])
            cylinder(d=axle_head_diameter, h=axle_head_thickness, $fn=6);
        cylinder(d=diameter, h=thread_start+eps);
        translate([0, 0, thread_start]) printable_thread(diameter, thread_length);
    }
}

module front_axle_pin() {
    plastic_screw_axle(front_axle_y, front_z, front_axle_diameter,
                       front_thread_x, front_thread_length);
}

module rear_axle_pin() {
    plastic_screw_axle(cutter_axle_y, cutter_z, axle_diameter,
                       rear_thread_x, rear_thread_length);
}

module axle_pins() {
    front_axle_pin();
    rear_axle_pin();
}

module front_wheel_discs() {
    for (x = [wheel_left_x, wheel_right_x]) {
        color(front_wheel_color)
            translate([x, front_axle_y, front_z])
                annular_wheel(front_wheel_radius, front_wheel_width, front_wheel_hole_radius);
    }
}

module cutter_disc() {
    color(cutter_color)
        translate([cut_x, cutter_axle_y, cutter_z])
            annular_wheel(cutter_radius, cutter_width, cutter_hole_radius);
}

module washers() {
    color(washer_color) {
        for (wheel_x = [wheel_left_x, wheel_right_x], sx = [-1, 1])
            translate([wheel_x+sx*(front_wheel_width/2+washer_disc_thickness/2+0.1),
                       front_axle_y, front_z]) rotate([0,90,0])
                difference() {
                    cylinder(r=washer_outer_radius, h=washer_disc_thickness,
                             center=true, $fn=48);
                    cylinder(d=front_axle_diameter+2*axle_hole_clearance,
                             h=washer_disc_thickness+2*eps, center=true, $fn=32);
                }
        for (sx = [-1, 1])
            translate([sx*(cutter_width/2+washer_disc_thickness/2+0.1),
                       cutter_axle_y, cutter_z]) rotate([0,90,0])
                difference() {
                    cylinder(r=washer_outer_radius, h=washer_disc_thickness,
                             center=true, $fn=48);
                    cylinder(d=axle_diameter+2*axle_hole_clearance,
                             h=washer_disc_thickness+2*eps, center=true, $fn=32);
        // Separate spacer discs fill the wider U opening and keep the cutter centered.
        for (sx = [-1, 1])
            translate([sx*(rear_fork_side_reach+rear_u_clearance/2+
                            rear_axle_spacer_thickness/2),
                       cutter_axle_y, cutter_z]) rotate([0,90,0])
                difference() {
                    cylinder(r=washer_outer_radius,
                             h=rear_axle_spacer_thickness, center=true, $fn=48);
                    cylinder(d=axle_diameter+2*axle_hole_clearance,
                             h=rear_axle_spacer_thickness+2*eps, center=true, $fn=32);
                }
                }
    }
}

module guide_rule() {
    if (guide_side == "right" || guide_side == "both")
        color(guide_color)
            translate([cut_offset+guide_clearance, -rail_length/2, 0])
                cube([rail_width, rail_length, rail_height]);
    if (guide_side == "left" || guide_side == "both")
        color(guide_color)
            translate([-cut_offset-rail_width-guide_clearance, -rail_length/2, 0])
                cube([rail_width, rail_length, rail_height]);
}

module assembly() {
    if (show_guide) guide_rule();
    color(carriage_color) carriage_body();
    front_wheel_discs();
    cutter_disc();
    washers();
    axle_pins();
    side_bearings();
    side_fasteners();
}

if (part == "assembly") assembly();
else if (part == "guide") guide_rule();
else if (part == "carriage") color(carriage_color) carriage_body();
else if (part == "front_wheels") front_wheel_discs();
else if (part == "axle_print") {
    color(axle_color) {
        translate([-axle_head_diameter, 0, axle_head_thickness])
            screw_axle_shape(front_axle_diameter, front_thread_x, front_thread_length);
        translate([axle_head_diameter, 0, axle_head_thickness])
            screw_axle_shape(axle_diameter, rear_thread_x, rear_thread_length);
    }
}
else if (part == "front_axle") front_axle_pin();
else if (part == "rear_axle") rear_axle_pin();
else if (part == "axles") axle_pins();
else if (part == "washers") washers();
else if (part == "side_bearings") side_bearings();
else if (part == "side_fasteners") side_fasteners();
else if (part == "cutter") cutter_disc();
else if (part == "front_wheel") annular_wheel(front_wheel_radius, front_wheel_width, front_wheel_hole_radius);
