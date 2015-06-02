class Boid {
  static final float R = 10.0;
  static final float NEIGHBOURHOOD_R = 42.0;
  static final float SEPARATE_R = 2.4 * R;

  static final float MAX_VELOCITY = 3.0;
  static final float W_ALIGNMENT = 0.4;
  static final float W_COHESION = 0.05;
  static final float W_SEPARATION = 0.5;

  PVector position;
  PVector velocity;
  color shade;

  Boid() {
    position = new PVector(random(width), random(height));
    velocity = new PVector(random(-2.0, 2.0), random(-2.0, 2.0));
    shade = color(0, 0, 0);
  }

  void render() {
    PVector col = velocity.get();
    col.normalize();
    col.mult(255);
    shade = color(col.x, col.y, 128);

    pushMatrix();
    translate(position.x, position.y);
    rotate(-(float)atan2(-velocity.y, velocity.x));

    noStroke();
    fill(shade);
    ellipseMode(RADIUS);
    ellipse(0, 0, R, R);
    stroke(220);
    strokeWeight(1);
    line(0, 0, R, 0);

    popMatrix();
  } 

  void update(ArrayList boids) {
    ArrayList neighbours = getNeighbours(boids);

    PVector centre = new PVector();
    PVector averVel = new PVector();

    PVector cohesion = new PVector();
    PVector separation = new PVector();
    PVector alignment = new PVector();

    for (int i = 0; i < neighbours.size (); i++) {
      Boid b = (Boid)neighbours.get(i);

      PVector deltaPos = PVector.sub(b.position, position);
      float distanceSq = deltaPos.magSq(); 
      PVector deltaVel = PVector.sub(b.velocity, velocity);

      centre.add(b.position);
      averVel.add(b.velocity);

      if (deltaPos.magSq() < pow(SEPARATE_R, 2)) {
        PVector sepVec = deltaPos.get();
        sepVec.mult(-1.0);
        separation.add(sepVec);
      }
    }
    if (neighbours.size() > 0) {
      centre.div(neighbours.size());
      cohesion = PVector.sub(centre, position);

      separation.div(neighbours.size());

      averVel.div(neighbours.size());
      alignment = PVector.sub(averVel, velocity);
    }

    if (cohesion.magSq() > 0.0)   cohesion.normalize();
    cohesion.mult(W_COHESION);
    if (separation.magSq() > 0.0) separation.normalize();
    separation.mult(W_SEPARATION);
    if (alignment.magSq() > 0.0)  alignment.normalize();
    alignment.mult(W_ALIGNMENT);

    PVector acceleration = new PVector();
    acceleration.add(cohesion);
    acceleration.add(separation);
    acceleration.add(alignment);

    velocity.add(acceleration);

    if (velocity.magSq() > pow(MAX_VELOCITY, 2)) {
      velocity.normalize();
      velocity.mult(MAX_VELOCITY);
    }

    position.add(velocity);

    clip();
  }

  Boolean clip() {
    Boolean c = false;
    if (position.x > width) { 
      position.x = position.x - width;  
      c = true;
    }
    if (position.x < 0) { 
      position.x = position.x + width;  
      c = true;
    }
    if (position.y > height) { 
      position.y = position.y - height; 
      c = true;
    }
    if (position.y < 0) { 
      position.y = position.y + height; 
      c = true;
    }
    return c;
  }

  // Returns a list of this boid's neighbours within NEIGHBOURHOOD_R
  private ArrayList getNeighbours(ArrayList boids) {
    ArrayList neighbours = new ArrayList();

    for (int i = 0; i < boids.size (); i++) {
      Boid b = (Boid)boids.get(i); 

      if (b == this) continue;

      PVector deltaVec = PVector.sub(b.position, position);
      float distanceSq = deltaVec.magSq();

      if (distanceSq < pow(NEIGHBOURHOOD_R, 2)) {
        neighbours.add(b);
      }
    }
    return neighbours;
  }
}

