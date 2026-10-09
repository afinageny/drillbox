// First-piece tile-cutter trolley with four top-running bearings
// and three side guide bearings.
// All bearings are installed with M4 screws.
// Units: millimetres.

/* [View] */
part = "assembly"; // [assembly, guide, trolley, bearings, bolts, nuts, washers, cutter_arm, cutter_wheel, cutter_axle]

/* [Guide] */
guide_width = 50; // [20:1:100]
guide_height = 10; // [5:1:30]
guide_length = 190; // [80:5:400]
show_guide = true;

/* [Trolley outline] */
trolley_length = 80; // [50:1:140]
trolley_thickness = 10; // [6:0.5:20]
trolley_end_width = 35; // [20:1:60] Width between the outer threaded faces of the wheel mounts.
trolley_end_tab_length = 16; // [13:1:35] Must be longer than the wheel diameter.
side_wing_extension = 12; // [5:1:25]
side_wing_length = 65; // [40:1:120]
trolley_guide_clearance = 1; // [0.2:0.1:3]

/* [Top bearings] */
bearing_outer_diameter = 12; // [8:0.5:30]
bearing_width = 4; // [3:0.5:12]
bearing_bore_diameter = 4.2; // [3:0.1:12]
bearing_radial_clearance = 0.4; // [0.1:0.1:1]
bearing_axial_clearance = 0.3; // [0.1:0.1:1]
bearing_edge_margin = 3; // [0.5:0.5:8] Reserves space for the screw head inside the guide width.

/* [Side guide bearings] */
side_bearing_side = "left"; // [right,left] Two fixed guide bearings are on the operator's side.
side_bearing_spacing = 44; // [20:1:70] Distance between the two side bearing axes.
fixed_side_edge_clearance = 0; // [0:0.05:1] The two fixed bearings touch the guide face.
adjustable_side_nominal_clearance = 0.3; // [0:0.1:1] Centre position of the adjustable bearing.
side_bearing_axial_clearance = 0.3; // [0.1:0.1:1] Gap below the overhanging wing.
single_side_bearing_y = 0; // [-25:1:25] Position of the opposite single bearing.
single_side_adjustment_travel = 2; // [0.5:0.5:6] Total slot travel toward/away from the guide.
single_side_adjustment = 0; // [-3:0.1:3] Preview position; positive moves the bearing toward the guide.

/* [Wheel screws] */
thread_diameter = 4; // [3:1:8] Metric screw diameter; 4 means M4.
thread_pitch = 0.7; // [0.5:0.05:1.5]
thread_engagement = 6; // [4:0.5:12]
thread_pilot_ratio = 0.825; // [0.75:0.005:0.95]
screw_head_diameter = 7; // [5:0.5:14]
screw_head_thickness = 3; // [2:0.5:6]
screw_end_clearance = 0.4; // [0.1:0.1:1]
through_hole_clearance = 0.3; // [0.1:0.1:0.8]
nut_width_across_flats = 7; // [5:0.5:14]
nut_thickness = 3.2; // [2:0.2:8]
nut_pocket_clearance = 0.3; // [0.1:0.1:1]
nut_recess_below_top = 0.2; // [0:0.1:2] Nut top sits below the trolley surface.

/* [Cutter arm and hinge] */
cutter_arm_length = 96; // [60:1:130]
cutter_arm_width = 44; // [25:1:60] Narrow hinge neck width.
cutter_arm_body_width = 86; // [60:1:140] Wide section carrying the offset cutter.
cutter_arm_end_width = 86; // [70:1:140] No unnecessary overhang beyond the cutter body.
cutter_arm_end_length = 18; // [10:1:35] Length of the widened cutter end.
cutter_arm_neck_length = 10; // [10:1:30] Length of the narrow section behind the hinge.
cutter_arm_thickness = 10; // [6:0.5:20] Same as trolley thickness by default.
cutter_arm_angle = 0; // [0:1:35] Raised angle of the free end; zero puts the cutter on the tile.
hinge_end = "far"; // [near,far] Hinge at the far end; cutter arm spans back over the trolley.
hinge_front_inset = 6; // [3:0.5:12] Axis distance from the arm's front end.
hinge_edge_inset = 7; // [5:0.5:15] Axis distance from the trolley's front edge.
hinge_lift = 3; // [0:0.5:8] Gap that lets the cutter arm move down under hand pressure.
hinge_ear_thickness = 3; // [2:0.5:6]
hinge_ear_length = 14; // [10:1:24]
hinge_side_clearance = 0.2; // [0.1:0.05:1]
hinge_pin_diameter = 4; // [3:1:8]
hinge_hole_clearance = 0.15; // [0.1:0.05:0.8]
hinge_head_diameter = 7; // [5:0.5:14]
hinge_head_thickness = 3; // [2:0.5:6]
hinge_nut_width_across_flats = 7; // [5:0.5:14]
hinge_nut_thickness = 3.2; // [2:0.2:8]
hinge_washer_outer_diameter = 9; // [6:0.5:16]
hinge_washer_thickness = 0.8; // [0.4:0.05:2] Visible external hinge washer.

/* [Scoring cutter] */
cut_side = "left"; // [right,left] Right-handed operation cuts on the operator's side.
cutter_end = "near"; // [near,far] Longitudinal position relative to the operator.
cutter_rest_clearance = 1.5; // [0:0.25:4] Cutter gap above the tile before pressing.
cutter_depth_limit = 0.3; // [0:0.1:1.5] Maximum cutter penetration into the tile.
cutter_stop_width = 24; // [12:1:40] Width of the underside depth stop.
cutter_stop_length = 12; // [8:1:24] Length along the arm.
cut_line_offset = 10; // [5:1:40] Distance from the selected guide face to the cutting line.
cutter_end_inset = 12; // [8:1:30] Distance from the free end of the arm to the cutter axis.
cutter_outer_diameter = 22; // [10:0.5:40]
cutter_width = 3; // [1:0.5:8]
cutter_bore_diameter = 4.2; // [3:0.1:10]
cutter_fork_thickness = 6; // [4:0.5:10]
cutter_fork_axial_clearance = 0.3; // [0.1:0.1:1]
cutter_fork_depth = 14; // [10:1:24]
cutter_fork_boss_diameter = 12; // [8:1:20]
cutter_axle_diameter = 4; // [3:1:8] Metric screw diameter; 4 means M4.
cutter_axle_clearance = 0.25; // [0.1:0.05:0.8]
cutter_thread_pilot_ratio = 0.825; // [0.75:0.005:0.95]
cutter_axle_head_diameter = 7; // [5:0.5:14]
cutter_axle_head_thickness = 3; // [2:0.5:6]
cutter_axle_end_clearance = 0.4; // [0.1:0.1:1]

/* [Anti-tilt guide pyramids] */
guide_end_pyramid_y = -34; // [-45:1:0] Single guide near the cutter end.
guide_end_pyramid_base_width = 28; // [18:1:40] Wider central guide at the cutter end.
guide_end_pyramid_top_width = 14; // [8:1:28]
guide_pyramid_height = 3; // [1:0.25:6]
guide_pyramid_clearance = 0.35; // [0.15:0.05:1]

/* [Display] */
guide_color = "#1677e8";
trolley_color = "#ed8b35";
bearing_color = "#929aa5";
bolt_color = "#252a30";
cutter_arm_color = "#d99a32";
cutter_wheel_color = "#b8bec4";

/* [Hidden] */
$fn = $preview ? 48 : 96;
eps = 0.02;
thread_profile_width = 0.42; // Fraction of pitch occupied by each thread flank.
thread_clearance = 0.18; // Printed radial allowance in internal threads.
bearing_radius = bearing_outer_diameter/2;
mount_station_y = trolley_length/2+trolley_end_tab_length/2;
mount_outer_x = trolley_end_width/2;
bearing_center_x = guide_width/2-bearing_edge_margin-bearing_width/2;
axle_local_z = bearing_radius-trolley_guide_clearance;
body_bottom_z = guide_height+trolley_guide_clearance;
thread_pilot_diameter = thread_diameter*thread_pilot_ratio;
bearing_inner_x = bearing_center_x-bearing_width/2;
side_sign = side_bearing_side == "left" ? -1 : 1;
side_bearing_center_x = side_sign*(guide_width/2+bearing_radius+fixed_side_edge_clearance);
single_side_sign = -side_sign;
single_side_slot_center_x =
    single_side_sign*(guide_width/2+bearing_radius+adjustable_side_nominal_clearance);
single_side_bearing_center_x =
    single_side_slot_center_x-single_side_sign*single_side_adjustment;
side_bearing_center_z = body_bottom_z-side_bearing_axial_clearance-bearing_width/2;
body_top_z = body_bottom_z+trolley_thickness;
hinge_end_sign = hinge_end == "near" ? -1 : 1;
hinge_axis_y = hinge_end_sign*(trolley_length/2-hinge_edge_inset);
hinge_axis_z = body_top_z+cutter_arm_thickness/2+hinge_lift;
hinge_ear_center_x =
    cutter_arm_width/2+hinge_side_clearance+hinge_ear_thickness/2;
cutter_radius = cutter_outer_diameter/2;
cutter_world_side_sign = cut_side == "left" ? -1 : 1;
// The long arm can face the near or far end independently of the hinge end.
cutter_end_sign = cutter_end == "near" ? -1 : 1;
arm_x_sign = cutter_end_sign < 0 ? 1 : -1;
// Turning the arm 180 degrees also mirrors its local X direction.
cutter_side_sign = cutter_world_side_sign*arm_x_sign;
cutter_local_x = cutter_side_sign*(guide_width/2+cut_line_offset);
cutter_local_y = -cutter_arm_length+hinge_front_inset+cutter_end_inset;
// At zero arm angle the wheel touches the same work plane as the guide.
cutter_axle_local_z = cutter_radius+cutter_rest_clearance-hinge_axis_z;
cutter_depth_stop_height = hinge_lift-cutter_depth_limit;
cutter_cheek_offset =
    cutter_width/2+cutter_fork_axial_clearance+cutter_fork_thickness/2;
cutter_inner_cheek_x = cutter_local_x-cutter_side_sign*cutter_cheek_offset;
cutter_outer_cheek_x = cutter_local_x+cutter_side_sign*cutter_cheek_offset;

assert(guide_width > 0 && guide_height > 0 && guide_length > 0,
       "Guide dimensions must be positive");
assert(trolley_end_tab_length > bearing_outer_diameter+2*bearing_radial_clearance,
       "Front/rear wheel mount length must exceed the wheel diameter plus clearance");
assert(bearing_inner_x-mount_outer_x >= bearing_axial_clearance,
       "Wheel mount is too wide for the bearings to stay near the guide edges");
assert(bearing_center_x+bearing_width/2+screw_head_thickness <= guide_width/2,
       "Screw heads extend beyond the guide width; move bearings inward");
assert(mount_outer_x > thread_engagement,
       "Wheel mount is too narrow for the selected threaded engagement");
assert(thread_engagement < trolley_thickness,
       "Side-bearing threaded holes must remain blind");
assert(side_bearing_spacing+bearing_outer_diameter <= side_wing_length,
       "Side bearings do not fit along the overhanging wing");
assert(side_wing_extension >= bearing_radius+fixed_side_edge_clearance,
       "The overhanging wing is too short to carry a side bearing");
assert(side_bearing_center_z-bearing_width/2-screw_head_thickness >= 0,
       "Side bearing screw head extends below the work surface");
assert(abs(single_side_bearing_y)+bearing_radius <= side_wing_length/2,
       "Single side bearing does not fit below the opposite wing");
assert(abs(single_side_adjustment) <= single_side_adjustment_travel/2,
       "Single side bearing preview position lies outside its adjustment slot");
assert(side_wing_extension >= bearing_radius+adjustable_side_nominal_clearance+
       single_side_adjustment_travel/2,
       "The opposite wing is too short for the complete adjustment slot");
assert(nut_width_across_flats > thread_diameter,
       "Nut must be wider than the screw thread");
assert(nut_thickness+nut_recess_below_top < trolley_thickness,
       "Recessed nut pocket is deeper than the trolley");
assert(cutter_arm_thickness == trolley_thickness,
       "Cutter arm and trolley thickness must match for this prototype");
assert(cutter_arm_width+2*(hinge_side_clearance+hinge_ear_thickness)
       <= guide_width+2*side_wing_extension,
       "Cutter arm hinge is wider than the trolley");
assert(cutter_arm_body_width/2 >=
       abs(cutter_outer_cheek_x)+cutter_fork_thickness/2,
       "Cutter arm is too narrow for the offset cutter fork");
assert(cutter_arm_end_width >= cutter_arm_body_width,
       "Cutter end width must be at least the body width");
assert(cutter_arm_neck_length < cutter_arm_length-hinge_front_inset,
       "Cutter arm neck leaves no room for its wide body");
assert(cutter_depth_stop_height > 0,
       "Cutter depth limit must be smaller than hinge lift");
assert(hinge_front_inset < cutter_arm_length &&
       hinge_edge_inset < trolley_length/2,
       "Hinge position must lie inside the arm and trolley");
assert(hinge_pin_diameter+2*hinge_hole_clearance < cutter_arm_thickness,
       "Hinge hole does not fit through the cutter arm");
assert(cutter_outer_diameter > cutter_bore_diameter,
       "Cutter outside diameter must exceed its bore");
assert(cutter_bore_diameter >= cutter_axle_diameter,
       "Cutter bore must fit over its axle screw");
assert(cutter_end_inset > cutter_radius/2 &&
       cutter_end_inset+cutter_radius/2 < cutter_arm_length-hinge_front_inset,
       "Cutter axis must remain inside the wide arm section");
assert(cutter_fork_boss_diameter >
       cutter_axle_diameter+2*cutter_axle_clearance,
       "Cutter axle hole leaves too little material in the fork");
assert(bearing_bore_diameter >= thread_diameter,
       "Bearing bore must be at least as large as the screw thread");
assert(axle_local_z > 0 && axle_local_z < trolley_thickness,
       "Bearing axle must pass through the trolley thickness");
assert(trolley_length+2*trolley_end_tab_length <= guide_length,
       "Trolley outline must fit on the guide length");

// Printed triangular helical thread. The hole cutter uses the same profile
// as the external bolt, so the two parts can be printed and assembled directly.
module threaded_ridge(nominal_d, pitch, length, pilot_ratio) {
    major_r = nominal_d/2;
    pilot_r = nominal_d*pilot_ratio/2;
    turns = max(1, length/pitch);
    translate([0, 0, -length/2])
        linear_extrude(height=length, twist=360*turns,
                       slices=max(24, ceil(turns*24)), convexity=10)
            polygon(points=[
                [pilot_r, -pitch*thread_profile_width/2],
                [major_r, 0],
                [pilot_r, pitch*thread_profile_width/2]
            ]);
}

module threaded_hole(length, nominal_d, pitch, pilot_ratio) {
    major_d = nominal_d+thread_clearance;
    pilot_d = nominal_d*pilot_ratio;
    hole_ratio = pilot_d/major_d;
    union() {
        cylinder(d=pilot_d, h=length, center=true);
        threaded_ridge(major_d, pitch, length, hole_ratio);
    }
}

module threaded_shaft(length, nominal_d, pitch, pilot_ratio) {
    union() {
        cylinder(d=nominal_d*pilot_ratio, h=length, center=true);
        threaded_ridge(nominal_d, pitch, length, pilot_ratio);
    }
}

module trolley_outline_2d() {
    union() {
        square([guide_width, trolley_length], center=true);
        for (end = [-1, 1])
            translate([0, end*mount_station_y])
                square([trolley_end_width, trolley_end_tab_length], center=true);
        for (side = [-1, 1])
            translate([side*(guide_width/2+side_wing_extension/2), 0])
                square([side_wing_extension, side_wing_length], center=true);
    }
}

module guide_solid() {
    translate([-guide_width/2, -guide_length/2, 0])
        cube([guide_width, guide_length, guide_height]);
}

// M4 tap-drill bore enters the outside face of each front/rear mount.
// The bearing itself remains outside the printed body, close to the guide edge.
module wheel_mount_cut(side, y) {
    hole_center_x = side*(mount_outer_x-thread_engagement/2);
    translate([hole_center_x, y, axle_local_z]) rotate([0, 90, 0])
        threaded_hole(thread_engagement+2*eps, thread_diameter, thread_pitch,
                      thread_pilot_ratio);
}

// Vertical pilot holes for the two M4 side-bearing screws.
module side_wheel_mount_cut(y) {
    local_x = side_bearing_center_x;
    // Open at the underside (z=0) and stop inside the plate.
    translate([local_x, y, thread_engagement/2-eps])
        threaded_hole(thread_engagement+2*eps, thread_diameter, thread_pitch,
                      thread_pilot_ratio);
}

// The opposite single bearing uses a through-hole and a separate nut on top.
module single_side_through_hole() {
    // Capsule-shaped through slot: two round ends joined by straight walls.
    hull()
        for (dx = [-single_side_adjustment_travel/2,
                    single_side_adjustment_travel/2])
            translate([single_side_slot_center_x+dx, single_side_bearing_y,
                       trolley_thickness/2])
                cylinder(d=thread_diameter+through_hole_clearance,
                         h=trolley_thickness+2*eps, center=true);
}

// Swept hexagonal pocket lets the recessed nut follow the adjustment slot.
module single_side_nut_pocket() {
    nut_outer_diameter =
        (nut_width_across_flats+2*nut_pocket_clearance)/cos(30);
    pocket_depth = nut_thickness+nut_recess_below_top+nut_pocket_clearance;
    hull()
        for (dx = [-single_side_adjustment_travel/2,
                    single_side_adjustment_travel/2])
            translate([single_side_slot_center_x+dx, single_side_bearing_y,
                       trolley_thickness-pocket_depth/2+eps])
                cylinder(d=nut_outer_diameter, h=pocket_depth+2*eps,
                         center=true, $fn=6);
}

module trolley_plate() {
    difference() {
        linear_extrude(height=trolley_thickness) trolley_outline_2d();
        for (side = [-1, 1], end = [-1, 1])
            wheel_mount_cut(side, end*mount_station_y);
        for (y = [-side_bearing_spacing/2, side_bearing_spacing/2])
            side_wheel_mount_cut(y);
        single_side_through_hole();
        single_side_nut_pocket();
    }
}

module guide_end_pyramid() {
    translate([0, guide_end_pyramid_y, trolley_thickness])
        linear_extrude(height=guide_pyramid_height,
                       scale=guide_end_pyramid_top_width/guide_end_pyramid_base_width)
            square([guide_end_pyramid_base_width, guide_end_pyramid_base_width],
                   center=true);
}

module guide_pyramids() {
    guide_end_pyramid();
}

module hinge_ears() {
    // Keep the ears joined to the trolley while lifting the hinge axis.
    ear_height = hinge_lift+cutter_arm_thickness;
    for (side = [-1, 1])
        difference() {
            translate([side*hinge_ear_center_x, hinge_axis_y,
                       trolley_thickness+ear_height/2])
                cube([hinge_ear_thickness, hinge_ear_length,
                      ear_height], center=true);
            translate([side*hinge_ear_center_x, hinge_axis_y,
                       trolley_thickness+hinge_lift+cutter_arm_thickness/2])
                rotate([0, 90, 0])
                    cylinder(d=hinge_pin_diameter+2*hinge_hole_clearance,
                             h=hinge_ear_thickness+2*eps, center=true);
        }
}

module trolley_solid() {
    union() {
        trolley_plate();
        guide_pyramids();
        hinge_ears();
    }
}

module bearing_disc() {
    difference() {
        rotate([0, 90, 0])
            cylinder(d=bearing_outer_diameter, h=bearing_width, center=true);
        rotate([0, 90, 0])
            cylinder(d=bearing_bore_diameter, h=bearing_width+2*eps, center=true);
    }
}

module wheel_bearing(side, y) {
    translate([side*bearing_center_x, y, body_bottom_z+axle_local_z]) bearing_disc();
}

module side_bearing(y) {
    translate([side_bearing_center_x, y, side_bearing_center_z])
        difference() {
            cylinder(d=bearing_outer_diameter, h=bearing_width, center=true);
            cylinder(d=bearing_bore_diameter, h=bearing_width+2*eps, center=true);
        }
}

module single_side_bearing() {
    translate([single_side_bearing_center_x, single_side_bearing_y,
               side_bearing_center_z])
        difference() {
            cylinder(d=bearing_outer_diameter, h=bearing_width, center=true);
            cylinder(d=bearing_bore_diameter, h=bearing_width+2*eps, center=true);
        }
}

module wheel_screw(side, y) {
    shaft_inner_x = mount_outer_x-thread_engagement+screw_end_clearance;
    shaft_outer_x = bearing_center_x+bearing_width/2+screw_head_thickness;
    shaft_length = shaft_outer_x-shaft_inner_x;
    shaft_center_x = (shaft_outer_x+shaft_inner_x)/2;
    translate([side*shaft_center_x, y, body_bottom_z+axle_local_z])
        rotate([0, 90, 0])
            threaded_shaft(shaft_length, thread_diameter, thread_pitch,
                           thread_pilot_ratio);
    translate([side*(bearing_center_x+bearing_width/2+screw_head_thickness/2), y,
               body_bottom_z+axle_local_z])
        rotate([0, 90, 0]) cylinder(d=screw_head_diameter,
                                   h=screw_head_thickness, center=true, $fn=6);
}

module side_wheel_screw(y) {
    bearing_bottom_z = side_bearing_center_z-bearing_width/2;
    shaft_bottom_z = bearing_bottom_z-screw_head_thickness;
    shaft_top_z = body_bottom_z+thread_engagement-screw_end_clearance;
    shaft_length = shaft_top_z-shaft_bottom_z;
    translate([side_bearing_center_x, y, (shaft_bottom_z+shaft_top_z)/2])
        threaded_shaft(shaft_length, thread_diameter, thread_pitch,
                       thread_pilot_ratio);
    translate([side_bearing_center_x, y,
               bearing_bottom_z-screw_head_thickness/2])
        cylinder(d=screw_head_diameter, h=screw_head_thickness,
                 center=true, $fn=6);
}

module single_side_bolt_and_nut() {
    bearing_bottom_z = side_bearing_center_z-bearing_width/2;
    shaft_bottom_z = bearing_bottom_z-screw_head_thickness;
    body_top_z = body_bottom_z+trolley_thickness;
    nut_center_z =
        body_top_z-nut_recess_below_top-nut_thickness/2;
    shaft_top_z = nut_center_z+nut_thickness/2;
    shaft_length = shaft_top_z-shaft_bottom_z;
    translate([single_side_bearing_center_x, single_side_bearing_y,
               (shaft_bottom_z+shaft_top_z)/2])
        threaded_shaft(shaft_length, thread_diameter, thread_pitch,
                       thread_pilot_ratio);
    translate([single_side_bearing_center_x, single_side_bearing_y,
               bearing_bottom_z-screw_head_thickness/2])
        cylinder(d=screw_head_diameter, h=screw_head_thickness,
                 center=true, $fn=6);
}

module single_side_nut() {
    body_top_z = body_bottom_z+trolley_thickness;
    nut_center_z = body_top_z-nut_recess_below_top-nut_thickness/2;
    nut_outer_diameter = nut_width_across_flats/cos(30);
    translate([single_side_bearing_center_x, single_side_bearing_y,
               nut_center_z])
        difference() {
            cylinder(d=nut_outer_diameter, h=nut_thickness, center=true, $fn=6);
            cylinder(d=thread_diameter, h=nut_thickness+2*eps, center=true);
        }
}

module cutter_fork_cheek(x, hole_diameter) {
    difference() {
        hull() {
            translate([x, cutter_local_y, -cutter_arm_thickness/2+1])
                cube([cutter_fork_thickness, cutter_fork_depth, 2], center=true);
            translate([x, cutter_local_y, cutter_axle_local_z])
                rotate([0, 90, 0])
                    cylinder(d=cutter_fork_boss_diameter,
                             h=cutter_fork_thickness, center=true);
        }
        translate([x, cutter_local_y, cutter_axle_local_z])
            rotate([0, 90, 0]) {
                if (hole_diameter < cutter_axle_diameter)
                    threaded_hole(cutter_fork_thickness+2*eps,
                                  cutter_axle_diameter, thread_pitch,
                                  cutter_thread_pilot_ratio);
                else
                    cylinder(d=hole_diameter,
                             h=cutter_fork_thickness+2*eps, center=true);
            }
    }
}

module cutter_fork() {
    // The outer cheek has a free M4 clearance hole. The inner cheek has
    // an M4 pilot hole for tapping or a self-threading screw.
    cutter_fork_cheek(cutter_outer_cheek_x,
                      cutter_axle_diameter+2*cutter_axle_clearance);
    cutter_fork_cheek(cutter_inner_cheek_x,
                      cutter_axle_diameter*cutter_thread_pilot_ratio);
}

module guide_pyramid_slots() {
    slot_depth = guide_pyramid_height+guide_pyramid_clearance;
    end_slot_top_width = guide_end_pyramid_top_width + 2*guide_pyramid_clearance;
    end_slot_base_width = guide_end_pyramid_base_width + 2*guide_pyramid_clearance;
    translate([0, guide_end_pyramid_y-hinge_axis_y, -cutter_arm_thickness/2])
        linear_extrude(height=slot_depth,
                       scale=end_slot_base_width/end_slot_top_width)
            square([end_slot_top_width, end_slot_top_width], center=true);
}

// Fixed underside stop: it contacts the trolley before the scoring wheel
// can be pressed deeper than cutter_depth_limit into the tile.
module cutter_depth_stop() {
    translate([0, cutter_local_y,
               -cutter_arm_thickness/2-cutter_depth_stop_height/2])
        cube([cutter_stop_width, cutter_stop_length,
              cutter_depth_stop_height], center=true);
}

// Arm is centred on the hinge axis; the free end extends toward -Y.
module cutter_arm_centered() {
    difference() {
        union() {
            // Narrow front neck carries the transverse hinge pin.
            translate([0, (hinge_front_inset-cutter_arm_neck_length)/2, 0])
                cube([cutter_arm_width,
                      hinge_front_inset+cutter_arm_neck_length,
                      cutter_arm_thickness], center=true);
            // Wider rear body leaves room for the scoring-wheel mount.
            wide_length =
                cutter_arm_length-hinge_front_inset-cutter_arm_neck_length;
            body_length = wide_length-cutter_arm_end_length;
            translate([0, -cutter_arm_neck_length-body_length/2, 0])
                cube([cutter_arm_body_width, body_length,
                      cutter_arm_thickness], center=true);
            // A small widened pad surrounds the cutter axle at the free end.
            translate([0, -cutter_arm_neck_length-body_length-
                       cutter_arm_end_length/2, 0])
                cube([cutter_arm_end_width, cutter_arm_end_length,
                      cutter_arm_thickness], center=true);
            cutter_fork();
            cutter_depth_stop();
        }
        rotate([0, 90, 0])
            cylinder(d=hinge_pin_diameter+2*hinge_hole_clearance,
                     h=cutter_arm_width+2*eps, center=true);
        guide_pyramid_slots();
    }
}

module cutter_wheel_local() {
    translate([cutter_local_x, cutter_local_y, cutter_axle_local_z])
        difference() {
            rotate([0, 90, 0])
                cylinder(d=cutter_outer_diameter, h=cutter_width, center=true);
            rotate([0, 90, 0])
                cylinder(d=cutter_bore_diameter,
                         h=cutter_width+2*eps, center=true);
        }
}

module cutter_axle_local() {
    inner_end_x = cutter_inner_cheek_x-
        cutter_side_sign*(cutter_fork_thickness/2-cutter_axle_end_clearance);
    outer_face_x = cutter_outer_cheek_x+
        cutter_side_sign*cutter_fork_thickness/2;
    shaft_length = abs(outer_face_x-inner_end_x);
    shaft_center_x = (outer_face_x+inner_end_x)/2;
    head_center_x = outer_face_x+
        cutter_side_sign*cutter_axle_head_thickness/2;

    translate([shaft_center_x, cutter_local_y, cutter_axle_local_z])
        rotate([0, 90, 0])
            threaded_shaft(shaft_length, cutter_axle_diameter, thread_pitch,
                           cutter_thread_pilot_ratio);
    translate([head_center_x, cutter_local_y, cutter_axle_local_z])
        rotate([0, 90, 0])
            cylinder(d=cutter_axle_head_diameter,
                     h=cutter_axle_head_thickness, center=true, $fn=6);
}

module place_on_cutter_arm() {
    translate([0, hinge_axis_y, hinge_axis_z])
        rotate([0, 0, cutter_end_sign > 0 ? 180 : 0])
            rotate([-cutter_arm_angle, 0, 0]) children();
}

module hinge_pin() {
    ear_outer_x = hinge_ear_center_x+hinge_ear_thickness/2;
    pin_left_x = -ear_outer_x-hinge_head_thickness;
    pin_right_x = ear_outer_x+hinge_nut_thickness;
    pin_length = pin_right_x-pin_left_x;
    pin_center_x = (pin_right_x+pin_left_x)/2;
    translate([pin_center_x, hinge_axis_y, hinge_axis_z])
        rotate([0, 90, 0])
            cylinder(d=hinge_pin_diameter, h=pin_length, center=true);
    translate([-ear_outer_x-hinge_head_thickness/2,
               hinge_axis_y, hinge_axis_z])
        rotate([0, 90, 0])
            cylinder(d=hinge_head_diameter, h=hinge_head_thickness,
                     center=true, $fn=6);
}

module hinge_nut() {
    ear_outer_x = hinge_ear_center_x+hinge_ear_thickness/2;
    nut_outer_diameter = hinge_nut_width_across_flats/cos(30);
    translate([ear_outer_x+hinge_nut_thickness/2,
               hinge_axis_y, hinge_axis_z])
        rotate([0, 90, 0])
            difference() {
                cylinder(d=nut_outer_diameter, h=hinge_nut_thickness,
                         center=true, $fn=6);
                cylinder(d=hinge_pin_diameter,
                         h=hinge_nut_thickness+2*eps, center=true);
            }
}

module hinge_washers() {
    ear_outer_x = hinge_ear_center_x+hinge_ear_thickness/2;
    for (side = [-1, 1])
        translate([side*(ear_outer_x+hinge_washer_thickness/2),
                   hinge_axis_y, hinge_axis_z])
            rotate([0, 90, 0])
                difference() {
                    cylinder(d=hinge_washer_outer_diameter,
                             h=hinge_washer_thickness, center=true);
                    cylinder(d=hinge_pin_diameter+2*hinge_hole_clearance,
                             h=hinge_washer_thickness+2*eps, center=true);
                }
}

module guide() { color(guide_color) guide_solid(); }
module trolley() { color(trolley_color) trolley_solid(); }
module trolley_placed() {
    color(trolley_color) translate([0, 0, body_bottom_z]) trolley_solid();
}
module bearings() {
    color(bearing_color) {
        for (side = [-1, 1], end = [-1, 1]) wheel_bearing(side, end*mount_station_y);
        for (y = [-side_bearing_spacing/2, side_bearing_spacing/2]) side_bearing(y);
        single_side_bearing();
    }
}
module bolts() {
    color(bolt_color) {
        for (side = [-1, 1], end = [-1, 1]) wheel_screw(side, end*mount_station_y);
        for (y = [-side_bearing_spacing/2, side_bearing_spacing/2]) side_wheel_screw(y);
        single_side_bolt_and_nut();
        hinge_pin();
    }
}
module nuts() {
    color(bolt_color) {
        single_side_nut();
        hinge_nut();
    }
}
module washers() {
    color(bolt_color) hinge_washers();
}
module cutter_arm() {
    color(cutter_arm_color)
        translate([0, 0, cutter_arm_thickness/2]) cutter_arm_centered();
}
module cutter_arm_placed() {
    color(cutter_arm_color)
        place_on_cutter_arm() cutter_arm_centered();
}
module cutter_wheel() {
    color(cutter_wheel_color)
        translate([0, 0, cutter_radius])
            difference() {
                rotate([0, 90, 0])
                    cylinder(d=cutter_outer_diameter,
                             h=cutter_width, center=true);
                rotate([0, 90, 0])
                    cylinder(d=cutter_bore_diameter,
                             h=cutter_width+2*eps, center=true);
            }
}
module cutter_wheel_placed() {
    color(cutter_wheel_color)
        place_on_cutter_arm() cutter_wheel_local();
}
module cutter_axle() {
    color(bolt_color) {
        rotate([0, 90, 0])
            cylinder(d=cutter_axle_diameter,
                     h=2*cutter_cheek_offset+cutter_fork_thickness,
                     center=true);
        translate([0, 0, cutter_axle_head_diameter/2])
            rotate([0, 90, 0])
                cylinder(d=cutter_axle_head_diameter,
                         h=cutter_axle_head_thickness, center=true, $fn=6);
    }
}
module cutter_axle_placed() {
    color(bolt_color)
        place_on_cutter_arm() cutter_axle_local();
}
module assembly() {
    if (show_guide) guide();
    trolley_placed();
    bearings();
    bolts();
    nuts();
    washers();
    cutter_arm_placed();
    cutter_wheel_placed();
    cutter_axle_placed();
}

if (part == "assembly") assembly();
else if (part == "guide") guide();
else if (part == "trolley") trolley();
else if (part == "trolley_placed") trolley_placed();
else if (part == "bearings") bearings();
else if (part == "bolts") bolts();
else if (part == "nuts") nuts();
else if (part == "washers") washers();
else if (part == "cutter_arm") cutter_arm();
else if (part == "cutter_arm_placed") cutter_arm_placed();
else if (part == "cutter_wheel") cutter_wheel();
else if (part == "cutter_wheel_placed") cutter_wheel_placed();
else if (part == "cutter_axle") cutter_axle();
else if (part == "cutter_axle_placed") cutter_axle_placed();
