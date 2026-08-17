# -*- coding: utf-8 -*-
# FreeCAD 1.1: parametric plate with N holes along the center
# and four wall-mount slots (stadium = box + two cylinders).
# Parameters live on the Params VarSet. Change them, then recompute.

import math
import os
import zipfile
import FreeCAD as App
import Part
import Sketcher

OUT = r"C:\Users\vofka\dev\freecad\drillbox\rect-n-holes.FCStd"


def add_slot_cut(body, name, x_expr, y_expr, along_x):
    """Stadium hole: inner box + two end cylinders. Radius = MountWidth/2."""
    half = "(Params.MountLength - Params.MountWidth) / 2"
    box = body.newObject("PartDesign::SubtractiveBox", name + "Box")
    box.setExpression("Height", "Params.Thickness")
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
        cyl.setExpression("Height", "Params.Thickness")
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


doc = App.newDocument("RectNHoles")

params = doc.addObject("App::VarSet", "Params")
params.Label = "Params"

# Do not name the count property N: in FreeCAD expressions N is the newton unit.
params.addProperty("App::PropertyInteger", "Count", "Holes", "Количество окружностей")
params.Count = 2
params.addProperty("App::PropertyLength", "Diameter", "Holes", "Диаметр окружности")
params.Diameter = "76 mm"
params.addProperty(
    "App::PropertyLength",
    "Offset",
    "Holes",
    "Расстояние между центрами соседних окружностей",
)
params.Offset = "71 mm"
params.addProperty(
    "App::PropertyLength",
    "MarginX",
    "Plate",
    "Отступ по горизонтали от крайней окружности до края",
)
params.MarginX = "20 mm"
params.addProperty(
    "App::PropertyLength",
    "MarginY",
    "Plate",
    "Отступ по вертикали от окружности до края",
)
params.MarginY = "20 mm"
params.addProperty("App::PropertyLength", "Thickness", "Plate", "Толщина пластины")
params.Thickness = "10 mm"
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
params.setExpression("Width", "2 * MarginX + Diameter + (Count - 1) * Offset")
params.setExpression("Height", "2 * MarginY + Diameter")
doc.recompute()

body = doc.addObject("PartDesign::Body", "Body")
doc.recompute()

plate = body.newObject("Sketcher::SketchObject", "SketchPlate")

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
print("plate constrained", plate.FullyConstrained, "status", plate.getStatusString())

pad = body.newObject("PartDesign::Pad", "Pad")
pad.Profile = plate
pad.setExpression("Length", "Params.Thickness")
doc.recompute()
print("pad", pad.getStatusString(), "vol", pad.Shape.Volume if not pad.Shape.isNull() else None)

holes = body.newObject("Sketcher::SketchObject", "SketchHole")

r = float(params.Diameter) / 2.0
cx = -((params.Count - 1) * float(params.Offset)) / 2.0
holes.addGeometry(Part.Circle(App.Vector(cx, 0, 0), App.Vector(0, 0, 1), r), False)
c_r = holes.addConstraint(Sketcher.Constraint("Radius", 0, r))
c_x = holes.addConstraint(Sketcher.Constraint("DistanceX", 0, 3, cx))
holes.addConstraint(Sketcher.Constraint("PointOnObject", 0, 3, -1))
holes.renameConstraint(c_r, "Radius")
holes.renameConstraint(c_x, "CenterX")
holes.setExpression("Constraints.Radius", "Params.Diameter / 2")
holes.setExpression("Constraints.CenterX", "-(Params.Count - 1) * Params.Offset / 2")
doc.recompute()
print("hole constrained", holes.FullyConstrained, "status", holes.getStatusString())

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
print("pattern", pattern.getStatusString(), "vol", pattern.Shape.Volume)

top_y = "Params.Height / 2 - Params.MarginY / 2"
bot_y = "-(Params.Height / 2 - Params.MarginY / 2)"
left_x = "-(Params.Width / 2 - Params.MarginX / 2)"
right_x = "Params.Width / 2 - Params.MarginX / 2"

add_slot_cut(body, "MountTop", "0 mm", top_y, True)
add_slot_cut(body, "MountBot", "0 mm", bot_y, True)
add_slot_cut(body, "MountLeft", left_x, "0 mm", False)
last = add_slot_cut(body, "MountRight", right_x, "0 mm", False)
body.Tip = last
doc.recompute()
print("mount tip", body.Tip.Name, body.Tip.getStatusString())

ml = float(params.MountLength)
mw = float(params.MountWidth)
slot_area = (ml - mw) * mw + math.pi * (mw / 2.0) ** 2
expected = float(params.Thickness) * (
    float(params.Width) * float(params.Height)
    - params.Count * math.pi * r * r
    - 4.0 * slot_area
)
print("Width", float(params.Width), "Height", float(params.Height))
if not body.Shape.isNull():
    print("Volume", body.Shape.Volume, "Expected", expected)
    print("faces", len(body.Shape.Faces))
else:
    print("Body shape is null")

# App-level visibility: only the body/tip should show when the file is opened.
plate.Visibility = False
holes.Visibility = False
for obj in doc.Objects:
    name = obj.Name
    if name in ("Body", params.Name) or obj is body.Tip:
        obj.Visibility = True
    elif name.startswith("Sketch") or "Axis" in name or "Plane" in name or name.startswith("Origin"):
        obj.Visibility = False
    elif obj is not body and obj is not params:
        obj.Visibility = False
body.Visibility = True
body.Tip.Visibility = True
try:
    body.Origin.Visibility = False
except Exception:
    pass

doc.saveAs(OUT)
print("Saved", OUT)
App.closeDocument(doc.Name)

# FreeCADCmd does not write GuiDocument.xml, so the body would open hidden in the GUI.
_gui = """<?xml version="1.0" encoding="utf-8"?>
<Document SchemaVersion="1" HasExpansion="1">
    <Expand count="1">
        <Expand name="Body" count="0"></Expand>
    </Expand>
    <ViewProviderData Count="2">
        <ViewProvider name="Body" expanded="1" Extensions="True">
            <Extensions Count="2">
                <Extension type="Gui::ViewProviderOriginGroupExtension" name="ViewProviderOriginGroupExtension"></Extension>
                <Extension type="Gui::ViewProviderFaceTexture" name="ViewProviderFaceTexture"></Extension>
            </Extensions>
            <Properties Count="4" TransientCount="0">
                <Property name="DisplayModeBody" type="App::PropertyEnumeration" status="1">
                    <Integer value="0"/>
                </Property>
                <Property name="ShowInTree" type="App::PropertyBool" status="1">
                    <Bool value="true"/>
                </Property>
                <Property name="Transparency" type="App::PropertyPercent" status="1">
                    <Integer value="0"/>
                </Property>
                <Property name="Visibility" type="App::PropertyBool" status="1">
                    <Bool value="true"/>
                </Property>
            </Properties>
        </ViewProvider>
        <ViewProvider name="MountRightCylB" expanded="0" Extensions="True">
            <Properties Count="2" TransientCount="0">
                <Property name="ShowInTree" type="App::PropertyBool" status="1">
                    <Bool value="true"/>
                </Property>
                <Property name="Visibility" type="App::PropertyBool" status="1">
                    <Bool value="true"/>
                </Property>
            </Properties>
        </ViewProvider>
    </ViewProviderData>
    <Camera settings="OrthographicCamera { viewportMapping ADJUST_CAMERA position 0 -220 260 orientation 0.353553 0.146447 0.353553  1.2870022 nearDistance 50 farDistance 800 aspectRatio 1 focalDistance 340 height 420 }"/>
</Document>
"""
_tmp = OUT + ".tmp"
with zipfile.ZipFile(OUT, "r") as zin, zipfile.ZipFile(_tmp, "w") as zout:
    for item in zin.infolist():
        if item.filename != "GuiDocument.xml":
            zout.writestr(item, zin.read(item.filename))
    zout.writestr("GuiDocument.xml", _gui.encode("utf-8"))
os.replace(_tmp, OUT)
print("GuiDocument.xml attached")
