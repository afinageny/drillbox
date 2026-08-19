# -*- coding: utf-8 -*-
# FreeCAD 1.1: parametric drillTemplate plate with N holes along the center
# and four wall-mount lugs, plus a matching waterCover (no big holes,
# uniform Thickness/2) placed beside it.
# Around each drillTemplate hole the plate is Thickness; outside a rim it is Thickness/2.
# Four small recessed crosses sit between each mount slot and the big holes
# on drillTemplate. waterCover is a matching frame (inner rectangle cut
# along the center-facing edges of those crosses) with the same lugs
# and walls of height WallHeight along the inner window, with a top
# frame of width FrameWidth whose outer contour matches the walls.
# Two G 1/2 (BSPP) wall holes sit in opposite +X and -Y walls, offset toward far corners.
# Two hoseFitting bodies (G 1/2, barb 19/22 mm) stand beside the cover, thread down.
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

OUT = r"C:\Users\vofka\dev\freecad\drillbox\rect-n-holes.FCStd"

# ISO 228 G 1/2 (BSPP). Pitch 14 TPI. Tap drill 19 mm.
G12_PITCH = 1.814
G12_MAJOR = 20.955
G12_MINOR = 18.631
COVER_X = "Params.Width + 4 * Params.MountWidth + Params.Margin"
FITTING_HEX_H = 7.0
FITTING_TOOTH = 4.5


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


def add_ear(body, name, along_edge_x, sign):
    """Rectangular lug outside the plate. Size (L+2W) x 2W, W = MountWidth."""
    ear = body.newObject("PartDesign::AdditiveBox", name)
    ear.setExpression("Height", "Params.Thickness / 2")
    if along_edge_x:
        ear.setExpression("Length", "Params.MountLength + 2 * Params.MountWidth")
        ear.setExpression("Width", "2 * Params.MountWidth")
        ear.setExpression(
            "Placement.Base.x",
            "-(Params.MountLength + 2 * Params.MountWidth) / 2",
        )
        if sign > 0:
            ear.setExpression("Placement.Base.y", "Params.Height / 2")
        else:
            ear.setExpression(
                "Placement.Base.y",
                "-Params.Height / 2 - 2 * Params.MountWidth",
            )
    else:
        ear.setExpression("Length", "2 * Params.MountWidth")
        ear.setExpression("Width", "Params.MountLength + 2 * Params.MountWidth")
        if sign > 0:
            ear.setExpression("Placement.Base.x", "Params.Width / 2")
        else:
            ear.setExpression(
                "Placement.Base.x",
                "-Params.Width / 2 - 2 * Params.MountWidth",
            )
        ear.setExpression(
            "Placement.Base.y",
            "-(Params.MountLength + 2 * Params.MountWidth) / 2",
        )
    return ear


def add_slot_cut(body, name, x_expr, y_expr, along_x):
    """Stadium hole: inner box + two end cylinders. Radius = MountWidth/2."""
    half = "(Params.MountLength - Params.MountWidth) / 2"
    box = body.newObject("PartDesign::SubtractiveBox", name + "Box")
    box.setExpression("Height", "Params.Thickness / 2")
    if along_x:
        box.setExpression("Length", "Params.MountLength - Params.MountWidth")
        box.setExpression("Width", "Params.MountWidth")
        box.setExpression(
            "Placement.Base.x",
            x_expr + " - (Params.MountLength - Params.MountWidth) / 2",
        )
        box.setExpression("Placement.Base.y", y_expr + " - Params.MountWidth / 2")
    else:
        box.setExpression("Length", "Params.MountWidth")
        box.setExpression("Width", "Params.MountLength - Params.MountWidth")
        box.setExpression("Placement.Base.x", x_expr + " - Params.MountWidth / 2")
        box.setExpression(
            "Placement.Base.y",
            y_expr + " - (Params.MountLength - Params.MountWidth) / 2",
        )

    def add_cyl(suffix, px, py):
        cyl = body.newObject("PartDesign::SubtractiveCylinder", name + suffix)
        cyl.setExpression("Radius", "Params.MountWidth / 2")
        cyl.setExpression("Height", "Params.Thickness / 2")
        cyl.setExpression("Placement.Base.x", px)
        cyl.setExpression("Placement.Base.y", py)
        return cyl

    if along_x:
        add_cyl("CylA", x_expr + " - " + half, y_expr)
        last = add_cyl("CylB", x_expr + " + " + half, y_expr)
    else:
        add_cyl("CylA", x_expr, y_expr + " + " + half)
        last = add_cyl("CylB", x_expr, y_expr + " - " + half)
    last.Refine = True
    return last


def add_cross_cut(body, name, x_expr, y_expr):
    """Plus-shaped recess on the thin plate, cut down from the top face."""
    z_expr = "Params.Thickness / 2 - Params.MarkWidth"
    hbar = body.newObject("PartDesign::SubtractiveBox", name + "H")
    hbar.setExpression("Length", "2 * Params.EarMark")
    hbar.setExpression("Width", "Params.MarkWidth")
    hbar.setExpression("Height", "Params.MarkWidth")
    hbar.setExpression("Placement.Base.x", x_expr + " - Params.EarMark")
    hbar.setExpression("Placement.Base.y", y_expr + " - Params.MarkWidth / 2")
    hbar.setExpression("Placement.Base.z", z_expr)
    vbar = body.newObject("PartDesign::SubtractiveBox", name + "V")
    vbar.setExpression("Length", "Params.MarkWidth")
    vbar.setExpression("Width", "2 * Params.EarMark")
    vbar.setExpression("Height", "Params.MarkWidth")
    vbar.setExpression("Placement.Base.x", x_expr + " - Params.MarkWidth / 2")
    vbar.setExpression("Placement.Base.y", y_expr + " - Params.EarMark")
    vbar.setExpression("Placement.Base.z", z_expr)
    return vbar


def vertical_thickness_edges(shape, thickness, tol=1e-3):
    """Edge names of vertical outline edges (length = plate thickness)."""
    names = []
    for i, edge in enumerate(shape.Edges, start=1):
        if abs(edge.Length - thickness) > tol:
            continue
        verts = edge.Vertexes
        if len(verts) != 2:
            continue
        a, b = verts[0].Point, verts[1].Point
        if abs(a.x - b.x) < tol and abs(a.y - b.y) < tol and abs(a.z - b.z) > tol:
            names.append("Edge%d" % i)
    return names


def vertical_edges_near(shape, points, thickness, tol=1.0):
    """Vertical thickness edges whose XY is near one of the given (x, y) points."""
    names = []
    for i, edge in enumerate(shape.Edges, start=1):
        if abs(float(edge.Length) - thickness) > 1e-3:
            continue
        verts = edge.Vertexes
        if len(verts) != 2:
            continue
        a, b = verts[0].Point, verts[1].Point
        if abs(float(a.x) - float(b.x)) > 1e-3 or abs(float(a.y) - float(b.y)) > 1e-3:
            continue
        if any(
            abs(float(a.x) - px) < tol and abs(float(a.y) - py) < tol for px, py in points
        ):
            names.append("Edge%d" % i)
    return names


def horizontal_edges_at_z(shape, z, skip_radii=(), skip_near=(), near_dist=0.0, tol=1e-3):
    """Edge names in plane z = const. skip_near is a list of (x, y) points."""
    names = []
    skip = tuple(skip_radii)
    for i, edge in enumerate(shape.Edges, start=1):
        bb = edge.BoundBox
        if abs(bb.ZMin - z) > tol or abs(bb.ZMax - z) > tol:
            continue
        rad = getattr(getattr(edge, "Curve", None), "Radius", None)
        if rad is not None and any(abs(rad - r) < 0.2 for r in skip):
            continue
        if skip_near:
            mx = (bb.XMin + bb.XMax) / 2.0
            my = (bb.YMin + bb.YMax) / 2.0
            if any((mx - sx) ** 2 + (my - sy) ** 2 < near_dist * near_dist for sx, sy in skip_near):
                continue
        names.append("Edge%d" % i)
    return names


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


def add_four_ears(body, prefix):
    add_ear(body, prefix + "EarTop", True, 1)
    add_ear(body, prefix + "EarBot", True, -1)
    add_ear(body, prefix + "EarLeft", False, -1)
    last = add_ear(body, prefix + "EarRight", False, 1)
    last.Refine = True
    doc.recompute()
    return last


def fillet_vertical(body, name):
    return add_geom_fillet(
        body,
        name,
        body.Tip,
        "Params.Fillet",
        "vertical",
        "Params.Thickness / 2",
    )


def add_boss_and_holes(body, plate, prefix):
    r = float(params.Diameter) / 2.0
    cx = -((params.Count - 1) * float(params.Offset)) / 2.0
    boss_sec = add_boss_section(body, prefix + "SketchBossSection")
    print("boss section", boss_sec.getStatusString(), boss_sec.FullyConstrained)
    rev_boss = body.newObject("PartDesign::Revolution", prefix + "RevBoss")
    rev_boss.Profile = boss_sec
    rev_boss.ReferenceAxis = (boss_sec, ["V_Axis"])
    rev_boss.Angle = 360.0
    doc.recompute()
    print("rev boss", rev_boss.getStatusString())
    boss_pattern = body.newObject("PartDesign::LinearPattern", prefix + "LinearPatternBoss")
    boss_pattern.Originals = [rev_boss]
    boss_pattern.Direction = (plate, ["H_Axis"])
    boss_pattern.Mode = "Spacing"
    boss_pattern.setExpression("Offset", "Params.Offset")
    boss_pattern.setExpression("Occurrences", "Params.Count")
    boss_pattern.Refine = True
    body.Tip = boss_pattern
    doc.recompute()
    print("boss pattern", boss_pattern.getStatusString())
    holes = body.newObject("Sketcher::SketchObject", prefix + "SketchHole")
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
    pocket = body.newObject("PartDesign::Pocket", prefix + "Pocket")
    pocket.Profile = holes
    pocket.Type = "ThroughAll"
    pocket.Reversed = True
    doc.recompute()
    print("pocket", pocket.getStatusString())
    pattern = body.newObject("PartDesign::LinearPattern", prefix + "LinearPattern")
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


def add_four_mounts(body, prefix):
    top_y = "Params.Height / 2 + Params.MountWidth / 2"
    bot_y = "-(Params.Height / 2 + Params.MountWidth / 2)"
    left_x = "-(Params.Width / 2 + Params.MountWidth / 2)"
    right_x = "Params.Width / 2 + Params.MountWidth / 2"
    add_slot_cut(body, prefix + "MountTop", "0 mm", top_y, True)
    add_slot_cut(body, prefix + "MountBot", "0 mm", bot_y, True)
    add_slot_cut(body, prefix + "MountLeft", left_x, "0 mm", False)
    last = add_slot_cut(body, prefix + "MountRight", right_x, "0 mm", False)
    body.Tip = last
    doc.recompute()
    print(prefix + "mount", last.Name, last.getStatusString())
    return last


def fillet_slots_and_outline(body, last_slot, skip_boss, prefix):
    fillet_slots = add_geom_fillet(
        body,
        prefix + "FilletSlots",
        last_slot,
        "Params.EdgeFillet",
        "slots",
        skip_boss=bool(skip_boss),
    )
    fillet_base = fillet_slots if not fillet_slots.Shape.isNull() else last_slot
    fillet_top = add_geom_fillet(
        body,
        prefix + "FilletThin",
        fillet_base,
        "Params.EdgeFillet",
        "thin_top",
        skip_boss=bool(skip_boss),
    )
    mark_base = fillet_top if not fillet_top.Shape.isNull() else fillet_base
    body.Tip = mark_base
    return mark_base


# Cross centers sit midway between the inner ear fillet and the hole boss.
# waterCover window sides follow the center-facing edges of those crosses.
CROSS_TOP_Y = (
    "(Params.Height / 2 - Params.EdgeFillet + Params.Diameter / 2 + Params.Rim) / 2"
)
CROSS_RIGHT_X = (
    "(Params.Width / 2 - Params.EdgeFillet"
    " + (Params.Count - 1) * Params.Offset / 2"
    " + Params.Diameter / 2 + Params.Rim) / 2"
)
WINDOW_LEN = (
    "Params.Width / 2 - Params.EdgeFillet"
    " + (Params.Count - 1) * Params.Offset / 2"
    " + Params.Diameter / 2 + Params.Rim - 2 * Params.EarMark"
)
WINDOW_WID = (
    "Params.Height / 2 - Params.EdgeFillet"
    " + Params.Diameter / 2 + Params.Rim - 2 * Params.EarMark"
)


def add_four_crosses(body, prefix):
    add_cross_cut(body, prefix + "CrossTop", "0 mm", CROSS_TOP_Y)
    add_cross_cut(body, prefix + "CrossBot", "0 mm", "-" + CROSS_TOP_Y)
    add_cross_cut(body, prefix + "CrossLeft", "-" + CROSS_RIGHT_X, "0 mm")
    last = add_cross_cut(body, prefix + "CrossRight", CROSS_RIGHT_X, "0 mm")
    last.Refine = True
    body.Tip = last
    doc.recompute()
    print(prefix + "marks", last.Name, last.getStatusString())
    return last


def add_frame_window(body, prefix):
    """Through-cut rectangle. Sides follow the center-facing edges of the crosses."""
    win = body.newObject("PartDesign::SubtractiveBox", prefix + "Window")
    win.setExpression("Length", WINDOW_LEN)
    win.setExpression("Width", WINDOW_WID)
    win.setExpression("Height", "Params.Thickness / 2")
    win.setExpression("Placement.Base.x", "-(" + WINDOW_LEN + ") / 2")
    win.setExpression("Placement.Base.y", "-(" + WINDOW_WID + ") / 2")
    win.Refine = True
    body.Tip = win
    doc.recompute()
    print(prefix + "Window", win.getStatusString())
    fillet = add_geom_fillet(
        body, prefix + "FilletWindow", win, "Params.Fillet", "window"
    )
    return add_cover_walls(body, prefix)


def add_cover_walls(body, prefix):
    """Walls standing on the cover, following the inner window."""
    outer_len = "(" + WINDOW_LEN + ") + 2 * Params.WallThickness"
    outer_wid = "(" + WINDOW_WID + ") + 2 * Params.WallThickness"
    block = body.newObject("PartDesign::AdditiveBox", prefix + "WallBlock")
    block.setExpression("Length", outer_len)
    block.setExpression("Width", outer_wid)
    block.setExpression("Height", "Params.WallHeight")
    block.setExpression("Placement.Base.x", "-(" + outer_len + ") / 2")
    block.setExpression("Placement.Base.y", "-(" + outer_wid + ") / 2")
    block.setExpression("Placement.Base.z", "Params.Thickness / 2")
    block.Refine = True
    body.Tip = block
    doc.recompute()
    print(prefix + "WallBlock", block.getStatusString())

    fillet_out = add_geom_fillet(
        body, prefix + "FilletWallOuter", block, "Params.Fillet", "wall_outer"
    )

    cut = body.newObject("PartDesign::SubtractiveBox", prefix + "WallWindow")
    cut.setExpression("Length", WINDOW_LEN)
    cut.setExpression("Width", WINDOW_WID)
    cut.setExpression("Height", "Params.WallHeight")
    cut.setExpression("Placement.Base.x", "-(" + WINDOW_LEN + ") / 2")
    cut.setExpression("Placement.Base.y", "-(" + WINDOW_WID + ") / 2")
    cut.setExpression("Placement.Base.z", "Params.Thickness / 2")
    cut.Refine = True
    body.Tip = cut
    doc.recompute()
    print(prefix + "WallWindow", cut.getStatusString())

    fillet_in = add_geom_fillet(
        body, prefix + "FilletWallInner", cut, "Params.Fillet", "wall_inner"
    )
    return add_cover_frame(body, prefix)


def add_cover_frame(body, prefix):
    """Rim on top of the walls. Outer corners use Fillet; inner corners use Diameter/2."""
    outer_len = "(" + WINDOW_LEN + ") + 2 * Params.WallThickness"
    outer_wid = "(" + WINDOW_WID + ") + 2 * Params.WallThickness"
    inner_len = "(" + outer_len + ") - 2 * Params.FrameWidth"
    inner_wid = "(" + outer_wid + ") - 2 * Params.FrameWidth"
    z0 = "Params.Thickness / 2 + Params.WallHeight"

    block = body.newObject("PartDesign::AdditiveBox", prefix + "FrameBlock")
    block.setExpression("Length", outer_len)
    block.setExpression("Width", outer_wid)
    block.setExpression("Height", "Params.WallThickness")
    block.setExpression("Placement.Base.x", "-(" + outer_len + ") / 2")
    block.setExpression("Placement.Base.y", "-(" + outer_wid + ") / 2")
    block.setExpression("Placement.Base.z", z0)
    block.Refine = True
    body.Tip = block
    doc.recompute()
    print(prefix + "FrameBlock", block.getStatusString())

    fillet_out = add_geom_fillet(
        body, prefix + "FilletFrameOuter", block, "Params.Fillet", "frame_outer"
    )

    cut = body.newObject("PartDesign::SubtractiveBox", prefix + "FrameWindow")
    cut.setExpression("Length", inner_len)
    cut.setExpression("Width", inner_wid)
    cut.setExpression("Height", "Params.WallThickness")
    cut.setExpression("Placement.Base.x", "-(" + inner_len + ") / 2")
    cut.setExpression("Placement.Base.y", "-(" + inner_wid + ") / 2")
    cut.setExpression("Placement.Base.z", z0)
    cut.Refine = True
    body.Tip = cut
    doc.recompute()
    print(prefix + "FrameWindow", cut.getStatusString())

    fillet_in = add_geom_fillet(
        body,
        prefix + "FilletFrameInner",
        cut,
        "Params.Diameter / 2",
        "frame_inner",
    )
    return add_cover_wall_holes(body, prefix)


def add_cover_wall_holes(body, prefix):
    """G 1/2 BSPP holes with outer bosses, mid-height, halfway to the far edges."""
    z_expr = "Params.Thickness / 2 + Params.WallHeight / 2"
    last = None
    # along_x: hole in +X wall (YZ plane). Else hole in -Y wall (XZ plane).
    specs = (
        (
            prefix + "HoleYZ",
            True,
            body.Origin.OriginFeatures[5],
            "(" + WINDOW_LEN + ") / 2 + Params.WallThickness + Params.ThreadBossLength",
            "Params.Height / 4",
            "(" + WINDOW_LEN + ") / 2 + Params.WallThickness",
            "Params.Height / 4",
        ),
        (
            prefix + "HoleXZ",
            False,
            body.Origin.OriginFeatures[4],
            "(" + WINDOW_WID + ") / 2 + Params.WallThickness + Params.ThreadBossLength",
            "-Params.Width / 4",
            "-(" + WINDOW_WID + ") / 2 - Params.WallThickness",
            "-Params.Width / 4",
        ),
    )
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
        cx = float(params.Height) / 4.0 if along_x else -float(params.Width) / 4.0
        cz = float(params.Thickness) / 2.0 + float(params.WallHeight) / 2.0
        g = sk.addGeometry(Part.Circle(App.Vector(cx, cz, 0), App.Vector(0, 0, 1), 5), False)
        c_x = sk.addConstraint(Sketcher.Constraint("DistanceX", g, 3, cx))
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
    last.Refine = True
    body.Tip = last
    doc.recompute()
    return last


def _add_closed_polyline(sk, pts):
    geos = []
    n = len(pts)
    for i in range(n):
        a = pts[i]
        b = pts[(i + 1) % n]
        geos.append(
            sk.addGeometry(
                Part.LineSegment(App.Vector(a[0], a[1], 0), App.Vector(b[0], b[1], 0)),
                False,
            )
        )
    sk.addConstraint(
        [Sketcher.Constraint("Coincident", geos[i], 2, geos[(i + 1) % n], 1) for i in range(n)]
    )
    return geos


def _barb_teeth(diameter, z0, n=3, step=FITTING_TOOTH):
    ridge = diameter / 2.0 + 0.7
    root = diameter / 2.0 - 0.9
    pts = [(root, z0)]
    z = z0
    for _ in range(n):
        pts.append((ridge, z + 1.1))
        z += step
        pts.append((root, z))
    return pts, z


def build_hose_fitting(body):
    """G 1/2 male fitting: thread -Z, hex at z=0, 22/19 mm barbs +Z."""
    thread_len = float(params.WallThickness) + float(params.ThreadBossLength)
    d22 = float(params.FittingBarb22)
    d19 = float(params.FittingBarb19)
    bore = float(params.FittingBore)
    af = float(params.FittingHex)

    hex_sk = body.newObject("Sketcher::SketchObject", "SketchHex")
    hex_sk.AttachmentSupport = [(body.Origin.OriginFeatures[3], "")]
    hex_sk.MapMode = "FlatFace"
    doc.recompute()
    rv = af / math.sqrt(3.0)
    hex_pts = []
    for i in range(6):
        ang = math.radians(30.0 + i * 60.0)
        hex_pts.append((rv * math.cos(ang), rv * math.sin(ang)))
    _add_closed_polyline(hex_sk, hex_pts)
    doc.recompute()
    hex_pad = body.newObject("PartDesign::Pad", "Hex")
    hex_pad.Profile = hex_sk
    hex_pad.Length = FITTING_HEX_H
    body.Tip = hex_pad
    doc.recompute()
    print(body.Name, "Hex", hex_pad.getStatusString())

    core = body.newObject("PartDesign::AdditiveCylinder", "ThreadCore")
    core.Radius = G12_MINOR / 2.0
    core.setExpression("Height", "Params.WallThickness + Params.ThreadBossLength")
    core.setExpression(
        "Placement.Base.z",
        "-(Params.WallThickness + Params.ThreadBossLength)",
    )
    body.Tip = core
    doc.recompute()
    print(body.Name, "ThreadCore", core.getStatusString())

    skt = body.newObject("Sketcher::SketchObject", "SketchThread")
    skt.AttachmentSupport = [(body.Origin.OriginFeatures[4], "")]
    skt.MapMode = "FlatFace"
    skt.setExpression(
        "AttachmentOffset.Base.y",
        "-(Params.WallThickness + Params.ThreadBossLength)",
    )
    doc.recompute()
    rin = G12_MINOR / 2.0
    rout = G12_MAJOR / 2.0
    hb = 0.38 * G12_PITCH
    _add_closed_polyline(
        skt,
        ((rin, hb), (rout, 0.0), (rin, -hb)),
    )
    doc.recompute()
    helix = body.newObject("PartDesign::AdditiveHelix", "Thread")
    helix.Profile = skt
    helix.ReferenceAxis = (body.Origin.OriginFeatures[2], "")
    helix.Mode = "pitch-height-angle"
    helix.Pitch = G12_PITCH
    helix.Angle = 0
    helix.setExpression("Height", "Params.WallThickness + Params.ThreadBossLength")
    body.Tip = helix
    doc.recompute()
    print(body.Name, "Thread", helix.getStatusString())

    z0 = FITTING_HEX_H + 1.5
    barb_pts = [(0.0, FITTING_HEX_H), (d22 / 2.0 - 0.4, FITTING_HEX_H)]
    t22, z = _barb_teeth(d22, z0)
    barb_pts.extend(t22)
    t19, z = _barb_teeth(d19, z + 0.6)
    barb_pts.extend(t19)
    barb_pts.append((bore / 2.0 + 0.6, z + 3.0))
    barb_pts.append((0.0, z + 3.0))
    skb = body.newObject("Sketcher::SketchObject", "SketchBarb")
    skb.AttachmentSupport = [(body.Origin.OriginFeatures[4], "")]
    skb.MapMode = "FlatFace"
    doc.recompute()
    _add_closed_polyline(skb, barb_pts)
    doc.recompute()
    barb = body.newObject("PartDesign::Revolution", "Barb")
    barb.Profile = skb
    barb.ReferenceAxis = (body.Origin.OriginFeatures[2], "")
    barb.Angle = 360
    body.Tip = barb
    doc.recompute()
    print(body.Name, "Barb", barb.getStatusString())

    hole = body.newObject("PartDesign::SubtractiveCylinder", "Bore")
    hole.setExpression("Radius", "Params.FittingBore / 2")
    hole.Height = thread_len + FITTING_HEX_H + 40.0
    hole.setExpression(
        "Placement.Base.z",
        "-(Params.WallThickness + Params.ThreadBossLength) - 1 mm",
    )
    hole.Refine = True
    body.Tip = hole
    doc.recompute()
    print(body.Name, "Bore", hole.getStatusString())
    return hole


def place_hose_fitting(body, slot):
    """Stand next to the cover: thread down onto z=0, barb up."""
    body.Placement.Rotation = App.Rotation()
    body.setExpression(
        "Placement.Base.z",
        "Params.WallThickness + Params.ThreadBossLength",
    )
    body.setExpression(
        "Placement.Base.x",
        COVER_X
        + " + Params.Width / 2 + 4 * Params.MountWidth + Params.Margin"
        + (" + 40 mm" if slot else ""),
    )
    body.setExpression("Placement.Base.y", "0 mm")


def build_part(body, prefix, with_holes, with_crosses=False, with_window=False):
    plate = add_plate_sketch(body, prefix + "SketchPlate")
    pad = body.newObject("PartDesign::Pad", prefix + "Pad")
    pad.Profile = plate
    pad.setExpression("Length", "Params.Thickness / 2")
    doc.recompute()
    print(prefix + "Pad", pad.getStatusString())
    add_four_ears(body, prefix)
    fillet_vertical(body, prefix + "Fillet")
    if with_holes:
        add_boss_and_holes(body, plate, prefix)
    last_slot = add_four_mounts(body, prefix)
    skip_boss = (float(params.Diameter) / 2.0 + float(params.Rim),) if with_holes else ()
    fillet_slots_and_outline(body, last_slot, skip_boss, prefix)
    if with_window:
        return add_frame_window(body, prefix)
    if with_crosses:
        return add_four_crosses(body, prefix)
    return body.Tip


_install_geom_fillet()
doc = App.newDocument("DrillBox")

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
    "Радиус скругления углов пластины и ушек",
)
params.Fillet = "6 mm"
params.addProperty("App::PropertyLength", "Width", "Plate", "Ширина (считается)")
params.addProperty("App::PropertyLength", "Height", "Plate", "Высота (считается)")
params.addProperty(
    "App::PropertyLength",
    "MountLength",
    "Mount",
    "Длина монтажного паза (вдоль края пластины)",
)
params.MountLength = "16 mm"
params.addProperty(
    "App::PropertyLength",
    "MountWidth",
    "Mount",
    "Ширина монтажного паза (узкая сторона, радиус = половина)",
)
params.MountWidth = "8 mm"
params.addProperty(
    "App::PropertyLength",
    "EdgeFillet",
    "Mount",
    "Радиус скругления верхних рёбер тонкой части (Thickness/2) и пазов в ушках",
)
params.EdgeFillet = "2 mm"
params.addProperty(
    "App::PropertyLength",
    "EarMark",
    "Mount",
    "Половина длины луча креста-метки (от центра до конца)",
)
params.EarMark = "2 mm"
params.addProperty(
    "App::PropertyLength",
    "MarkWidth",
    "Mount",
    "Ширина и глубина канавки креста-метки",
)
params.MarkWidth = "0.8 mm"
params.addProperty(
    "App::PropertyLength",
    "WallHeight",
    "Cover",
    "Высота стенок waterCover вдоль внутреннего окна",
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
    "FrameWidth",
    "Cover",
    "Ширина рамки поверх стенок waterCover",
)
params.FrameWidth = "10 mm"
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
params.addProperty(
    "App::PropertyLength",
    "FittingBarb22",
    "Fitting",
    "Большая ступень ёлки штуцера (шланг 22 мм)",
)
params.FittingBarb22 = "22 mm"
params.addProperty(
    "App::PropertyLength",
    "FittingBarb19",
    "Fitting",
    "Малая ступень ёлки штуцера (шланг 19 мм)",
)
params.FittingBarb19 = "19 mm"
params.addProperty(
    "App::PropertyLength",
    "FittingBore",
    "Fitting",
    "Внутренний канал штуцера",
)
params.FittingBore = "12 mm"
params.addProperty(
    "App::PropertyLength",
    "FittingHex",
    "Fitting",
    "Размер под ключ шестигранника штуцера",
)
params.FittingHex = "24 mm"
params.setExpression("Width", "2 * Margin + Diameter + (Count - 1) * Offset")
params.setExpression("Height", "2 * Margin + Diameter")
doc.recompute()

drill = doc.addObject("PartDesign::Body", "drillTemplate")
drill.Label = "drillTemplate"
doc.recompute()
build_part(drill, "", with_holes=True, with_crosses=True)

cover = doc.addObject("PartDesign::Body", "waterCover")
cover.Label = "waterCover"
doc.recompute()
build_part(cover, "WC", with_holes=False, with_window=True)
cover.setExpression(
    "Placement.Base.x",
    COVER_X,
)
doc.recompute()

fit_yz = doc.addObject("PartDesign::Body", "hoseFittingYZ")
fit_yz.Label = "штуцер 1"
doc.recompute()
build_hose_fitting(fit_yz)
place_hose_fitting(fit_yz, slot=0)
doc.recompute()

fit_xz = doc.addObject("PartDesign::Body", "hoseFittingXZ")
fit_xz.Label = "штуцер 2"
doc.recompute()
build_hose_fitting(fit_xz)
place_hose_fitting(fit_xz, slot=1)
doc.recompute()

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


r = float(params.Diameter) / 2.0
rim = float(params.Rim)
ml = float(params.MountLength)
mw = float(params.MountWidth)
fr = float(params.Fillet)
half_th = float(params.Thickness) / 2.0
slot_area = (ml - mw) * mw + math.pi * (mw / 2.0) ** 2
ear_area = (ml + 2.0 * mw) * (2.0 * mw)
corner = (1.0 - math.pi / 4.0) * fr * fr
thin_area = (
    float(params.Width) * float(params.Height) + 4.0 * ear_area - 4.0 * corner
)
boss_area = circle_union_area(params.Count, r + rim, float(params.Offset))
hole_area = circle_union_area(params.Count, r, float(params.Offset))
expected = (
    half_th * (thin_area + boss_area - 4.0 * slot_area)
    - float(params.Thickness) * hole_area
)
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
    "hoseFittingYZ",
    fit_yz.getStatusString(),
    "vol",
    None if fit_yz.Shape.isNull() else fit_yz.Shape.Volume,
)
print(
    "hoseFittingXZ",
    fit_xz.getStatusString(),
    "vol",
    None if fit_xz.Shape.isNull() else fit_xz.Shape.Volume,
)

# App-level visibility: each Body in Tip mode shows its final solid.
# Other features stay hidden — Part Design allows only one visible shape
# in a Body, so extra visibilities fight and everything can end up off.
BODY_NAMES = ("drillTemplate", "waterCover", "hoseFittingYZ", "hoseFittingXZ")
for obj in doc.Objects:
    obj.Visibility = False
for part in (drill, cover, fit_yz, fit_xz):
    part.Visibility = True
    part.Tip.Visibility = False
    try:
        part.Origin.Visibility = False
    except Exception:
        pass

visible_names = set(BODY_NAMES)

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
        vp_blocks.append(_vp(obj.Name, obj.Name in visible_names))

hx = float(params.Width) + 4.0 * float(params.MountWidth)
hy = float(params.Height) + 4.0 * float(params.MountWidth)
gap = float(params.Margin)
fit_right = (
    hx
    + gap
    + float(params.Width) / 2.0
    + 4.0 * float(params.MountWidth)
    + gap
    + 40.0
    + float(params.FittingHex)
)
cam_x = fit_right / 2.0
cam_h = max(fit_right, hy) * 1.2

_gui = f"""<?xml version="1.0" encoding="utf-8"?>
<Document SchemaVersion="1" HasExpansion="1">
    <Expand count="4">
        <Expand name="drillTemplate" count="0"></Expand>
        <Expand name="waterCover" count="0"></Expand>
        <Expand name="hoseFittingYZ" count="0"></Expand>
        <Expand name="hoseFittingXZ" count="0"></Expand>
    </Expand>
    <ViewProviderData Count="{len(vp_blocks)}">
{chr(10).join(vp_blocks)}
    </ViewProviderData>
    <Camera settings="OrthographicCamera {{ viewportMapping ADJUST_CAMERA position {cam_x:.3f} 0 {cam_h:.3f} orientation 0 0 1  0 nearDistance 1 farDistance {4 * cam_h:.3f} aspectRatio 1 focalDistance {cam_h:.3f} height {cam_h:.3f} }}"/>
</Document>
"""

doc.saveAs(OUT)
print("Saved", OUT, "tips", drill.Tip.Name, cover.Tip.Name, fit_yz.Tip.Name, fit_xz.Tip.Name)
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
