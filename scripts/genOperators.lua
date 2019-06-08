require "chromosomes"

--[[ First the crossover should be applied then the mutation on the offspring is applied.
the offspring replaces all the population or only the worst individuals?
--]]

--array of the selected popoulation (the mating pool)
local selectedCandidates={};

--[[at first use tournament selection
Tournament Selection (iteratively pick two or more individuals and put in the mating pool the fittest)
--currPopulation: the current population from wich we select
-numToSelect: the number of candidates to select
--]]
function geneticSelection(currPopulation, numToSelect)
    -- the population is already fitness-sorted
    for i=1,numToSelect do
        -- the mating pool is overwrited each time with the new selection
        selectedCandidates[i]=currPopulation[i];
    end
end

function getSelectedCandidates()
  return selectedCandidates;
end

--[[the crossover is the second operation performed
by now it performs a single point crossover between 2 chromosomes from the mating pool
-chromosomesLength: the number of genes of the chromosomes.
it is used to try to perform the "cut" around the middle of the chromosome
--]]
function geneticCrossover()
    local chLength = chromsomeLength();
    local chromosomesMid =chLength/2;
    local cutPoint = math.random(chromosomesMid-(chLength/4) , chromosomesMid+(chLength/4));
    local chromosome1=selectedCandidates[1];
    local chromosome2=selectedCandidates[2];
    for i=1, cutPoint do
        chromosome1.inputSeq[i]=selectedCandidates[1].inputSeq[i];
        chromosome2.inputSeq[i]=selectedCandidates[2].inputSeq[i];
    end
    for j=cutPoint, chLength do
        chromosome1.inputSeq[j]=selectedCandidates[2].inputSeq[j];
        chromosome2.inputSeq[j]=selectedCandidates[1].inputSeq[j];
    end

    geneticMutation(0.5, chromosome1, 0)
    geneticMutation(0.5, chromosome2, 1)
end

--[[
selected individuals (the fittest) are mutated.
- changeProbability: probabilty (from 0 to 1) that each gene has of being mutated (new random inputs)
note: higher probabilty usually means slower convergence to the best solution
--]]
function geneticMutation(changeProbability, newChromsome, indexToInsert)
    local chLength=chromsomeLength();
    for i=1, chLength do
        if math.random()<=changeProbability then
            newChromsome.inputSeq[i]=generateRandomInput();
        end
    end
    population=getPopulation()
    --the new chromosomes replace the last chromsome of the population (the less fitt since the population is sorted vy fitness)
    population[getPopulationSize()-indexToInsert]=newChromsome;
end

--[[
function main()
  generateInitialPopulation(4,1000)
  local pop = getPopulation()
  print("SIZE: "..tostring(pop.size))
  for i=1, 3 do
    pop[i].fitness=math.random(1,10)
    print("Candidate: ")
    print(pop[i])
    print("Fitness: ")
    print(pop[i].fitness)
  end

  print("--------")
  table.sort(pop,function(a,b) return a.fitness >= b.fitness end);
--  print("sorted table")
--  for i=1, 3 do
--    print("Candidate: ")
--    print(pop[i])
--    print("Fitness: ")
--    print(pop[i].fitness)
--  end

--  print("--------")
--  print("selection")
--  geneticSelection(pop, 2);
-- print("selected candidates:")
--  for i=1, 2 do
--    print(selectedCandidates[i])
--  end
--
--  for i=1, 3 do
--    print("Candidate: ")
--    print(pop[i])
--    print("Fitness: ")
--    print(pop[i].fitness)
--    for k=1, 3 do
--      print("input n "..i)
--      print("up "..tostring(pop[i].inputSeq[k].up))
--      print("down "..tostring(pop[i].inputSeq[k].down))
--      print("left "..tostring(pop[i].inputSeq[k].left))
--      print("right "..tostring(pop[i].inputSeq[k].right))
--      print("A "..tostring(pop[i].inputSeq[k].A))
--      print("B "..tostring(pop[i].inputSeq[k].B))
--    end
--  end
--
--  print("---------------------------")
--  print("crossover")
--  geneticCrossover(3);
--  for i=1, 3 do
--    print("Candidate: ")
--    print(pop[i])
--    print("Fitness: ")
--    print(pop[i].fitness)
--    for k=1, 3 do
--      print("input n "..i)
--      print("up "..tostring(pop[i].inputSeq[k].up))
--      print("down "..tostring(pop[i].inputSeq[k].down))
--      print("left "..tostring(pop[i].inputSeq[k].left))
--      print("right "..tostring(pop[i].inputSeq[k].right))
--      print("A "..tostring(pop[i].inputSeq[k].A))
--      print("B "..tostring(pop[i].inputSeq[k].B))
--    end
--  end
end

main()
--]]
