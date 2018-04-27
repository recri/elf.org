import processing.core.*; import java.applet.*; import java.awt.*; import java.awt.image.*; import java.awt.event.*; import java.io.*; import java.net.*; import java.text.*; import java.util.*; import java.util.zip.*; public class mudcrack extends PApplet {class Patch {
  PatchGrid p;
  int x;
  int y;
  int c;
  int[] inbrs;
  Patch(PatchGrid p, int x, int y) {
    this(p, x, y, color(0));
  }
  Patch(PatchGrid p, int x, int y, int c) {
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
  public void setColor(int c) {
    this.c = c;
    set(x, y, c);
  }
  public int getColor() {
    return c;
  }
  public int getX() {
    return x;
  }
  public int getY() {
    return y;
  }
  public int ipatch(int x, int y) {
    return p.ipatch(x,y);
  }
  public Patch patch(int x, int y) {
    return p.patch(x,y);
  }
  public Patch patch(int i) {
    return p.patch(i);
  }
  public Patch neighbor4(int dir) {
    return neighbor8(dir*2);
  }
  public Patch neighbor8(int dir) {
    return patch(inbrs[dir%8]);
  }
  public Patch oneOfNeighbor4() {
    return neighbor4(PApplet.toInt(random(4)));
  }
  public Patch oneOfNeighbor8() {
    return neighbor8(PApplet.toInt(random(8)));
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
  public void makeVapor() {
    liquid = 0;
    particle = 0;
    setColor(vaporColor);
  }
  public void makeLiquid() {
    liquid = 1;
    particle = 0;
    setColor(liquidColor);
  }
  public void makeParticle() {
    liquid = 0;
    particle = 1;
    setColor(particleColor);
  }
  public boolean isVapor() {
    return liquid == 0 && particle == 0;
  }
  public boolean isLiquid() {
    return liquid == 1;
  }
  public boolean isParticle() {
    return particle == 1;
  }
  public void sumNeighbors() {
    nliquid = 0;
    nparticle = 0;
    for (int i = 0; i < 4; i += 1) {
      Patch n = neighbor4(i);
      nliquid += n.liquid;
      nparticle += n.particle;
    }
  }
  
  public void tryEvaporate() {
    sumNeighbors();
    if (accept(energyOfEvaporation())) {
      makeVapor();
    }
  }
  public void tryCondense() {
    sumNeighbors();
    if (accept(energyOfCondensation())) {
      makeLiquid();
    }
  }
  public void tryMoving() {
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
  public boolean accept(float deltaH) {
    return p.accept(deltaH);
  }
  public float energyOfEvaporation() {
    return energyAsVapor() - energyAsLiquid();
  }
  public float energyOfCondensation() {
    return energyAsLiquid() - energyAsVapor();
  }
  public float energyOfMotion(Patch dir) {
    return energyAsLiquidMoving() - energyAsParticle()
             + dir.energyAsParticleMoving() - dir.energyAsLiquid();
  }
  public float energyAsVapor() {
    return 0;
  }
  public float energyAsLiquid() {
    return (-eps_ll * nliquid) - (eps_nl * nparticle) - mu;
  }
  public float energyAsParticle() { 
    return (- eps_nn * nparticle) - (eps_nl * nliquid);
  }
  public float energyAsLiquidMoving() {
    // this cell is a particle trying to move into an adjacent liquid cell,
    // so when we evaluate the energy as a liquid we assume that one of 
    // the neighboring liquid cells has become a particle,
    // hence nliquid is 1 too big, and nparticle is 1 too small
    return (-eps_ll * (nliquid - 1)) - (eps_nl * (nparticle + 1)) - mu;
  }
  public float energyAsParticleMoving() {
    // this cell is a liquid trying to be displaced by a particle
    // hence nliquid is 1 too small and nparticle is 1 too big
    return (-eps_nn * (nparticle - 1)) - (eps_nl * (nliquid + 1));
  }
  public String toString() {
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
  public Patch patch(int x, int y) {
    return patch(ipatch(x, y));
  }
  public Patch patch(int i) {
    return grid[i];
  }
  public int ipatch(int x, int y) {
    y = y%iheight;
    x = x%iwidth;
    if (y < 0) y += iheight;
    if (x < 0) x += iwidth;
    return y*iwidth+x;
  }
  public Patch randomPatch() {
    return patch(PApplet.toInt(random(area)));
  }
  
  float coverage;
  PatchGrid(int iwidth, int iheight, float coverage) {
    this(iwidth, iheight);
    this.coverage = coverage;
    for (int i = 0; i < area; i += 1) {
      if (random(1.0f) >= coverage)
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
    public float exp(float num) {
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
  
  public boolean accept(float deltaH) {
    if (deltaH <= 0) return true;
    return random(1.0f) < map.exp(-deltaH);
    // return random(1.0) < exp(-deltaH);
  }
  
  float pAttemptMovement = 1.0f;
  float pAttemptTransition = 1.0f;

  public void initialize() {
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
      pAttemptTransition = 1.0f;
      pAttemptMovement = pmove * (1-coverage) / coverage;
      if (pAttemptMovement > 1.0f) {
        pAttemptTransition = 1 / pAttemptMovement;
        pAttemptMovement = 1.0f;
      }
    }
    // System.out.println("pAttemptMovement = "+pAttemptMovement+", pAttemptTransition = "+pAttemptTransition);
    // accept - memoize the return values of exp for accept, because there are only a handful that get used
    map = new ExpMap(1024);
  }
  public void simulate() {
    Patch p = randomPatch();
    if (p.isParticle()) {
      if (pAttemptMovement == 1.0f || random(1.0f) < pAttemptMovement)
        p.tryMoving();
    } else {
      if (pAttemptTransition == 1.0f || random(1.0f) < pAttemptTransition)
        if (p.isLiquid())
          p.tryEvaporate();
        else
          p.tryCondense();
    }
  }
}

float coverage = 0.40f;  // proportion of particles
float eps_ll = 2.01f;    // energy of liquid-liquid patch boundary (kT)
float eps_nl = 3.02f;    // energy of particle-liquid patch boundary (kT)
float eps_nn = 4.03f;    // energy of particle-particle patch boundary (kT)
float mu = -5.50f;       // potential of evaporation (kT)
float pmove = 0.01f;     // probability of movement, given a particle

int vaporColor = mycolor("#8a4c2d");      // color of vapor patches
int liquidColor = mycolor("#cdb249");     // color of liquid patches
int particleColor = mycolor("#ca9048");   // color of particle patches

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

public String[][] getParameterInfo() {
  return pinfo;
}

public void params() {
  String value;
  if ((value = param("coverage")) != null) coverage = Float.parseFloat(value);
  if ((value = param("eps_ll")) != null) eps_ll = Float.parseFloat(value);
  if ((value = param("eps_nl")) != null) eps_nl = Float.parseFloat(value);
  if ((value = param("eps_nn")) != null) eps_nn = Float.parseFloat(value);
  if ((value = param("mu")) != null) mu = Float.parseFloat(value);
  if ((value = param("pmove")) != null) pmove = Float.parseFloat(value);
  if ((value = param("vaporColor")) != null) vaporColor = mycolor(value);
  if ((value = param("liquidColor")) != null) liquidColor = mycolor(value);
  if ((value = param("particleColor")) != null) particleColor = mycolor(value);
  if ((value = param("iwidth")) != null) iwidth = Integer.parseInt(value);
  if ((value = param("iheight")) != null) iheight = Integer.parseInt(value);
  if ((value = param("iframerate")) != null) iframerate = Integer.parseInt(value);
}

public int mycolor(String s) {
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

public void setup() {
  // report_velocity = true;
  if (online) params();
  size(iwidth, iheight);
  framerate(iframerate);
  grid = new PatchGrid(iwidth, iheight, coverage);
}

public void draw() {
  int start = millis();
  int end = start + PApplet.toInt((1000.0f / iframerate) * 0.9f);
  int steps = 0;
  while (millis() < end) {
    grid.simulate();
    steps += 1;
  }
  if (report_velocity) {
    velocity = (nsamples * velocity + steps / ((end - start) / 1000.0f)) / (nsamples + 1);
    nsamples += 1;
    if ((nsamples % (iframerate * 5)) == 0)
      System.out.println(velocity+" steps/second over "+nsamples+" frames");
  }
}

static public void main(String args[]) {   PApplet.main(new String[] { "mudcrack" });}}