module placa(N=10,freq=2,d0=0.8,dL=74,wMin=12.05,wMax=74,gp=2,eta=120*3.142,Z0=50){
  // N: número de secciones
  // freq: frecuencia mínima
  // d0: dist mínima entre las placas
  // dL: dist máxima entre las placas
  // wMin: anchura mínima del primer segmento
  // wMax: anchura máxima del último segmento
  // gp: grosor de la placa (aprox)

  //-- Determinación de constantes
  lambda = 299.792458/freq;
  L = 0.4*lambda;  // Longitud en proyección vertical
  a = d0;
  b = ln(dL/d0)/L;
  alpha = ln(eta/Z0)/L;

  // Generación de puntos - perfil vista lateral
  verticesF = [
      for (x = [0 : L/N : L])
          [x, a*pow(2.71828,b*x)/2],
      [0,L] // Para que la union con el feed sea buena
  ];
      
  // Generación de puntos - perfil vista cenital
  verticesL = [
      for (x = [0 : L/N : L])
          [x, eta*a*pow(2.71828,(b-alpha)*x)/(2*Z0)],
      [0,L]
  ];
  difference(){
    difference(){
      difference(){
        translate([0,0,d0/2])
        rotate([90,0,0])
        linear_extrude(height=wMax)
        polygon(points=verticesF);
          
        translate([-gp/sqrt(2),0,d0/2+gp/sqrt(2)])
        rotate([90,0,0])
        linear_extrude(height=wMax+2)
        polygon(points=verticesF);
      }
      
      translate([-0.01,-wMax/2,0])
      linear_extrude(height=wMax+2)
      polygon(points=verticesL);
    }
    
    translate([-0.01,-wMax/2,0])
    mirror([0,180,0])
    linear_extrude(height=wMax+2)
    polygon(points=verticesL);
  }
      
}

module feed(g=2.3, lc=5){
  // g: grosor paredes
  // lc: longitud que sobresale el cable coaxial
  
  difference(){
    union(){
      //- Caja/soporte del feed
      color("cyan")
      difference(){
        difference(){
          cube([2.3+7.4+13/2+g,28,13+2*g]);
            
          translate([13/2+g,-1,g])
          cube([7.4+2.3+2,28+2,13]);
        }
        
        translate([13/2+g,-1,g+13/2])
        rotate([-90,0,0])
        cylinder(r=13/2,h=28+2,$fn=300);
      }
      
      // Cubo inferior
      color("lightgreen")
      translate([13/2+g,(28-6)/2,g])
      cube([2.3+7.4,6,6.1]);
      
      // Cubo superior
      color("green")
      translate([13/2+g,(28-6)/2,13+g-6.1])
      cube([2.3+7.4,6,6.1]);
      
      // Cilindro externo | cable coaxial
      color("cyan")
      translate([13/2+g+2.3,28/2,-lc])
      cylinder(r=4.6/2,h=lc,$fn=300);
    }
      
    //- Hueco para el cable
    color("lightgreen")
    translate([13/2+g+2.3,28/2,-lc-0.005])
    cylinder(r=4.12/2,h=lc+g+6.25+0.01,$fn=300);
  }
  
  //- Cilindro interno | cable coaxial
  color("green")
  translate([13/2+g+2.3,28/2,-lc])
    cylinder(r=1.26/2,h=lc+g+7,$fn=300);

}

wMax = 74; 
g = 2.3;  // Grosor del soporte del feed
gp = 1.8;  // Grosor de las placas
lc = 6;  // Longitud del cable
nCaras = 13;  // Num caras del suavizado
rSuavizado = 0;  // Radio del suavizado (~1 mm)
nSegmentos = 30;  // Num segmentos de las placas
d0 = 0.8;

feed();

color("green")
//minkowski(){
  translate([13/2+g+(2.3+7.399),wMax/2+(28)/2,13/2+g+rSuavizado-d0/2])
  placa(N=nSegmentos,gp=gp);
  
//  sphere(r=rSuavizado,$fn=nCaras);
//}
color("lightgreen")
//  minkowski(){
  translate([13/2+g+(2.3+7.399),wMax/2+(28)/2,13/2+g-rSuavizado+d0/2])
  mirror([0,0,180])
  placa(N=nSegmentos,gp=gp);
//  
//    sphere(r=rSuavizado,$fn=nCaras);
//  }






