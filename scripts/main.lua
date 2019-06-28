require "utils"
require "chromosomes"
require "genOperators"

local PLAYER_XPAGE_ADDR     = 0x6D   --Player's page (screen) address
local PLAYER_PAGE_WIDTH     = 256    -- Width of pages
local PLAYER_XPOS_ADDR      = 0x86   --Player's position on the x-axis
local PLAYER_STATE_ADDR     = 0x000E --Player's state (dead/dying)
local PLAYER_VIEWPORT_ADDR  = 0x00B5 --Player's viewport status (falling)
local PLAYER_YPOS_ADDR      = 0x00CE --Player's y position address
local PLAYER_VPORT_HEIGHT   = 256    --raw height of viewport pages
local PLAYER_DOWN_HOLE      = 3      --VIEWPORT+ypos val for falling into hole
local PLAYER_DYING_STATE    = 0x0B   --State value for dying player
--local PLAYER_DEAD_STATE     = 0x06   --(CURRENTLY UNUSED!) State value for dead player
local PLAYER_FLOAT_STATE    = 0x001D --Used to check if player has won
local PLAYER_FLAGPOLE       = 0x03   --Player is sliding down flagpole.
local GAME_TIMER_ONES       = 0x07fA --Game Timer first digit
local GAME_TIMER_TENS       = 0x07f9 --Game Timer second digit
local GAME_TIMER_HUNDREDS   = 0x07f8 --Game Time third digit
local GAME_TIMER_MAX        = 400    --Max time assigned by game
local CONTROL_FRAME_NUMBER = 10
local LIVES_LEFT = 0x075A            -- the number of mario's lives left

-- TODO:
-- 1) FINIRE LA FUNZIONE DI SALVATAGGIO IN UN FILE DEL CANDIDATO MIGLIORE PER NON PERDERE I PROGRESSI (OK)
-- 2) TESTARE SE EFFETTIVAMENTE C'è UN MIGLIORAMENTO DOPO UN PO DI TEMPO
-- 3) INIZIARE LA FASE 2 IN CUI SI AGGIUNGE INTERAZIONE CON AMBIENTE DEL GIOCO

local POPULATION_SIZE = 4
local INPUT_SEQ_LENGTH = 1000
local geneIndex=1;
local inputCount=1;
local solutionFound=-1;

generateInitialPopulation(POPULATION_SIZE, INPUT_SEQ_LENGTH)
local candidates = getPopulation()

-- reading tests
--print(candidates[1]);
--saveWinInputs(candidates[1]);
--tableRead = readWinInputs();
--print(tableRead);
if file_exists("winning_candidates.txt") then
    print("reading first candidate frome save file...")
    candidates[1].inputSeq = readWinInputs()
end

-- main loop that iterates over the chromosomes of the population and tests each o them
while true do -------------------------------------------------------------------------------------
    -- ci saranno altri due loop interni: uno che cicla sulla popolazione (su tutti i cromosomi)
    -- e l'altro cicla sul cromosoma (su tutti gli input del cromosoma)

    -- loop over all the population -----------------------------------------------------------------
    for chromIndex=1, POPULATION_SIZE do
        geneIndex=1
        memoryWrite(LIVES_LEFT,2)
        --loop of chromosome's genes --------------------------------------------------------------------
        for i=1,INPUT_SEQ_LENGTH*CONTROL_FRAME_NUMBER do

            -- the player current position on the x axis (space traveled by mario)
            playerXDistance = memoryRead(PLAYER_XPAGE_ADDR) * PLAYER_PAGE_WIDTH +
            memoryRead(PLAYER_XPOS_ADDR);
            gameTime = (memoryRead(GAME_TIMER_HUNDREDS) * 100) +
            (memoryRead(GAME_TIMER_TENS) * 10)      +
            memoryRead(GAME_TIMER_ONES);

            fitness = playerXDistance; -- at the moment the fitness depends only on the x distance covered by mario
            candidates[chromIndex].fitness=fitness

            --sets the random input map for the player 1
            joypad.set(1,candidates[chromIndex].inputSeq[geneIndex]);

            writeOnDisplay(1, "Fitness: "..fitness); -- NB: .. is the concat operator


            writeOnDisplay(2, "Chromsome n.: "..chromIndex);

            -- reading from memory mario's state (dead or alive)
            local playerState = memoryRead(PLAYER_STATE_ADDR);
            local fallingState = memoryRead(PLAYER_VIEWPORT_ADDR);
            if p_state == PLAYER_DYING_STATE or fallingState >= PLAYER_DOWN_HOLE or gameTime==0 then
                -- MARIO DIED or there is no time left
                print("Mario has died! :(");
                candidates[chromIndex].fitness=fitness
                while gameTime <= GAME_TIMER_MAX-5 do
                    gameTime = (memoryRead(GAME_TIMER_HUNDREDS) * 100)+(memoryRead(GAME_TIMER_TENS) * 10)+memoryRead(GAME_TIMER_ONES);
                    -- wait until the next game starts
                    emu.frameadvance()
                end
                print("Next chromosome starts")
                --starts the next chromosome
                break;
            end

            --reading from memory if mario is currently floating
            local floatingState = memoryRead(PLAYER_FLOAT_STATE);
            -- checks if mario is floating because he's on the flagpole
            if floatingState == PLAYER_FLAGPOLE then
                print("chromsome "..chromIndex.." lead to a winning solution, s")
                -- mario is on the flagpole = he won
                -- register that the current chromosome lead to a winning solution
                candidates[chromIndex].hasWon=true;
                saveWinInputs(candidates[chromIndex]);
                solutionFound=chromIndex;
                break;
            end

            inputCount=inputCount+1;
            if inputCount==CONTROL_FRAME_NUMBER then
                inputCount=0;
                geneIndex=geneIndex+1;
            end

            --current binary input data
            --local bid=joypad.get(1);
            --writeOnDisplay(3,bid);

            --[[Advance the emulator by one frame. It's like pressing the frame advance button once.
            the frame is the basic unit of time in the NES
            --]]
            emu.frameadvance()
        end -- end of the loop over the single chromosome
        if solutionFound >= 0 then
            break;
        end
        --print("Chromosome "..chromIndex.." finished, next chromsome")
    end -- end of the loop over the population
    print("popoulation finished")

    if solutionFound > 0 then
        break;
    end
    --fine dei due loop interni
    --chromosomes sorting in dec orderd from the fittest to the less fit (fitnessSort defined in utils.lua)
    print("performing genetic operations..")
    table.sort(candidates,function(a,b) return a.fitness > b.fitness end);

    -- perform selection, crossover and mutation operations (genetic operators)
    geneticSelection(candidates, 2);
    geneticCrossover(); -- also calls mutation

end --end of the main loop: winning(s) chromosome search
