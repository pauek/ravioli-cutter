
module pyramid(side, height) {
  linear_extrude(height = height, scale = 0)
    square(size=[side, side], center=true);
}

module cubramid(side, height) {
  rotate([0, 0, 135])
    multmatrix(m = [
      [1, 0, 0, 0],
      [0, 1, 0.5*side*sqrt(2)/height, 0],
      [0, 0, 1, 0],
      [0, 0, 0, 1]
    ]) {  
      translate([0, 0, height/2])
        rotate([0, 0, 45])
          cube([side, side, height], center = true);
    }
}

module cubramid_line(N, side, height) {
  X = side*sqrt(2);
  for (i = [1:N]) {
    translate([(i - 0.5)*X, X/2, -0.1])
      rotate([0, 0, 45])
        cubramid(side, height + 1);
  }
}

module cube_line(N, side, height) {
  X = side*sqrt(2);
  for (i = [1:N]) {
    translate([(i - 0.5)*X, X/2, height/2 - 0.1])
      rotate([0, 0, 45])
        cube([side, side, height + 1], center = true);
  }
}

module cutter_band(N, side, height, thickness) {
  X = side*sqrt(2);
  difference() {
    union() {
      cube([side*N, thickness + side/2, height]);
      multmatrix(m = [
        [1, 0, 0, 0],
        [0, 1, -side/height*.5, 0],
        [0, 0, 1, 0],
        [0, 0, 0,  1]
      ]) {
        cube([side*N, thickness + side/2, height]);
      }
    }
    
    translate([0, thickness, 0])
    cube_line(N, X/2, height);
    translate([-side/2, -side/2, 0])
      cubramid_line(N+1, X/2, height);
  }
}

module cutter_full(N, side, height, thickness) {
  union() {
    for (angle = [0, 90, 180, 270]) {
      rotate([0, 0, angle])
        translate([-N/2*side, -N/2*side, 0])
          cutter_band(N, side, height, thickness);
    }
  }
}


cutter_band(N = 12, side = 10, height = 20, thickness = 1);
// cubramid(10, 20);