
ww = 1;
w1 = 36.3;
w2 = 21.35;
e = 59.81;
r = 13.12;
g = 9.97;
i = 6.87;
f = 5.91;
h = 21.59;
a = 4.03;
d = 23.02;
d0 = w1/2-a-r;

R = 0.105;
c1 = w2/(2*(pow(2.71,R*e)-1));
c2 = w2*pow(2.71,R*e)/(pow(2.71,R*e)-1);

function f(z) = (c1*pow(2.71,R*z)+c2);

perf = [
  [-1,f(0)],
  for (z = [0 : e/40 : e])
    [z,f(z)],
  
  [-1,f(e)]
];
  
module perfil(){
  translate([0,0,-ww])
    union(){
      difference(){
        translate([-w2/2+0.05,-0.05,0])
        cube([w2,e+0.1,2*ww]);
        
        translate([-w2,0,-ww])
        mirror([180,0,0])
        rotate([0,0,90])
        linear_extrude(height = 4*ww) {
          polygon(perf);
        }
      }
    }
}

module lobulo(){
  rotate([0,0,-55])
  translate([0,d-e,0])
  difference(){
    translate([0,2*d,0])
    cube([w2-2*d0,d,ww+0.1],center=true);
    
    union(){
      translate([-w2-d0,0,-ww])
      mirror([180,0,0])
      rotate([0,0,90])
      linear_extrude(height = 2*ww) {
        polygon(perf);
      }
      
      rotate([0,180,0])
      translate([-w2-d0,0,-ww])
      mirror([180,0,0])
      rotate([0,0,90])
      linear_extrude(height = 2*ww) {
        polygon(perf);
      }
    }
  }
}


difference(){
  difference(){
    difference(){
      difference(){
        difference(){
          difference(){
            translate([0,e/2,0])
            cube([w1,e,ww],center=true);
            
            translate([w1/2-a,g+r,0])
            cylinder(r=r,center=true,h=2*ww,$fn=200);
          }
          
          translate([-r+w1/2-a,-0.1,-ww])
          cube([2*r,g+r+0.1,2*ww]);
        }
        
        translate([-r-w1/2+a,-0.1,-ww])
        cube([2*r,e+0.2,2*ww]);
      }
      
      perfil();
    }
  }
  
  union(){
    translate([(f+g+h)*tan(10),g+h,0])
    lobulo();
    translate([(f+g+h+i)*tan(10),g+h+i,0])
    lobulo();
    translate([(f+g+h+2*i)*tan(10),g+h+2*i,0])
    lobulo();
    translate([(f+g+h+3*i)*tan(10),g+h+3*i,0])
    lobulo();
    translate([15,28,-1.5*ww])
    cube([10,10,3*ww]);
  }
}




