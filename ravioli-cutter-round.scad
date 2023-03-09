// --------------------------
N = 32;
SIDE = 10;
HEIGHT = 30;
THICKNESS = 0.4;
// --------------------------

circum = N * SIDE;
radius = circum / (2.02 * PI);


A = [
      [1.3, 0, 0, 0],
      [0, 1.1, -(SIDE/2)/HEIGHT, 0],
      [0, 0, 1, 0],
      [0, 0, 0, 1]
    ];

module prisma() {
  translate([0, 0, HEIGHT/2])
    rotate([0, 0, 45])
      cube([SIDE/2*sqrt(2), SIDE/2*sqrt(2), HEIGHT], center = true);
}

module sheared_prisma() {
  rotate([0, 0, 180])
    multmatrix(m = A)
      prisma();
}

module prisma_line(N) {
  for (i = [1:N]) {
    translate([(i-.5) * SIDE, SIDE/2, 0])
      prisma();
  }
}

module base() {
  translate([0, 0, 0])
  difference() {
    translate([0, -THICKNESS, 0])
      multmatrix(m = A) cube([N*SIDE, SIDE + THICKNESS, HEIGHT-1]);
    translate([0, SIDE/2, 0])
      cube([N*SIDE, SIDE/2, HEIGHT-1]);
  }
}

module cutter_SIDE() {
  translate([-N*SIDE/2, -N*SIDE/2, 0])
  difference() {
    base();
    translate([-SIDE/2, -SIDE/2 - THICKNESS, 0])
      multmatrix(m = A)
        prisma_line(N+1);
    prisma_line(N+1);
  }
}

module cutter() {
  union() {
    for (angle = [0, 90, 180, 270]) {
      rotate([0, 0, angle])
        cutter_SIDE();
    }
    difference() {
      translate([0, 0, HEIGHT-1]) {
        minkowski() {
          cube([(N)*SIDE, (N)*SIDE, 1], center = true);
          cylinder(h = 1, r = SIDE);
        }
      }
      cube([(N-2)*SIDE, (N-2)*SIDE, HEIGHT*10], center = true);
    }
  }
}


module ring(r1, r2) {
  difference() {
    # cylinder(h = HEIGHT, r1 = r1 - SIDE/2, r2 = r1);
    translate([0, 0, -0.5])
      cylinder(h = HEIGHT + 1, r = r2);
  }
}

module mold() {
  union() {
    for (i = [0:N]) {
      rotate([0, 0, 360/N*i])
        translate([0, radius - 0.1, 0])
          prisma();
    }
    for (i = [0:N]) {
      rotate([0, 0, 360/N*(i + 0.5)])
        translate([0, radius + SIDE/2 + 0.7, 0])
          sheared_prisma();
          // prisma();
    }
  }
}


module blade() {
  difference() {
    ring(radius + SIDE + .6, radius + .3);
    mold();
  }
}

module reinforcement() {
  r = radius + SIDE/2;
  width = SIDE;
  translate([0, 0, HEIGHT - 0.1])
    difference() {
      cylinder(h = 2, r = r + width, $fn = 120);
      translate([0, 0, -0.5])
        cylinder(h = 3, r = r - width, $fn = 120);
    }
}

module cutter() {
  rotate([180, 0, 0])
    union() {
      blade();
      reinforcement();
    }
}


cutter();