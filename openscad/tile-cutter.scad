// First-piece tile-cutter trolley with four top-running bearings
// and three side guide bearings.
// Bearing and cutter screw sizes follow their bore diameters.
// Units: millimetres.

/* [View] */
part = "assembly"; // [assembly, print, guide, trolley, bearings, bolts, nuts, washers, cutter_arm, cutter_arm_print, cutter_wheel, cutter_axle]

/* [Guide] */
guide_width = 40; // [20:1:100]
guide_height = 20; // [5:1:30]
guide_length = 190; // [80:5:400]
show_guide = true;

/* [Trolley outline] */
trolley_length = 80; // [50:1:140]
trolley_thickness = 10; // [6:0.5:20]
trolley_end_width = 13; // [13:1:60] Width between the outer threaded faces of the wheel mounts.
trolley_end_tab_length = 24; // [13:1:35] Must be longer than the wheel diameter.
side_wing_extension = 23; // [5:1:25] Matches the 96 mm arm body and encloses the M8 nut pocket.
side_wing_length = 80; // [40:1:120] At least the central plate length; no corner cutouts.

/* [Comfort rounding] */
body_corner_radius = 3; // [0:0.5:6] Outer corners in plan view.
body_edge_radius = 1; // [0:0.25:2] Rounded upper and lower edges.

/* [Top bearings] */
bearing_outer_diameter = 22; // [8:0.5:30]
bearing_width = 8; // [3:0.5:12]
bearing_bore_diameter = 8; // [3:0.1:12]
bearing_radial_clearance = 0.4; // [0.1:0.1:1]
bearing_axial_clearance = 0.3; // [0.1:0.1:1]
bearing_edge_margin = 5; // [0.5:0.5:8] Reserves space for the screw head inside the guide width.

/* [Side guide bearings] */
side_bearing_side = "left"; // [right,left] Two fixed guide bearings are on the operator's side.
side_bearing_spacing = 44; // [20:1:70] Distance between the two side bearing axes.
fixed_side_edge_clearance = 0; // [0:0.05:1] The two fixed bearings touch the guide face.
adjustable_side_nominal_clearance = 0.3; // [0:0.1:1] Centre position of the adjustable bearing.
single_side_bearing_y = 0; // [-25:1:25] Position of the opposite single bearing.
single_side_adjustment_travel = 2; // [0.5:0.5:6] Total slot travel toward/away from the guide.
single_side_adjustment = 0; // [-3:0.1:3] Preview position; positive moves the bearing toward the guide.

/* [Wheel screws] */
screw_end_clearance = 0.4; // [0.1:0.1:1]
through_hole_clearance = 0.3; // [0.1:0.1:0.8]
nut_pocket_clearance = 0.3; // [0.1:0.1:1]
nut_recess_below_top = 0.2; // [0:0.1:2] Nut top sits below the trolley surface.

/* [Cutter arm and hinge] */
cutter_arm_length = 96; // [60:1:130]
cutter_arm_width = 44; // [25:1:60] Narrow hinge neck width.
cutter_arm_body_width = 86; // [60:1:140] Wide section carrying the offset cutter.
cutter_arm_end_width = 86; // [70:1:140] Matches the trolley's overall width for the default guide.
cutter_arm_end_length = 18; // [10:1:35] Length of the widened cutter end.
cutter_arm_opposite_trim = 18; // [0:1:30] Remove unused width opposite the cutter; zero restores the full outline.
cutter_arm_neck_length = 10; // [10:1:30] Length of the narrow section behind the hinge.
cutter_arm_thickness = 10; // [6:0.5:20] Same as trolley thickness by default.
grip_dome_height = 0; // [0:0.5:12] Palm dome height; zero restores the flat arm.
cutter_arm_angle = 0; // [0:1:35] Raised angle of the free end; zero puts the cutter on the tile.
hinge_end = "far"; // [near,far] Hinge at the far end; cutter arm spans back over the trolley.
hinge_front_inset = 6; // [3:0.5:12] Axis distance from the arm's front end.
hinge_edge_inset = 10; // [5:0.5:25] Axis distance from the trolley's front edge.
hinge_lift = 5; // [0:0.5:12] Gap that lets the cutter arm move down under hand pressure.
hinge_ear_thickness = 3; // [2:0.5:6]
hinge_ear_length = 14; // [10:1:24]
hinge_base_radius = 1; // [0:0.25:3] Small concave fillet where each ear meets the trolley.
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
cut_line_offset = 10; // [5:1:40] Distance from the selected guide face to the cutting line.
cutter_end_inset = 8; // [8:1:30] Distance from the free end of the arm to the cutter axis.
cutter_outer_diameter = 22; // [10:0.5:40]
cutter_width = 5; // [1:0.5:8]
cutter_bore_diameter = 6; // [3:0.1:10]
cutter_fork_thickness = 6; // [4:0.5:10]
cutter_fork_axial_clearance = 0.3; // [0.1:0.1:1]
cutter_fork_depth = 14; // [10:1:24]
cutter_fork_boss_diameter = 12; // [8:1:20]
cutter_axle_clearance = 0.25; // [0.1:0.05:0.8]
cutter_axle_end_clearance = 0.4; // [0.1:0.1:1]

/* [Enclosed elliptical arm guides] */
fin_length = 60; // [40:1:120] Half-ellipse length along the trolley.
fin_offset = 10; // [0:1:25] Shift away from the hinge toward the opposite edge.
fin_height = 6.5; // [4:0.5:14] Height above the trolley top.
fin_spacing = 38; // [18:1:38] Distance between guide centre lines, near the top wheel tracks.
fin_thickness = 3; // [2:0.5:5]
fin_slot_clearance = 0.25; // [0.1:0.05:0.8]
fin_roof_thickness = 2; // [1.5:0.5:4] Solid material above the blind slots.

/* [Depth stop] */
depth_stop_y = -34; // [-45:1:0]
depth_stop_width = 6; // [4:1:12] Small square stop, separate from side guidance.
depth_stop_height = 5; // [1:0.25:12]
depth_stop_clearance = 0.35; // [0.15:0.05:1]

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
function metric_pitch(d) = d <= 3 ? 0.5 : d <= 4 ? 0.7 : d <= 5 ? 0.8 :
                           d <= 6 ? 1 : d <= 8 ? 1.25 : d <= 10 ? 1.5 : 1.75;
function thread_ratio(d) = (d-1.22687*metric_pitch(d))/d;
thread_diameter = bearing_bore_diameter;
thread_pitch = metric_pitch(thread_diameter);
thread_engagement = min(0.75*thread_diameter, trolley_thickness-2);
thread_pilot_ratio = thread_ratio(thread_diameter);
screw_head_diameter = thread_diameter*1.625;
screw_head_thickness = thread_diameter*0.625;
nut_width_across_flats = thread_diameter*1.625;
nut_thickness = thread_diameter*0.8125;
cutter_axle_diameter = cutter_bore_diameter;
cutter_thread_pitch = metric_pitch(cutter_axle_diameter);
cutter_thread_pilot_ratio = thread_ratio(cutter_axle_diameter);
cutter_axle_head_diameter = cutter_axle_diameter*1.625;
cutter_axle_head_thickness = cutter_axle_diameter*0.625;
thread_profile_width = 0.42; // Fraction of pitch occupied by each thread flank.
thread_clearance = 0.18; // Printed radial allowance in internal threads.
bearing_radius = bearing_outer_diameter/2;
mount_station_y = trolley_length/2+trolley_end_tab_length/2;
mount_outer_x = trolley_end_width/2;
effective_side_wing_length = max(side_wing_length, trolley_length);
bearing_center_x = guide_width/2-bearing_edge_margin-bearing_width/2;
// Centre the running-wheel axes in the platform while keeping wheel contact.
axle_local_z = trolley_thickness/2;
body_bottom_z = guide_height+bearing_radius-axle_local_z;
thread_pilot_diameter = thread_diameter*thread_pilot_ratio;
bearing_inner_x = bearing_center_x-bearing_width/2;
side_sign = side_bearing_side == "left" ? -1 : 1;
side_bearing_center_x = side_sign*(guide_width/2+bearing_radius+fixed_side_edge_clearance);
single_side_sign = -side_sign;
single_side_slot_center_x =
    single_side_sign*(guide_width/2+bearing_radius+adjustable_side_nominal_clearance);
single_side_bearing_center_x =
    single_side_slot_center_x-single_side_sign*single_side_adjustment;
// Full bearing width lies on the guide face; a thin integral flange stays above the tile.
side_bearing_center_z = guide_height-bearing_width/2;
side_flange_thickness = 1.5;
side_flange_diameter = thread_diameter*1.5;
side_support_bottom_z = guide_height-body_bottom_z;
side_support_height = -side_support_bottom_z;
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
// Solve the downward arm rotation at the requested wheel penetration.
function stop_angle(lo=0, hi=30, n=28) =
    n == 0 ? (lo+hi)/2 :
    let(a=(lo+hi)/2,
        wheel_z=hinge_axis_z+cutter_local_y*sin(a)+cutter_axle_local_z*cos(a))
    wheel_z > cutter_radius-cutter_depth_limit
        ? stop_angle(a, hi, n-1) : stop_angle(lo, a, n-1);
depth_stop_angle = stop_angle();
depth_stop_local_y = arm_x_sign*(depth_stop_y-hinge_axis_y);
// The free-end edge of the small stop touches the flat pocket roof first.
depth_stop_contact_y = depth_stop_local_y-depth_stop_width/2;
depth_stop_roof_z =
    (body_top_z+depth_stop_height-hinge_axis_z-
     depth_stop_contact_y*sin(depth_stop_angle))/cos(depth_stop_angle);
depth_stop_slot_depth = cutter_arm_thickness/2+depth_stop_roof_z;
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
assert(side_bearing_spacing+bearing_outer_diameter <= effective_side_wing_length,
       "Side bearings do not fit along the overhanging wing");
assert(side_wing_extension >= bearing_radius+fixed_side_edge_clearance,
       "The overhanging wing is too short to carry a side bearing");
assert(side_bearing_center_z-bearing_width/2-side_flange_thickness >= 0.3,
       "Side bearing flange must clear the work surface by at least 0.3 mm");
assert(side_bearing_center_z-bearing_width/2 >= 0 &&
       side_bearing_center_z+bearing_width/2 <= guide_height,
       "The complete side-bearing width must lie on the guide face");
assert(side_support_height >= 0,
       "Side-bearing supports do not fit below the platform");
assert(abs(single_side_bearing_y)+bearing_radius <= effective_side_wing_length/2,
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
// Keep the complete hinge foot on the filled side wings, away from their rounded edge.
assert(abs(hinge_axis_y)+hinge_ear_length/2+hinge_base_radius+
       body_edge_radius+0.3*body_corner_radius <= effective_side_wing_length/2,
       "Move the hinge inward: its feet must fit on the existing side wings");
assert(mount_station_y-abs(hinge_axis_y)-hinge_ear_length/2-hinge_base_radius
       > bearing_radius+bearing_radial_clearance,
       "Hinge feet are too close to the top bearings");
assert(cutter_arm_body_width/2 >=
       abs(cutter_outer_cheek_x)+cutter_fork_thickness/2,
       "Cutter arm is too narrow for the offset cutter fork");
assert(cutter_arm_end_width >= cutter_arm_body_width,
       "Cutter end width must be at least the body width");
assert(cutter_arm_neck_length < cutter_arm_length-hinge_front_inset,
       "Cutter arm neck leaves no room for its wide body");
assert(depth_stop_slot_depth > 0 && depth_stop_slot_depth < cutter_arm_thickness,
       "Adjust stop height or hinge lift so the depth-stop pocket fits inside the arm");
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
assert(abs(hinge_axis_y+arm_x_sign*(cutter_local_y*cos(depth_stop_angle)-
       cutter_axle_local_z*sin(depth_stop_angle))) >
       effective_side_wing_length/2+cutter_radius,
       "Pressed cutter wheel hits the trolley edge: move it toward the free end");
assert(cutter_fork_boss_diameter >
       cutter_axle_diameter+2*cutter_axle_clearance,
       "Cutter axle hole leaves too little material in the fork");
assert(bearing_bore_diameter >= thread_diameter,
       "Bearing bore must be at least as large as the screw thread");
assert(axle_local_z > 0 && axle_local_z < trolley_thickness,
       "Bearing axle must pass through the trolley thickness");
assert(trolley_thickness/2 > (thread_diameter+thread_clearance)/2+body_edge_radius/2,
       "Bearing thread breaks through the platform: increase its thickness");
assert(guide_width/2+side_wing_extension >
       abs(single_side_slot_center_x)+single_side_adjustment_travel/2+
       (nut_width_across_flats+2*nut_pocket_clearance)/(2*cos(30))+body_edge_radius,
       "Adjustable nut pocket is too close to the trolley edge");
// Running bearings enter shallow underside reliefs when the arm is lowered.
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

// Axial shaft with a smooth bearing surface and a threaded fastening segment.
module partial_thread_shaft(length, d, thread_start, thread_end, ratio=undef) {
    effective_ratio = is_undef(ratio) ? thread_ratio(d) : ratio;
    union() {
        if (thread_start > -length/2)
            translate([0,0,(-length/2+thread_start)/2])
                cylinder(d=d, h=thread_start+length/2+eps, center=true);
        if (thread_end < length/2)
            translate([0,0,(thread_end+length/2)/2])
                cylinder(d=d, h=length/2-thread_end+eps, center=true);
        translate([0,0,(thread_start+thread_end)/2])
            threaded_shaft(thread_end-thread_start, d, metric_pitch(d), effective_ratio);
    }
}

// Matching roundovers on both faces, with rounded corners in plan view.
module comfortable_plate(height, corner_r=body_corner_radius, edge_r=body_edge_radius) {
    r = min(edge_r, height/2-eps);
    if (r > 0)
        translate([0, 0, r])
            minkowski() {
                linear_extrude(height=height-2*r)
                    offset(delta=-r)
                        offset(r=max(corner_r, r))
                            offset(delta=-max(corner_r, r)) children();
                sphere(r=r, $fn=$preview ? 16 : 32);
            }
    else
        linear_extrude(height=height)
            if (corner_r > 0)
                offset(r=corner_r) offset(delta=-corner_r) children();
            else children();
}

module trolley_outline_2d() {
    difference() {
    union() {
        square([guide_width, trolley_length], center=true);
        for (end = [-1, 1])
            translate([0, end*mount_station_y])
                square([trolley_end_width, trolley_end_tab_length], center=true);
        for (side = [-1, 1])
            translate([side*(guide_width/2+side_wing_extension/2), 0])
                square([side_wing_extension, effective_side_wing_length], center=true);
    }
    translate([0, hinge_axis_y])
        rotate(cutter_end_sign > 0 ? 180 : 0)
            opposite_trim_2d();
    }
}

module guide_solid() {
    translate([-guide_width/2, -guide_length/2, 0])
        cube([guide_width, guide_length, guide_height]);
}

// Bore sized for the bearing axle thread enters the outside face of each front/rear mount.
// The bearing itself remains outside the printed body, close to the guide edge.
module wheel_mount_cut(side, y) {
    hole_center_x = side*(mount_outer_x-thread_engagement/2);
    translate([hole_center_x, y, axle_local_z]) rotate([0, 90, 0])
        threaded_hole(thread_engagement+2*eps, thread_diameter, thread_pitch,
                      thread_pilot_ratio);
}

// Fixed side axles now pass through the supports and are secured by captive nuts above.
module side_wheel_mount_cut(y) {
    translate([side_bearing_center_x, y, side_support_bottom_z-eps])
        cylinder(d=thread_diameter+through_hole_clearance,
                 h=trolley_thickness+side_support_height+2*eps);
}

module side_supports() {
    for (y = [-side_bearing_spacing/2, side_bearing_spacing/2])
        translate([side_bearing_center_x, y, side_support_bottom_z])
            cylinder(d=side_flange_diameter, h=side_support_height+eps);
    hull()
        for (dx = [-single_side_adjustment_travel/2, single_side_adjustment_travel/2])
            translate([single_side_slot_center_x+dx, single_side_bearing_y,
                       side_support_bottom_z])
                cylinder(d=side_flange_diameter, h=side_support_height+eps);
}

module fixed_side_nut_pocket(y) {
    pocket_depth = nut_thickness+nut_recess_below_top+nut_pocket_clearance;
    translate([side_bearing_center_x, y, trolley_thickness-pocket_depth])
        cylinder(d=(nut_width_across_flats+2*nut_pocket_clearance)/cos(30),
                 h=pocket_depth+eps, $fn=6);
}

// The opposite single bearing uses a through-hole and a separate nut on top.
module single_side_through_hole() {
    // Capsule-shaped through slot: two round ends joined by straight walls.
    hull()
        for (dx = [-single_side_adjustment_travel/2,
                    single_side_adjustment_travel/2])
            translate([single_side_slot_center_x+dx, single_side_bearing_y,
                       (trolley_thickness+side_support_bottom_z)/2])
                cylinder(d=thread_diameter+through_hole_clearance,
                         h=trolley_thickness+side_support_height+2*eps, center=true);
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
        union() {
            comfortable_plate(trolley_thickness) trolley_outline_2d();
            side_supports();
        }
        for (side = [-1, 1], end = [-1, 1])
            wheel_mount_cut(side, end*mount_station_y);
        for (y = [-side_bearing_spacing/2, side_bearing_spacing/2])
            { side_wheel_mount_cut(y); fixed_side_nut_pocket(y); }
        single_side_through_hole();
        single_side_nut_pocket();
    }
}

// Smooth half ellipses remain below the arm's upper surface.
fin_center_y = -hinge_end_sign*fin_offset;

module elliptical_guide(side, clearance=0) {
        translate([side*fin_spacing/2, fin_center_y, trolley_thickness-eps])
            multmatrix([[0,0,1,0],[1,0,0,0],[0,1,0,0],[0,0,0,1]])
                linear_extrude(height=fin_thickness+2*clearance, center=true)
                    offset(r=clearance)
                        polygon(concat(
                            [[-fin_length/2, 0], [fin_length/2, 0]],
                            [for (i=[0:64])
                                [fin_length/2*cos(180*i/64),
                                 fin_height*sin(180*i/64)]]));
}

module elliptical_guides(clearance=0) {
    for (side=[-1, 1]) elliptical_guide(side, clearance);
}

function fin_top_in_arm(a) =
    sqrt(pow(fin_length/2*sin(a),2)+pow(fin_height*cos(a),2))
    -(hinge_lift+cutter_arm_thickness/2)*cos(a)
    +arm_x_sign*(fin_center_y-hinge_axis_y)*sin(a)+fin_slot_clearance;
assert(abs(fin_center_y)+fin_length/2 <= trolley_length/2,
       "Elliptical guides must stay within the trolley length");
assert(fin_height > hinge_lift+fin_slot_clearance,
       "Guides must enter the arm's underside pockets");
assert(fin_spacing/2+fin_thickness/2+fin_slot_clearance+body_edge_radius
       < cutter_arm_width/2,
       "Guide pockets must remain inside the arm sides");
assert(max([for (i=[0:36])
           fin_top_in_arm(-depth_stop_angle+(35+depth_stop_angle)*i/36)])
       < cutter_arm_thickness/2-fin_roof_thickness,
       "Guides would protrude above the arm: reduce their height or length");

module elliptical_guide_pockets() {
    // Sweep the guides through the arm's full movement, including pressing.
    // The roof assertion keeps these pockets blind, with a solid grip surface.
    steps = 18;
    // Hull each guide separately so the material between the slots remains solid.
    for (side=[-1, 1], i=[0:steps-1])
        hull()
            for (j=[i, i+1])
                rotate([-depth_stop_angle+(35+depth_stop_angle)*j/steps, 0, 0])
                    rotate([0, 0, cutter_end_sign > 0 ? 180 : 0])
                        translate([0, -hinge_axis_y, -(hinge_axis_z-body_bottom_z)])
                            elliptical_guide(side, fin_slot_clearance);
}

module small_depth_stop() {
    translate([0, depth_stop_y, trolley_thickness])
        linear_extrude(height=depth_stop_height)
            square([depth_stop_width, depth_stop_width], center=true);
}

module hinge_ears() {
    // Keep the ears joined to the trolley while lifting the hinge axis.
    ear_height = hinge_lift+cutter_arm_thickness;
    for (side = [-1, 1])
        difference() {
            union() {
                translate([side*hinge_ear_center_x, hinge_axis_y, trolley_thickness])
                    comfortable_plate(ear_height,
                                      min(body_corner_radius, hinge_ear_thickness/4),
                                      min(body_edge_radius, hinge_ear_thickness/4))
                        square([hinge_ear_thickness, hinge_ear_length], center=true);
                // Inverse quarter-circle fillet: broad only at the plate surface,
                // then concave toward the vertical ear. Keep the inner hinge face clear.
                r = hinge_base_radius;
                steps = $preview ? 12 : 24;
                if (r > 0)
                    for (i = [0:steps-1])
                        hull()
                            for (j = [i, i+1]) {
                                z = r*j/steps;
                                spread = r-sqrt(max(0, r*r-(r-z)*(r-z)));
                                translate([side*(hinge_ear_center_x+spread/2),
                                           hinge_axis_y, trolley_thickness+z-eps])
                                    comfortable_plate(2*eps,
                                                      min(0.5, hinge_ear_thickness/4), 0)
                                        square([hinge_ear_thickness+spread,
                                                hinge_ear_length+2*spread], center=true);
                            }
            }
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
        small_depth_stop();
        elliptical_guides();
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
            partial_thread_shaft(shaft_length, thread_diameter,
                side > 0 ? -shaft_length/2 : shaft_center_x-mount_outer_x,
                side > 0 ? mount_outer_x-shaft_center_x : shaft_length/2);
    translate([side*(bearing_center_x+bearing_width/2+screw_head_thickness/2), y,
               body_bottom_z+axle_local_z])
        rotate([0, 90, 0]) cylinder(d=screw_head_diameter,
                                   h=screw_head_thickness, center=true, $fn=6);
}

// Integral mushroom flange supports the inner ring; the bearing runs on a smooth shank.
module side_mushroom_axle(x, y) {
    bearing_bottom_z = side_bearing_center_z-bearing_width/2;
    shaft_bottom_z = bearing_bottom_z-side_flange_thickness;
    shaft_top_z = body_top_z-nut_recess_below_top;
    shaft_length = shaft_top_z-shaft_bottom_z;
    shaft_center_z = (shaft_bottom_z+shaft_top_z)/2;
    difference() {
        union() {
            translate([x, y, shaft_center_z])
                partial_thread_shaft(shaft_length, thread_diameter,
                                     body_bottom_z-shaft_center_z, shaft_length/2);
            translate([x, y, shaft_bottom_z])
                cylinder(d1=thread_diameter, d2=side_flange_diameter,
                         h=side_flange_thickness);
        }
        // Underside screwdriver slot prevents the axle turning with the top nut.
        translate([x, y, shaft_bottom_z+0.3-eps])
            cube([side_flange_diameter+eps, 1.2, 0.6+2*eps], center=true);
    }
}

module side_wheel_screw(y) {
    side_mushroom_axle(side_bearing_center_x, y);
}

module single_side_bolt_and_nut() {
    side_mushroom_axle(single_side_bearing_center_x, single_side_bearing_y);
}

module single_side_nut() {
    body_top_z = body_bottom_z+trolley_thickness;
    nut_center_z = body_top_z-nut_recess_below_top-nut_thickness/2;
    nut_outer_diameter = nut_width_across_flats/cos(30);
    translate([single_side_bearing_center_x, single_side_bearing_y,
               nut_center_z])
        difference() {
            cylinder(d=nut_outer_diameter, h=nut_thickness, center=true, $fn=6);
            threaded_hole(nut_thickness+2*eps, thread_diameter, thread_pitch, thread_pilot_ratio);
        }
}

module cutter_fork_cheek(x, hole_diameter) {
    r = min(body_edge_radius, cutter_fork_thickness/2-eps, 1-eps);
    difference() {
        if (r > 0)
            minkowski() {
                cutter_fork_cheek_core(x, r);
                sphere(r=r, $fn=$preview ? 16 : 32);
            }
        else cutter_fork_cheek_core(x, 0);
        translate([x, cutter_local_y, cutter_axle_local_z])
            rotate([0, 90, 0]) {
                if (hole_diameter < cutter_axle_diameter)
                    threaded_hole(cutter_fork_thickness+2*eps,
                                  cutter_axle_diameter, cutter_thread_pitch,
                                  cutter_thread_pilot_ratio);
                else
                    cylinder(d=hole_diameter,
                             h=cutter_fork_thickness+2*eps, center=true);
            }
    }
}

// Inset core keeps the original fork envelope after adding the roundover.
module cutter_fork_cheek_core(x, r) {
    hull() {
        translate([x, cutter_local_y, -cutter_arm_thickness/2+1])
            cube([cutter_fork_thickness-2*r, cutter_fork_depth-2*r, 2-2*r], center=true);
        translate([x, cutter_local_y, cutter_axle_local_z])
            rotate([0, 90, 0])
                cylinder(d=cutter_fork_boss_diameter-2*r,
                         h=cutter_fork_thickness-2*r, center=true);
        }
}

module cutter_fork() {
    // Both cheeks follow the cutter bore: outer clearance, inner thread.
    cutter_fork_cheek(cutter_outer_cheek_x,
                      cutter_axle_diameter+2*cutter_axle_clearance);
    cutter_fork_cheek(cutter_inner_cheek_x,
                      cutter_axle_diameter*cutter_thread_pilot_ratio);
}

module depth_stop_pocket() {
    // A roomy pocket receives the stop; only its roof sets the pressing limit.
    slot_width = depth_stop_width+2*depth_stop_clearance;
    translate([0, depth_stop_local_y, -cutter_arm_thickness/2-eps])
        linear_extrude(height=depth_stop_slot_depth+eps)
            square([slot_width, slot_width], center=true);
}

module cutter_arm_outline_2d() {
    difference() {
    union() {
            // Narrow front neck carries the transverse hinge pin.
            translate([0, (hinge_front_inset-cutter_arm_neck_length)/2])
                square([cutter_arm_width,
                      hinge_front_inset+cutter_arm_neck_length], center=true);
            // Wider rear body leaves room for the scoring-wheel mount.
            wide_length =
                cutter_arm_length-hinge_front_inset-cutter_arm_neck_length;
            body_length = wide_length-cutter_arm_end_length;
            translate([0, -cutter_arm_neck_length-body_length/2])
                square([cutter_arm_body_width, body_length], center=true);
            // A small widened pad surrounds the cutter axle at the free end.
            translate([0, -cutter_arm_neck_length-body_length-
                       cutter_arm_end_length/2])
                square([cutter_arm_end_width, cutter_arm_end_length], center=true);
    }
    opposite_trim_2d();
    }
}

// Shared contour in arm coordinates; reused on the trolley in assembly coordinates.
module opposite_trim_2d() {
    // Keep a wall outside the guide pockets while removing the unused palm area.
    trim_outer = max(cutter_arm_body_width, cutter_arm_end_width)/2;
    trim_inner = max(trim_outer-cutter_arm_opposite_trim,
                     fin_spacing/2+fin_thickness/2+fin_slot_clearance+body_edge_radius+3);
    trim_start_y = -cutter_arm_neck_length-10;
    trim_end_y = -cutter_arm_length+hinge_front_inset;
    if (cutter_arm_opposite_trim > 0)
        scale([-cutter_side_sign, 1])
            polygon(concat(
                [for(i=[0:48])
                    let(t=i/48, blend=t*t*(3-2*t))
                    [trim_outer-(trim_outer-trim_inner)*blend,
                     trim_start_y+(trim_end_y-trim_start_y)*t]],
                [[trim_inner, trim_end_y-10],
                 [trim_outer+20, trim_end_y-10],
                 [trim_outer+20, trim_start_y]]));
}

// Arm is centred on the hinge axis; the free end extends toward -Y.
module cutter_arm_centered() {
    difference() {
        union() {
            translate([0, 0, -cutter_arm_thickness/2])
                comfortable_plate(cutter_arm_thickness) cutter_arm_outline_2d();
            cutter_fork();
            palm_dome();
        }
        rotate([0, 90, 0])
            cylinder(d=hinge_pin_diameter+2*hinge_hole_clearance,
                     h=cutter_arm_width+2*eps, center=true);
        depth_stop_pocket();
        elliptical_guide_pockets();
        running_bearing_reliefs();
    }
}

// Offset the palm support toward the scoring wheel, with a longer slope toward the hinge.
module palm_dome() {
    if (grip_dome_height > 0) {
        cx = 0;
        cy = -0.56*cutter_arm_length;
        rx = cutter_arm_body_width/2-body_corner_radius-2;
        ry = 0.34*cutter_arm_length;
        px = cutter_local_x;
        py = cutter_local_y+10;
        rings = $preview ? 32 : 48;
        sectors = $preview ? 96 : 144;
        // Nested elliptical rings converge on the offset crest. No clipped sides.
        points = concat([[px, py, grip_dome_height+eps]],
            [for (i=[1:rings], j=[0:sectors-1])
                let(t=i/rings, a=360*j/sectors)
                [(1-t)*px+t*(cx+rx*cos(a)),
                 (1-t)*py+t*(cy+ry*sin(a)),
                 eps+grip_dome_height*pow(1-t*t, 2)]],
            [[cx, cy, 0]]);
        bottom = 1+rings*sectors;
        faces = concat(
            [for(j=[0:sectors-1]) [0, 1+j, 1+(j+1)%sectors]],
            [for(i=[0:rings-2], j=[0:sectors-1])
                let(a=1+i*sectors+j, b=1+i*sectors+(j+1)%sectors,
                    c=b+sectors, d=a+sectors) [a,d,c,b]],
            [for(j=[0:sectors-1])
                [bottom, 1+(rings-1)*sectors+(j+1)%sectors,
                 1+(rings-1)*sectors+j]]);
        translate([0, 0, cutter_arm_thickness/2-eps])
            polyhedron(points=points, faces=faces, convexity=10);
    }
}
// Sweep each running bearing into arm coordinates over its complete movement.
// Separate pockets preserve the material between the wheel tracks.
module running_bearing_reliefs() {
    steps = 18;
    for (side=[-1, 1], end=[-1, 1], i=[0:steps-1])
        hull()
            for (j=[i, i+1])
                rotate([-depth_stop_angle+(35+depth_stop_angle)*j/steps, 0, 0])
                    rotate([0, 0, cutter_end_sign > 0 ? 180 : 0])
                        translate([side*bearing_center_x,
                                   end*mount_station_y-hinge_axis_y,
                                   body_bottom_z+axle_local_z-hinge_axis_z])
                            rotate([0, 90, 0])
                                cylinder(d=bearing_outer_diameter+2*bearing_radial_clearance,
                                         h=bearing_width+2*bearing_axial_clearance, center=true);
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
            partial_thread_shaft(shaft_length, cutter_axle_diameter,
                cutter_side_sign > 0 ? -shaft_length/2 : cutter_inner_cheek_x-cutter_fork_thickness/2-shaft_center_x,
                cutter_side_sign > 0 ? cutter_inner_cheek_x+cutter_fork_thickness/2-shaft_center_x : shaft_length/2,
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
    pin_left_x = -ear_outer_x-hinge_washer_thickness-hinge_head_thickness;
    pin_right_x = ear_outer_x+hinge_washer_thickness+hinge_nut_thickness+metric_pitch(hinge_pin_diameter);
    pin_length = pin_right_x-pin_left_x;
    pin_center_x = (pin_right_x+pin_left_x)/2;
    translate([pin_center_x, hinge_axis_y, hinge_axis_z])
        rotate([0, 90, 0])
            partial_thread_shaft(pin_length, hinge_pin_diameter,
                ear_outer_x+hinge_washer_thickness-pin_center_x, pin_length/2);
    translate([-ear_outer_x-hinge_washer_thickness-hinge_head_thickness/2,
               hinge_axis_y, hinge_axis_z])
        rotate([0, 90, 0])
            cylinder(d=hinge_head_diameter, h=hinge_head_thickness,
                     center=true, $fn=6);
}

module hinge_nut() {
    ear_outer_x = hinge_ear_center_x+hinge_ear_thickness/2;
    nut_outer_diameter = hinge_nut_width_across_flats/cos(30);
    translate([ear_outer_x+hinge_washer_thickness+hinge_nut_thickness/2,
               hinge_axis_y, hinge_axis_z])
        rotate([0, 90, 0])
            difference() {
                cylinder(d=nut_outer_diameter, h=hinge_nut_thickness,
                         center=true, $fn=6);
                threaded_hole(hinge_nut_thickness+2*eps, hinge_pin_diameter,
                              metric_pitch(hinge_pin_diameter), thread_ratio(hinge_pin_diameter));
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
        for (y = [-side_bearing_spacing/2, side_bearing_spacing/2])
            translate([side_bearing_center_x-single_side_bearing_center_x,
                       y-single_side_bearing_y, 0]) single_side_nut();
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
// Upper grip face on the bed; fork and all blind pockets face upward.
module cutter_arm_print() {
    color(cutter_arm_color)
        translate([0, 0, cutter_arm_thickness/2])
            rotate([180, 0, 0]) cutter_arm_centered();
}

module print_layout() {
    gap = 12;
    trolley_half_width = guide_width/2+side_wing_extension;
    arm_half_width = max(cutter_arm_width, cutter_arm_body_width, cutter_arm_end_width)/2;
    translate([0, 0, side_support_height]) trolley();
    translate([trolley_half_width+gap+arm_half_width,
               -cutter_arm_length/2+hinge_front_inset, 0]) cutter_arm_print();

    // Reuse assembly geometry, undo its placement, and put screw heads on the bed.
    row_y = max(trolley_length/2+trolley_end_tab_length, cutter_arm_length/2)+gap;
    screw_step = max(screw_head_diameter, cutter_axle_head_diameter,
                     hinge_head_diameter)+gap;
    wheel_head_x = bearing_center_x+bearing_width/2+screw_head_thickness;
    side_bottom_z = side_bearing_center_z-bearing_width/2-side_flange_thickness;
    color(bolt_color) {
        for (i=[0:3])
            translate([i*screw_step, row_y, 0]) rotate([0, 90, 0])
                translate([-wheel_head_x, 0, -(body_bottom_z+axle_local_z)])
                    wheel_screw(1, 0);
        for (i=[0:1])
            translate([(i+4)*screw_step, row_y, 0])
                translate([-side_bearing_center_x, 0, -side_bottom_z]) side_wheel_screw(0);
        translate([6*screw_step, row_y, 0])
            translate([-single_side_bearing_center_x, -single_side_bearing_y, -side_bottom_z])
                single_side_bolt_and_nut();
        ear_outer_x = hinge_ear_center_x+hinge_ear_thickness/2;
        translate([7*screw_step, row_y, 0]) rotate([0, -90, 0])
            translate([ear_outer_x+hinge_washer_thickness+hinge_head_thickness, -hinge_axis_y, -hinge_axis_z]) hinge_pin();
        cutter_head_x = cutter_outer_cheek_x+cutter_side_sign*
                        (cutter_fork_thickness/2+cutter_axle_head_thickness);
        translate([8*screw_step, row_y, 0]) rotate([0, cutter_side_sign*90, 0])
            translate([-cutter_head_x, -cutter_local_y, -cutter_axle_local_z]) cutter_axle_local();
        translate([0, row_y+screw_step, nut_thickness/2])
            translate([-single_side_bearing_center_x, -single_side_bearing_y,
                       -(body_top_z-nut_recess_below_top-nut_thickness/2)]) single_side_nut();
        for (i=[0:1])
            translate([(i+4)*screw_step, row_y+screw_step, nut_thickness/2])
                translate([-single_side_bearing_center_x, -single_side_bearing_y,
                           -(body_top_z-nut_recess_below_top-nut_thickness/2)]) single_side_nut();
        translate([screw_step, row_y+screw_step, hinge_nut_thickness/2]) rotate([0, 90, 0])
            translate([-(ear_outer_x+hinge_washer_thickness+hinge_nut_thickness/2), -hinge_axis_y, -hinge_axis_z]) hinge_nut();
        for (i=[0:1])
            translate([(i+2)*screw_step, row_y+screw_step, 0])
                difference() {
                    cylinder(d=hinge_washer_outer_diameter, h=hinge_washer_thickness);
                    translate([0,0,-eps]) cylinder(d=hinge_pin_diameter+2*hinge_hole_clearance,
                                                  h=hinge_washer_thickness+2*eps);
                }
    }
    // Seven bearing models and the cutter wheel, flat faces on the bed.
    disc_step = max(bearing_outer_diameter, cutter_outer_diameter)+gap;
    for (i=[0:6])
        color(bearing_color) translate([i*disc_step, row_y+2*disc_step, bearing_width/2])
            rotate([0,90,0]) bearing_disc();
    color(cutter_wheel_color)
        translate([7*disc_step, row_y+2*disc_step, cutter_width/2])
            rotate([0,90,0]) translate([-cutter_local_x,-cutter_local_y,-cutter_axle_local_z])
                cutter_wheel_local();
    translate([guide_width/2, row_y+3*disc_step+guide_length/2, 0]) guide();
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
else if (part == "print") print_layout();
else if (part == "guide") guide();
else if (part == "trolley") trolley();
else if (part == "trolley_placed") trolley_placed();
else if (part == "bearings") bearings();
else if (part == "bolts") bolts();
else if (part == "nuts") nuts();
else if (part == "washers") washers();
else if (part == "cutter_arm") cutter_arm();
else if (part == "cutter_arm_print") cutter_arm_print();
else if (part == "cutter_arm_placed") cutter_arm_placed();
else if (part == "cutter_wheel") cutter_wheel();
else if (part == "cutter_wheel_placed") cutter_wheel_placed();
else if (part == "cutter_axle") cutter_axle();
else if (part == "cutter_axle_placed") cutter_axle_placed();
