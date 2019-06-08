require "utils"

--[[ structure of the chromosome
the chromosome is composed by the sequence of action (inputs) performed by mario during a run.
The genes of the chromosome are the single inputs.
The chromosome's fitness value is initially 0 ang gets evaluated after mario's run
If the inputs sequence lead to winning the level hasWon will be set to true
--]]
chromosome ={
    fitness = 0,
    hasWon = false
}
--array of all the chromosome (the population)
local population = {}
local populationSize;
local chromosomeLength;

--non so esattamente cosa fa
chromosome.__index = chromosome;

--[[creates a new table instance with structure defined by chromosome
--]]
function chromosome.new()
    --non so esattamente cosa fa
    local self = setmetatable({}, chromosome);
    self.inputSeq = {};
    --self.input_fit = {};
    return self;
end

--[[function that generates the initial population
each chromosome is initialized with random input values
--]]
function generateInitialPopulation(candidateNum, inputSeqLength)
    populationSize=candidateNum;
    chromosomeLength=inputSeqLength;
    -- note: the for semantic is <= so a -1 is necessary if we start from 0
    for i=1, candidateNum do
        population[i]=chromosome.new();
        for j=1, inputSeqLength do
            population[i].inputSeq[j]=generateRandomInput();
        end
    end
end


function getPopulation()
    return population;
end

function getPopulationSize()
  return populationSize;
end


--[[function that generates random input for mario
The input must be encoded in a map with keys "up", "down" and so on. right and left can't be pressed at the same time
--]]
function generateRandomInput()
    local lrv = randomBoolean();
    return {
        up      = randomBoolean(),
        down    = randomBoolean(),
        left    = lrv,
        right   = not lrv,
        A       = randomBoolean(),
        B       = randomBoolean(),
        start   = false,
        select  = false
    };
end


function chromsomeLength()
  return chromosomeLength;
end
