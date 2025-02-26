module placa(N=10,freq=2,d0=1.6,dL=74){
  // N: número de secciones
  // freq: frecuencia mínima
  // d0: dist mínima entre las placas
  // dL: dist máxima entre las placas
  
  wMin = 12.05; // Anchura mínima del primer segmento

  //-- Determinación de constantes
  lambda = 299.792458/freq;
  L = 0.4*lambda;  // Longitud en proyección vertical
  a = d0;
  b = ln(dL/d0)/L;
  eta = 120*3.142;
  Z0 = 50;
  alpha = ln(eta/Z0)/L;
  
  
  //linear_extrude(height=2,v=[0,0,1],center=true)
  //polygon(points=[[0,w/2],[0,-w/2],[]]);

  // Generación de puntos
  //vertices = [
  //    for (x = [0 : L/N : L])
  //        [x, a*pow(2.71828,b*x)]
  //];
  function altRel(i) = (a*pow(2.71828,b*L*i/N)-a*pow(2.71828,b*L*(i-1)/N))/2;
  function theta(i) = atan(N*altRel(i)/L);
  function R(i) = L/(N*cos(theta(i)));
  function w(i) = eta*a*pow(2.71828,(b-alpha)*i*L/N)/Z0;
  
  R1 = L/(N*cos(atan(N*(a*pow(2.71828,b*L/N)-a*pow(2.71828,b*d0))/(2*L))));
  v = [
      [
      [0,-wMin/2],
      [0,wMin/2],
      [R1,w(1)/2],
      [R1,-w(1)/2],
      ],
      [
      [0,-w(1)/2],
      [0,w(1)/2],
      [R(2),w(2)/2],
      [R(2),-w(2)/2],
      ],
    for (i=[2 : 1 : N])
      [
      [0,-w(i)/2],
      [0,w(i)/2],
      [R(i+1),w(i+1)/2],
      [R(i+1),-w(i+1)/2],
      ]
  ];
  
  theta1 = atan(N*(a*pow(2.71828,b*L/N)-a*pow(2.71828,b*d0))/(2*L));
    
  translate([0,0,d0/2])
  rotate([0,-theta1,0])
  linear_extrude(height=1)
  polygon(points=v[1]);
    
//  sumaCos = [
//    for (i=[2:1:N])
//      R(i)*cos(theta(i)),
//    ];
//  sumaSin = [
//    for (i=[2:1:N])
//      R(i)*sin(theta(i)),
//    ];
//
//  echo(sumaCos);
//    
//    
//  for (i=[2 : 1 : N]) {
//    translate([R1*cos(theta1),0,R1*sin(theta1)+d0/2])
//    rotate([0,-theta(i),0])
//    linear_extrude(height=1)
//    polygon(points=v[i]);
//  }
  
  function RC(i) = R(i)*cos(theta(i));
  function RS(i) = R(i)*sin(theta(i));
  
  translate([R1*cos(theta1),0,R1*sin(theta1)+d0/2])
  rotate([0,-theta(2),0])
  linear_extrude(height=1)
  polygon(points=v[2]);
  
  translate([R1*cos(theta1)+RC(2),0,R1*sin(theta1)+RS(2)+d0/2])
  rotate([0,-theta(3),0])
  linear_extrude(height=1)
  polygon(points=v[3]);
  
  translate([R1*cos(theta1)+RC(2)+RC(3),0,R1*sin(theta1)+RS(2)+RS(3)+d0/2])
  rotate([0,-theta(4),0])
  linear_extrude(height=1)
  polygon(points=v[4]);
  
  translate([R1*cos(theta1)+RC(2)+RC(3)+RC(4),0,R1*sin(theta1)+RS(2)+RS(3)+RS(4)+d0/2])
  rotate([0,-theta(5),0])
  linear_extrude(height=1)
  polygon(points=v[5]);
  
  translate([R1*cos(theta1)+RC(2)+RC(3)+RC(4)+RC(5),0,R1*sin(theta1)+RS(2)+RS(3)+RS(4)+RS(5)+d0/2])
  rotate([0,-theta(6),0])
  linear_extrude(height=1)
  polygon(points=v[6]);
  
  translate([R1*cos(theta1)+RC(2)+RC(3)+RC(4)+RC(5)+RC(6),0,R1*sin(theta1)+RS(2)+RS(3)+RS(4)+RS(5)+RS(6)+d0/2])
  rotate([0,-theta(7),0])
  linear_extrude(height=1)
  polygon(points=v[7]);
  
  translate([R1*cos(theta1)+RC(2)+RC(3)+RC(4)+RC(5)+RC(6)+RC(7),0,R1*sin(theta1)+RS(2)+RS(3)+RS(4)+RS(5)+RS(6)+RS(7)+d0/2])
  rotate([0,-theta(8),0])
  linear_extrude(height=1)
  polygon(points=v[8]);
  
  translate([R1*cos(theta1)+RC(2)+RC(3)+RC(4)+RC(5)+RC(6)+RC(7)+RC(8),0,R1*sin(theta1)+RS(2)+RS(3)+RS(4)+RS(5)+RS(6)+RS(7)+RS(8)+d0/2])
  rotate([0,-theta(9),0])
  linear_extrude(height=1)
  polygon(points=v[9]);
  
  translate([R1*cos(theta1)+RC(2)+RC(3)+RC(4)+RC(5)+RC(6)+RC(7)+RC(8)+RC(9),0,R1*sin(theta1)+RS(2)+RS(3)+RS(4)+RS(5)+RS(6)+RS(7)+RS(8)+RS(9)+d0/2])
  rotate([0,-theta(10),0])
  linear_extrude(height=1)
  polygon(points=v[10]);
  
}


union(){
  placa();

  mirror([0,0,180])
  placa();
}
