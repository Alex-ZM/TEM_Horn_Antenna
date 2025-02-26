//-- Parámetros a variar
freq = 2; // Frecuencia en GHz
d0 = 10;
dL = 80;
i = 10;

//-- Determinación de constantes
lambda = 299.792458/freq;
L = 0.4*lambda;
a = d0;
b = ln(dL/d0)/L;

//-- CONSTRUCCIÓN DEL FEED
grosor_feed = 1.8; // Ver en el diagrama, no queda claro
// Revisar. ¿El eje del cilindro debería coincidir con el cable coaxial? Supongo que no por el diagrama

//translate([-(6+2.3+7.4)/2,-28/2,-(13+grosor_feed)/2])

difference(){
  difference(){
    cube([6+2.3+7.4,28,13+2*grosor_feed]);
      
    translate([6,-1,grosor_feed])
    cube([7.4+2.3+2,28+2,13]);
  }
  
  translate([6,-1,grosor_feed+13/2])
  #rotate([-90,0,0])
  cylinder(r=13/2,h=28+2);
}