/*
** Implementation of Hong & Page, Groups of diverse problem solvers can 
** outperform groups of high-ability problem solvers, PNAS 101: 16385, 
** November 16, 2004.
*/

/*
** create an array of integers from min to max inclusive in order.
*/
void sequence(int min, int max, int[] seq) {
  for (int i = 0; i < max-min+1; i += 1)
    seq[i] = min+i;
}

/*
** shuffle an array of integers
*/
void shuffle(int[] nums) {
  for (int i = 0; i < nums.length; i += 1) {
    int j = (int)random(nums.length-i);
    int k = nums[i];
    nums[i] = nums[j];
    nums[j] = k;
  }
}

/*
** The problems: given a collection of N random numbers drawn uniformly in the range [0..100]
** find the index of the maximum value.
*/
class Problem {
  int n;
  float[] result;
  Problem(int n) {
    this.n = n;
    result = new float[n];
    for (int i = 0; i < n; i += 1)
      result[i] = random(100);
  }
  float resultAt(int i) {
    i %= n;
    if (i < 0) i += n;
    return result[i];
  }
}

/*
** The heuristics: starting from i, search k offsets from i less or equal to l while there is improvement.
*/
class Heuristic {
  int k;
  int l;
  int offset[];
  Heuristic(int k, int l) {
    this.k = k;
    this.l = l;
    offset = new int[k];
    // do not allow duplicate values.
    int[] offsets = new int[l];
    sequence(1, l, offsets);
    shuffle(offsets);
    for (int i = 0; i < k; i += 1) {
      offset[i] = offsets[i];
    }
  }
  int resultIndex(Problem p, int startIndex) {
    int bestIndex = startIndex;
    float bestResult = p.resultAt(startIndex);
    int tries = 0;
    while (tries < k) {
      for (int i = 0; i < k; i += 1) {
        int trialIndex = bestIndex+offset[i];
        float trialResult = p.resultAt(trialIndex);
        if (trialResult >= bestResult) {
          tries = 0;
          bestIndex = trialIndex;
          bestResult = trialResult;
        } else {
          tries += 1;
        }
      }
    }
    return bestIndex;
  }
  float result(Problem p, int startIndex) {
    return p.resultAt(resultIndex(p, startIndex));
  }
  float expectedResult(Problem p) {
    float value = 0;
    for (int i = 0; i < p.n; i += 1)
      value += result(p, i);
    return value / p.n;
  }
  float diversity(Heuristic heuristic) {
    float diversity = k;
    for (int i = 0; i < k; i += 1)
      diversity -= ((offset[i]==heuristic.offset[i])?1:0);
    return diversity / k;
  }
    
}

/*
** The candidate population, a collection of heuristics.
*/
class Candidate {
  int n;
  int k;
  int l;
  Heuristic[] candidate;
  Candidate(int n, int k, int l) {
    this.n = n;
    this.k = k;
    this.l = l;
    candidate = new Heuristic[n];
    for (int i = 0; i < n; i += 1)
      candidate[i] = new Heuristic(k, l);
  }
  Heuristic candidateAt(int i) {
    return candidate[i];
  }
}

/*
** A ranked heuristic, a heuristic, a problem, 
** and the result of applying the heuristic
** to the problem.
*/
class RankedHeuristic {
  Heuristic heuristic;
  Problem problem;
  float result;
  RankedHeuristic(Heuristic heuristic, Problem problem) {
    this.heuristic = heuristic;
    this.problem = problem;
    result = heuristic.expectedResult(problem);
  }
}

/*
** The ranking of a candidate population over a problem.
*/
class RankedCandidate {
  Candidate population;
  Problem problem;
  RankedHeuristic[] ranking;
  RankedCandidate(Candidate population, Problem problem) {
    this.population = population;
    this.problem = problem;
    ranking = new RankedHeuristic[population.n];
    for (int i = 0; i < population.n; i += 1) {
      insert(ranking, i, new RankedHeuristic(population.candidateAt(i), problem));
    }
  }
  void insert(RankedHeuristic[] ranking, int n, RankedHeuristic unranked) {
    for (int i = n-1; i >= 0; i -= 1) {
      if (ranking[i].result < unranked.result) {
        ranking[i+1] = ranking[i];
      } else {
        ranking[i+1] = unranked;
        return;
      }
    }
    ranking[0] = unranked;
  }
  RankedHeuristic candidateAt(int i) {
    return ranking[i];
  }
  Heuristic[] bestRanked(int n) {
    Heuristic[] team = new Heuristic[n];
    for (int i = 0; i < n; i += 1) {
      team[i] = ranking[i].heuristic;
    }
    return team;
  }
  Heuristic[] randomRanked(int n) {
    Heuristic[] team = new Heuristic[n];
    int[] ptr = new int[population.n];
    sequence(0, population.n-1, ptr);
    shuffle(ptr);
    for (int i = 0; i < n; i += 1)
      team[i] = ranking[ptr[i]].heuristic;
    return team;
  }
}

/*
** A team is a collection of heuristics drawn from a candidate population.
*/
class Team {
  Heuristic[] member;
  float diversity;
  Team(Heuristic[] member) {
    this.member = member;
    int n = 0;
    float sumDiversities = 0;
    // average the pairwise diversity
    for (int i = 0; i < member.length; i += 1) {
      for (int j = 0; j < i; j += 1) {
        sumDiversities += member[j].diversity(member[i]);
        n += 1;
      }
    }
    diversity = sumDiversities / n;
  }
  float result(Problem p, int start) {
    float best = p.resultAt(start);
    while (true) {
      int trialIndex = start;
      float trialResult = best;
      for (int i = 0; i < member.length; i += 1) {
        trialIndex = member[i].resultIndex(p, trialIndex);
        trialResult = p.resultAt(trialIndex);
      }
      if (trialResult > best) {
        best = trialResult;
        continue;
      }
      break;
    }
    return best;
  }
  float expectedResult(Problem p) {
    float value = 0;
    for (int i = 0; i < p.n; i += 1)
      value += result(p, i);
    return value / p.n;
  }
  float averageIndividualPerformance(Problem p) {
    float performance = 0;
    for (int i = 0; i < member.length; i += 1)
      performance += member[i].expectedResult(p) / member.length;
    return performance;
  }
}

int problem_size = 1000;
int population_size = 500;
int heuristic_size = 20;
int heuristic_span = 20;
int team_size = 10;
int window_size = 100;
int window_scale = window_size/100;
int background_color = color(255, 255, 255);
int best_color = color(255, 0, 0);
int random_color = color(0, 255, 0);
int versus_color = color(0, 0, 255);

void setup() {
  size(window_size, window_size);
  background(background_color);
}
void draw() {
  Problem problem = new Problem(problem_size);
  Candidate population = new Candidate(population_size, heuristic_size, heuristic_span);
  RankedCandidate rankedPopulation = new RankedCandidate(population, problem);
  Team bestTeam = new Team(rankedPopulation.bestRanked(team_size));
  Team randomTeam = new Team(rankedPopulation.randomRanked(team_size));
  float bestAverageIndividualPerformance = bestTeam.averageIndividualPerformance(problem);
  float randomAverageIndividualPerformance = randomTeam.averageIndividualPerformance(problem);
  float bestDiversity = bestTeam.diversity;
  float randomDiversity = randomTeam.diversity;
  float bestExpectedResult = bestTeam.expectedResult(problem);
  float randomExpectedResult = randomTeam.expectedResult(problem);
  // print("candidate["+0+"] expectedResult = "+rankedPopulation.candidateAt(0).result+"\n");
  // print("candidate["+(population_size/2)+"] expectedResult = "+rankedPopulation.candidateAt(population_size/2).result+"\n");
  // print("candidate["+(population_size-1)+"] expectedResult = "+rankedPopulation.candidateAt((population_size-1)).result+"\n");
  // print("bestTeam diversity = "+bestTeam.diversity+" averageResult = "+bestAverageIndividualPerformance+" expectedResult = "+bestExpectedResult+"\n");
  // print("randomTeam diversity = "+randomTeam.diversity+" averageResult = "+randomAverageIndividualPerformance+" expectedResult = "+randomExpectedResult+"\n");
  stroke(best_color); point(window_scale*bestDiversity*100, window_size-window_scale*bestExpectedResult);
  stroke(random_color); point(window_scale*randomDiversity*100, window_size-window_scale*randomExpectedResult);
  stroke(versus_color); point(window_scale*bestExpectedResult, window_size-window_scale*randomExpectedResult);
}
