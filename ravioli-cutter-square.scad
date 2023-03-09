N = 12;
side = 10;
height = 30;
thickness = 0.4;

A = [
      [1, 0, 0, 0],
      [0, 1, -(side/2)/height, 0],
      [0, 0, 1, 0],
      [0, 0, 0, 1]
    ];

module prisma() {
  translate([0, 0, height/2])
    rotate([0, 0, 45])
      cube([side/2*sqrt(2), side/2*sqrt(2), height], center = true);
}

module prisma_line(N) {
  for (i = [1:N]) {
    translate([(i-.5) * side, side/2, 0])
      prisma();
  }
}

module base() {
  translate([0, 0, 0])
  difference() {
    translate([0, -thickness, 0])
      multmatrix(m = A) cube([N*side, side + thickness, height-1]);
    translate([0, side/2, 0])
      cube([N*side, side/2, height-1]);
  }
}

module cutter_side() {
  translate([-N*side/2, -N*side/2, 0])
  difference() {
    base();
    translate([-side/2, -side/2 - thickness, 0])
      multmatrix(m = A)
        prisma_line(N+1);
    prisma_line(N+1);
  }
}

module cutter() {
  union() {
    for (angle = [0, 90, 180, 270]) {
      rotate([0, 0, angle])
        cutter_side();
    }
    difference() {
      translate([0, 0, height-1]) {
        minkowski() {
          cube([(N)*side, (N)*side, 1], center = true);
          cylinder(h = 1, r = side);
        }
      }
      cube([(N-2)*side, (N-2)*side, height*10], center = true);
    }
  }
}

translate([0, 0, height])
  rotate([180, 0, 0])
    cutter();