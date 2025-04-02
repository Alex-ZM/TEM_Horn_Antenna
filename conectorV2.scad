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


module cresta(N=10,freq=2,d0=0.8,dL=74,wMin=12.05,wMax=74,gp=2.3,eta=120*3.142,Z0=50,grCresta=2){
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
    translate([-gp/sqrt(2),(-wMax+grCresta)/2,d0/2])
    rotate([90,0,0])
    linear_extrude(height=grCresta)
    polygon(points=verticesF);
    
    translate([27.5,(-wMax+2)/2-gp/2,43.6])
    cube([L+2,7,70],center=true);
  }
}


module cunia(g=2.3){
  translate([13/2+g,28/2,g/2])
  rotate([90,0,90])
  linear_extrude(height=g+7.4+0.02){
    polygon(points=[[6+1.2,g/3.7],[6+1.2,-g/3.7],[6,-g/3.7],[6,-g/2-0.01],[-6,-g/2-0.01],[-6,-g/3.7],[-6-1.2,-g/3.7],[-6-1.2,g/3.7],[-6,+g/3.7],[-6,+g/2+0.01],[+6,+g/2+0.01],[+6,+g/3.7]]);
  }
}

module cunia2(g=2.3){
  translate([13/2+g,28/2,g/2])
  rotate([90,0,90])
  linear_extrude(height=g+7.4+0.01){
    polygon(points=[[6+1.1,g/3.7-0.1],[6+1.1,-g/3.7+0.1],[5.9,-g/3.7+0.1],[5.9,-g/2],[-5.9,-g/2],[-5.9,-g/3.7+0.1],[-6-1.1,-g/3.7+0.1],[-6-1.1,g/3.7-0.1],[-5.9,+g/3.7-0.1],[-5.9,+g/2],[+5.9,+g/2],[+5.9,+g/3.7-0.1]]);
  }
}

module feed_soporte(g=2.3,lc=5,wMax=74,gp=1.8,nCaras=13,rSuavizado=0,nSegmentos=30,d0=0.8,grCresta=2){
  // g: grosor paredes
  // lc: longitud que sobresale el cable coaxial
  
  //- Caja/soporte del feed
  difference(){
    union(){
      difference(){
        difference(){
          difference(){
            cube([g+7.4+13/2+g,28,13+2*g]);
              
            translate([13/2+g,-1,g])
            cube([7.4+g+2,28+2,13]);
          }
          
          translate([13/2+g,-1,g+13/2])
          rotate([-90,0,0])
          cylinder(r=13/2,h=28+2,$fn=300);
        }
        
        //- Hueco cuia superior
        translate([0,0,13+g])
        cunia(g);
      }

      //- 'Cubo' GND
      color("cyan")
      translate([13/2+g,(28-6)/2,g])
      cube([g+7.4,6,6.1]);
    }
    
    //- Hueco para el cable
    color("cyan")
    translate([13/2+g+g,28/2,-lc-0.005])
    cylinder(r=1.45,h=lc+g+6.25+0.01,$fn=300);
  }
  
  translate([8.5,(28-16)/2,-5.6])
  cube([6,16,5.7]);
  
  //- Placa emisora inferior
  color("cyan")
  union(){
    translate([13/2+g+(g+7.399),wMax/2+(28)/2,13/2+g-rSuavizado+d0/2])
    mirror([0,0,180])
    cresta(wMax=wMax,grCresta=grCresta);
    
//    minkowski(){
      translate([13/2+g+(g+7.399),wMax/2+(28)/2,13/2+g-rSuavizado+d0/2])
      mirror([0,0,180])
      difference(){
        placa(N=nSegmentos,gp=gp,wMax=wMax);
        translate([0,-80,21.33])
        rotate([0,-15,0])
        cube([100,100,4]);
      }
        
//      sphere(r=rSuavizado,$fn=nCaras);
//    }
  }

}

module feed_live(g=2.3,lc=5,wMax=74,gp=1.8,nCaras=13,rSuavizado=0,nSegmentos=30,d0=0.8){
  // Cubo superior
  color("green")
  translate([13/2+g,(28-6)/2,13+g-6.1])
  cube([g+7.4,6,6.1]);
  
//  //- Cilindro interno | cable coaxial
//  color("green")
//  translate([13/2+g+g,28/2,-lc])
//  cylinder(r=1.26/2,h=lc+g+7,$fn=300);
  
  //- Cunia
  color("green")
  translate([0,0,13+g])
  cunia2(g);
  
  //- Placa emisora superior
  color("green")
  union(){
    translate([13/2+g+(g+7.399),wMax/2+(28)/2,13/2+g+rSuavizado-d0/2])
    cresta(wMax=wMax);
    
//    minkowski(){
      translate([13/2+g+(g+7.399),wMax/2+(28)/2,13/2+g+rSuavizado-d0/2])
      difference(){
        placa(N=nSegmentos,gp=gp,wMax=wMax);
        translate([0,-80,21.33])
        rotate([0,-15,0])
        cube([100,100,4]);
      }
//      sphere(r=rSuavizado,$fn=nCaras);
//    }
  }
}

module conector(a=12.72,gConector=2,lCoax=3,dAgujeros=12.2,rAgujeros=2.6/2,lPTFE=12,rPTFE=4.13/2){
// a: Lado del soporte del conector
// gConector: Grosor del soporte del conector
// lCoax: distancia entre el soporte y la punta del coax
// dAgujeros: distancia entre los centros de los agujeros
// rAgujeros: radio de los agujeros
// lPTFE: longitud del cilindro de PTFE
// rPTFE: radio del cilindro de PTFE
  
//  difference(){
//    //- Soporte del conector
//    minkowski(){
//      cube([a-3,a-3,gConector],center=true);
//      cylinder(r=1.5,h=0.01,$fn=15);
//    }
//    
//    union(){
//      translate([0.55*a,-0.55*a,0])
//      rotate([0,0,-45])
//      cube([a,a,gConector+3],center=true);
//      translate([-0.55*a,0.55*a,0])
//      rotate([0,0,-45])
//      cube([a,a,gConector+3],center=true);
//    }
//  }

  cube([6,16,gConector],center=true);
  
  translate([0,+dAgujeros/2,2*gConector])
  cylinder(r=rAgujeros,h=6*gConector,center=true,$fn=60);
  
  translate([0,-dAgujeros/2,2*gConector])
  cylinder(r=rAgujeros,h=6*gConector,center=true,$fn=60);
  
  translate([0,0,lPTFE/2+gConector/2])
  cylinder(r=rPTFE,h=lPTFE,center=true,$fn=100);
  
  translate([0,0,lPTFE+lCoax/2+gConector/2])
  cylinder(r=1.26/2,h=lCoax,center=true,$fn=100);
  
//  translate([0,0,-gConector/2])
//  color([0.8,0.8,0,0.1])
//  cube([a,a,2*gConector],center=true);
  
}


wMax = 74; 
g = 2.5;  // Grosor del soporte del feed
gp = 1.8;  // Grosor de las placas
lc = 0;  // Longitud del cable
nCaras = 13;  // Num caras del suavizado
rSuavizado = 0;  // Radio del suavizado (~1 mm)
nSegmentos = 10;  // Num segmentos de las placas
grCresta=2.3;

//color("green")
///render()
translate([10,0,0])
feed_live(rSuavizado=rSuavizado,nCaras=nCaras,g=g);

render()
//color([0.8,0.8,0,0.5])
difference(){
  //render()
  feed_soporte(g=g,lc=lc,grCresta=grCresta);
  
  #translate([13/2+g+1.26*2-0.02,28/2,-6.6])
  conector();
  #translate([13/2+g+1.26*2-0.02,-28/2,-6.6])
  conector();
}

//color("brown")
//translate([13/2+g+1.26*2-0.02,28/2,-1.7/2-0.01-8*$t])
//rotate([0,0,45])
//conector();







