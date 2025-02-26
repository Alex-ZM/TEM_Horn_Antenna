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
    
    //- Corte cilindrico
//    union(){
//      r=87.5;
//      translate([L-9+r,-wMax/2,2])
//      #cylinder(r=r,$fn=40,h=100);
//      
//      translate([0,-wMax/2,66.1])
//      rotate([0,90,0])
//      #cylinder(r=47,$fn=40,h=100);
//    }
  }
}


module cresta(N=10,freq=2,d0=0.8,dL=74,wMin=12.05,wMax=74,gp=2.3,eta=120*3.142,Z0=50){
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
      //[-2,eta*a/(2*Z0)], // Para que el corte quede bien
      for (x = [0 : L/N : L])
          [x, eta*a*pow(2.71828,(b-alpha)*x)/(2*Z0)],
      [0,L]
  ];
  
  difference(){
    translate([-gp/sqrt(2),(-wMax+2)/2,d0/2])
    rotate([90,0,0])
    linear_extrude(height=2)
    polygon(points=verticesF);
    
    translate([27.5,(-wMax+2)/2-gp/2,43])
    cube([L+2,7,70],center=true);
  }
}


module cunia(g=2.3){
  translate([13/2+g,28/2,g/2])
  rotate([90,0,90])
  linear_extrude(height=2.3+7.4+0.01){
    polygon(points=[[6+1,g/3],[6+1,-g/3],[6,-g/3],[6,-g/2-0.01],[-6,-g/2-0.01],[-6,-g/3],[-6-1,-g/3],[-6-1,g/3],[-6,+g/3],[-6,+g/2+0.01],[+6,+g/2+0.01],[+6,+g/3]]);
  }
}

module cunia2(g=2.3){
  translate([13/2+g,28/2,g/2])
  rotate([90,0,90])
  linear_extrude(height=2.3+7.4+0.01){
    polygon(points=[[6+0.9,g/3-0.1],[6+0.9,-g/3+0.1],[5.9,-g/3+0.1],[5.9,-g/2],[-5.9,-g/2],[-5.9,-g/3+0.1],[-6-0.9,-g/3+0.1],[-6-0.9,g/3-0.1],[-5.9,+g/3-0.1],[-5.9,+g/2],[+5.9,+g/2],[+5.9,+g/3-0.1]]);
  }
}

module feed_soporte(g=2.3, lc=5){
  // g: grosor paredes
  // lc: longitud que sobresale el cable coaxial
  
  //- Caja/soporte del feed
  difference(){
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
    
    color("cyan")
    union(){
      cunia();
      translate([0,0,13+g])
      cunia();
    }
  }
}

module feed_gnd(g=2.3,lc=5,wMax=74,gp=1.8,nCaras=13,rSuavizado=0,nSegmentos=30,d0=0.8){
  // g: grosor paredes
  // lc: longitud que sobresale el cable coaxial
  
  difference(){
    // Cubo inferior + cuña
    color("lightgreen")
    union(){
      union(){
        translate([13/2+g,(28-6)/2,g])
        cube([2.3+7.4,6,6.1]);
        
        cunia2();
      }
      
      // Cilindro externo | cable coaxial
      color("lightgreen")
      translate([13/2+g+2.3,28/2,-lc])
      cylinder(r=4.6/2,h=lc,$fn=300);
    }
    
    //- Hueco para el cable
    color("lightgreen")
    translate([13/2+g+2.3,28/2,-lc-0.005])
    cylinder(r=4.12/2,h=lc+g+6.25+0.01,$fn=300);
  }
  
  //- Placa inferior
  color("lightgreen")
  union(){
    translate([13/2+g+(2.3+7.399),wMax/2+(28)/2,13/2+g-rSuavizado+d0/2])
    mirror([0,0,180])
    cresta(wMax=wMax);
    
//    minkowski(){
      translate([13/2+g+(2.3+7.399),wMax/2+(28)/2,13/2+g-rSuavizado+d0/2])
      mirror([0,0,180])
      placa(N=nSegmentos,gp=gp,wMax=wMax);
        
//      sphere(r=rSuavizado,$fn=nCaras);
//    }
  }
}
  

module feed_live(g=2.3,lc=5,wMax=74,gp=1.8,nCaras=13,rSuavizado=0,nSegmentos=30,d0=0.8){
  // Cubo superior
  color("green")
  translate([13/2+g,(28-6)/2,13+g-6.1])
  cube([2.3+7.4,6,6.1]);
  
  //- Cilindro interno | cable coaxial
  color("green")
  translate([13/2+g+2.3,28/2,-lc])
  cylinder(r=1.26/2,h=lc+g+7,$fn=300);
  
  //- Cunia
  color("green")
  translate([0,0,13+g])
  cunia2();
  
  //- Placa Superior
  color("green")
  union(){
    translate([13/2+g+(2.3+7.399),wMax/2+(28)/2,13/2+g+rSuavizado-d0/2])
    cresta(wMax=wMax);
    
//    minkowski(){
      translate([13/2+g+(2.3+7.399),wMax/2+(28)/2,13/2+g+rSuavizado-d0/2])
      placa(N=nSegmentos,gp=gp,wMax=wMax);
    
//      sphere(r=rSuavizado,$fn=nCaras);
//    }
  }
}


wMax = 74; 
g = 2.3;  // Grosor del soporte del feed
gp = 1.8;  // Grosor de las placas
lc = 6;  // Longitud del cable
nCaras = 13;  // Num caras del suavizado
rSuavizado = 0;  // Radio del suavizado (~1 mm)
nSegmentos = 10;  // Num segmentos de las placas

//color("cyan")
//render()
feed_soporte();

color("lightgreen")
render()
translate([13-(13*$t),0,0])
feed_gnd(rSuavizado=rSuavizado,nCaras=nCaras);

//color("green")
//render()
translate([13-(13*$t),0,0])
feed_live(rSuavizado=rSuavizado,nCaras=nCaras);






