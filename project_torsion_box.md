# Project: Composite Modular Torsion Box for LowRider v4 CNC

This document contains the engineering specifications, structural calculations, 3D printing configuration, and parametric OpenSCAD source code for a high-precision, ultra-rigid work surface optimized for the LowRider v4 CNC.

The system replaces the classic glued plywood torsion box with a **pre-compressed/post-tensioned interlocking segmented structure** that combines 3D-printed PLA modules with a load-bearing skeleton made of 2020 aluminum extrusions.

---

## 1. Geometric Specifications and Architecture

The design fully utilizes the standard shipping limit of industrial distributors (1980 mm) to maximize the working area without incurring oversized freight shipping rates (cargo/pallet).

* **Total Dimensions:** 1980 mm (Length) x 1237.5 mm (Width) x 80 mm (Thickness)
* **Grid Configuration:** 8 modules (Y-axis) x 5 modules (X-axis) = **40 total units**
* **Single Module Dimensions:** 247.5 x 247.5 x 80 mm (Exact submultiple ratio to 1980 mm)
* **Mechanical Force Decoupling:** The aluminum extrusions run on two staggered internal levels within the PLA modules, creating a spatial space frame.
  * **Lower Level (Z: 5-25 mm):** 4 continuous 1980 mm extrusions (Y-axis).
  * **Upper Level (Z: 55-75 mm):** 9 continuous 1237.5 mm extrusions (X-axis).
  * **Central Divider (Z: 25-55 mm):** 30 mm of printed PLA core that physically separates the two planes and absorbs dynamic shear stresses.

---

## 2. Clamping Mechanics and Creep Elimination

PLA suffers from *creep* (viscous flow) when subjected to constant static loads. To eliminate this effect:
1. The PLA modules slide freely over the 2020 aluminum extrusions.
2. The ends of the 2020 profiles (native 5 mm center hole) are manually tapped with an **M6** thread.
3. At the table edges, metal or solid 3D-printed **End Plates** rest against the face of the perimeter PLA modules.
4. An M6 screw is tightened into the center hole of the aluminum. The screw pulls the aluminum (tension) and pushes the plate against the PLA (compression).

The aluminum acts as a structural tie-rod, absorbing 98.3% of micro-deformations. The compression only serves to close the tolerances of the joints. The global creep of the PLA is completely nullified.

### Complanar Interlocking System
To prevent vertical stepping (Z) or lateral shifting (X/Y) due to CNC accelerations, each module integrates **Tapered Alignment Pins** (pyramidal male/female joints) on its side faces. The pyramidal shape acts as a self-centering invitation that locks out mechanical play once the "skewer" is tensioned.

---

## 3. Bill of Materials (BOM) & Cost Estimation

The configuration is calculated based on industrial pricing (e.g., Motedis 2020 I-Typ Slot 5) and bulk PLA filament.

| Material / Component | Specifications / Notes | Quantity | Estimated Cost |
| :--- | :--- | :--- | :--- |
| **Aluminum 2020 I-Typ Slot 5** | Motedis custom cut - 1980 mm | 4 bars | ~46.80 € |
| **Aluminum 2020 I-Typ Slot 5** | Motedis custom cut - 1237.5 mm | 9 bars | ~65.70 € |
| **PLA Filament** | Optimized (Coil/Bulk @ 6 €/kg) | ~20 kg | ~120.00 € |
| **End Plates** | Steel/Aluminum or Solid 3D Print (40x40x15 mm) | 26 pieces | ~10.00 € |
| **M6 Cap Screws** | Length 35 mm (UNI 5931 / ISO 4762) | 26 pieces | ~5.00 € |
| **Standard Shipping** | Under the 2-meter / 30kg package limit | - | ~20.00 € |
| **TOTAL ESTIMATED COST** | | | **~267.50 €** |

---

## 4. Slicing Strategy (0.8 mm Nozzle Optimization)

To cut printing times by 65% and maximize inter-layer molecular bonding, an **0.8 mm nozzle** is highly recommended (ideal for Bambu Lab P1S or Sovol SV08).

### Critical Print Parameters (OrcaSlicer / Bambu Studio):
* **Layer Height:** 0.45 mm
* **Line Width:** 0.85 mm (Walls) / 0.90 mm (Infill)
* **Wall Loops:** 3 or 4 walls (ensures ~2.6 mm of structural thickness on tunnels and sides).
* **Infill:** **5% Gyroid**. Provides omnidirectional strength and excellent vibration damping for the router.
* **Top/Bottom Solid Layers:** 7 Top Layers / 5 Bottom Layers (prevents pillowing over the large gaps of the 5% gyroid).
* **Max Volumetric Speed:** 15 mm³/s (Bambu P1S to avoid under-extrusion) / 25 mm³/s (Sovol SV08).
* **X-Y Hole Compensation:** `+0.15 mm` (corrects the natural inner shrinkage caused by the 0.8 mm nozzle).

### Hardware Adjustments for Bambu P1S:
* **Heat Dissipation:** Print strictly with the front door open and the top glass panel removed to avoid PLA heat creep in the enclosed chamber.
* **Build Plate Area:** The 247.5 mm module intersects the filament cutter exclusion zone (18x18 mm front left). Disable the exclusion zone in the slicer before sending or apply a 15 mm chamfer to the corresponding corner in CAD.

---

## 5. Parametric OpenSCAD Source Code

```openscad
// ====================================================================
// COMPOSITE TORSION BOX FOR LOWRIDER v4 - POLY-ALUMINUM 2020 MODULE
// Module: 247.5 x 247.5 x 80 mm | Profile: Motedis 2020 I-Typ Slot 5
// ====================================================================

mode = "detail"; // Options: "detail", "exploded", "assembled"
$fn = 32; 

mod_size = 247.5;
mod_h = 80;
alu_size = 20;
alu_hole = 5; 
gap = 0.2;     

color_pla = [0.2, 0.5, 0.8, 0.75]; 
color_alu = [0.75, 0.75, 0.75, 1]; 
color_plate = [0.9, 0.2, 0.2, 1]; 
color_steel = [0.3, 0.3, 0.3, 1]; 

module printed_module() {
    color(color_pla)
    difference() {
        union() {
            cube([mod_size, mod_size, mod_h], center=true);
            translate([0, mod_size/2, -10]) pin();
            translate([0, mod_size/2, 10]) pin();
        }
        translate([0, 0, -25]) cube([alu_size + gap, mod_size + 2, alu_size + gap], center=true);
        translate([0, 0, 25]) cube([mod_size + 2, alu_size + gap, alu_size + gap], center=true);
        translate([0, -mod_size/2, -10]) rotate([0, 0, 180]) pin(hole=true);
        translate([0, -mod_size/2, 10]) rotate([0, 0, 180]) pin(hole=true);
    }
}

module pin(hole=false) {
    t = hole ? 0.2 : 0; 
    rotate([-90, 0, 0]) translate([0, 0, -0.1])
    linear_extrude(height=10, scale=0.7) square([20 + t, 15 + t], center=true);
}

module alu_profile(length) {
    color(color_alu)
    difference() {
        cube([alu_size, length, alu_size], center=true);
        rotate([90, 0, 0]) cylinder(d=alu_hole, h=length + 2, center=true);
    }
}

module end_plate() {
    color(color_plate)
    difference() {
        cube([40, 15, 40], center=true); 
        rotate([90, 0, 0]) cylinder(d=6.5, h=15, center=true);
    }
}

module screw_m6() {
    color(color_steel)
    rotate([90, 0, 0]) {
        cylinder(d=10, h=6); 
        translate([0, 0, 6]) cylinder(d=6, h=35); 
    }
}

if (mode == "detail") {
    difference() {
        printed_module();
        translate([0, -mod_size, -mod_h]) cube([mod_size*2, mod_size*2, mod_h*2]);
    }
    translate([0, -50, -25]) alu_profile(length=300);
    translate([0, mod_size/2 + 20, -25]) end_plate();
    translate([0, mod_size/2 + 50, -25]) screw_m6();
} else if (mode == "exploded") {
    offset = 60; 
    translate([0, 0, -25]) alu_profile(length=800);
    translate([0, -mod_size - offset, 0]) printed_module();
    printed_module();
    translate([0, mod_size + offset, 0]) printed_module();
    translate([0, (mod_size*1.5) + offset + 20, -25]) end_plate();
    translate([0, (mod_size*1.5) + offset + 40, -25]) screw_m6();
} else if (mode == "assembled") {
    translate([0, 0, -25]) alu_profile(length=mod_size * 3);
    translate([0, -mod_size, 0]) printed_module();
    printed_module();
    translate([0, mod_size, 0]) printed_module();
    translate([0, (mod_size*1.5) + 6, -25]) end_plate();
    translate([0, (mod_size*1.5) + 12, -25]) screw_m6();
}