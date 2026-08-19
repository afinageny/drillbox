# -*- coding: utf-8 -*-
# Parametric fillet for PartDesign: picks edges by geometry on every recompute
# so Count/Width changes do not leave stale EdgeN links.


def _f(val):
    return float(val)


def _window_len(p):
    return (
        _f(p.Width) / 2.0
        - _f(p.EdgeFillet)
        + (p.Count - 1) * _f(p.Offset) / 2.0
        + _f(p.Diameter) / 2.0
        + _f(p.Rim)
        - 2.0 * _f(p.EarMark)
    )


def _window_wid(p):
    return (
        _f(p.Height) / 2.0
        - _f(p.EdgeFillet)
        + _f(p.Diameter) / 2.0
        + _f(p.Rim)
        - 2.0 * _f(p.EarMark)
    )


def _is_vertical(edge, tol=1e-3):
    verts = edge.Vertexes
    if len(verts) != 2:
        return False
    a, b = verts[0].Point, verts[1].Point
    return abs(_f(a.x) - _f(b.x)) < tol and abs(_f(a.y) - _f(b.y)) < tol and abs(_f(a.z) - _f(b.z)) > tol


def _vertical_of_length(shape, length, tol=1e-3):
    edges = []
    for edge in shape.Edges:
        if abs(_f(edge.Length) - length) > tol:
            continue
        if _is_vertical(edge, tol):
            edges.append(edge)
    return edges


def _vertical_near(shape, points, length, xy_tol=1.0):
    edges = []
    for edge in shape.Edges:
        if abs(_f(edge.Length) - length) > 1e-3:
            continue
        if not _is_vertical(edge):
            continue
        a = edge.Vertexes[0].Point
        if any(abs(_f(a.x) - px) < xy_tol and abs(_f(a.y) - py) < xy_tol for px, py in points):
            edges.append(edge)
    return edges


def _corners(hx, hy):
    return ((hx, hy), (hx, -hy), (-hx, hy), (-hx, -hy))


def _mid(edge):
    bb = edge.BoundBox
    return (bb.XMin + bb.XMax) / 2.0, (bb.YMin + bb.YMax) / 2.0


def _slot_and_thin_edges(shape, p, skip_boss_radius, want_slots):
    th = _f(p.Thickness)
    hh = _f(p.Height) / 2.0
    hw = _f(p.Width) / 2.0
    mw = _f(p.MountWidth)
    ef = _f(p.EdgeFillet)
    slot_off = mw / 2.0
    slot_centers = (
        (0.0, hh + slot_off),
        (0.0, -(hh + slot_off)),
        (-(hw + slot_off), 0.0),
        (hw + slot_off, 0.0),
    )
    ztop = th / 2.0
    skip_r = skip_boss_radius if skip_boss_radius else 0.0

    def near_slot(edge, dist):
        mx, my = _mid(edge)
        return any((mx - sx) ** 2 + (my - sy) ** 2 < dist * dist for sx, sy in slot_centers)

    picked = []
    for edge in shape.Edges:
        bb = edge.BoundBox
        if abs(bb.ZMin - ztop) > 1e-3 or abs(bb.ZMax - ztop) > 1e-3:
            continue
        rad = getattr(getattr(edge, "Curve", None), "Radius", None)
        if rad is not None and skip_r and abs(rad - skip_r) < 0.2:
            continue
        if want_slots:
            if rad is not None and abs(rad - mw / 2.0) < 0.2:
                picked.append(edge)
            elif near_slot(edge, mw / 2.0 + 0.5):
                picked.append(edge)
        else:
            if edge.Length < 1.0:
                continue
            if rad is not None and abs(rad - mw / 2.0) < 0.2:
                continue
            if near_slot(edge, mw / 2.0 + ef + 0.2):
                continue
            picked.append(edge)
    return picked


def _select_edges(shape, obj, p):
    mode = obj.Mode
    if mode == "vertical":
        return _vertical_of_length(shape, _f(obj.EdgeLength))
    if mode == "window":
        hx = _window_len(p) / 2.0
        hy = _window_wid(p) / 2.0
        return _vertical_near(shape, _corners(hx, hy), _f(p.Thickness) / 2.0)
    if mode == "wall_outer":
        t = _f(p.WallThickness)
        hx = _window_len(p) / 2.0 + t
        hy = _window_wid(p) / 2.0 + t
        return _vertical_near(shape, _corners(hx, hy), _f(p.WallHeight))
    if mode == "wall_inner":
        hx = _window_len(p) / 2.0
        hy = _window_wid(p) / 2.0
        return _vertical_near(shape, _corners(hx, hy), _f(p.WallHeight))
    if mode == "frame_outer":
        t = _f(p.WallThickness)
        hx = _window_len(p) / 2.0 + t
        hy = _window_wid(p) / 2.0 + t
        return _vertical_near(shape, _corners(hx, hy), t)
    if mode == "frame_inner":
        t = _f(p.WallThickness)
        fw = _f(p.FrameWidth)
        hx = _window_len(p) / 2.0 + t - fw
        hy = _window_wid(p) / 2.0 + t - fw
        return _vertical_near(shape, _corners(hx, hy), t)
    skip = _f(obj.SkipBossRadius) if getattr(obj, "HasSkipBoss", False) else 0.0
    if mode == "slots":
        return _slot_and_thin_edges(shape, p, skip, True)
    if mode == "thin_top":
        return _slot_and_thin_edges(shape, p, skip, False)
    return []


def _apply_fillet(shape, radius, edges):
    if not edges or radius <= 0:
        return shape
    try:
        return shape.makeFillet(radius, edges)
    except Exception:
        result = shape
        for edge in edges:
            try:
                result = result.makeFillet(radius, [edge])
            except Exception:
                continue
        return result


class GeomFillet:
    def __init__(self, obj):
        obj.addProperty("App::PropertyLink", "Source", "Fillet", "Feature whose solid is filleted")
        obj.addProperty("App::PropertyLength", "Radius", "Fillet", "Fillet radius")
        obj.addProperty("App::PropertyString", "Mode", "Fillet", "Edge selection rule")
        obj.addProperty("App::PropertyLength", "EdgeLength", "Fillet", "Vertical edge length for Mode=vertical")
        obj.addProperty("App::PropertyLength", "SkipBossRadius", "Fillet", "Skip circular edges of this radius")
        obj.addProperty("App::PropertyBool", "HasSkipBoss", "Fillet", "Whether SkipBossRadius is used")
        obj.Mode = "vertical"
        obj.HasSkipBoss = False
        obj.Proxy = self

    def execute(self, obj):
        if obj.Source is None or obj.Source.Shape.isNull():
            return
        p = obj.Document.getObject("Params")
        edges = _select_edges(obj.Source.Shape, obj, p)
        obj.Shape = _apply_fillet(obj.Source.Shape, _f(obj.Radius), edges)

    def onDocumentRestored(self, obj):
        obj.Proxy = self

    def __getstate__(self):
        return None

    def __setstate__(self, state):
        return None
