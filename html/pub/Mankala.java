/*
** A mankala game applet/application.
**
** Copyright 1996 by Roger E. Critchlow Jr.,
** San Francisco, California,
** all rights reserved,
** fair use permitted,
** caveat emptor,
** no warranty.
*/

import java.applet.*;
import java.awt.*;

/**
 * The Mankala class builds a frame and instantiates a menubar, board
 * display, and a match manager to run the game.
*/
public class Mankala extends Applet {
  /*
   * The frame.
   */
  Frame f = new Frame("Mankala");

  /*
   * The menubar.
   */
  MankalaMenuBar menubar = new MankalaMenuBar(this);

  /*
   * The mankala display.
   */
  MankalaDisplay display = new MankalaDisplay();

  /*
   * The match in progress.
   */
  MankalaMatch match = new MankalaMatch(menubar, display);

  /*
   * Application begins.
   *
   * Nota bene - this only works because the applet doesn't call
   * any applet context specific services.  In general, an applet
   * needs more environment.
   */
  public static void main(String args[]) {
    Mankala m = new Mankala();
    m.init();
    m.start();
  }

  /*
   * Applet begins.
   */
  public void init() {
    f.setMenuBar(menubar);
    f.setLayout(new BorderLayout());
    f.add("Center", display);
    f.resize(600,200);
  }
    
  /*
   * Applet starts.
   */
  public void start() {
    f.show();
    match.resume();
  }
  
  /*
   * Applet stops.
   */
  public void stop() {
    match.suspend();
    f.hide();
  }

}

/**
 * The MankalaMenuBar class catches menubar events.
 */
class MankalaMenuBar extends MenuBar {
  MankalaMatch match = null;
  Mankala app = null;

  Menu game = new Menu("Game", false);
  Menu stones = new Menu("Stones", false);
  Menu turn = new Menu("Turn", false);
  Menu north = new Menu("North", false);
  Menu south = new Menu("South", false);
  Menu message = new Menu("Initializing ...", false);
  Menu count = new Menu(".. stones", false);

  MankalaMenuBar(Mankala app) {
    super();

    this.app = app;

    this.add(game);
    this.add(stones);
    this.add(turn);
    this.add(north);
    this.add(south);
    this.add(message);
    this.add(count);

    game.add(new MenuItem("Mankala"));
    game.add(new MenuItem("Manbula"));
    game.addSeparator();
    game.add(new CheckboxMenuItem("Symmetric"));
    game.add(new CheckboxMenuItem("Replay"));
    game.add(new CheckboxMenuItem("Capture Across"));
    game.add(new CheckboxMenuItem("Capture to Home"));
    game.add(new CheckboxMenuItem("Continue"));

    stones.add(new CheckboxMenuItem("3 stones"));
    stones.add(new CheckboxMenuItem("4 stones"));
    stones.add(new CheckboxMenuItem("5 stones"));
    stones.add(new CheckboxMenuItem("6 stones"));

    turn.add(new CheckboxMenuItem("North to play"));
    turn.add(new CheckboxMenuItem("South to play"));

    String strategies[] = MankalaPlayer.strategies;
    for (int i = 0; i < strategies.length; i += 1) {
      north.add(new CheckboxMenuItem(strategies[i]));
      south.add(new CheckboxMenuItem(strategies[i]));
    }

    message.add(new MenuItem("Mankala by rec@elf.org"));
    count.add(new MenuItem("Mankala by rec@elf.org"));
  }

  public boolean postEvent(Event e) {
    super.postEvent(e);
    if (e.arg.equals("Mankala")) {
      match.setGame("Mankala");
      return true;
    }
    if (e.arg.equals("Manbula")) {
      match.setGame("Manbula");
      return true;
    }
    if (e.arg.equals("Symmetric")) { 
      boolean symmetric = ((CheckboxMenuItem)e.target).getState();
      match.setGame(symmetric, match.replay, match.across, match.to_home, match.manbula);
      return true;
    }
    if (e.arg.equals("Replay")) {
      boolean replay = ((CheckboxMenuItem)e.target).getState();
      match.setGame(match.symmetric, replay, match.across, match.to_home, match.manbula);
      return true;
    }
    if (e.arg.equals("Capture Across")) {
      boolean across = ((CheckboxMenuItem)e.target).getState();
      match.setGame(match.symmetric, match.replay, across, false, match.manbula);
      return true;
    }
    if (e.arg.equals("Capture to Home")) {
      boolean to_home = ((CheckboxMenuItem)e.target).getState();
      match.setGame(match.symmetric, match.replay, false, to_home, match.manbula);
      return true;
    }
    if (e.arg.equals("Continue")) {
      boolean manbula = ((CheckboxMenuItem)e.target).getState();
      match.setGame(match.symmetric, match.replay, match.across, match.to_home, manbula);
      return true;
    }
    if (e.arg.equals("3 stones")) {
      match.setNStones(3);
      return true;
    }
    if (e.arg.equals("4 stones")) {
      match.setNStones(4);
      return true;
    }
    if (e.arg.equals("5 stones")) {
      match.setNStones(5);
      return true;
    }
    if (e.arg.equals("6 stones")) {
      match.setNStones(6);
      return true;
    }
    if (e.arg.equals("North to play")) {
      match.setSouthToPlay(false);
      return true;
    }
    if (e.arg.equals("South to play")) {
      match.setSouthToPlay(true);
      return true;
    }
    if (e.arg.equals("Mankala by rec@elf.org")) {
      return true;
    }
    String strategies[] = MankalaPlayer.strategies;
    for (int i = 0; i < strategies.length; i += 1) {
      if (e.arg.equals(strategies[i])) {
	if (((MenuItem)e.target).getParent().equals(north))
	  match.setNorth(strategies[i]);
	else
	  match.setSouth(strategies[i]);
	return true;
      }
    }
    System.out.println("menu event: "+e);
    return false;
  }

  void setMatch(MankalaMatch match) {
    this.match = match;

    ((CheckboxMenuItem)game.getItem(3)).setState(match.symmetric);
    ((CheckboxMenuItem)game.getItem(4)).setState(match.replay);
    ((CheckboxMenuItem)game.getItem(5)).setState(match.across);
    ((CheckboxMenuItem)game.getItem(6)).setState(match.to_home);
    ((CheckboxMenuItem)game.getItem(7)).setState(match.manbula);

    ((CheckboxMenuItem)stones.getItem(0)).setState(match.nstones == 3);
    ((CheckboxMenuItem)stones.getItem(1)).setState(match.nstones == 4);
    ((CheckboxMenuItem)stones.getItem(2)).setState(match.nstones == 5);
    ((CheckboxMenuItem)stones.getItem(3)).setState(match.nstones == 6);
    
    ((CheckboxMenuItem)turn.getItem(0)).setState(! match.southToPlay);
    ((CheckboxMenuItem)turn.getItem(1)).setState(match.southToPlay);

    String strategies[] = MankalaPlayer.strategies;
    for (int i = 0; i < strategies.length; i += 1) {
      ((CheckboxMenuItem)north.getItem(i)).setState(strategies[i].equals(match.northStrategy));
      ((CheckboxMenuItem)south.getItem(i)).setState(strategies[i].equals(match.southStrategy));
    }
  }

  void showMessage(String message) {
    this.message.setLabel(message);
    // I disabled this menu to mark it as an informational field,
    // but the text was rendered illegible by the stippling.
  }

  void showCount(String count) {
    this.count.setLabel(count);
  }

}


/**
 * The MankalaMatch class supervises the play.
 */
class MankalaMatch implements Runnable {
  /**
   * The current position of this match.
   */
  MankalaPosition position = null;
  
  /**
   * Parameters to pass into position constructor.
   */
  boolean symmetric = false;
  boolean replay = true;
  boolean across = true;
  boolean to_home = false;
  boolean manbula = false;
  boolean southToPlay = true;
  int nstones = 3;

  /**
   * Each player may be a person or an algorithm.
   */
  String southStrategy = "Manual";
  String northStrategy = "Greedy";
  MankalaPlayer southPlayer = new MankalaPlayer(this, southStrategy);
  MankalaPlayer northPlayer = new MankalaPlayer(this, northStrategy);

  /*
   * The play runs in its own thread.
   */
  Thread play = null;

  /*
   * We remember our menubar and our display context from the
   * constructor.
   */
  MankalaMenuBar menubar = null;
  MankalaDisplay display = null;
  
  /*
   * Construct an instance.
   */
  MankalaMatch(MankalaMenuBar menubar, MankalaDisplay display) {
    this.menubar = menubar;
    this.display = display;
    display.setMatch(this);
    menubar.setMatch(this);
    start();
  }
   
  /**
   * Play the game.
   */
  public void run() {

    /* Start the game */
    showMessage("Starting game ...");
    position = new MankalaPosition(symmetric, replay, across, to_home, manbula, southToPlay, nstones);
    display.setMatch(this);
    MankalaPit.RemakePositions();
    display.showPosition(position);
    // If this is done any sooner, then the menus do not reflect the selected options.
    menubar.setMatch(this);

    /* Until the end of the game. */
    while ( ! position.end()) {
      int move = -1;

      /* Take turns */

      if (position.southToPlay) {
	showMessage("South to play ...");
	display.flashPits(MankalaPosition.allSouth);
	do move = southPlayer.takeTurn(); while ( ! position.valid(move));
      } else {
	showMessage("North to play ...");
	display.flashPits(MankalaPosition.allNorth);
	do move = northPlayer.takeTurn(); while ( ! position.valid(move));
      }
      
      /* Display the play */
      position.animate(move, display);
      
      /* Update the position */
      position = position.consequence(move);

      /* Update the toplevel selector */
      menubar.setMatch(this);
    }
    
    /* Score game */
    position.score();
    display.showPosition(position);
    if (position.southScore() < position.northScore())
      showMessage("North wins ...");
    else if (position.northScore() < position.southScore())
      showMessage("South wins ...");
    else
      showMessage("Game tied ...");

    stop();
  }

  /**
   * Advertise.
   */
  void showMessage(String message) {
    menubar.showMessage(message);
  }

  void showCount(String message) {
    menubar.showCount(message);
  }

  /**
   * Adjust state.
   */
  void setSouthToPlay(boolean southToPlay) {
    this.southToPlay = southToPlay;
    start();
  }

  void setNorth(String strategy) {
    northStrategy = strategy;
    northPlayer = new MankalaPlayer(this, strategy);
    start();
  }

  void setSouth(String strategy) {
    southStrategy = strategy;
    southPlayer = new MankalaPlayer(this, strategy);
    start();
  }

  void setNStones(int n) {
    nstones = n;
    start();
  }

  void setGame(String name) {
    if (name.equals("Mankala")) {
      nstones = 3;
      setGame(false, true, true, false, false);
    }
    if (name.equals("Manbula")) {
      nstones = 4;
      setGame(true, true, false, false, true);
    }
  }

  void setGame(boolean symmetric, boolean replay, boolean across, boolean to_home, boolean manbula) {
    this.symmetric = symmetric;
    this.replay = replay;
    this.across = across;
    this.to_home = to_home;
    this.manbula = manbula;
    start();
  }

  /**
   * Adjust thread state.
   */
  void start() {
    if (play != null)
      play.stop();
    play = new Thread(this);
    play.setPriority(play.getPriority()-1);
    play.start();
  }

  void suspend() {
    play.suspend();
  }

  void stop() {
    play.stop();
    play = null;
  }

  void resume() {
    play.resume();
  }
}

/**
 * The MankalaPosition class implements the game rules and a tree of
 * positions that the game passes through or past.  The game rules are
 * summarized by four boolean variables, to give 16 variants.  Each of
 * these can be played with 3 to 6 stones in each play pit.
 */
class MankalaPosition {
  /*
   * These four fields define the rulse of the game which is being
   * played.
   */
  /**
   * Is this a symmetric game in which players are allowed to choose
   * any play pit on the board, or is it an asymmetric game in which
   * players are limited to their own play pits only.
   */
  boolean symmetric = false;

  /**
   * Does this game implement the replay rule in which a play which ends
   * in a player's home pit allows the player to play again.
   */
  boolean replay = true;

  /**
   * Does this game implement the capture rule in which a play into an
   * empty play pit captures the stones in the opposite pit into the
   * capturing pit.  This rule is implemented symmetrically for
   * symmetric games, and asymmetrically for asymmetric games.
   */
  boolean across = true;

  /**
   * Does this game implement the capture rule in which a play into an
   * empty play pit captures the stones in the opposite pit into the
   * player's home pit.  This rule is implemented symmetrically for
   * symmetric games, and  asymmetrically for asymmetric games.
   */
  boolean to_home = false;

  /**
   * Does this game implement manbula play in which a play which ends
   * in a nonempty play pit continues by playing the stones from that
   * pit as from the beginning of the turn.
   */
  boolean manbula = false;
   
  /**
   * The number of stones to play into the play pits to initiate the
   * game.
   */
  int nstones = 3;

  /**
   * The players take turns.  Is it south's turn now?
   */
  boolean southToPlay = true;

  /**
   * The board consists of fourteen pits, seven for the north player
   * and seven for the south player.  The north pits are numbered from
   * 0 to 6, the south pits are numbered from 7 to 13.  The seventh
   * pit in each set is the player's home pit, the first six pits are
   * the player's play  pits.
   */
  int board[] = { 0, 0, 0, 0, 0, 0, 0,
		  0, 0, 0, 0, 0, 0, 0 };

  /**
   * The antecedent position for a consequent position.
   */
  MankalaPosition antecedent = null;

  /**
   * The consequent positions for each valid move.
   */
  MankalaPosition consequent[] = new MankalaPosition[14];

  /**
   * Did the last play result in a replay.
   */
  boolean tookReplay = false;
  
  /**
   * Did the last play result in a capture.
   */
  boolean tookCapture = false;

  /**
   * The last play made this many manbula continuations.
   */
  int tookManbula = 0;

  /**
   * Two of the pits are 'home' pits.
   */
  static final int northHome = 6;
  static final int southHome = 13;
  static final int homePits[] = { 6, 13 };

  /**
   * The other twelve pits are play pits.
   */
  static final int northPlay[] = { 0, 1, 2, 3, 4, 5 };
  static final int southPlay[] = { 7, 8, 9, 10, 11, 12 };
  static final int playPits[] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11, 12 };

  /**
   * Sometimes they need to be treated as groups.
   */
  static final int allNorth[] = { 0, 1, 2, 3, 4, 5, 6 };
  static final int allSouth[] = { 7, 8, 9, 10, 11, 12, 13 };
  static final int allPits[] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 };

  /**
   * Sometimes we need to know the pit opposite a given pit.
   */
  static final int oppositePit[] = { 12, 11, 10, 9, 8, 7, 13, 5, 4, 3, 2, 1, 0, 6 };

  /**
   * Sometimes we need to know the successor of a given pit.
   */
  static final int northSuccessor[] = { 1, 2, 3, 4, 5, 6,  7, 8, 9, 10, 11, 12,  0, -1 };
  static final int southSuccessor[] = { 1, 2, 3, 4, 5, 7, -1, 8, 9, 10, 11, 12, 13,  0 };

  /**
   * Sometimes we want to see the pits ordered with the home pit last.
   */
  static final int northMoves[] = { 7, 8, 9, 10, 11, 12, 0, 1, 2, 3, 4, 5 };
  static final int southMoves[] = { 0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11, 12 };

  /**
   * Sum the stones in a set of pits.
   */
  int sumPits(int pits[]) {
    int sum = 0;
    for (int i = 0; i < pits.length; i += 1)
      sum += board[pits[i]];
    return sum;
  }

  /**
   * Decide if a pit occurs in a list of pits.
   */
  static boolean memberPit(int pit, int pits[]) {
    for (int i = 0; i < pits.length; i += 1)
      if (pit == pits[i])
	return true;
    return false;
  }

  /**
   * Empty a list of pits and return the number of stones found.
   */
  int emptyPits(int pits[]) {
    int stones = 0;
    for (int i = 0; i < pits.length; i += 1) {
      stones += board[pits[i]];
      board[pits[i]] = 0;
    }
    return stones;
  }

  /**
   * Distribute stones into a list of pits.
   */
  void distributeStones(int pits[], int stones) {
    for (int i = 0; stones > 0 && i < pits.length - 1; i += 1) {
      int n = nstones < stones ?  nstones : stones;
      board[pits[i]] += n;
      stones -= n;
    }
    if (stones > 0)
      board[pits[pits.length-1]] += stones;
  }

  /**
   * Construct a mankala game from scratch.
   */
  MankalaPosition(boolean symmetric, boolean replay, boolean across, boolean to_home,
	      boolean manbula, boolean southToPlay, int nstones) {
    this.symmetric = symmetric;
    this.replay = replay;
    this.across = across;
    this.to_home = to_home;
    this.manbula = manbula;
    this.southToPlay = southToPlay;
    this.nstones = nstones;
    for (int i = 0; i < 6; i += 1)
      board[i] = board[7+i] = nstones;
    board[6] = board[13] = 0;
  }
   
  /**
   * Construct a mankala game as the consequence of a move in an
   * existing game and optionally animate the move on a display.
   */
  MankalaPosition(MankalaPosition antecedent, int move, MankalaDisplay animator) {
    // replicate the game
    this.antecedent = antecedent;
    this.symmetric = antecedent.symmetric;
    this.replay = antecedent.replay;
    this.across = antecedent.across;
    this.to_home = antecedent.to_home;
    this.manbula = antecedent.manbula;
    this.southToPlay = antecedent.southToPlay;
    this.nstones = antecedent.nstones;
    for (int i = 0; i < 14; i += 1)
      this.board[i] = antecedent.board[i];

    if (valid(move)) {
      // perform the move
      int successor[] = ownSuccessor();
      while (true) {
	int stones = board[move];
	board[move] = 0;
	if (animator != null) animator.takeStones(move);
	for (move = successor[move]; stones > 1; move = successor[move]) {
	  stones -= 1;
	  board[move] += 1;
	  if (animator != null) animator.dropStones(move, 1);
	}
	board[move] += 1;
	if (animator != null) animator.dropStones(move, 1);
	if ( ! manbula || move == ownHome() || board[move] == 1)
	  break;
	tookManbula += 1;
      }
      // evaluate capture
      if ((across || to_home) && move != ownHome() && board[move] == 1
	  && (symmetric || ownPit(move)) && board[oppositePit[move]] != 0) {
	if (animator != null) {
	  animator.takeStones(oppositePit[move]);
	  if (across)
	    animator.dropStones(move, board[oppositePit[move]]);
	  else
	    animator.dropStones(ownHome(), board[oppositePit[move]]);
	}
	if (across)
	  board[move] += board[oppositePit[move]];
	else
	  board[ownHome()] += board[oppositePit[move]];
	board[oppositePit[move]] = 0;
	tookCapture = true;
      } 
      // evaluate replay
      if (replay && move == ownHome())
	tookReplay = true;
      else
	southToPlay = ! southToPlay;
    }
  }

  /**
   * Construct a mankala game, as I learned it, with nstones.
   */
  static MankalaPosition mankala(int nstones) {
    return new MankalaPosition(false, true, true, false, false, true, nstones);
  }

  /**
   * Construct a mankala game, as I learned it, with 3 stones.
   */
  static MankalaPosition mankala() {
    return mankala(3);
  }

  /**
   * Construct a manbula game, as Eric taught Caroline, with nstones.
   */
  static MankalaPosition manbula(int nstones) {
    return new MankalaPosition(true, true, false, false, true, true, nstones);
  }

  /**
   * Construct a manbula game, as Eric taught Caroline, with 4 stones.
   */
  static MankalaPosition manbula() {
    return manbula(4);
  }

  /**
   * Return this player's home pit.
   */
  int ownHome() {
    return southToPlay ? southHome : northHome;
  }

  /**
   * Decide if pit belongs to this player.
   */
  boolean ownPit(int pit) {
    return memberPit(pit, southToPlay ? allSouth : allNorth);
  }

  /**
   * Return this player's play pits.
   */
  int[] ownPlayPits() {
    return southToPlay ? southPlay : northPlay;
  }

  /**
   * Return the opponent's play pits.
   */
  int[] otherPlayPits() {
    return southToPlay ? northPlay : southPlay;
  }

  /**
   * Return this player's successor map.
   */
  int[] ownSuccessor() {
    return southToPlay ? southSuccessor : northSuccessor;
  }

  /**
   * Return this player's list of valid moves.
   */
  int[] ownMoves() {
    int own[] = southToPlay ? southMoves : northMoves;
    int n = 0;
    for (int i = 0; i < own.length; i += 1)
      if (valid(own[i]))
	n += 1;
    int moves[] = new int[n];
    n = 0;
    for (int i = 0; i < own.length; i += 1)
      if (valid(own[i]))
	moves[n++] = own[i];
    return moves;
  }

  /**
   * Construct the consequence of a move.
   */
  MankalaPosition consequence(int move) {
    if (valid(move) && consequent[move] == null)
      consequent[move] = new MankalaPosition(this, move, (MankalaDisplay)null);
    return consequent[move];
  }

  /**
   * Animate the consequence of a move.
   */
  void animate(int move, MankalaDisplay display) {
    new MankalaPosition(this, move, display);
  }

  /**
   * Is this a valid move for the current game?
   */
  boolean valid(int move) {
    if (symmetric)
      return memberPit(move, playPits) && board[move] != 0;
    else
      return memberPit(move, ownPlayPits()) && board[move] != 0;
  }

  /**
   * Does this move result in a replay?
   */
  boolean takesReplay(int move) {
    return valid(move) && consequence(move).tookReplay;
  }

  /**
   * Does this move result in a capture?
   */
  boolean takesCapture(int move) {
    return valid(move) && consequence(move).tookCapture;
  }

  /**
   * Does this move result in a manbula continuation?
   */
  boolean takesManbula(int move) {
    return valid(move) && consequence(move).tookManbula != 0;
  }

  /**
   * Is this position the end of the game?
   */
  boolean end() {
    return sumPits(symmetric ? playPits : ownPlayPits()) == 0;
  }

  /**
   * Redistribute stones to score the game.
   */
  void score() {
    distributeStones(allNorth, emptyPits(allNorth));
    distributeStones(allSouth, emptyPits(allSouth));
  }

  /**
   * Return the scores - correct at end of game, only an approximation
   * if not at the end.
   */
  int southScore() {
    return sumPits(allSouth);
  }

  int northScore() {
    return sumPits(allNorth);
  }

}
      
/**
 * The MankalaPlayer class abstracts the interface which the manual
 * and automated players both observe.
 */
class MankalaPlayer {
  /**
   * The match in which we play.
   */
  MankalaMatch match;

  /**
   * The strategy which we employ.
   */
  String strategy;

  /**
   * The strategies which we implement.
   */
  static String strategies[] = {
    "Manual",
    "Random",
    "First",
    "First largest",
    "First smallest",
    "Last",
    "Last largest",
    "Last smallest",
    "Greedy",
  };

  /**
   * Construct a mankala player.
   */
  MankalaPlayer(MankalaMatch match, String strategy) {
    this.match = match;
    this.strategy = strategy;
  }

  /**
   * take a turn from the specified position.
   */
  int pitHit = -1;
  int takeTurn() {
    match.display.setPlayer(this);
    if (strategy.equals("Manual")) {
      if (pitHit == -1)
	match.play.suspend();
      int pit = pitHit;
      pitHit = -1;
      return pit;
    }
    if (strategy.equals("Random"))
      return randomMove(match.position.ownMoves());
    if (strategy.equals("First"))
      return firstMove(match.position.ownMoves());
    if (strategy.equals("First largest"))
      return firstLargestMove(match.position.ownMoves());
    if (strategy.equals("First smallest"))
      return firstSmallestMove(match.position.ownMoves());
    if (strategy.equals("Last"))
      return lastMove(match.position.ownMoves());
    if (strategy.equals("Last largest"))
      return lastLargestMove(match.position.ownMoves());
    if (strategy.equals(    "Last smallest"))
      return lastSmallestMove(match.position.ownMoves());
    if (strategy.equals("Greedy"))
      return greedyMove(match.position.ownMoves());
    return -1;
  }

  /**
   * handle a mouse event during our turn.
   */
  void handleEvent(int pit) {
    if (strategy.equals("Manual")) {
      pitHit = pit;
      match.play.resume();
    }
  }

  /*
   * Various strategies for constructing moves
   */
  /**
   * Pick a random valid move.
   */
  int randomMove(int moves[]) {
    return moves[(int)(Math.random() * moves.length)];
  }

  /**
   * Pick the first, ie farthest from home pit, valid move.
   */
  int firstMove(int moves[]) {
    return moves[0];
  }

  /**
   * Pick the last, ie closest to home pit, valid move.
   */
  int lastMove(int moves[]) {
    return moves[moves.length-1];
  }

  /**
   * Pick the first move with the largest number of stones.
   */
  int firstLargestMove(int moves[]) {
    int max = 0, imax = -1;
    for (int i = 0; i < moves.length; i += 1)
      if (match.position.board[moves[i]] > max) {
	imax = moves[i];
	max = match.position.board[imax];
      }
    return imax;
  }

  /**
   * Pick the last move with the largest number of stones.
   */
  int lastLargestMove(int moves[]) {
    int max = 0, imax = -1;
    for (int i = 0; i < moves.length; i += 1)
      if (match.position.board[moves[i]] >= max) {
	imax = moves[i];
	max = match.position.board[imax];
      }
    return imax;
  }

  /**
   * Pick the first move with the smallest number of stones.
   */
  int firstSmallestMove(int moves[]) {
    int min = 1000, imin = -1;
    for (int i = 0; i < moves.length; i += 1)
      if (match.position.board[moves[i]] < min) {
	imin = moves[i];
	min = match.position.board[imin];
      }
    return imin;
  }

  /**
   * Pick the last move with the smallest number of stones.
   */
  int lastSmallestMove(int moves[]) {
    int min = 1000, imin = -1;
    for (int i = 0; i < moves.length; i += 1)
      if (match.position.board[moves[i]] <= min) {
	imin = moves[i];
	min = match.position.board[imin];
      }
    return imin;
  }

  /**
   * Pick the first move which gives a replay.
   */
  int firstReplayMove(int moves[]) {
    for (int i = 0; i < moves.length; i += 1)
      if (match.position.takesReplay(moves[i]))
	return moves[i];
    return -1;
  }

  /**
   * Pick the last move which gives a replay.
   */
  int lastReplayMove(int moves[]) {
    int move = -1;
    for (int i = 0; i < moves.length; i += 1)
      if (match.position.takesReplay(moves[i]))
	move = moves[i];
    return move;
  }

  /**
   * Pick the move with the largest capture.
   */
  int largestCaptureMove(int moves[]) {
    int move = -1;
    for (int i = 0; i < moves.length; i += 1)
      if (match.position.takesCapture(moves[i]))
	move = moves[i];
    return move;
  }

  /**
   * Take the last replay move, or the largest capture, or the last
   * move.
   */
  int greedyMove(int moves[]) {
    if (lastReplayMove(moves) != -1)
      return lastReplayMove(moves);
    if (largestCaptureMove(moves) != -1)
      return largestCaptureMove(moves);
    return lastMove(moves);
  }

}

/**
 * The MankalaStone class implements a stone set
 * with persistent colors.
 */
class MankalaStone extends Rectangle {
  /**
   * The color of the stone.
   */
  Color color = null;

  /**
   * The next stone in this pit.
   */
  MankalaStone next = null;

  /**
   * A color table for choosing stone colors.
   */
  static final Color colors[] = {
    Color.blue,
    Color.cyan,
    Color.green,
    Color.magenta,
    Color.orange,
    Color.pink,
    Color.red,
    Color.yellow,
    Color.gray,
    Color.white,
    Color.black,
    Color.darkGray,
    Color.lightGray,
  };
  
  /**
   * Make a stone.
   */
  MankalaStone() {
    this.color = colors[(int)(Math.random() * colors.length)];
  }

  /**
   * Draw this stone.
   */
  void paint(Graphics g) {
    if (g != null) {
      g.setColor(color);
      g.fillOval(x, y, width, height);
    }
  }

}

/**
 * The MankalaPit class implements the pits used for
 * playing and an extra pit used to hold stones during play.
 */
class MankalaPit extends Canvas {
  /*
   * The display that contains this pit.
   */
  MankalaDisplay display = null;

  /*
   * The pit number of this pit.
   */
  int pit;

  /*
   * The bounds of the oval drawn for the pit.
   */
  Rectangle oval = new Rectangle();

  /*
   * The upper right quadrant of the oval, for positioning stones
   * and translating mouse hits.
   */
  Rectangle quad = new Rectangle();
  
  /*
   * A count of the stones in this pit.
   */
  int nstones = 0;

  /*
   * A linked list of the stones in this pit.
   */
  MankalaStone stones = null;

  /*
   * Announce the number of stones in this pit when it changes.
   */
  boolean announce = false;

  /*
   * The positions of the stones in the pits.
   * The nth stone added to the pit always has the same position.
   */
  static final int MaxStones = 6;
  static double positions[][] = MakePositions();
  static final double ptr = 0.2, minr = 0.1, maxr = 0.2, minr2 = 0.1*0.1;
  static double[][] MakePositions() {
    double positions[][] = new double[MaxStones*12][2];
    positions[0][0] = 0;
    positions[0][1] = 0;
    for (int i = 1; i < MaxStones*12; i += 1) {
    again:
      while (true) {
	double theta = 2 * Math.PI * Math.random();
	double r = maxr + ptr * Math.random();
	double x = r * Math.cos(theta);
	double y = r * Math.sin(theta);
	for (int j = i-1; j >= 0 && j >= i - 18; j -= 1) {
	  double x2 = Math.pow(x-positions[j][0], 2);
	  double y2 = Math.pow(y-positions[j][1], 2);
	  if (x2+y2 < minr2)
	    continue again;
	}
	positions[i][0] = x;
	positions[i][1] = y;
	break;
      }
    }
    return positions;
  }

  static void RemakePositions() {
    positions = MakePositions();
  }

  /*
   * Constructor.
   */
  MankalaPit(MankalaDisplay display, int pit, GridBagLayout gridbag, GridBagConstraints c) {
    super();
    this.display = display;
    this.pit = pit;
    if (pit < 7) {
      c.gridx = 6-pit;
      if (pit != 6) {
	c.gridy = 0;
	c.gridheight = 1;
      } else {
	c.gridy = 0;
	c.gridheight = 2;
      }
      gridbag.setConstraints(this, c);
    } else if (pit < 14) {
      c.gridx = pit-6;
      if (pit != 13) {
	c.gridy = 1;
	c.gridheight = 1;
      } else {
	c.gridy = 0;
	c.gridheight = 2;
      }
      gridbag.setConstraints(this, c);
    }
  }

  public void paint(Graphics g) {
    if (g != null) {
      Rectangle b = bounds();
      g.clearRect(b.x, b.y, b.width, b.height);
      g.setColor(getForeground());
      g.drawOval(oval.x, oval.y, oval.width, oval.height);
      for (MankalaStone s = stones; s != null; s = s.next)
	s.paint(g);
    }
  }

  public void reshape(int x, int y, int w, int h) {
    super.reshape(x, y, w, h);
    int dw = w/10;
    int dh = h/10;

    if (pit == 6)
      oval.reshape(dw, dh,      w-2*dw, h-4*dh);
    else if (pit == 13)
      oval.reshape(dw, dh+2*dh, w-2*dw, h-4*dh);
    else
      oval.reshape(dw, dh,      w-2*dw, h-2*dh);

    quad.reshape(oval.x+oval.width/2, oval.y+oval.height/2, oval.width/2, oval.height/2);
    int n = 0;
    for (MankalaStone s = stones; s != null; s = s.next)
      stoneShape(s, n++);
  }

  public boolean inside(int x, int y) {
    int dx = x - quad.x;
    int dy = y - quad.y;
    return dx*dx + dy*dy < quad.width*quad.height;
  }

  MankalaStone takeStone() {
    MankalaStone s = stones;
    if (stones != null) {
      stones = stones.next;
      nstones -= 1;
      showCount();
    }
    return s;
  }

  void stoneShape(MankalaStone s, int n) {
    int x = (int) (quad.x + positions[n][0] * quad.width);
    int y = (int) (quad.y + positions[n][1] * quad.height);
    int r = (int) (quad.width * 0.2);
    s.reshape(x-r, y-r, 2*r, 2*r);
  }

  void putStone(MankalaStone s) {
    int n = nstones++;
    s.next = stones;
    stones = s;
    stoneShape(s, n);
    s.paint(getGraphics());
    showCount();
  }

  public boolean mouseDown(Event evt, int x, int y) {
    if (inside(x,y))
      display.mousePicked(pit);
    return true;
  }

  public boolean mouseEnter(Event evt, int x, int y) {
    announce = true;
    showCount();
    return true;
  }

  public boolean mouseExit(Event evt, int x, int y) {
    announce = false;
    display.showCount("...");
    return true;
  }

  void showCount() {
    if (announce)
      display.showCount(nstones+(nstones == 1 ? " stone." : " stones."));
  }

}

/**
 * The MankalaDisplay class implements the visible playing
 * surface and dispatches pit selection events to the
 * MankalaGame class.
 */
class MankalaDisplay extends Panel {
  /**
   * The maximum number of stones per start pit.
   */
  static final int MaxStones = 6;

  /**
   * The pits.
   */
  MankalaPit pits[];
  
  /*
   * The current player.
   */
  MankalaPlayer player = null;

  /*
   * The match.
   */
  MankalaMatch match = null;

  /**
   * The constructor.
   */
  MankalaDisplay() {
    GridBagLayout gridbag = new GridBagLayout();
    GridBagConstraints c = new GridBagConstraints();
    Color brown = new Color(205, 51, 51);
    setLayout(gridbag);
    c.fill = GridBagConstraints.BOTH;
    c.weightx = 1.0;
    c.weighty = 1.0;
    c.gridwidth = 1;
    c.gridheight = 1;
    pits = new MankalaPit[15];
    for (int i = 0; i < pits.length; i += 1) {
      pits[i] = new MankalaPit(this, i, gridbag, c);
      pits[i].setBackground(brown);
      pits[i].setForeground(Color.black);
      add(pits[i]);
    }
    for (int i = 0; i < MaxStones*12; i += 1)
      pits[14].putStone(new MankalaStone());
  }

  void setPlayer(MankalaPlayer player) {
    this.player = player;
  }

  void setMatch(MankalaMatch match) {
    this.match = match;
  }

  /**
   * Draw one stone.
   */
  void putStone(int pit) {
    pits[pit].putStone(pits[14].takeStone());
  }

  /**
   * Clear a pit.
   */
  void clearPit(int pit) {
    for (MankalaStone s = pits[pit].takeStone(); s != null; s = pits[pit].takeStone())
      pits[14].putStone(s);
    pits[pit].repaint();
  }

  /*
   * Flash a pit.
   */
  void flashPit(int pit) {
    pits[pit].setForeground(Color.white);
    pits[pit].repaint();
    try { Thread.sleep(400); } catch(InterruptedException e) { };
    pits[pit].setForeground(Color.black);
    pits[pit].repaint();
  }

  /*
   * Flash a collection of pits.
   */
  void flashPits(int list[]) {
    for (int i = 0; i < list.length; i += 1) {
      pits[list[i]].setForeground(Color.white);
      pits[list[i]].repaint();
    }
    try { Thread.sleep(400); } catch(InterruptedException e) { };
    for (int i = 0; i < list.length; i += 1) {
      pits[list[i]].setForeground(Color.black);
      pits[list[i]].repaint();
    }
  }

  /*
   * Show a position.
   */
  void showPosition(MankalaPosition position) {
    for (int i = 0; i < 14; i += 1)
      clearPit(i);
    for (int i = 0; i < 14; i += 1)
      for (int j = 0; j < position.board[i]; j += 1)
	putStone(i);
  }

  /*
   * Animate a move, take stones from a pit.
   */
  void takeStones(int pit) {
    clearPit(pit);
    flashPit(pit);
  }

  /*
   * Animate a move, drop stones into a pit.
   */
  void dropStones(int pit, int stones) {
    for (int i = 0; i < stones; i += 1)
      putStone(pit);
    flashPit(pit);
  }

  /*
   * Identify the pit picked.
   */
  void mousePicked(int pit) {
    if (player != null)
      player.handleEvent(pit);
  }

  /*
   * Advertise the number of stones in a pit.
   */
  void showCount(String count) {
    match.showCount(count);
  }

}

