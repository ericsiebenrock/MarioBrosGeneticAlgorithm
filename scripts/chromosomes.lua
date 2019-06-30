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
--array(table) of all the chromosome (the population)
local population = {}
local populationSize;
local chromosomeLength;

--[[default metamethod __index for the chromsome metatable.
 it specifies where to search if an index is not found in the table associated to the metatable
 in this case the table will be population[i] and the metatable chromsome. so something not found in population is serached in chromsome.
 in that way it is possible to access "fitness" and "hasWon" properties directly from popoulation (as happens in main.lua)
-- ]]
chromosome.__index = chromosome;

--[[creates a new table instance with structure defined by chromosome
note: the name "metatable.new()" is only conventional
--]]
function chromosome.new()
    --sets "chromsome" as metatable of a new empty table {}.
    -- self is the name given to the table (setmetatable returns the table)
    --Metatables allow us to change the behavior of a table. For instance,
    --using metatables, we can define how Lua computes the expression a+b, where a and b are tables
    local self = setmetatable({}, chromosome);
    --sets a table indexed by "inputSeq" inside the self table
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
        up      = false,
        down    = false,
        left    = lrv,
        right   = not lrv,
        A       = randomBoolean(), -- jump
        B       = randomBoolean(), -- sprint
        start   = false,
        select  = false
    };
end


function chromsomeLength()
  return chromosomeLength;
end
