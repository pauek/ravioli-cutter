N = 32;
SIDE = 10;
HEIGHT = 30;
THICKNESS = 0.4;
// --------------------------

circum = N * SIDE;
radius = circum / (2.02 * PI);


module reinforcement(height = 1) {
  r = radius - 0.8*SIDE/2;
  width = SIDE/2;
    difference() {
      cylinder(h = height, r = r + width, $fn = 120);
      translate([0, 0, -0.5])
        cylinder(h = height + 1, r = r - width, $fn = 120);
    }
}


module lettering(height) {
  for (i = [0:12]) {
    rotate([0, 0, i * 360/12])
      linear_extrude(height = height) {
        translate([-11.5, 0, 0])
          import(
            file = "SGCV.svg", 
            center = false, 
            convexity = 10, 
            dpi = 160, 
            $fn = 10
          );
    }
  }
}

module stamp() {
  union() {
    lettering(2);
    translate([0, 0, 2]) reinforcement();
  }
}

rotate([180, 0, 0])
  stamp();