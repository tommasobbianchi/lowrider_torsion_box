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
