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
  
  for (Boid b : boids) {
    b.update(boids);
  }
  for (Boid b : boids) {
    b.render();
  }
}

