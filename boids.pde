static final int POPULATION = 240;
ArrayList<Boid> boids;

void setup() {
  size(1280, 720);

  boids = new ArrayList<Boid>();

  for (int i = 0; i < POPULATION; i++) {
    boids.add(new Boid());
  }
}

void draw() {
  background(0);
    
  if(mousePressed) {  
    noStroke();
    fill(255,20);
  } else {
    strokeWeight(1.8);
    stroke(255,20);
    noFill();
  }
  ellipse(mouseX,mouseY,Boid.MOUSE_R,Boid.MOUSE_R);
  
  for (Boid b : boids) {
    b.update(boids);
  }
  for (Boid b : boids) {
    b.render();
  }
}

