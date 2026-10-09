// Compact three-point scoring carriage for a large-format tile guide.
// Units: millimetres. The wheels are simplified as one-piece annular discs.

/* [View] */
part = "assembly"; // [assembly, guide, carriage, front_wheels, cutter, front_axle, rear_axle, axles, washers, front_wheel]

/* [Guide rule] */
// Rectangular rule lies flat on the tile: width across the tile, height above it.
rail_width = 50; // [20:1:100]
rail_height = 10; // [5:1:30]
guide_clearance = 0; // [0:0.1:1]
guide_side = "right"; // [right, left, both]

/* [Carriage] */
// Deck length along the guide. Its width is twice cut_offset, keeping the cutter centered.
body_width = 100; // [70:1:140]
body_height = 10; // [8:1:16]
body_edge_radius = 7; // [2:0.5:10]
deck_corner_radius = 7; // [2:0.5:12]
// Distance from the rule's near long side to the scoring line.
cut_offset = 27.5; // [26.5:0.5:40]
wheel_edge_margin = 2; // [1:0.5:10]
front_wheel_spacing = 29.5; // [16:0.5:29.5] Spacing left/right across the carriage.
skirt_thickness = 3; // [2:0.5:6]
skirt_tile_clearance = 1; // [0.5:0.5:4]
rear_u_clearance = 0.25; // [0:0.05:2] Axial clearance between cutter spacers and U-wall forks.
rear_u_opening_scale = 2; // [1:0.1:3] U-opening width relative to its previous width.
rear_wheel_edge_clearance = 0.1; // [0:0.1:2] Gap between the cutter rim and the rear outer edge.

/* [Front wheels] */
front_wheel_radius = 10; // [6:0.5:16]
front_wheel_width = 8; // [3:0.5:16]
front_wheel_hole_radius = 3.3; // [1:0.25:6] Axle diameter plus radial running clearance.

/* [Rear scoring wheel] */
cutter_radius = 11; // [6:0.5:18]
cutter_width = 3; // [1:0.25:8]
cutter_hole_radius = 3.3; // [1:0.25:6] Axle diameter plus radial running clearance.

/* [Axle snap fit] */
axle_diameter = 6; // [3:0.5:10] Smooth axle pin diameter.
axle_hole_clearance = 0.25; // [0:0.05:0.8] Clearance in wheel bores and axle seats.
axle_snap_gap = 5.5; // [3:0.1:5.8] Open throat width; smaller than the axle for a press fit.
fork_thickness = 3; // [2:0.5:6]
axle_head_diameter = 9; // [7:0.5:14] Integral end heads retain the axle laterally.
axle_head_thickness = 1.5; // [1:0.1:3]
axle_end_clearance = 0.1; // [0:0.05:1] Small running gap from the outer fork face to each head.

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

/* [Hidden] */
$fn = $preview ? 48 : 96;
eps = 0.02;
wheel_left_x = -front_wheel_spacing/2;
wheel_right_x = front_wheel_spacing/2;
cut_x = 0;
front_z = front_wheel_radius;
cutter_z = cutter_radius;
deck_z = 2 * max(front_wheel_radius, cutter_radius);
body_span = 2 * cut_offset;
body_mid_x = 0;
rail_length = 190;
fork_span_y = 14;
wheel_clearance = 0.8;
top_corner_radius = 1;
skirt_outer_corner_radius = deck_corner_radius+top_corner_radius;
// Travel is +Y: place the two front wheels and the rear cutter near opposite ends.
front_axle_y = body_width/2 - max(front_wheel_radius, fork_span_y/2) - wheel_edge_margin;
// Place the cutter rim just inside the carriage's rear outer edge.
cutter_axle_y = -body_width/2 + cutter_radius + rear_wheel_edge_clearance;
fork_top = deck_z;
// The U-wall forks sit just outside the rear cutter washers.
rear_fork_side_reach = cutter_width/2 + washer_disc_thickness + 0.1;
rear_u_inner_x = (rear_fork_side_reach + rear_u_clearance)*rear_u_opening_scale;
rear_u_outer_x = rear_u_inner_x + skirt_thickness;
rear_u_inner_y = cutter_radius+wheel_clearance;
rear_u_outer_y = rear_u_inner_y+skirt_thickness;
rear_axle_spacer_thickness = rear_u_inner_x-rear_fork_side_reach-rear_u_clearance;
front_ear_offset = front_wheel_width/2 + washer_disc_thickness + fork_thickness/2 + 0.25;
front_axle_halfspan = front_wheel_spacing/2 + front_ear_offset + fork_thickness/2;
rear_axle_halfspan = rear_u_inner_x + skirt_thickness;

assert(rail_width > 0 && rail_height > 0);
assert(front_wheel_radius > front_wheel_hole_radius);
assert(cutter_radius > cutter_hole_radius);
assert(front_wheel_width > 0 && cutter_width > 0);
assert(cut_offset >= 0 && guide_clearance >= 0);
assert(cut_offset > front_wheel_spacing/2 + front_wheel_width/2 +
                   fork_thickness + wheel_clearance,
       "Carriage is too narrow for the front wheel forks");
assert(body_width >= 2*max(front_wheel_radius,cutter_radius) + 2*wheel_edge_margin);
assert(cutter_axle_y-cutter_radius >= -body_width/2+rear_wheel_edge_clearance-eps,
       "Rear cutter extends beyond the carriage edge");
assert(body_height > body_edge_radius, "Body height must exceed the top edge radius");
assert(body_span > 2*body_edge_radius && body_width > 2*body_edge_radius);
assert(rear_u_inner_x > rear_fork_side_reach,
       "Rear U skirt does not clear the cutter fork stack");
assert(rear_axle_spacer_thickness >= 0,
       "Rear U opening is too narrow for the cutter axle spacers");
assert(rear_u_outer_x < body_span/2,
       "Increase carriage width or reduce the rear U clearance/fork dimensions");
assert(front_axle_halfspan+axle_end_clearance+axle_head_thickness <
       body_span/2-skirt_thickness,
       "Front wheel axle heads collide with the side skirts; reduce wheel spacing or increase carriage width");
assert(axle_diameter/2 + axle_hole_clearance <= min(front_wheel_hole_radius,cutter_hole_radius),
       "Axle does not fit through the wheel bores");
assert(axle_snap_gap < axle_diameter,
       "Snap-fit throat must be narrower than the axle diameter");
assert(axle_head_diameter > axle_diameter && axle_head_thickness > 0 && axle_end_clearance >= 0,
       "Axle end heads must be larger than the shaft and sit beyond the outer fork faces");
assert(washer_outer_radius > axle_diameter/2 + axle_hole_clearance,
       "Washer outer radius must exceed its axle hole radius");

module annular_wheel(radius, width, hole_radius) {
    difference() {
        rotate([0, 90, 0]) cylinder(h=width, r=radius, center=true);
        rotate([0, 90, 0]) cylinder(h=width+2*eps, r=hole_radius, center=true);
    }
}

module rounded_rect_2d(width, length, radius) {
    offset(r=radius) offset(delta=-radius)
        square([width, length], center=true);
}

// The lower outline matches the skirt; a clipped spherical cap rounds the top edge.
module rounded_deck() {
    r = body_edge_radius;
    cap_z = deck_z+body_height-r;
    overlap = 0.1;
    union() {
        translate([body_mid_x, 0, deck_z-overlap])
            linear_extrude(height=body_height-r+2*overlap)
                rounded_rect_2d(body_span, body_width, skirt_outer_corner_radius);
        intersection() {
            translate([body_mid_x, 0, cap_z])
                minkowski() {
                    linear_extrude(height=eps)
                        rounded_rect_2d(body_span-2*r, body_width-2*r,
                                        top_corner_radius);
                    sphere(r=r);
                }
            translate([-body_span, -body_width, cap_z])
                cube([2*body_span, 2*body_width, r+2*eps]);
        }
    }
}

// Tapered fork ears have downward-facing snap seats for bottom-up axle assembly.
module fork_pair(x, y, radius, width) {
    // Leave room for a washer between the wheel and each fork ear.
    ear_offset = width/2 + washer_disc_thickness + fork_thickness/2 + 0.25;
    ear_bottom = max(1, radius - axle_diameter/2 - 2);
    for (sx = [-1, 1]) {
        difference() {
            hull() {
                translate([x + sx*ear_offset, y, ear_bottom])
                    cube([fork_thickness, fork_span_y*0.65, 1], center=true);
                translate([x + sx*ear_offset, y, fork_top])
                    cube([fork_thickness, fork_span_y, 1], center=true);
            }
            translate([x + sx*ear_offset, y, radius]) rotate([0, 90, 0])
                cylinder(h=fork_thickness+0.2,
                         d=axle_diameter+2*axle_hole_clearance, center=true);
            // The narrow throat flexes as the smooth axle is pressed upward.
            slot_bottom = ear_bottom-1;
            slot_top = radius+eps;
            translate([x + sx*ear_offset, y,
                       (slot_bottom+slot_top)/2])
                cube([fork_thickness+0.3, axle_snap_gap,
                      slot_top-slot_bottom], center=true);
        }
    }
}

module carriage_body() {
    difference() {
        union() {
            rounded_deck();
            fork_pair(wheel_left_x, front_axle_y, front_wheel_radius, front_wheel_width);
            fork_pair(wheel_right_x, front_axle_y, front_wheel_radius, front_wheel_width);
            skirt_frame();
        }
    }
}

// A continuous skirt ties the full-length guide faces together. In plan view,
// the rear-open U-shaped skirt wraps around the cutter and its axle snap seats.
module skirt_frame() {
    skirt_height = deck_z-skirt_tile_clearance;
    u_fork_x = rear_u_inner_x+skirt_thickness/2;
    u_leg_center_y = (-body_width/2+cutter_axle_y)/2;
    u_leg_length = cutter_axle_y+body_width/2;
    union() {
        difference() {
            union() {
                // Full perimeter skirt; remove its straight rear bridge at the U opening.
                translate([0, 0, skirt_tile_clearance])
                    linear_extrude(height=skirt_height)
                        difference() {
                            difference() {
                                rounded_rect_2d(body_span, body_width,
                                                skirt_outer_corner_radius);
                                rounded_rect_2d(body_span-2*skirt_thickness,
                                                body_width-2*skirt_thickness,
                                                max(0.1, skirt_outer_corner_radius-skirt_thickness));
                            }
                            translate([0, -body_width/2])
                                square([2*rear_u_inner_x+2*eps,
                                        2*skirt_thickness+2*eps], center=true);
                        }
                // Flat Π-shaped bridge and side rails leave the cutter opening open below.
                translate([0, cutter_axle_y, skirt_tile_clearance])
                    linear_extrude(height=skirt_height)
                        difference() {
                            translate([0, rear_u_outer_y/2])
                                square([2*rear_u_outer_x, rear_u_outer_y], center=true);
                            translate([0, (rear_u_inner_y-eps)/2])
                                square([2*rear_u_inner_x, rear_u_inner_y+eps], center=true);
                        }
                translate([0, 0, skirt_tile_clearance])
                    linear_extrude(height=skirt_height)
                        for (side = [-1, 1])
                            translate([side*u_fork_x, u_leg_center_y])
                                square([skirt_thickness, u_leg_length], center=true);
            }
            // One continuous pair of lower-open sockets cuts through the joined U walls.
            for (side = [-1, 1]) {
                translate([side*u_fork_x, cutter_axle_y, cutter_z]) rotate([0,90,0])
                    cylinder(d=axle_diameter+2*axle_hole_clearance,
                             h=skirt_thickness+2*eps, center=true,
                             $fn=32);
                translate([side*u_fork_x, cutter_axle_y,
                           (cutter_z+skirt_tile_clearance)/2])
                    cube([skirt_thickness+2*eps, axle_snap_gap,
                          cutter_z-skirt_tile_clearance+eps], center=true);
            }
            // The front bridge wraps around both support wheels.
            for (x = [wheel_left_x, wheel_right_x])
                translate([x, front_axle_y, front_z]) rotate([0, 90, 0])
                    cylinder(h=front_wheel_width+2*fork_thickness+2*wheel_clearance,
                             r=front_wheel_radius+wheel_clearance, center=true);
        }
    }
}

// Smooth axles are separate parts. The wheels are assembled onto them first,
// then the wheel-and-axle units press upward into the carriage snap forks.
module axle_pin_with_heads(y, z, support_halfspan) {
    total_halfspan = support_halfspan+axle_end_clearance+axle_head_thickness;
    color(axle_color) union() {
        translate([0, y, z]) rotate([0,90,0])
            cylinder(d=axle_diameter, h=2*total_halfspan, center=true);
        for (side = [-1, 1])
            translate([side*(support_halfspan+axle_end_clearance+axle_head_thickness/2),
                       y, z]) rotate([0,90,0])
                cylinder(d=axle_head_diameter, h=axle_head_thickness, center=true);
    }
}

module front_axle_pin() {
    axle_pin_with_heads(front_axle_y, front_z, front_axle_halfspan);
}

module rear_axle_pin() {
    axle_pin_with_heads(cutter_axle_y, cutter_z, rear_axle_halfspan);
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
                    cylinder(d=axle_diameter+2*axle_hole_clearance,
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
}

if (part == "assembly") assembly();
else if (part == "guide") guide_rule();
else if (part == "carriage") color(carriage_color) carriage_body();
else if (part == "front_wheels") front_wheel_discs();
else if (part == "front_axle") front_axle_pin();
else if (part == "rear_axle") rear_axle_pin();
else if (part == "axles") axle_pins();
else if (part == "washers") washers();
else if (part == "cutter") cutter_disc();
else if (part == "front_wheel") annular_wheel(front_wheel_radius, front_wheel_width, front_wheel_hole_radius);
