

function cat(L1, L2, L3) = [
  for(L = [L1, L2, L3], elem=L) elem
];

module sawProf(N, size) {
  polygon(
    points = cat(
      [for (i = [0: 1: N]) [i*size, (i % 2)*size]],
      [[N*size, size*2], [0, size*2]]
    )
  );
}

module sawHalf(N, size) {
  H = size*2;
  union() {
    linear_extrude(height = H, scale=[1, 0.0], $fn = 60) {
      sawProf(N, size);
    }
    rotate([0, 90, 0])
      linear_extrude(height = N*size)
        polygon([[-H, H], [0, H], [0, H/2], [-H, 0]]);
  }
}

intersection() {
  translate([-50, -3, 0])
    sawHalf(20, 5);
  rotate([0, 0, 180])
    translate([-55, -3, 1])
      sawHalf(21, 5);
}