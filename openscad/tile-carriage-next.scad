// Compact three-point scoring carriage for a large-format tile guide.
// Units: millimetres. The wheels are simplified as one-piece annular discs.

/* [View] */
part = "assembly"; // [assembly, print, guide, carriage, front_wheels, cutter, front_axle, rear_axle, axles, washers, front_wheel, side_bearings, side_fasteners, axle_print, magnets, magnet_screws, magnet_screws_print]

/* [Print layout] */
print_gap = 8; // [4:1:20] Minimum layout spacing between part envelopes.

/* [Guide rule] */
// Rectangular rule lies flat on the tile: width across the tile, height above it.
rail_width = 50; // [20:1:100]
rail_height = 20; // [5:1:30]
guide_opacity = 0.35; // [0.1:0.05:1] Guide opacity in the browser preview.
guide_clearance = 0; // [0:0.1:1]
guide_side = "right"; // [right, left, both]

/* [Shared wheel bearings] */
bearing_diameter = 22; // [12:1:32] Outside diameter of both support and side bearings.
bearing_width = 7; // [4:0.5:12] Width of all four bearings.
bearing_bore = 8; // [3:1:12] Bore of all four bearings.

/* [Front wheel bearing zone] */
front_wheel_bearing_diameter = 12; // [9:0.5:20] Bearing contact diameter, also the front washer outside diameter.

/* [Shared bearing screw threads] */
bearing_thread_diameter = 8; // [6:1:10] Nominal metric diameter: M8 for the front axle and side screws.
bearing_thread_pitch = 1.25; // [0.5:0.25:2] M8 coarse pitch.
bearing_thread_clearance = 0.15; // [0.05:0.05:0.3] Radial thread clearance.
bearing_thread_axial_clearance = 0.08; // [0.04:0.02:0.16] Shared axial thread clearance.

/* [Standard screw lengths] */
front_bolt_length = 75; // [50:5:85] M8 length under the head for the wider carriage.
rear_bolt_length = 33; // [25:1:55] M6 cutter-kit bolt length under the head.
side_bolt_length = 30; // [20:1:40] M8 length under the head for two stacked bearings; use low button heads.
magnet_bolt_length = 12; // [10:1:20] Metal M4 countersunk screw, overall length including the head.
bolt_bottom_clearance = 0.5; // [0.3:0.1:1] Blind-hole extra depth beyond the bolt tip.
side_lower_washer_thickness = 0.5; // [0.3:0.1:1] Separate lower washers also work with metal side screws.

/* [Metric thread printing] */
thread_external_radial_compensation = 0.1; // [0:0.025:0.2] Radial undersize of printed male threads; 0 uses nominal metric geometry.

/* [Side guide bearings] */
side_bearing_count = 2; // [1:1:2] Bearings stacked vertically on each side-guide axle.
side_front_gap = 4; // [1.5:0.5:15] Longitudinal edge gap to the front wheels.
side_rear_gap = 0; // [0:0.5:15] Longitudinal projected edge gap to the rear cutter.
side_plastic_clearance = 1.5; // [0.5:0.1:3] Plastic setback from the rule face.
side_bearing_clearance = 0.5; // [0.2:0.1:1] Radial pocket and outer-ring axial clearance.
side_bearing_tile_clearance = 2.5; // [2.5:0.5:6] Minimum bearing bottom clearance when the rule is too low for centering.
side_mount_diameter = 14; // [8:0.5:20]
enable_side_mount_ribs = true;
side_mount_rib_thickness = 3; // [2:0.5:5] One rectangular transverse rib per side-bearing mount.
side_bolt_clearance = 0.4; // [0.2:0.1:0.8] Clearance through the inner-ring shoulder.
side_screw_journal_diameter = 7.6; // [6:0.1:8] Smooth bearing journal, separate from the M8 thread.
side_thread_depth = 16; // [8:1:20] Blind socket for the longer paired-bearing axle.

/* [Magnets] */
enable_magnets = true;
enable_center_magnet = true; // Magnet halfway between the side guide bearings.
enable_end_magnets = false; // Optional front and rear magnets with projecting ears.
magnet_axle_web = 3; // [2:0.5:8] Solid longitudinal gap between magnet pocket and axle passage.
magnet_ear_overlap = 3; // [2:0.5:6] Ear connection overlap into the end band.
magnet_ear_shoulder_radius = 0; // [0:0.5:6] Shoulder rounding; zero keeps a sharp transition to the deck.
magnet_diameter = 20; // [5:0.5:30] Outside diameter.
magnet_thickness = 5; // [1:0.5:8]
magnet_hole_diameter = 4.5; // [1:0.1:6] Through-hole diameter.
magnet_countersink_diameter = 10; // [2:0.1:14] Outer countersink diameter.
magnet_countersink_wall_angle = 45; // [15:1:75] Wall angle to the hole axis; full cone angle is twice this value.
magnet_fit_clearance = 0.15; // [0.05:0.05:0.4] Radial pocket clearance.
magnet_face_recess = 0.1; // [0:0.1:2] Magnet face setback behind the plastic outer face; 0 is flush.
magnet_holder_wall = 1.75; // [1.5:0.25:3] Radial carrier wall allowance.
magnet_screw_diameter = 4; // [2:0.1:4] Metal screw shank diameter.
magnet_thread_diameter = 4; // [2:0.5:4] Metal M4 fastener, shown without thread detail.
magnet_screw_thread_pitch = 0.7; // [0.4:0.1:0.8] M4 coarse pitch (reference only).
magnet_nut_across_flats = 7; // [5:0.1:10] Metal nut width across flats.
magnet_nut_thickness = 3.2; // [2:0.1:5] Metal nut thickness.
magnet_nut_clearance = 0.2; // [0.1:0.05:0.5] Pocket clearance per side.
magnet_backing_wall = 2; // [2:0.5:5] Plastic between magnet and nut.
magnet_screw_thread_clearance = 0.12; // [0.05:0.01:0.25]
magnet_screw_head_clearance = 0.3; // [0.1:0.1:0.6] Diametral countersink clearance.
magnet_mount_back_wall = 1.5; // [1:0.5:3] Closed wall behind the blind thread.
magnet_block_tile_clearance = 3; // [0.5:0.5:4] Minimum height of the magnet holder above the tile.

/* [Carriage] */
// Deck length along the guide. Extra width is added only opposite the active rule.
body_width = 100; // [70:1:180]
body_height = 14; // [8:1:36] Crown peak height above the deck underside; preserve the original 44 mm overall height.
pressure_grip_height = 0; // [0:1:25] Raised palm rest over the cutter end; zero disables it.
top_crown_drop = 20; // [0:1:28] Integral transverse crown: edges lower than the ridge over the cutting line.
pressure_grip_forward = 14; // [10:1:30] Palm-rest center ahead of cutter axle, inside the support triangle.
pressure_grip_width = 32; // [24:1:44] Upper palm contact width, centered on the cutting line.
pressure_grip_length = 20; // [16:1:30] Upper palm contact length along travel.
enable_rear_taper = true; // Remove the free-side rear corner to discourage off-axis pressure.
body_edge_radius = 0; // [0:0.5:4] Rounding of the four upper edges and four vertical corners.
wheel_drop = 1; // [0:0.25:4] Lower wheels and cutter relative to the body.
// Distance from the rule's near long side to the scoring line.
cut_offset = 40; // [26.5:0.5:50]
body_free_side_extension = 3; // [0:0.5:12] Gives 80 mm total body width with a 40 mm scoring offset.
wheel_overhang = 0.5; // [0:0.05:0.5] Fraction of wheel diameter outside the deck at each end.
front_wheel_spacing = 46; // [16:0.5:50] Wider support base for the 80 mm body and M8x75 axle.
rear_u_clearance = 0; // [0:0.025:2] Per-side cutter stack clearance; zero fits the cutter and washers without extra axial play.
rear_fork_thickness = 5; // [3:0.5:8] Reinforced cutter support walls and bridge.
rear_u_opening_scale = 1; // [1:0.1:3] Cutter pocket width multiplier; 1 fits the cutter and thin washers.

/* [Rectangular skirt] */
skirt_side_thickness = 3; // [2:0.5:6]
skirt_end_thickness = 14; // [12:1:22] Front and rear bands centered on the wheel axes.
skirt_tile_clearance = 3; // [1:0.5:4]

/* [Rear scoring wheel] */
cutter_radius = 11; // [6:0.5:18]
cutter_width = 6; // [1:0.25:8]
cutter_hole_radius = 3; // [1:0.25:6] 6 mm cutter bore.
cutter_bearing_diameter = 8; // [7:0.5:20] Bearing contact diameter, also the cutter washer outside diameter.

/* [Plastic screw axles] */
axle_diameter = 5.5; // [3:0.5:10] Cutter axle with clearance in its 6 mm bore.
front_axle_diameter = 7.8; // [3:0.1:10] Smooth journal: 0.2 mm diametral clearance in an 8 mm bearing bore.
axle_hole_clearance = 0.25; // [0:0.05:0.8] Radial clearance in printed axle passages; bearing bores stay unchanged.
fork_thickness = 3; // [2:0.5:6]
axle_head_diameter = 11; // [7:0.5:14] Integral end heads retain the axle laterally.
axle_head_thickness = 3; // [2:0.5:5] Shared head height for wheel axles and side-bearing screws.

cutter_thread_diameter = 6; // [4:1:8] Nominal M6 thread diameter, separate from the smooth cutter axle.
axle_thread_pitch = 1; // [0.5:0.25:1.5] M6 coarse pitch.
axle_thread_clearance = 0.2; // [0.1:0.05:0.4] Radial thread clearance.
axle_thread_axial_clearance = 0.06; // [0.02:0.02:0.1] Axial fit clearance for the M6 profile.

/* [Washers] */
washer_disc_thickness = 2; // [2:0.1:4] Axial thickness of each wheel/cutter washer; pockets follow wheel width plus two washers exactly.

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
front_washer_radius = front_wheel_bearing_diameter/2;
cutter_washer_radius = cutter_bearing_diameter/2;
front_axle_passage_diameter = max(front_axle_diameter+2*axle_hole_clearance,bearing_thread_diameter+0.2);
rear_axle_passage_diameter = max(axle_diameter+2*axle_hole_clearance,cutter_thread_diameter+0.2);
side_bearing_diameter = bearing_diameter;
side_bearing_width = bearing_width;
side_bearing_bore = bearing_bore;
wheel_left_x = -front_wheel_spacing/2;
wheel_right_x = front_wheel_spacing/2;
cut_x = 0;
front_z = front_wheel_radius;
cutter_z = cutter_radius;
deck_z = 2 * max(front_wheel_radius, cutter_radius)+wheel_drop+
    (side_bearing_count-1)*side_bearing_width;
body_span = 2 * cut_offset;
axle_receiving_side = guide_side == "left" ? -1 : 1;
body_actual_width = body_span-2*side_plastic_clearance+body_free_side_extension;
body_mid_x = -axle_receiving_side*body_free_side_extension/2;
rail_length = 190;
fork_span_y = 14;
wheel_clearance = 0.8;
// Travel is +Y: place the two front wheels and the rear cutter near opposite ends.
front_axle_y = body_width/2-front_wheel_radius+2*front_wheel_radius*wheel_overhang;
// At half-diameter overhang, the wheel axes lie on the deck end edges.
cutter_axle_y = -body_width/2+cutter_radius-2*cutter_radius*wheel_overhang;
fork_top = deck_z;
// The U-wall forks sit just outside the rear cutter washers.
rear_fork_side_reach = cutter_width/2 + washer_disc_thickness;
rear_u_inner_x = (rear_fork_side_reach + rear_u_clearance)*rear_u_opening_scale;
rear_u_outer_x = rear_u_inner_x + rear_fork_thickness;
rear_u_inner_y = cutter_radius+wheel_clearance;
rear_u_outer_y = rear_u_inner_y+rear_fork_thickness;
rear_axle_spacer_thickness = max(0,rear_u_inner_x-rear_fork_side_reach-rear_u_clearance);
front_ear_offset = front_wheel_width/2 + washer_disc_thickness + fork_thickness/2 + 0.25;
front_axle_halfspan = front_wheel_spacing/2 + front_ear_offset + fork_thickness/2;
rear_axle_halfspan = rear_u_inner_x + rear_fork_thickness;
side_bearing_r = side_bearing_diameter/2;
side_bearing_x = cut_offset-side_bearing_r;
// Keep room below for the bolt head even with an 8 mm wide bearing on a 10 mm rule.
side_bearing_z = max(rail_height/2,side_bearing_width/2+side_bearing_tile_clearance);
side_bearing_bottom = side_bearing_z-side_bearing_width/2;
side_screw_head_bottom = side_bearing_bottom-side_lower_washer_thickness-axle_head_thickness;
side_bearing_top = side_bearing_bottom+side_bearing_count*side_bearing_width;
side_mount_bottom = side_bearing_top+side_bearing_clearance;
side_screw_thread_length = side_bolt_length-(side_mount_bottom-side_bearing_bottom+side_lower_washer_thickness);
magnet_screw_thread_length = magnet_bolt_length-magnet_thickness;
side_sides = guide_side == "both" ? [-1, 1] : guide_side == "left" ? [-1] : [1];
side_spacer_diameter = side_bearing_bore+2;
side_front_y = front_axle_y-front_wheel_radius-side_bearing_r-side_front_gap;
side_rear_y = cutter_axle_y+cutter_radius+side_bearing_r+side_rear_gap;
side_bearing_positions = [side_rear_y, side_front_y];
magnet_holder_diameter = magnet_diameter+2*magnet_holder_wall;
magnet_front_x = cut_offset-side_plastic_clearance-magnet_face_recess;
magnet_rear_x = magnet_front_x-magnet_thickness;
magnet_holder_inner_x = magnet_rear_x-magnet_backing_wall-magnet_nut_thickness-magnet_nut_clearance;
magnet_screw_head_diameter = 8; // Reference metal M4 countersunk head; verify actual hardware.
magnet_screw_head_depth = (magnet_screw_head_diameter-magnet_screw_diameter)/(2*tan(magnet_countersink_wall_angle));
magnet_center_z = max(rail_height/2,magnet_diameter/2+skirt_tile_clearance);
// Magnets sit near the end corners; the front one clears the support-wheel axle.
magnet_center_y = (side_rear_y+side_front_y)/2;
magnet_center_holder_radius = max(magnet_holder_diameter/2,
                                 magnet_center_z-magnet_block_tile_clearance);
magnet_rear_y = cutter_axle_y-max(skirt_end_thickness/2+magnet_center_holder_radius-magnet_ear_overlap,
    rear_axle_passage_diameter/2+magnet_diameter/2+magnet_fit_clearance+magnet_axle_web);
magnet_front_y = front_axle_y+max(skirt_end_thickness/2+magnet_center_holder_radius-magnet_ear_overlap,
    front_axle_passage_diameter/2+magnet_diameter/2+magnet_fit_clearance+magnet_axle_web);
magnet_positions = concat(enable_end_magnets ? [magnet_rear_y,magnet_front_y] : [],
                          enable_center_magnet ? [magnet_center_y] : []);
magnet_cone_depth = (magnet_countersink_diameter-magnet_hole_diameter)/
                    (2*tan(magnet_countersink_wall_angle));
if (enable_magnets) {
    assert(magnet_hole_diameter > 0 && magnet_hole_diameter < magnet_countersink_diameter);
    assert(magnet_countersink_diameter < magnet_diameter && magnet_cone_depth < magnet_thickness);
    assert(magnet_screw_diameter < magnet_hole_diameter);
    assert(magnet_screw_head_diameter > magnet_hole_diameter);
    assert(magnet_screw_head_depth < magnet_thickness);
    assert(magnet_thread_diameter-2*thread_external_radial_compensation <= magnet_hole_diameter);
    assert(magnet_center_z-magnet_holder_diameter/2 > 0, "Magnet carrier touches the tile");
    if (enable_end_magnets) assert(magnet_positions[0]+magnet_holder_diameter/2 < side_rear_y-side_bearing_r &&
           magnet_positions[1]-magnet_holder_diameter/2 > side_front_y+side_bearing_r,
           "Corner magnets overlap side bearings; reduce magnet diameter or adjust the corner offsets");
    if (enable_center_magnet)
        assert((side_front_y-side_rear_y)/2 > side_bearing_r+magnet_center_holder_radius+side_bearing_clearance,
               "Center magnet overlaps side bearings; reduce its diameter or increase bearing spacing");
}
assert(side_front_y-side_rear_y > side_bearing_diameter+side_bearing_clearance,
       "Side bearings overlap; increase body length or reduce the end gap");
assert(side_front_gap > wheel_clearance+side_bearing_clearance);
assert(side_rear_gap >= 0);
assert(side_front_y+side_bearing_r+side_bearing_clearance < front_axle_y-skirt_end_thickness/2,
       "Front side bearing overlaps the end skirt band");
assert(side_rear_y-side_bearing_r-side_bearing_clearance > cutter_axle_y+skirt_end_thickness/2,
       "Rear side bearing overlaps the end skirt band");
// The opposite rule is only a reference in both-side view; remove it for screw access.
axle_outer_halfspan = body_span/2-side_plastic_clearance;
front_head_halfspan = axle_outer_halfspan+body_free_side_extension;
// Recess short cutter bolts while retaining at least the fork thickness of thread.
rear_thread_x = rear_u_inner_x+0.7;
rear_head_halfspan = min(front_head_halfspan,
                        rear_bolt_length-rear_thread_x-max(rear_fork_thickness,3*axle_thread_pitch));
rear_head_recess_depth = front_head_halfspan-rear_head_halfspan;
rear_head_recess_diameter = max(axle_head_diameter,2*cutter_thread_diameter)+2*axle_hole_clearance;
function axle_head_halfspan(y) = y == cutter_axle_y ? rear_head_halfspan : front_head_halfspan;
function body_outer_x(side) = side*axle_outer_halfspan-(side == -axle_receiving_side ? axle_receiving_side*body_free_side_extension : 0);
front_thread_x = front_wheel_spacing/2+front_wheel_width/2+washer_disc_thickness+0.2;
front_thread_length = front_bolt_length-front_head_halfspan-front_thread_x;
rear_thread_length = rear_bolt_length-rear_head_halfspan-rear_thread_x;
assert(rear_head_halfspan >= rear_u_outer_x,
       "Cutter bolt is too short to retain the head-side fork wall");
assert(front_thread_length >= 3*bearing_thread_pitch, "Front standard bolt is too short for adequate thread engagement");
assert(rear_thread_length >= 3*axle_thread_pitch, "Cutter standard bolt is too short for adequate thread engagement");
assert(side_screw_thread_length >= 3*bearing_thread_pitch && side_screw_thread_length+bolt_bottom_clearance <= side_thread_depth, "Side bolt length does not fit its blind socket");
assert(magnet_bolt_length >= magnet_thickness+magnet_backing_wall+magnet_nut_thickness,
       "Magnet screw must reach through the metal nut");
assert(front_thread_x+front_thread_length+bolt_bottom_clearance < axle_outer_halfspan,
       "Front thread does not fit in the outer skirt wall");
assert(rear_thread_x+rear_thread_length+bolt_bottom_clearance < axle_outer_halfspan);
assert(thread_external_radial_compensation >= 0);
assert(axle_thread_pitch > 0);
assert(cutter_thread_diameter-2*thread_external_radial_compensation <= 2*cutter_hole_radius);

assert(skirt_end_thickness > max(front_axle_diameter, axle_diameter)+3);
assert(skirt_end_thickness > skirt_side_thickness);
assert(skirt_tile_clearance < min(front_z, cutter_z));
assert(side_bearing_bottom > 2, "Raise the rule height or reduce side bearing width to clear the tile and bolt heads");
assert(side_screw_head_bottom > 0,
       "Shared screw head height leaves no tile clearance; reduce it or raise the side bearings");
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
assert(side_screw_journal_diameter < side_bearing_bore);
assert(bearing_thread_diameter-2*thread_external_radial_compensation <= min(side_bearing_bore,2*front_wheel_hole_radius));
assert(rear_u_inner_x >= rear_fork_side_reach,
       "Rear U skirt does not clear the cutter fork stack");
assert(rear_axle_spacer_thickness >= 0,
       "Rear U opening is too narrow for the cutter axle spacers");
assert(rear_u_outer_x < body_span/2,
       "Increase carriage width or reduce the rear U clearance/fork dimensions");
assert(axle_diameter/2 + axle_hole_clearance <= min(front_wheel_hole_radius,cutter_hole_radius),
       "Axle does not fit through the wheel bores");
assert(front_axle_diameter/2 <= front_wheel_hole_radius,
       "Front axle journal exceeds the bearing bore");
assert(axle_head_diameter > max(axle_diameter, front_axle_diameter) && axle_head_thickness > 0,
       "Screw heads must be larger than both axle shafts");
assert(body_free_side_extension >= 0);
assert(front_wheel_bearing_diameter > 2*front_wheel_hole_radius &&
       front_wheel_bearing_diameter < 2*front_wheel_radius,
       "Front bearing diameter must be between the bore and wheel outside diameters");
assert(cutter_bearing_diameter > 2*cutter_hole_radius && cutter_bearing_diameter < 2*cutter_radius,
       "Cutter bearing diameter must be between the bore and cutter outside diameters");
assert(front_washer_radius > front_axle_diameter/2+axle_hole_clearance);
assert(cutter_washer_radius > axle_diameter/2+axle_hole_clearance);

module annular_wheel(radius, width, hole_radius) {
    difference() {
        rotate([0, 90, 0]) cylinder(h=width, r=radius, center=true);
        rotate([0, 90, 0]) cylinder(h=width+2*eps, r=hole_radius, center=true);
    }
}

// Deck and skirt share one outer contour without end ledges.
module carriage_outer_envelope() {
    length = front_axle_y-cutter_axle_y+skirt_end_thickness;
    top = deck_z+body_height;
    r = body_edge_radius;
    translate([body_mid_x,(front_axle_y+cutter_axle_y)/2,0])
        if (r > 0)
            // Extend below the body so only the top and vertical edges are rounded.
            minkowski() {
                translate([-body_actual_width/2+r,-length/2+r,-r])
                    cube([body_actual_width-2*r,length-2*r,top]);
                sphere(r=r);
            }
        else
            translate([-body_actual_width/2,-length/2,-eps])
                cube([body_actual_width,length,top+eps]);
}

module flat_deck() {
    translate([body_mid_x, (front_axle_y+cutter_axle_y)/2, deck_z+body_height/2])
        cube([body_actual_width,
              front_axle_y-cutter_axle_y+skirt_end_thickness, body_height], center=true);
}

// A narrow raised landing cues pressure on the cutting line near the rear axle.
// The longer front slope guides the palm away from the lightly loaded front end.
module pressure_grip() {
    if (pressure_grip_height > 0)
        hull() {
            translate([0,cutter_axle_y+24,deck_z+body_height-eps/2])
                cube([min(body_actual_width-8,pressure_grip_width+20),48,eps],center=true);
            translate([0,cutter_axle_y+pressure_grip_forward,
                       deck_z+body_height+pressure_grip_height-eps/2])
                cube([pressure_grip_width,pressure_grip_length,eps],center=true);
        }
}

// Taper the free side toward the cutter, retaining the recessed axle-head seat.
module rear_taper_shape(wall=false) {
    outer = front_head_halfspan;
    rear = max(rear_head_halfspan+3,rear_u_outer_x+skirt_side_thickness);
    y0 = cutter_axle_y-skirt_end_thickness/2;
    y1 = front_axle_y-15;
    t = skirt_side_thickness;
    scale([-axle_receiving_side,1,1])
        translate([0,0,wall ? skirt_tile_clearance : -eps])
            linear_extrude(height=wall ? deck_z-skirt_tile_clearance+eps :
                deck_z+body_height+pressure_grip_height+2*eps)
                polygon(wall ? [[rear,y0],[outer,y1],[outer-t,y1],[rear-t,y0]] :
                    [[rear,y0],[outer,y1],[outer+20,y1],
                     [outer+20,y0-20],[rear,y0-20]]);
}

// Compound roof with matching outer and inner surfaces.
function crown_z(x,y) = let(x0=body_mid_x-body_actual_width/2,
 x1=body_mid_x+body_actual_width/2, rear=cutter_axle_y-skirt_end_thickness/2,
 front=front_axle_y+skirt_end_thickness/2, peak=cutter_axle_y+35,
 drop=y>peak ? 16*pow((y-peak)/(front-peak),2) : 3*pow((peak-y)/(peak-rear),2),
 z=deck_z+body_height-top_crown_drop*pow(x/(x<0 ? -x0 : x1),2)-drop,
 rear_width=max(rear_head_halfspan+3,rear_u_outer_x+skirt_side_thickness),
 free_width=enable_rear_taper ? rear_width+(front_head_halfspan-rear_width)*
     min(1,max(0,(y-rear)/(front_axle_y-15-rear))) : front_head_halfspan,
 distance=free_width+x*axle_receiving_side,
 t=min(1,max(0,1-distance/12)),
 corner_drop=min(12,max(0,z-skirt_tile_clearance-skirt_side_thickness)),
 rounded=z-(x*axle_receiving_side<0 ? corner_drop*(1-sqrt(max(0,1-t*t))) : 0),
 // Raise only the front roof; keep a solid shell above the rolling envelope.
 blend=min(1,max(0,(y-(front_axle_y-30))/16)),
 front_floor=2*front_wheel_radius+skirt_side_thickness+1,
 front_weight=blend*blend*(3-2*blend))
 max(rounded,front_floor*front_weight);
module crown_mesh(cut=false) {
 nx=40; ny=60; n=(nx+1)*(ny+1);
 x0=body_mid_x-body_actual_width/2; x1=body_mid_x+body_actual_width/2;
 y0=cutter_axle_y-skirt_end_thickness/2; y1=front_axle_y+skirt_end_thickness/2;
 pts=[for(l=[0:1],j=[0:ny],i=[0:nx]) let(x=x0+(x1-x0)*i/nx,y=y0+(y1-y0)*j/ny,z=crown_z(x,y))
 [x,y,l==0 ? (cut ? deck_z+body_height+pressure_grip_height+1 : z) : (cut ? z : z-skirt_side_thickness)]];
 tf=[for(j=[0:ny-1],i=[0:nx-1]) let(a=j*(nx+1)+i,b=a+1,c=a+nx+1,d=c+1) each [[a,b,d],[a,d,c]]];
 bf=[for(f=tf) [f[2]+n,f[1]+n,f[0]+n]];
 ring=concat([for(i=[0:nx]) i],[for(j=[1:ny]) j*(nx+1)+nx],
 [for(i=[nx-1:-1:0]) ny*(nx+1)+i],[for(j=[ny-1:-1:1]) j*(nx+1)]);
 sf=[for(k=[0:len(ring)-1]) let(a=ring[k],b=ring[(k+1)%len(ring)]) each [[a,a+n,b+n],[a,b+n,b]]];
 // OpenSCAD polyhedra use clockwise faces when viewed from outside.
 polyhedron(points=pts,faces=[for(f=concat(tf,bf,sf)) [f[2],f[1],f[0]]],convexity=10);
}
module top_crown_cut() { crown_mesh(cut=true); }
module crown_shell() { crown_mesh(); }

// Broad ellipsoidal caps blend each blind socket into the roof.
module bearing_roof_hills() {
    peak = side_mount_bottom+side_thread_depth+2;
    r = 18;
    h = 12;
    for (side=side_sides,y=side_bearing_positions)
        intersection() {
            translate([side*side_bearing_x,y,peak-h])
                scale([1,1,h/r]) sphere(r=r,$fn=72);
            translate([side*side_bearing_x,y,side_mount_bottom+(peak-side_mount_bottom)/2])
                cube([2*r,2*r,peak-side_mount_bottom],center=true);
            translate([body_mid_x,0,peak/2])
                cube([body_actual_width,body_width+skirt_end_thickness,peak],center=true);
        }
}

module carriage_body() {
    difference() {
        union() {
        intersection() {
        carriage_outer_envelope();
        union() {
            flat_deck();
            integrated_skirt();
            if (enable_side_mount_ribs) side_mount_ribs();
            for (side = side_sides, y = side_bearing_positions)
                translate([side*side_bearing_x, y, 0]) {
                    translate([0, 0, side_mount_bottom])
                        translate([-side_mount_diameter/2,-side_mount_diameter/2,0])
                            cube([side_mount_diameter,side_mount_diameter,
                                  deck_z-side_mount_bottom+0.2]);
                    translate([0, 0, side_bearing_top])
                        cylinder(d=side_spacer_diameter, h=side_bearing_clearance+eps);
                }
        }
        }
        // Ears extend beyond the rounded body envelope and join its end bands.
        if (enable_magnets) magnet_holders();
        pressure_grip();
        crown_shell();
        bearing_roof_hills();
        if (enable_rear_taper) rear_taper_shape(wall=true);
        }
        if (enable_rear_taper) rear_taper_shape();
        difference() {
            top_crown_cut();
            // Preserve local material around blind bearing sockets, without
            // raising the crown or keeping a tall wall along the whole side.
            bearing_roof_hills();
        }
        side_mount_holes();
        // Preserve the wheel-and-washer rotation space.
        for (x=[wheel_left_x,wheel_right_x])
            translate([x,front_axle_y,front_z]) rotate([0,90,0])
                cylinder(r=front_wheel_radius+wheel_clearance,
                         h=front_wheel_width+2*washer_disc_thickness,center=true);
        // Cut axle sockets through the complete body, including the corner magnet blocks.
        front_axle_socket();
        screw_axle_socket(cutter_axle_y,cutter_z,axle_diameter,rear_thread_x,rear_thread_length);
        if (enable_magnets) magnet_mount_holes();
    }
}

// One centered rectangular rib joins each bearing block to the opposite skirt.
// The underside clears the bearing; side_mount_holes preserves the screw socket.
module side_mount_ribs() {
    t = min(side_mount_rib_thickness,side_mount_diameter/3);
    for (side=side_sides,y=side_bearing_positions) {
        mount_x = side*(side_bearing_x-side_mount_diameter/2+t/2);
        wall_x = body_outer_x(-side)+side*skirt_side_thickness/2;
        translate([(mount_x+wall_x)/2,y,(side_mount_bottom+deck_z+0.2)/2])
            cube([abs(mount_x-wall_x)+min(t,skirt_side_thickness),
                  t,deck_z+0.2-side_mount_bottom],center=true);
    }
}

module side_mount_holes() {
    for (side = side_sides, y = side_bearing_positions)
        translate([side*side_bearing_x, y, 0]) {
            // Shoulder clearance followed by the matching blind printed thread.
            translate([0, 0, side_bearing_top-eps])
                cylinder(d=side_bearing_bore+side_bolt_clearance, h=side_bearing_clearance+eps);
            translate([0, 0, side_mount_bottom])
                metric_thread(bearing_thread_diameter,side_thread_depth,bearing_thread_pitch,
                              true,bearing_thread_clearance,bearing_thread_axial_clearance);
        }
}

// Carriers have rule-side magnet pockets and rear-access hexagonal nut pockets.
module magnet_frame(side, y) {
    translate([side*magnet_holder_inner_x, y, magnet_center_z])
        rotate([0, side*90, 0]) children();
}

module magnet_screw_frame(side, y) {
    translate([side*magnet_front_x, y, magnet_center_z])
        rotate([0, -side*90, 0]) children();
}

module magnet_holders() {
    holder_depth = cut_offset-side_plastic_clearance-magnet_holder_inner_x;
    for (side=side_sides, i=[0:len(magnet_positions)-1]) {
        y = magnet_positions[i];
        holder_radius = magnet_center_holder_radius;
        holder_center_z = magnet_block_tile_clearance+holder_radius;
        if (enable_end_magnets && i < 2) {
            // A full round nose flows tangentially into a rounded upper shoulder.
            // Both sections share the backing face, keeping the nut accessible.
            inward = i == 0 ? 1 : -1;
            end_y = i == 0 ? cutter_axle_y-skirt_end_thickness/2 :
                            front_axle_y+skirt_end_thickness/2;
            r = magnet_ear_shoulder_radius;
            hull() {
                translate([side*magnet_holder_inner_x,y,holder_center_z])
                    rotate([0,side*90,0])
                        cylinder(r=holder_radius,h=holder_depth,$fn=96);
                if (r > 0)
                    translate([side*magnet_holder_inner_x,
                               end_y+inward*(r+magnet_ear_overlap),deck_z+body_height-r])
                        rotate([0,side*90,0])
                            cylinder(r=r,h=holder_depth,$fn=64);
                else
                    translate([side*(magnet_holder_inner_x+holder_depth/2),
                               end_y,deck_z+body_height-eps/2])
                        cube([holder_depth,eps,eps],center=true);
                // Carry the lower outline into the end band instead of leaving
                // a crescent-shaped recess below the round magnet carrier.
                translate([side*(magnet_holder_inner_x+holder_depth/2),
                           end_y+inward*magnet_ear_overlap,
                           skirt_tile_clearance+eps/2])
                    cube([holder_depth,2*magnet_ear_overlap,eps],center=true);
            }
        } else {
        intersection() {
            union() {
                translate([side*magnet_holder_inner_x,y,holder_center_z])
                    rotate([0,side*90,0])
                        cylinder(r=holder_radius,h=holder_depth,$fn=128);
                translate([side*(magnet_holder_inner_x+holder_depth/2),y,
                           (holder_center_z+deck_z+0.2)/2])
                    cube([holder_depth,2*holder_radius,
                          deck_z+0.2-holder_center_z],center=true);
            }
            translate([side*(magnet_holder_inner_x+holder_depth/2),y,
                       (magnet_block_tile_clearance+deck_z+0.4)/2])
                cube([holder_depth+2*eps,2*holder_radius+2*eps,
                      deck_z+0.4-magnet_block_tile_clearance],center=true);
        }
        }
    }
}

// Clear the square skirt corners on the inward half of each end magnet.
// The remaining skirt follows the same circular underside as the central holder.
module magnet_end_corner_reliefs() {
    r = magnet_center_holder_radius;
    z = magnet_block_tile_clearance+r;
    if (enable_magnets && enable_end_magnets)
        for (i=[0:1]) {
            y = magnet_positions[i];
            inward = i == 0 ? 1 : -1;
            difference() {
                translate([body_mid_x,y+inward*r/2,magnet_block_tile_clearance+r/2-eps/2])
                    cube([body_actual_width+2*eps,r,r+eps],center=true);
                translate([body_mid_x,y,z]) rotate([0,90,0])
                    cylinder(r=r,h=body_actual_width+4*eps,center=true,$fn=128);
            }
        }
}

// Quarter circles tangent to both the inner end-band face and the skirt bottom.
// Continue each profile to its wheel pocket and across the front center bridge.
module bolt_end_corner_reliefs() {
    r = magnet_center_holder_radius;
    side = -axle_receiving_side;
    for (i=[0:1]) {
        pocket_edge = i == 0 ? rear_u_inner_x :
            front_wheel_spacing/2+(front_wheel_width+2*washer_disc_thickness)/2;
        depth = abs(body_outer_x(side))-pocket_edge+eps;
        x = body_outer_x(side)-side*depth/2;
        inward = i == 0 ? 1 : -1;
        edge_y = i == 0 ? cutter_axle_y+skirt_end_thickness/2 :
                         front_axle_y-skirt_end_thickness/2;
        y = edge_y-inward*r;
        bridge_width = front_wheel_spacing-
                       (front_wheel_width+2*washer_disc_thickness);
        sections = concat([[x,depth]],i == 1 ? [[0,bridge_width]] : []);
        for (section=sections)
            difference() {
                translate([section[0],y+inward*r/2,skirt_tile_clearance+r/2-eps/2])
                    cube([section[1]+2*eps,r,r+eps],center=true);
                translate([section[0],y,skirt_tile_clearance+r]) rotate([0,90,0])
                    cylinder(r=r,h=section[1]+4*eps,center=true,$fn=128);
            }
    }
}

module magnet_mount_holes() {
    for (side=side_sides, y=magnet_positions) {
        translate([side*magnet_rear_x,y,magnet_center_z]) rotate([0,side*90,0])
            cylinder(d=magnet_diameter+2*magnet_fit_clearance,
                     h=magnet_thickness+magnet_face_recess+eps);
        magnet_screw_frame(side,y) {
            translate([0,0,magnet_thickness-eps])
                cylinder(d=magnet_screw_diameter+0.4,
                         h=magnet_backing_wall+magnet_nut_thickness+magnet_nut_clearance+2*eps);
            translate([0,0,magnet_thickness+magnet_backing_wall])
                cylinder(d=(magnet_nut_across_flats+2*magnet_nut_clearance)/cos(30),
                         h=magnet_nut_thickness+magnet_nut_clearance+eps,$fn=6);
        }
    }
}

module magnets() {
    if (enable_magnets) color("#b8bec4")
        for (side=side_sides, y=magnet_positions)
            translate([side*magnet_rear_x,y,magnet_center_z]) rotate([0,side*90,0])
                difference() {
                    cylinder(d=magnet_diameter,h=magnet_thickness);
                    translate([0,0,-eps]) cylinder(d=magnet_hole_diameter,h=magnet_thickness+2*eps);
                    translate([0,0,magnet_thickness-magnet_cone_depth])
                        cylinder(d1=magnet_hole_diameter,d2=magnet_countersink_diameter,
                                 h=magnet_cone_depth+eps);
                }
}

module magnet_screw_shape() {
    difference() {
        union() {
            cylinder(d1=magnet_screw_head_diameter,d2=magnet_screw_diameter,
                     h=magnet_screw_head_depth);
            translate([0,0,magnet_screw_head_depth-eps])
                cylinder(d=magnet_screw_diameter,h=magnet_thickness-magnet_screw_head_depth+eps);
            translate([0,0,magnet_thickness])
                cylinder(d=magnet_screw_diameter,h=magnet_screw_thread_length);
        }
        // Screwdriver slot opens on the rule-facing, flush countersunk head.
        translate([0,0,0.3-eps])
            cube([magnet_screw_head_diameter+1,0.8,0.6],center=true);
    }
}

module magnet_screws() {
    if (enable_magnets) color(axle_color)
        for (side=side_sides, y=magnet_positions) magnet_screw_frame(side,y) {
            magnet_screw_shape();
            translate([0,0,magnet_thickness+magnet_backing_wall]) difference() {
                cylinder(d=magnet_nut_across_flats/cos(30),h=magnet_nut_thickness,$fn=6);
                translate([0,0,-eps]) cylinder(d=magnet_screw_diameter,h=magnet_nut_thickness+2*eps);
            }
        }
}

module side_bearings() {
    color(side_bearing_color)
        for (side = side_sides, y = side_bearing_positions, level=[0:side_bearing_count-1])
            translate([side*side_bearing_x, y, side_bearing_bottom+level*side_bearing_width])
                difference() {
                    cylinder(d=side_bearing_diameter, h=side_bearing_width);
                    translate([0, 0, -eps]) cylinder(d=side_bearing_bore, h=side_bearing_width+2*eps);
                }
}

// Printed screws enter blind threaded mounts from below; no upper nuts.
module side_fasteners() {
    color(axle_color)
        for (side = side_sides, y = side_bearing_positions)
            translate([side*side_bearing_x, y, side_screw_head_bottom])
                side_fastener_shape();
}

// Head at Z = 0; smooth bearing journal and threaded end are separate sections.
module side_fastener_shape() {
    thread_start = side_mount_bottom-side_screw_head_bottom;
    union() {
        cylinder(d=side_bearing_bore*1.6,h=axle_head_thickness,$fn=6);
        translate([0,0,axle_head_thickness]) {
            cylinder(d=side_screw_journal_diameter,h=thread_start-axle_head_thickness);
        }
        translate([0,0,thread_start])
            metric_thread(bearing_thread_diameter,side_screw_thread_length,bearing_thread_pitch);
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
            for (side = [-1, 1]) {
                // Only the rule-facing wall needs clearance above side rollers.
                // Close the free side down to the same bottom as the tapered wall.
                bottom = side == -axle_receiving_side && guide_side != "both" ?
                    skirt_tile_clearance : side_bottom;
                height = deck_z-bottom+0.2;
                translate([body_outer_x(side)-side*skirt_side_thickness/2,
                           (front_axle_y+cutter_axle_y)/2,
                           bottom+height/2])
                    cube([skirt_side_thickness, front_axle_y-cutter_axle_y,
                          height], center=true);
            }
            for (y = [front_axle_y, cutter_axle_y])
                translate([body_mid_x, y, skirt_tile_clearance+band_height/2])
                    cube([body_actual_width, skirt_end_thickness, band_height], center=true);
        }
        // Wheel and washer cavities leave solid walls for the axle seats.
        for (x = [wheel_left_x, wheel_right_x])
            translate([x, front_axle_y, front_z]) rotate([0, 90, 0])
                cylinder(r=front_wheel_radius+wheel_clearance,
                         h=front_wheel_width+2*washer_disc_thickness, center=true);
        translate([0, cutter_axle_y, cutter_z]) rotate([0, 90, 0])
            cylinder(r=cutter_radius+wheel_clearance, h=2*rear_u_inner_x, center=true);
        front_axle_socket();
        screw_axle_socket(cutter_axle_y, cutter_z, axle_diameter, rear_thread_x, rear_thread_length);
    }
}

// Local Z follows screw insertion from the free side toward the rule.
module axle_frame(y, z) {
    translate([-axle_receiving_side*axle_head_halfspan(y), y, z])
        rotate([0, axle_receiving_side*90, 0]) children();
}

module front_axle_socket() {
    screw_axle_socket(front_axle_y,front_z,front_axle_diameter,front_thread_x,front_thread_length,
                      bearing_thread_diameter,bearing_thread_pitch,
                      bearing_thread_clearance,bearing_thread_axial_clearance);
}

module screw_axle_socket(y, z, diameter, thread_x, thread_length,
                         thread_diameter=cutter_thread_diameter,thread_pitch=axle_thread_pitch,
                         radial_clearance=axle_thread_clearance,
                         axial_clearance=axle_thread_axial_clearance) {
    effective_diameter = is_undef(thread_diameter) ? diameter : thread_diameter;
    thread_start = axle_head_halfspan(y)+thread_x;
    axle_frame(y, z) {
        if (y == cutter_axle_y && rear_head_recess_depth > 0)
            translate([0,0,-rear_head_recess_depth-eps])
                cylinder(d=rear_head_recess_diameter,h=rear_head_recess_depth+eps);
        translate([0, 0, -eps])
            cylinder(d=max(diameter+2*axle_hole_clearance,effective_diameter+0.2),
                     h=thread_start+4*eps);
        translate([0, 0, thread_start])
            metric_thread(effective_diameter,thread_length+bolt_bottom_clearance,thread_pitch,
                          true,radial_clearance,axial_clearance);
    }
}

// ISO metric 60-degree profile: H=sqrt(3)/2*P, external crest P/8,
// internal minor depth 5H/8, external rounded-root depth 17H/24.
// Male print compensation and female fit offsets do not change pitch or flank angle.
function metric_h(pitch) = sqrt(3)/2*pitch;
function metric_external_root(diameter,pitch) = diameter-2*17/24*metric_h(pitch);
function metric_internal_minor(diameter,pitch) = diameter-2*5/8*metric_h(pitch);
function metric_pitch_diameter(diameter,pitch) = diameter-2*3/8*metric_h(pitch);

module metric_thread(diameter,length,pitch,internal=false,radial_clearance=0,axial_clearance=0) {
    h = metric_h(pitch);
    major_r = diameter/2+(internal ? radial_clearance : -thread_external_radial_compensation);
    core_r = major_r-(internal ? 5/8 : 17/24)*h;
    rho = h/6;
    root_arc_center_r = major_r-13/24*h;
    start = pitch*0.55;
    finish = length-pitch*0.55;
    turns = (finish-start)/pitch;
    steps = ceil(turns*($preview ? 48 : 96));
    profile = internal ? [
        [core_r-eps,-3*pitch/8-axial_clearance-eps/sqrt(3)],
        [major_r,-pitch/16-axial_clearance],
        [major_r,pitch/16+axial_clearance],
        [core_r-eps,3*pitch/8+axial_clearance+eps/sqrt(3)]
    ] : concat(
        [[core_r-eps,-0.49*pitch]],
        [for(i=[0:3]) let(z=(-0.49+(0.49-0.375)*i/3)*pitch)
            [root_arc_center_r-sqrt(max(0,rho*rho-pow(z+pitch/2,2))),z]],
        [[major_r,-pitch/16],[major_r,pitch/16]],
        [for(i=[0:3]) let(z=(0.375+(0.49-0.375)*i/3)*pitch)
            [root_arc_center_r-sqrt(max(0,rho*rho-pow(z-pitch/2,2))),z]],
        [[core_r-eps,0.49*pitch]]
    );
    n = len(profile);
    points = [for(i=[0:steps],p=profile)
        let(a=360*turns*i/steps,z=start+pitch*a/360)
        [p[0]*cos(a),p[0]*sin(a),z+p[1]]];
    faces = concat(
        [[for(j=[n-1:-1:0]) j]],
        [for(i=[0:steps-1],j=[0:n-1],t=[0:1])
            let(a=n*i+j,b=n*i+(j+1)%n,c=n*(i+1)+(j+1)%n,d=n*(i+1)+j)
            t==0 ? [a,b,c] : [a,c,d]],
        [[for(j=[0:n-1]) n*steps+j]]
    );
    assert(pitch > 0 && length > 1.2*pitch && core_r > 0);
    assert(!internal || 3*pitch/8+axial_clearance+eps/sqrt(3) < pitch/2,
           "Axial thread clearance makes adjacent metric turns overlap");
    union() {
        cylinder(r=core_r,h=length);
        polyhedron(points=points,faces=faces,convexity=16);
    }
}

module plastic_screw_axle(y, z, diameter, thread_x, thread_length) {
    color(axle_color) axle_frame(y, z)
        screw_axle_shape(diameter, thread_x, thread_length,head_halfspan=axle_head_halfspan(y));
}

module screw_axle_shape(diameter, thread_x, thread_length,
                        thread_diameter=cutter_thread_diameter,thread_pitch=axle_thread_pitch,
                        head_halfspan=front_head_halfspan) {
    effective_diameter = is_undef(thread_diameter) ? diameter : thread_diameter;
    thread_start = head_halfspan+thread_x;
    union() {
        // Single accessible hex head; the smooth shank passes through all wheel bores.
        translate([0, 0, -axle_head_thickness])
            cylinder(d=axle_head_diameter, h=axle_head_thickness, $fn=6);
        cylinder(d=diameter, h=thread_start+eps);
        translate([0, 0, thread_start])
            metric_thread(effective_diameter,thread_length,thread_pitch);
    }
}

module front_axle_shape() {
    screw_axle_shape(front_axle_diameter,front_thread_x,front_thread_length,
                     bearing_thread_diameter,bearing_thread_pitch,front_head_halfspan);
}

module front_axle_pin() {
    color(axle_color) axle_frame(front_axle_y,front_z) front_axle_shape();
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

module side_lower_washers() {
    color(washer_color)
        for(side=side_sides,y=side_bearing_positions)
            translate([side*side_bearing_x,y,side_bearing_bottom-side_lower_washer_thickness])
                print_washer_disc(bearing_thread_diameter+0.2,
                                  side_lower_washer_thickness,side_spacer_diameter);
}

module washers() {
    side_lower_washers();
    color(washer_color) {
        for (wheel_x = [wheel_left_x, wheel_right_x], sx = [-1, 1])
            translate([wheel_x+sx*(front_wheel_width/2+washer_disc_thickness/2),
                       front_axle_y, front_z]) rotate([0,90,0])
                difference() {
                    cylinder(r=front_washer_radius, h=washer_disc_thickness,
                             center=true, $fn=48);
                    cylinder(d=front_axle_passage_diameter,
                             h=washer_disc_thickness+2*eps, center=true, $fn=32);
                }
        for (sx = [-1, 1])
            translate([sx*(cutter_width/2+washer_disc_thickness/2),
                       cutter_axle_y, cutter_z]) rotate([0,90,0])
                difference() {
                    cylinder(r=cutter_washer_radius, h=washer_disc_thickness,
                             center=true, $fn=48);
                    cylinder(d=rear_axle_passage_diameter,
                             h=washer_disc_thickness+2*eps, center=true, $fn=32);
        // Separate spacer discs fill the wider U opening and keep the cutter centered.
        if (rear_axle_spacer_thickness > eps) for (sx = [-1, 1])
            translate([sx*(rear_fork_side_reach+rear_u_clearance/2+
                            rear_axle_spacer_thickness/2),
                       cutter_axle_y, cutter_z]) rotate([0,90,0])
                difference() {
                    cylinder(r=cutter_washer_radius,
                             h=rear_axle_spacer_thickness, center=true, $fn=48);
                    cylinder(d=rear_axle_passage_diameter,
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
    magnets();
    magnet_screws();
}

// Separate printable parts, seated at Z = 0. Purchased rolling parts are omitted.
print_item_size = max(front_wheel_bearing_diameter,cutter_bearing_diameter,side_bearing_bore*1.6,
                      axle_head_diameter,magnet_screw_head_diameter,side_spacer_diameter);
print_pitch = print_item_size+print_gap;
print_body_length = enable_magnets && enable_end_magnets ? magnet_front_y-magnet_rear_y+2*magnet_center_holder_radius :
    front_axle_y-cutter_axle_y+skirt_end_thickness;
function print_x(column) = body_mid_x+body_actual_width/2+
                           print_gap+print_item_size/2+column*print_pitch;
function print_y(row) = -print_body_length/2+print_item_size/2+row*print_pitch;

module print_body() {
    color(carriage_color)
        translate([0,(front_axle_y+cutter_axle_y)/2,deck_z+body_height+pressure_grip_height])
            rotate([180,0,0]) carriage_body();
}

module print_axles() {
    color(axle_color) {
        translate([print_x(0),print_y(0),axle_head_thickness])
            front_axle_shape();
        translate([print_x(0),print_y(1),axle_head_thickness])
            screw_axle_shape(axle_diameter,rear_thread_x,rear_thread_length,
                             head_halfspan=rear_head_halfspan);
    }
}

module print_washer_disc(bore,height,outer_diameter) {
    difference() {
        cylinder(d=outer_diameter,h=height,$fn=48);
        translate([0,0,-eps]) cylinder(d=bore,h=height+2*eps,$fn=32);
    }
}

module print_washers() {
    side_washer_row = rear_axle_spacer_thickness > eps ? 4 : 3;
    color(washer_color) {
        for(i=[0:2*len(side_sides)-1])
            translate([print_x(1+i%2),print_y(side_washer_row+floor(i/2)),0])
                print_washer_disc(bearing_thread_diameter+0.2,side_lower_washer_thickness,side_spacer_diameter);
        for (i=[0:3])
            translate([print_x(1+i%2),print_y(floor(i/2)),0])
                print_washer_disc(front_axle_passage_diameter,washer_disc_thickness,front_wheel_bearing_diameter);
        for (i=[0:1]) {
            translate([print_x(1+i),print_y(2),0])
                print_washer_disc(rear_axle_passage_diameter,washer_disc_thickness,cutter_bearing_diameter);
            if (rear_axle_spacer_thickness > eps)
                translate([print_x(1+i),print_y(3),0])
                    print_washer_disc(rear_axle_passage_diameter,rear_axle_spacer_thickness,cutter_bearing_diameter);
        }
    }
}

module print_side_fasteners() {
    color(axle_color)
        for (i=[0:2*len(side_sides)-1])
            translate([print_x(0),print_y(2+i),0]) side_fastener_shape();
}

module print_magnet_screws() {
    // Metal screws and nuts are purchased hardware, omitted from print layouts.
}

module print_layout() {
    print_body();
    print_axles();
    print_washers();
    print_side_fasteners();
    print_magnet_screws();
}

if (part == "assembly") assembly();
else if (part == "print") print_layout();
else if (part == "print_body") print_body();
else if (part == "print_axles") print_axles();
else if (part == "print_washers") print_washers();
else if (part == "print_side_fasteners") print_side_fasteners();
else if (part == "print_magnet_screws") print_magnet_screws();
else if (part == "guide") guide_rule();
else if (part == "carriage") color(carriage_color) carriage_body();
else if (part == "front_wheels") front_wheel_discs();
else if (part == "axle_print") {
    color(axle_color) {
        translate([-axle_head_diameter, 0, axle_head_thickness])
            front_axle_shape();
        translate([axle_head_diameter, 0, axle_head_thickness])
            screw_axle_shape(axle_diameter, rear_thread_x, rear_thread_length,
                             head_halfspan=rear_head_halfspan);
    }
}
else if (part == "front_axle") front_axle_pin();
else if (part == "rear_axle") rear_axle_pin();
else if (part == "axles") axle_pins();
else if (part == "washers") washers();
else if (part == "side_bearings") side_bearings();
else if (part == "side_fasteners") side_fasteners();
else if (part == "magnets") magnets();
else if (part == "magnet_screws") magnet_screws();
else if (part == "magnet_screws_print")
    print_magnet_screws();
else if (part == "cutter") cutter_disc();
else if (part == "front_wheel") annular_wheel(front_wheel_radius, front_wheel_width, front_wheel_hole_radius);
