# -*- coding: utf-8 -*-
# FreeCAD 1.1: inner-lug variant, first step.
# Parametric plate with N holes along the center and no external lugs.
# Around each hole the plate is Thickness; outside a rim it is Thickness/2.
# Corner and top-edge rounding match the original plate (GeomFillet).
# Four screw holes sit in the corners, inset by CornerInset from both edges.
# waterCover is the same plate without the big holes, plus walls inset from the
# plate edge so they sit on the flat (not over the edge fillets). At the corners
# the walls wrap around the screw holes at CornerInset (same offset as to the
# plate edge), so there is room to fasten the cover. Screws stay outside the box.
# The bottom plate is cut through along the inner perimeter of the walls.
# Two G 1/2 (BSPP) drain holes sit at mid-length and mid-height of the +X and -Y walls.
# Two G 1/2 (BSPP) drain holes sit in the middle of the +X and -Y walls.
# Parameters live on the Params VarSet. Change them, then recompute.

import math
import os
import shutil
import sys
import zipfile

_HERE = os.path.dirname(os.path.abspath(__file__))
if _HERE not in sys.path:
    sys.path.insert(0, _HERE)

import FreeCAD as App
import Part
import Sketcher
import geom_fillet

OUT = r"C:\Users\vofka\dev\freecad\drillbox\rect-n-holes-inner.FCStd"


def _install_geom_fillet():
    here = os.path.dirname(os.path.abspath(__file__))
    if here not in sys.path:
        sys.path.insert(0, here)
    try:
        mdir = App.getUserMacroDir(True)
        shutil.copy2(os.path.join(here, "geom_fillet.py"), os.path.join(mdir, "geom_fillet.py"))
    except Exception as exc:
        print("install geom_fillet:", exc)


def add_geom_fillet(body, name, source, radius_expr, mode, edge_len_expr=None, skip_boss=False):
    obj = body.newObject("PartDesign::FeaturePython", name)
    geom_fillet.GeomFillet(obj)
    obj.Source = source
    obj.Mode = mode
    obj.setExpression("Radius", radius_expr)
    if edge_len_expr:
        obj.setExpression("EdgeLength", edge_len_expr)
    obj.HasSkipBoss = bool(skip_boss)
    if skip_boss:
        obj.setExpression("SkipBossRadius", "Params.Diameter / 2 + Params.Rim")
    vo = getattr(obj, "ViewObject", None)
    if vo is not None:
        vo.Proxy = 0
    body.Tip = obj
    doc.recompute()
    print(name, obj.getStatusString())
    return obj


def add_plate_sketch(body, name):
    plate = body.newObject("Sketcher::SketchObject", name)
    w = float(params.Width)
    h = float(params.Height)
    hw, hh = w / 2.0, h / 2.0
    plate.addGeometry(Part.LineSegment(App.Vector(-hw, hh, 0), App.Vector(hw, hh, 0)))
    plate.addGeometry(Part.LineSegment(App.Vector(hw, hh, 0), App.Vector(hw, -hh, 0)))
    plate.addGeometry(Part.LineSegment(App.Vector(hw, -hh, 0), App.Vector(-hw, -hh, 0)))
    plate.addGeometry(Part.LineSegment(App.Vector(-hw, -hh, 0), App.Vector(-hw, hh, 0)))
    plate.addConstraint(
        [
            Sketcher.Constraint("Coincident", 0, 2, 1, 1),
            Sketcher.Constraint("Coincident", 1, 2, 2, 1),
            Sketcher.Constraint("Coincident", 2, 2, 3, 1),
            Sketcher.Constraint("Coincident", 3, 2, 0, 1),
            Sketcher.Constraint("Horizontal", 0),
            Sketcher.Constraint("Horizontal", 2),
            Sketcher.Constraint("Vertical", 1),
            Sketcher.Constraint("Vertical", 3),
            Sketcher.Constraint("Symmetric", 0, 1, 2, 1, -1, 1),
        ]
    )
    c_h = plate.addConstraint(Sketcher.Constraint("Distance", 3, h))
    c_w = plate.addConstraint(Sketcher.Constraint("Distance", 0, w))
    plate.renameConstraint(c_h, "Height")
    plate.renameConstraint(c_w, "Width")
    plate.setExpression("Constraints.Height", "Params.Height")
    plate.setExpression("Constraints.Width", "Params.Width")
    doc.recompute()
    print(name, "constrained", plate.FullyConstrained, plate.getStatusString())
    return plate


def add_boss_section(body, name):
    """Boss ring cross-section on XZ: step from Thickness/2 to Thickness with top fillet."""
    sk = body.newObject("Sketcher::SketchObject", name)
    sk.AttachmentSupport = [(body.Origin.OriginFeatures[4], "")]
    sk.MapMode = "FlatFace"
    doc.recompute()

    r_outer = float(params.Diameter) / 2.0 + float(params.Rim)
    z_step = float(params.Thickness) / 2.0
    z_top = float(params.Thickness)
    fillet_r = float(params.Thickness) / 2.0
    axis_eps = 0.01

    sk.addGeometry(
        Part.LineSegment(App.Vector(0, z_step, 0), App.Vector(r_outer, z_step, 0)),
        False,
    )
    circ = Part.Circle(
        App.Vector(r_outer - fillet_r, z_top - fillet_r, 0),
        App.Vector(0, 0, 1),
        fillet_r,
    )
    sk.addGeometry(Part.ArcOfCircle(circ, 0, math.pi / 2.0), False)
    sk.addGeometry(
        Part.LineSegment(
            App.Vector(r_outer - fillet_r, z_top, 0),
            App.Vector(axis_eps, z_top, 0),
        ),
        False,
    )
    sk.addGeometry(
        Part.LineSegment(
            App.Vector(axis_eps, z_top, 0),
            App.Vector(axis_eps, z_step, 0),
        ),
        False,
    )
    sk.addGeometry(
        Part.LineSegment(App.Vector(axis_eps, z_step, 0), App.Vector(0, z_step, 0)),
        False,
    )
    sk.addConstraint(
        [
            Sketcher.Constraint("Coincident", 0, 2, 1, 1),
            Sketcher.Constraint("Coincident", 1, 2, 2, 1),
            Sketcher.Constraint("Coincident", 2, 2, 3, 1),
            Sketcher.Constraint("Coincident", 3, 2, 4, 1),
            Sketcher.Constraint("Coincident", 4, 2, 0, 1),
            Sketcher.Constraint("Horizontal", 0),
            Sketcher.Constraint("Horizontal", 2),
            Sketcher.Constraint("Vertical", 3),
            Sketcher.Constraint("PointOnObject", 0, 1, -2),
        ]
    )
    c_w = sk.addConstraint(Sketcher.Constraint("DistanceX", 0, 2, r_outer))
    c_s = sk.addConstraint(Sketcher.Constraint("DistanceY", 0, 1, z_step))
    c_h = sk.addConstraint(Sketcher.Constraint("DistanceY", 2, 1, z_top))
    c_f = sk.addConstraint(Sketcher.Constraint("Radius", 1, fillet_r))
    sk.renameConstraint(c_w, "OuterRadius")
    sk.renameConstraint(c_s, "Step")
    sk.renameConstraint(c_h, "Top")
    sk.renameConstraint(c_f, "FilletRadius")
    sk.setExpression("Constraints.OuterRadius", "Params.Diameter / 2 + Params.Rim")
    sk.setExpression("Constraints.Step", "Params.Thickness / 2")
    sk.setExpression("Constraints.Top", "Params.Thickness")
    sk.setExpression("Constraints.FilletRadius", "Params.Thickness / 2")
    sk.setExpression(
        "AttachmentOffset.Base.x",
        "-(Params.Count - 1) * Params.Offset / 2",
    )
    doc.recompute()
    return sk


def add_boss_and_holes(body, plate):
    r = float(params.Diameter) / 2.0
    cx = -((params.Count - 1) * float(params.Offset)) / 2.0
    boss_sec = add_boss_section(body, "SketchBossSection")
    print("boss section", boss_sec.getStatusString(), boss_sec.FullyConstrained)
    rev_boss = body.newObject("PartDesign::Revolution", "RevBoss")
    rev_boss.Profile = boss_sec
    rev_boss.ReferenceAxis = (boss_sec, ["V_Axis"])
    rev_boss.Angle = 360.0
    doc.recompute()
    print("rev boss", rev_boss.getStatusString())
    boss_pattern = body.newObject("PartDesign::LinearPattern", "LinearPatternBoss")
    boss_pattern.Originals = [rev_boss]
    boss_pattern.Direction = (plate, ["H_Axis"])
    boss_pattern.Mode = "Spacing"
    boss_pattern.setExpression("Offset", "Params.Offset")
    boss_pattern.setExpression("Occurrences", "Params.Count")
    boss_pattern.Refine = True
    body.Tip = boss_pattern
    doc.recompute()
    print("boss pattern", boss_pattern.getStatusString())
    holes = body.newObject("Sketcher::SketchObject", "SketchHole")
    holes.addGeometry(Part.Circle(App.Vector(cx, 0, 0), App.Vector(0, 0, 1), r), False)
    c_r = holes.addConstraint(Sketcher.Constraint("Radius", 0, r))
    c_x = holes.addConstraint(Sketcher.Constraint("DistanceX", 0, 3, cx))
    holes.addConstraint(Sketcher.Constraint("PointOnObject", 0, 3, -1))
    holes.renameConstraint(c_r, "Radius")
    holes.renameConstraint(c_x, "CenterX")
    holes.setExpression("Constraints.Radius", "Params.Diameter / 2")
    holes.setExpression("Constraints.CenterX", "-(Params.Count - 1) * Params.Offset / 2")
    doc.recompute()
    print("hole constrained", holes.FullyConstrained, holes.getStatusString())
    pocket = body.newObject("PartDesign::Pocket", "Pocket")
    pocket.Profile = holes
    pocket.Type = "ThroughAll"
    pocket.Reversed = True
    doc.recompute()
    print("pocket", pocket.getStatusString())
    pattern = body.newObject("PartDesign::LinearPattern", "LinearPattern")
    pattern.Originals = [pocket]
    pattern.Direction = (holes, ["H_Axis"])
    pattern.Mode = "Spacing"
    pattern.setExpression("Offset", "Params.Offset")
    pattern.setExpression("Occurrences", "Params.Count")
    pattern.Refine = True
    body.Tip = pattern
    doc.recompute()
    print("pattern", pattern.getStatusString())
    return pattern


def add_corner_holes(body, prefix=""):
    """Through holes in the four corners. Center is CornerInset from each edge."""
    x_expr = "Params.Width / 2 - Params.CornerInset"
    y_expr = "Params.Height / 2 - Params.CornerInset"
    last = None
    for name, sx, sy in (
        (prefix + "CornerHoleNE", "", ""),
        (prefix + "CornerHoleSE", "", "-"),
        (prefix + "CornerHoleNW", "-", ""),
        (prefix + "CornerHoleSW", "-", "-"),
    ):
        cyl = body.newObject("PartDesign::SubtractiveCylinder", name)
        cyl.setExpression("Radius", "Params.CornerHoleDiameter / 2")
        cyl.setExpression("Height", "Params.Thickness / 2")
        cyl.setExpression("Placement.Base.x", sx + "(" + x_expr + ")")
        cyl.setExpression("Placement.Base.y", sy + "(" + y_expr + ")")
        last = cyl
    last.Refine = True
    body.Tip = last
    doc.recompute()
    print(prefix + "corner holes", last.getStatusString())
    return last


def _arc_90(center, p0, p1, radius):
    """Quarter-circle from p0 to p1, CCW around center."""
    a0 = math.atan2(p0[1] - center[1], p0[0] - center[0])
    a1 = math.atan2(p1[1] - center[1], p1[0] - center[0])
    if a1 < a0:
        a1 += 2.0 * math.pi
    circ = Part.Circle(App.Vector(center[0], center[1], 0), App.Vector(0, 0, 1), radius)
    return Part.ArcOfCircle(circ, a0, a1)


def _wall_outline_segments(hw, hh, hx, hy, inset, wrap):
    """CCW segments of an inset rectangle with concave wraps around the four holes.

    Each item is ("line", p0, p1) or ("arc", p0, p1, center, radius).
    """
    ox = hw - inset
    oy = hh - inset
    return (
        ("line", (-hx + wrap, oy), (hx - wrap, oy)),
        ("line", (hx - wrap, oy), (hx - wrap, hy)),
        ("arc", (hx - wrap, hy), (hx, hy - wrap), (hx, hy), wrap),
        ("line", (hx, hy - wrap), (ox, hy - wrap)),
        ("line", (ox, hy - wrap), (ox, -hy + wrap)),
        ("line", (ox, -hy + wrap), (hx, -hy + wrap)),
        ("arc", (hx, -hy + wrap), (hx - wrap, -hy), (hx, -hy), wrap),
        ("line", (hx - wrap, -hy), (hx - wrap, -oy)),
        ("line", (hx - wrap, -oy), (-hx + wrap, -oy)),
        ("line", (-hx + wrap, -oy), (-hx + wrap, -hy)),
        ("arc", (-hx + wrap, -hy), (-hx, -hy + wrap), (-hx, -hy), wrap),
        ("line", (-hx, -hy + wrap), (-ox, -hy + wrap)),
        ("line", (-ox, -hy + wrap), (-ox, hy - wrap)),
        ("line", (-ox, hy - wrap), (-hx, hy - wrap)),
        ("arc", (-hx, hy - wrap), (-hx + wrap, hy), (-hx, hy), wrap),
        ("line", (-hx + wrap, hy), (-hx + wrap, oy)),
    )


def add_notched_wall_sketch(body, name, inset, wrap, inset_expr, wrap_expr):
    """Closed inset rectangle with quarter-circle wraps around the four screw holes."""
    sk = body.newObject("Sketcher::SketchObject", name)
    sk.AttachmentSupport = [(body.Origin.OriginFeatures[3], "")]
    sk.MapMode = "FlatFace"
    doc.recompute()
    sk.setExpression("AttachmentOffset.Base.z", "Params.Thickness / 2")
    doc.recompute()

    C = float(params.CornerInset)
    hw = float(params.Width) / 2.0
    hh = float(params.Height) / 2.0
    hx = hw - C
    hy = hh - C
    hole_pts = ((hx, hy), (hx, -hy), (-hx, -hy), (-hx, hy))
    hole_ids = [
        sk.addGeometry(Part.Point(App.Vector(px, py, 0)), True) for px, py in hole_pts
    ]

    segs = _wall_outline_segments(hw, hh, hx, hy, inset, wrap)
    ids = []
    for seg in segs:
        if seg[0] == "line":
            p0, p1 = seg[1], seg[2]
            gid = sk.addGeometry(
                Part.LineSegment(
                    App.Vector(p0[0], p0[1], 0), App.Vector(p1[0], p1[1], 0)
                )
            )
        else:
            p0, p1, center, radius = seg[1], seg[2], seg[3], seg[4]
            gid = sk.addGeometry(_arc_90(center, p0, p1, radius))
        ids.append(gid)

    n = len(ids)
    for i, gid in enumerate(ids):
        sk.addConstraint(Sketcher.Constraint("Coincident", gid, 2, ids[(i + 1) % n], 1))
        geo = sk.Geometry[gid]
        if isinstance(geo, Part.LineSegment):
            if abs(geo.EndPoint.x - geo.StartPoint.x) < abs(
                geo.EndPoint.y - geo.StartPoint.y
            ):
                sk.addConstraint(Sketcher.Constraint("Vertical", gid))
            else:
                sk.addConstraint(Sketcher.Constraint("Horizontal", gid))

    hole_xy = (
        (
            "HoleNEX",
            "HoleNEY",
            "Params.Width / 2 - Params.CornerInset",
            "Params.Height / 2 - Params.CornerInset",
        ),
        (
            "HoleSEX",
            "HoleSEY",
            "Params.Width / 2 - Params.CornerInset",
            "-(Params.Height / 2 - Params.CornerInset)",
        ),
        (
            "HoleSWX",
            "HoleSWY",
            "-(Params.Width / 2 - Params.CornerInset)",
            "-(Params.Height / 2 - Params.CornerInset)",
        ),
        (
            "HoleNWX",
            "HoleNWY",
            "-(Params.Width / 2 - Params.CornerInset)",
            "Params.Height / 2 - Params.CornerInset",
        ),
    )
    for gid, (px, py), (xn, yn, xe, ye) in zip(hole_ids, hole_pts, hole_xy):
        cx = sk.addConstraint(Sketcher.Constraint("DistanceX", gid, 1, px))
        cy = sk.addConstraint(Sketcher.Constraint("DistanceY", gid, 1, py))
        sk.renameConstraint(cx, xn)
        sk.renameConstraint(cy, yn)
        sk.setExpression("Constraints." + xn, xe)
        sk.setExpression("Constraints." + yn, ye)

    arcs = (ids[2], ids[6], ids[10], ids[14])
    # NE/SW: arc starts west/east (same Y as center) and ends south/north (same X).
    # SE/NW: arc starts north/south (same X as center) and ends west/east (same Y).
    axis_aligned = (
        ("Horizontal", "Vertical"),
        ("Vertical", "Horizontal"),
        ("Horizontal", "Vertical"),
        ("Vertical", "Horizontal"),
    )
    for arc, hole, rname, (c_start, c_end) in zip(
        arcs, hole_ids, ("WrapNE", "WrapSE", "WrapSW", "WrapNW"), axis_aligned
    ):
        sk.addConstraint(Sketcher.Constraint("Coincident", arc, 3, hole, 1))
        cr = sk.addConstraint(Sketcher.Constraint("Radius", arc, wrap))
        sk.renameConstraint(cr, rname)
        sk.setExpression("Constraints." + rname, wrap_expr)
        sk.addConstraint(Sketcher.Constraint(c_start, arc, 1, arc, 3))
        sk.addConstraint(Sketcher.Constraint(c_end, arc, 2, arc, 3))

    c_top = sk.addConstraint(Sketcher.Constraint("DistanceY", ids[0], 1, hh - inset))
    c_right = sk.addConstraint(Sketcher.Constraint("DistanceX", ids[4], 1, hw - inset))
    c_bot = sk.addConstraint(Sketcher.Constraint("DistanceY", ids[8], 1, -(hh - inset)))
    c_left = sk.addConstraint(Sketcher.Constraint("DistanceX", ids[12], 1, -(hw - inset)))
    sk.renameConstraint(c_top, "OuterY")
    sk.renameConstraint(c_right, "OuterX")
    sk.renameConstraint(c_bot, "OuterYNeg")
    sk.renameConstraint(c_left, "OuterXNeg")
    sk.setExpression("Constraints.OuterY", "Params.Height / 2 - (" + inset_expr + ")")
    sk.setExpression("Constraints.OuterX", "Params.Width / 2 - (" + inset_expr + ")")
    sk.setExpression(
        "Constraints.OuterYNeg", "-(Params.Height / 2 - (" + inset_expr + "))"
    )
    sk.setExpression(
        "Constraints.OuterXNeg", "-(Params.Width / 2 - (" + inset_expr + "))"
    )
    doc.recompute()
    print(name, "constrained", sk.FullyConstrained, sk.getStatusString())
    return sk


def add_cover_walls(body, prefix):
    """Inset walls whose corners wrap around the screw holes, opening to the outside."""
    I = float(params.WallInset)
    T = float(params.WallThickness)
    wr = float(params.CornerInset)
    wrap_outer = "Params.CornerInset"

    outer = add_notched_wall_sketch(
        body, prefix + "SketchWallOuter", I, wr, "Params.WallInset", wrap_outer
    )
    pad = body.newObject("PartDesign::Pad", prefix + "Walls")
    pad.Profile = outer
    pad.setExpression("Length", "Params.WallHeight")
    pad.Refine = True
    body.Tip = pad
    doc.recompute()
    print(prefix + "Walls", pad.getStatusString())

    inner = add_notched_wall_sketch(
        body,
        prefix + "SketchWallInner",
        I + T,
        wr + T,
        "Params.WallInset + Params.WallThickness",
        wrap_outer + " + Params.WallThickness",
    )
    cut = body.newObject("PartDesign::Pocket", prefix + "WallCavity")
    cut.Profile = inner
    cut.Type = "Length"
    cut.setExpression("Length", "Params.WallHeight")
    cut.Reversed = True
    cut.Refine = True
    body.Tip = cut
    doc.recompute()
    print(prefix + "WallCavity", cut.getStatusString(), "rev", cut.Reversed)
    if cut.getStatusString() != "Valid":
        cut.Reversed = False
        doc.recompute()
        print(prefix + "WallCavity", cut.getStatusString(), "rev", cut.Reversed)

    floor = body.newObject("PartDesign::Pocket", prefix + "FloorWindow")
    floor.Profile = inner
    floor.Type = "ThroughAll"
    floor.Reversed = False
    floor.Refine = True
    body.Tip = floor
    doc.recompute()
    print(prefix + "FloorWindow", floor.getStatusString(), "rev", floor.Reversed)
    if floor.getStatusString() != "Valid":
        floor.Reversed = True
        doc.recompute()
        print(prefix + "FloorWindow", floor.getStatusString(), "rev", floor.Reversed)
    return add_cover_wall_holes(body, prefix)


def add_cover_wall_holes(body, prefix):
    """G 1/2 BSPP holes with outer bosses, mid-height and mid-length of +X and -Y walls."""
    z_expr = "Params.Thickness / 2 + Params.WallHeight / 2"
    outer_x = "Params.Width / 2 - Params.WallInset"
    outer_y = "Params.Height / 2 - Params.WallInset"
    last = None
    specs = (
        (
            prefix + "HoleYZ",
            True,
            body.Origin.OriginFeatures[5],
            "(" + outer_x + ") + Params.ThreadBossLength",
            "0 mm",
            outer_x,
            "0 mm",
        ),
        (
            prefix + "HoleXZ",
            False,
            body.Origin.OriginFeatures[4],
            "(" + outer_y + ") + Params.ThreadBossLength",
            "0 mm",
            "-(" + outer_y + ")",
            "0 mm",
        ),
    )
    cz = float(params.Thickness) / 2.0 + float(params.WallHeight) / 2.0
    for name, along_x, plane, sketch_z, sketch_x, boss_along, boss_cross in specs:
        boss = body.newObject("PartDesign::AdditiveCylinder", name + "Boss")
        boss.setExpression("Radius", "Params.ThreadBossDiameter / 2")
        boss.setExpression("Height", "Params.ThreadBossLength")
        boss.setExpression("Placement.Base.z", z_expr)
        if along_x:
            boss.Placement.Rotation = App.Rotation(App.Vector(0, 1, 0), 90)
            boss.setExpression("Placement.Base.x", boss_along)
            boss.setExpression("Placement.Base.y", boss_cross)
        else:
            boss.Placement.Rotation = App.Rotation(App.Vector(1, 0, 0), 90)
            boss.setExpression("Placement.Base.x", boss_cross)
            boss.setExpression("Placement.Base.y", boss_along)
        body.Tip = boss
        doc.recompute()
        print(name + "Boss", boss.getStatusString())

        sk = body.newObject("Sketcher::SketchObject", name + "Sketch")
        sk.AttachmentSupport = [(plane, "")]
        sk.MapMode = "FlatFace"
        sk.setExpression("AttachmentOffset.Base.z", sketch_z)
        doc.recompute()
        g = sk.addGeometry(
            Part.Circle(App.Vector(0, cz, 0), App.Vector(0, 0, 1), 5), False
        )
        c_x = sk.addConstraint(Sketcher.Constraint("DistanceX", g, 3, 0))
        c_y = sk.addConstraint(Sketcher.Constraint("DistanceY", g, 3, cz))
        sk.renameConstraint(c_x, "CenterX")
        sk.renameConstraint(c_y, "CenterY")
        sk.setExpression("Constraints.CenterX", sketch_x)
        sk.setExpression("Constraints.CenterY", z_expr)
        doc.recompute()
        print(name + "Sketch", sk.FullyConstrained, sk.getStatusString())

        hole = body.newObject("PartDesign::Hole", name)
        hole.Profile = sk
        hole.Threaded = True
        hole.ThreadType = "BSP"
        hole.ThreadSize = "1/2"
        hole.ModelThread = True
        hole.Tapered = False
        hole.DepthType = "Dimension"
        hole.DrillPoint = "Flat"
        hole.setExpression("Depth", "Params.WallThickness + Params.ThreadBossLength")
        last = hole
        body.Tip = hole
        doc.recompute()
        print(name, hole.getStatusString(), "dia", float(hole.Diameter))
        if hole.getStatusString() != "Valid":
            hole.Reversed = True
            doc.recompute()
            print(name, hole.getStatusString(), "rev", hole.Reversed)
    last.Refine = True
    body.Tip = last
    doc.recompute()
    return last


def build_plate(body, prefix, with_holes):
    plate = add_plate_sketch(body, prefix + "SketchPlate")
    pad = body.newObject("PartDesign::Pad", prefix + "Pad")
    pad.Profile = plate
    pad.setExpression("Length", "Params.Thickness / 2")
    doc.recompute()
    print(prefix + "Pad", pad.getStatusString())
    add_geom_fillet(
        body,
        prefix + "Fillet",
        pad,
        "Params.Fillet",
        "vertical",
        "Params.Thickness / 2",
    )
    if with_holes:
        add_boss_and_holes(body, plate)
    add_geom_fillet(
        body,
        prefix + "FilletThin",
        body.Tip,
        "Params.EdgeFillet",
        "plate_top",
        skip_boss=bool(with_holes),
    )
    add_corner_holes(body, prefix)
    add_geom_fillet(
        body,
        prefix + "FilletCornerHoles",
        body.Tip,
        "Params.EdgeFillet",
        "corner_holes",
    )
    return body.Tip


def circle_union_area(n, radius, pitch):
    """Union area of n equal circles in a line. Neighbour overlap only."""
    if n <= 0 or radius <= 0:
        return 0.0
    one = math.pi * radius * radius
    if n == 1 or pitch >= 2.0 * radius:
        return n * one
    d = pitch
    inter = (
        2.0 * radius * radius * math.acos(d / (2.0 * radius))
        - 0.5 * d * math.sqrt(4.0 * radius * radius - d * d)
    )
    return n * one - (n - 1) * inter


_install_geom_fillet()
doc = App.newDocument("DrillBoxInner")

params = doc.addObject("App::VarSet", "Params")
params.Label = "Params"

# Do not name the count property N: in FreeCAD expressions N is the newton unit.
params.addProperty("App::PropertyInteger", "Count", "Holes", "Количество окружностей")
params.Count = 2
params.addProperty("App::PropertyLength", "Diameter", "Holes", "Диаметр окружности")
params.Diameter = "76 mm"
params.addProperty(
    "App::PropertyLength",
    "Rim",
    "Holes",
    "Насколько радиус площадки полной толщины больше радиуса отверстия",
)
params.Rim = "10 mm"
params.addProperty(
    "App::PropertyLength",
    "Offset",
    "Holes",
    "Расстояние между центрами соседних окружностей",
)
params.Offset = "71 mm"
params.addProperty(
    "App::PropertyLength",
    "Margin",
    "Plate",
    "Отступ от крайней окружности до края пластины",
)
params.Margin = "20 mm"
params.addProperty("App::PropertyLength", "Thickness", "Plate", "Толщина пластины")
params.Thickness = "10 mm"
params.addProperty(
    "App::PropertyLength",
    "Fillet",
    "Plate",
    "Радиус скругления вертикальных углов пластины",
)
params.Fillet = "6 mm"
params.addProperty(
    "App::PropertyLength",
    "EdgeFillet",
    "Plate",
    "Радиус скругления верхних рёбер тонкой части (Thickness/2)",
)
params.EdgeFillet = "2 mm"
params.addProperty(
    "App::PropertyLength",
    "CornerInset",
    "Plate",
    "Отступ от края пластины до центра углового отверстия (одинаковый по X и Y)",
)
params.CornerInset = "1 cm"
params.addProperty(
    "App::PropertyLength",
    "CornerHoleDiameter",
    "Plate",
    "Диаметр угловых отверстий под шуруп",
)
params.CornerHoleDiameter = "5 mm"
params.addProperty(
    "App::PropertyLength",
    "WallHeight",
    "Cover",
    "Высота стенок waterCover",
)
params.WallHeight = "5 cm"
params.addProperty(
    "App::PropertyLength",
    "WallThickness",
    "Cover",
    "Толщина стенок waterCover",
)
params.WallThickness = "3 mm"
params.addProperty(
    "App::PropertyLength",
    "WallInset",
    "Cover",
    "Отступ стенок от края пластины: начинается там, где заканчивается скругление верхнего ребра",
)
params.WallInset = "2 mm"
params.setExpression("WallInset", "EdgeFillet")
params.addProperty(
    "App::PropertyLength",
    "WallWrapClearance",
    "Cover",
    "Зазор от отверстия до огибающей стенки; равен зазору до края пластины",
)
params.WallWrapClearance = "7.5 mm"
params.setExpression("WallWrapClearance", "CornerInset - CornerHoleDiameter / 2")
params.addProperty(
    "App::PropertyLength",
    "WallHoleDiameter",
    "Cover",
    "Диаметр сверления под резьбу G 1/2 в стенках waterCover",
)
params.WallHoleDiameter = "19 mm"
params.addProperty(
    "App::PropertyLength",
    "ThreadBossLength",
    "Cover",
    "Длина бобышки под резьбу G 1/2 снаружи стенки",
)
params.ThreadBossLength = "8 mm"
params.addProperty(
    "App::PropertyLength",
    "ThreadBossDiameter",
    "Cover",
    "Диаметр бобышки под резьбу G 1/2",
)
params.ThreadBossDiameter = "32 mm"
params.addProperty("App::PropertyLength", "Width", "Plate", "Ширина (считается)")
params.addProperty("App::PropertyLength", "Height", "Plate", "Высота (считается)")
params.setExpression("Width", "2 * Margin + Diameter + (Count - 1) * Offset")
params.setExpression("Height", "2 * Margin + Diameter")
doc.recompute()

drill = doc.addObject("PartDesign::Body", "drillTemplate")
drill.Label = "drillTemplate"
doc.recompute()
build_plate(drill, "", with_holes=True)

cover = doc.addObject("PartDesign::Body", "waterCover")
cover.Label = "waterCover"
doc.recompute()
build_plate(cover, "WC", with_holes=False)
add_cover_walls(cover, "WC")
cover.setExpression("Placement.Base.x", "Params.Width + Params.Margin")
doc.recompute()

r = float(params.Diameter) / 2.0
rim = float(params.Rim)
fr = float(params.Fillet)
half_th = float(params.Thickness) / 2.0
corner = (1.0 - math.pi / 4.0) * fr * fr
thin_area = float(params.Width) * float(params.Height) - 4.0 * corner
boss_area = circle_union_area(params.Count, r + rim, float(params.Offset))
hole_area = circle_union_area(params.Count, r, float(params.Offset))
expected = half_th * (thin_area + boss_area) - float(params.Thickness) * hole_area
print("Width", float(params.Width), "Height", float(params.Height))
print(
    "drillTemplate",
    drill.getStatusString(),
    "vol",
    None if drill.Shape.isNull() else drill.Shape.Volume,
    "expected",
    expected,
)

print(
    "waterCover",
    cover.getStatusString(),
    "vol",
    None if cover.Shape.isNull() else cover.Shape.Volume,
)

for obj in doc.Objects:
    obj.Visibility = False
for part in (drill, cover):
    part.Visibility = True
    part.Tip.Visibility = False
    try:
        part.Origin.Visibility = False
    except Exception:
        pass

BODY_NAMES = ("drillTemplate", "waterCover")


def _vp(name, visible, expanded=False, extra="", with_extensions=False):
    vis = "true" if visible else "false"
    exp = "1" if expanded else "0"
    extras = extra.strip()
    props = [
        """                <Property name="ShowInTree" type="App::PropertyBool" status="1">
                    <Bool value="true"/>
                </Property>""",
        f"""                <Property name="Visibility" type="App::PropertyBool" status="1">
                    <Bool value="{vis}"/>
                </Property>""",
    ]
    if extras:
        props.append("                " + extras)
    count = sum(p.count("<Property ") for p in props)
    ext_attr = ' Extensions="True"' if with_extensions else ""
    ext_block = (
        """            <Extensions Count="2">
                <Extension type="Gui::ViewProviderOriginGroupExtension" name="ViewProviderOriginGroupExtension"></Extension>
                <Extension type="Gui::ViewProviderFaceTexture" name="ViewProviderFaceTexture"></Extension>
            </Extensions>
"""
        if with_extensions
        else ""
    )
    return (
        f'        <ViewProvider name="{name}" expanded="{exp}"{ext_attr}>\n'
        + ext_block
        + f'            <Properties Count="{count}" TransientCount="0">\n'
        + "\n".join(props)
        + "\n            </Properties>\n        </ViewProvider>"
    )


body_extra = """<Property name="DisplayModeBody" type="App::PropertyEnumeration" status="1">
                    <Integer value="1"/>
                </Property>
                <Property name="Transparency" type="App::PropertyPercent" status="1">
                    <Integer value="0"/>
                </Property>"""
vp_blocks = []
for obj in doc.Objects:
    if obj.Name in BODY_NAMES:
        vp_blocks.append(
            _vp(obj.Name, True, expanded=True, extra=body_extra, with_extensions=True)
        )
    else:
        vp_blocks.append(_vp(obj.Name, False))

cam_x = (float(params.Width) + float(params.Margin)) / 2.0
cam_h = max(2.0 * float(params.Width) + float(params.Margin), float(params.Height)) * 1.2

_gui = f"""<?xml version="1.0" encoding="utf-8"?>
<Document SchemaVersion="1" HasExpansion="1">
    <Expand count="2">
        <Expand name="drillTemplate" count="0"></Expand>
        <Expand name="waterCover" count="0"></Expand>
    </Expand>
    <ViewProviderData Count="{len(vp_blocks)}">
{chr(10).join(vp_blocks)}
    </ViewProviderData>
    <Camera settings="OrthographicCamera {{ viewportMapping ADJUST_CAMERA position {cam_x:.3f} 0 {cam_h:.3f} orientation 0 0 1  0 nearDistance 1 farDistance {4 * cam_h:.3f} aspectRatio 1 focalDistance {cam_h:.3f} height {cam_h:.3f} }}"/>
</Document>
"""

doc.saveAs(OUT)
print("Saved", OUT, "tips", drill.Tip.Name, cover.Tip.Name)
App.closeDocument(doc.Name)
_tmp = OUT + ".tmp"
with zipfile.ZipFile(OUT, "r") as zin, zipfile.ZipFile(_tmp, "w") as zout:
    for item in zin.infolist():
        if item.filename != "GuiDocument.xml":
            zout.writestr(item, zin.read(item.filename))
    zout.writestr(
        "GuiDocument.xml",
        _gui.encode("utf-8"),
        compress_type=zipfile.ZIP_DEFLATED,
    )
os.replace(_tmp, OUT)
print("GuiDocument.xml attached")
