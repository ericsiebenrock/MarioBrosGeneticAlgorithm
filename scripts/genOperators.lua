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
        -- the 2 fittest candidates are copied by value (not by reference as happens for tables in lua)
        selectedCandidates[i]=chromosomeCopy(currPopulation[i]);
        print("[genOperators print] currPopulation[i].fitness: "..currPopulation[i].fitness)
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
    local chromosomesMid = chLength/2;
    -- cutPoint in always between the half and before cause 500 is around the actual chromsome middle
    -- but the chromosome length was put to 1500 just to be sure
    local cutPoint = math.random(chromosomesMid-(chLength/4) , chromosomesMid);
    local chromosome1=chromosomeCopy(selectedCandidates[1]);
    local chromosome2=chromosomeCopy(selectedCandidates[2]);
    print("performing genetic crossover with cut point around the chromsome center ("..chromosomesMid.."): Cut point = "..cutPoint)
    print("first half from 1 to"..cutPoint.."; second half from "..(cutPoint+1).." to "..chLength.."")
    -- for ha semantica <=
    for i=1, cutPoint do
        --chromsome1 keeps the first part while chromosome2 changes it with the one of chromosome1
        chromosome1.inputSeq[i]=selectedCandidates[1].inputSeq[i];
        chromosome2.inputSeq[i]=selectedCandidates[1].inputSeq[i];
    end
    for j=(cutPoint+1), chLength do
        --chromsome2 keeps the second part while chromosome1 changes it with the one of chromosome2
        chromosome1.inputSeq[j]=selectedCandidates[2].inputSeq[j];
        chromosome2.inputSeq[j]=selectedCandidates[2].inputSeq[j];
    end

    geneticMutation(0.5, chromosome1, 0) -- chromsome1 inserted as the last chromosome of the population
    geneticMutation(0.5, chromosome2, 1) -- chromsome2 inserted as the last-1 chromosome of the population
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
    --the new chromosomes replace the 2 last chromsomes of the population (the less fitt since the population is sorted by fitness)
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
