class Patch {
  PatchGrid p;
  int x;
  int y;
  color c;
  int[] inbrs;
  Patch(PatchGrid p, int x, int y) {
    this(p, x, y, color(0));
  }
  Patch(PatchGrid p, int x, int y, color c) {
    this.p = p;
    this.x = x;
    this.y = y;
    setColor(c);
    inbrs = new int[8];
    inbrs[0] = ipatch(x+0,y-1);    // north
    inbrs[1] = ipatch(x+1,y-1);    // northeast
    inbrs[2] = ipatch(x+1,y+0);    // east
    inbrs[3] = ipatch(x+1,y+1);    // southeast
    inbrs[4] = ipatch(x+0,y+1);    // south    
    inbrs[5] = ipatch(x-1,y+1);    // southwest    
    inbrs[6] = ipatch(x-1,y+0);    // west    
    inbrs[7] = ipatch(x-1,y-1);    // northwest
  }
  void setColor(color c) {
    this.c = c;
    set(x, y, c);
  }
  color getColor() {
    return c;
  }
  int getX() {
    return x;
  }
  int getY() {
    return y;
  }
  int ipatch(int x, int y) {
    return p.ipatch(x,y);
  }
  Patch patch(int x, int y) {
    return p.patch(x,y);
  }
  Patch patch(int i) {
    return p.patch(i);
  }
  Patch neighbor4(int dir) {
    return neighbor8(dir*2);
  }
  Patch neighbor8(int dir) {
    return patch(inbrs[dir%8]);
  }
  Patch oneOfNeighbor4() {
    return neighbor4(int(random(4)));
  }
  Patch oneOfNeighbor8() {
    return neighbor8(int(random(8)));
  }

  //
  // begin code for mudcrack simulation
  //
  int liquid;
  int particle;
  int nliquid;
  int nparticle;
  
  Patch(PatchGrid p, int x, int y, boolean isLiquid) {
    this(p, x, y);
    if (isLiquid)
      makeLiquid();
    else
      makeParticle();
  }
  void makeVapor() {
    liquid = 0;
    particle = 0;
    setColor(vaporColor);
  }
  void makeLiquid() {
    liquid = 1;
    particle = 0;
    setColor(liquidColor);
  }
  void makeParticle() {
    liquid = 0;
    particle = 1;
    setColor(particleColor);
  }
  boolean isVapor() {
    return liquid == 0 && particle == 0;
  }
  boolean isLiquid() {
    return liquid == 1;
  }
  boolean isParticle() {
    return particle == 1;
  }
  void sumNeighbors() {
    nliquid = 0;
    nparticle = 0;
    for (int i = 0; i < 4; i += 1) {
      Patch n = neighbor4(i);
      nliquid += n.liquid;
      nparticle += n.particle;
    }
  }
  
  void tryEvaporate() {
    sumNeighbors();
    if (accept(energyOfEvaporation())) {
      makeVapor();
    }
  }
  void tryCondense() {
    sumNeighbors();
    if (accept(energyOfCondensation())) {
      makeLiquid();
    }
  }
  void tryMoving() {
    Patch dir = oneOfNeighbor4();
    if (dir.isLiquid()) {
      sumNeighbors();
      dir.sumNeighbors();
      if (accept(energyOfMotion(dir))) {
        makeLiquid();
        dir.makeParticle();
      }
    }
  }
  boolean accept(float deltaH) {
    return p.accept(deltaH);
  }
  float energyOfEvaporation() {
    return energyAsVapor() - energyAsLiquid();
  }
  float energyOfCondensation() {
    return energyAsLiquid() - energyAsVapor();
  }
  float energyOfMotion(Patch dir) {
    return energyAsLiquidMoving() - energyAsParticle()
             + dir.energyAsParticleMoving() - dir.energyAsLiquid();
  }
  float energyAsVapor() {
    return 0;
  }
  float energyAsLiquid() {
    return (-eps_ll * nliquid) - (eps_nl * nparticle) - mu;
  }
  float energyAsParticle() { 
    return (- eps_nn * nparticle) - (eps_nl * nliquid);
  }
  float energyAsLiquidMoving() {
    // this cell is a particle trying to move into an adjacent liquid cell,
    // so when we evaluate the energy as a liquid we assume that one of 
    // the neighboring liquid cells has become a particle,
    // hence nliquid is 1 too big, and nparticle is 1 too small
    return (-eps_ll * (nliquid - 1)) - (eps_nl * (nparticle + 1)) - mu;
  }
  float energyAsParticleMoving() {
    // this cell is a liquid trying to be displaced by a particle
    // hence nliquid is 1 too small and nparticle is 1 too big
    return (-eps_nn * (nparticle - 1)) - (eps_nl * (nliquid + 1));
  }
  String toString() {
    return "(l "+liquid+", p "+particle+", x "+x+", y "+y+")";
  }
}

class PatchGrid {
  int iwidth;
  int iheight;
  int area;
  Patch[] grid;
  PatchGrid(int iwidth, int iheight) {
    this.iwidth = iwidth;
    this.iheight = iheight;
    this.area = iwidth * iheight;
    this.grid = new Patch[area];
    for (int i = 0; i < area; i += 1) {
      int x = i % iwidth;
      int y = i / iwidth;
      this.grid[i] = new Patch(this, x, y);
    }
  }
  Patch patch(int x, int y) {
    return patch(ipatch(x, y));
  }
  Patch patch(int i) {
    return grid[i];
  }
  int ipatch(int x, int y) {
    y = y%iheight;
    x = x%iwidth;
    if (y < 0) y += iheight;
    if (x < 0) x += iwidth;
    return y*iwidth+x;
  }
  Patch randomPatch() {
    return patch(int(random(area)));
  }
  
  float coverage;
  PatchGrid(int iwidth, int iheight, float coverage) {
    this(iwidth, iheight);
    this.coverage = coverage;
    for (int i = 0; i < area; i += 1) {
      if (random(1.0) >= coverage)
        patch(i).makeLiquid();
      else
        patch(i).makeParticle();
    }
    initialize();
  }
  
  // map floats into exp(floats)
  // there are 3 states for each cell, 
  // so there are 3^5 nearest neighbor configurations,
  // so there aren't that many different values of deltaH
  // that will be passed to accept.
  class ExpMap {
    float[] f;
    float[] expf;
    int n;
    ExpMap(int size) {
      f = new float[size];
      expf = new float[size];
      n = 0;
    }
    float exp(float num) {
      for (int i = 0; i < n; i += 1)
        if (f[i] == num)
          return expf[i];
      f[n] = num;
      expf[n] = PApplet.exp(num);
      // System.out.println("f["+n+"] = "+f[n]+" -> "+expf[n]);
      n += 1;
      return expf[n-1];
    }
  }
      
  ExpMap map;
  
  boolean accept(float deltaH) {
    if (deltaH <= 0) return true;
    return random(1.0) < map.exp(-deltaH);
    // return random(1.0) < exp(-deltaH);
  }
  
  float pAttemptMovement = 1.0;
  float pAttemptTransition = 1.0;

  void initialize() {
    // pmove ~= N[particle movement attempts] / N[phase transition attempts] in the limit
    // N = N[particle patches chosen] + N[liquid vapor patches chosen]
    // N[particle patches chosen] ~= N * coverage
    // N[liquid vapor patches chosen] ~= N * (1 - coverage)
    // N[particle movement attempts] ~= P[attempt movement] * N * coverage
    // N[phase transition attempts] ~= P[attempt transition] * N * (1 - coverage)
    // hence pmove = P[attempt movement] * N * coverage / (P[attempt transition] * N * (1 - coverage)
    // and pmove * P[attempt transition] * (1-coverage) / coverage = P[attempt movement]
    // if we set P[attempt transition] = 1, then P[attempt movement] = pmove * (1-coverage) / coverage
    // if we set P[attempt movement] = 1, then P[attempt transition] = coverage / (pmove * (1 - coverage))
    // one of those two should yield a usable probability.
    if (coverage == 0 || coverage == 1) {
      pAttemptMovement = 1;
      pAttemptTransition = 1;
    } else {
      pAttemptTransition = 1.0;
      pAttemptMovement = pmove * (1-coverage) / coverage;
      if (pAttemptMovement > 1.0) {
        pAttemptTransition = 1 / pAttemptMovement;
        pAttemptMovement = 1.0;
      }
    }
    // System.out.println("pAttemptMovement = "+pAttemptMovement+", pAttemptTransition = "+pAttemptTransition);
    // accept - memoize the return values of exp for accept, because there are only a handful that get used
    map = new ExpMap(1024);
  }
  void simulate() {
    Patch p = randomPatch();
    if (p.isParticle()) {
      if (pAttemptMovement == 1.0 || random(1.0) < pAttemptMovement)
        p.tryMoving();
    } else {
      if (pAttemptTransition == 1.0 || random(1.0) < pAttemptTransition)
        if (p.isLiquid())
          p.tryEvaporate();
        else
          p.tryCondense();
    }
  }
}

float coverage = 0.40;  // proportion of particles
float eps_ll = 2.01;    // energy of liquid-liquid patch boundary (kT)
float eps_nl = 3.02;    // energy of particle-liquid patch boundary (kT)
float eps_nn = 4.03;    // energy of particle-particle patch boundary (kT)
float mu = -5.50;       // potential of evaporation (kT)
float pmove = 0.01;     // probability of movement, given a particle

color vaporColor = mycolor("#8a4c2d");      // color of vapor patches
color liquidColor = mycolor("#cdb249");     // color of liquid patches
color particleColor = mycolor("#ca9048");   // color of particle patches

int iwidth = 201;        // width of patch array
int iheight = 201;       // height of patch array
int iframerate = 30;     // framerate of update

PatchGrid grid;

String[][] pinfo = {
  { "coverage", "0.0 - 1.0", "proportion of particles" },
  { "eps_ll", "0.0 - 8.0", "energy of liquid-liquid patch boundary (kT)" },
  { "eps_nl", "0.0 - 8.0", "energy of particle-liquid patch boundary (kT)" },
  { "eps_nn", "0.0 - 8.0", "energy of particle-particle patch boundary (kT)" },
  { "mu", "-8.0 - 0.0", "potential of vaporization (kT)" },
  { "pmove", "0.0 - 1.0", "probability of particle motion" },
  { "vaporColor", "#000000", "color of vapor" },
  { "liquidColor", "#888888", "color of liquid" },
  { "particleColor", "#ffffff", "color of particles" },
  { "iwidth", "pixels", "width of cell array" },
  { "iheight", "pixels", "height of cell array" },
  { "iframerate", "fps", "frame rate of simulation" } 
};

String[][] getParameterInfo() {
  return pinfo;
}

void params() {
  for (int i = 0; i < pinfo.length; i += 1) {
    String name = pinfo[i][0];
    String value =  param(name);
    if (value != null)
      setParam(name, value);
  }
}

color mycolor(String s) {
  int c;
  if (s.startsWith("0x") || s.startsWith("0X"))
    c = Integer.parseInt(s.substring(2), 16);
  else if (s.startsWith("#"))
    c = Integer.parseInt(s.substring(1), 16);
  else
    c = Integer.parseInt(s);
  return color((c>>16)&0xff, (c>>8)&0xff, c&0xff);
}

boolean report_velocity = false;
float velocity = 0;
int nsamples = 0;

void setup() {
  // report_velocity = true;
  if (online) params();
  size(iwidth, iheight);
  frameRate(iframerate);
  grid = new PatchGrid(iwidth, iheight, coverage);
}

void draw() {
  int start = millis();
  int end = start + int((1000.0 / iframerate) * 0.9);
  int steps = 0;
  while (millis() < end) {
    grid.simulate();
    steps += 1;
  }
  if (report_velocity) {
    velocity = (nsamples * velocity + steps / ((end - start) / 1000.0)) / (nsamples + 1);
    nsamples += 1;
    if ((nsamples % (iframerate * 5)) == 0)
      System.out.println(velocity+" steps/second over "+nsamples+" frames");
  }
}

// this is for javascript update in medius res
// NB - only somethings can change in medius res
// but it's also used for parsing params at the start
void setParam(String name, String value) {
  if (name.equals("coverage")) coverage = Float.parseFloat(value);
  if (name.equals("eps_ll")) eps_ll = Float.parseFloat(value);
  if (name.equals("eps_nl")) eps_nl = Float.parseFloat(value);
  if (name.equals("eps_nn")) eps_nn = Float.parseFloat(value);
  if (name.equals("mu")) mu = Float.parseFloat(value);
  if (name.equals("pmove")) pmove = Float.parseFloat(value);
  if (name.equals("vaporColor")) vaporColor = mycolor(value);
  if (name.equals("liquidColor")) liquidColor = mycolor(value);
  if (name.equals("particleColor")) particleColor = mycolor(value);
  if (name.equals("iwidth")) iwidth = Integer.parseInt(value);
  if (name.equals("iheight")) iheight = Integer.parseInt(value);
  if (name.equals("iframerate")) iframerate = Integer.parseInt(value);
}
