--[[function to print text on the screen
-offset: number of the element printed: all the elements are encoloumned vertically
-text: the text printed
--]]
function writeOnDisplay(offset, text)
    local vertical_position = 10; -- the default distance from the top of the screen
    gui.text(0, offset*vertical_position, text);
end

function memoryRead(addr)
    return memory.readbyte(addr);
end

function memoryWrite(addr, value)
    return memory.writebyte(addr,value);
end

--simple function that returns a random boolean (true or false)
function randomBoolean()
  return math.random() >= 0.5;
end

--[[function used in table.sort to automatically sort the population in respect to fitness
This order function receives two arguments and must return true if the first argument
should come first in the sorted array
--]]
function fitnessSort(ch1,ch2)
    return ch1.fitness>=ch2.fitness;
end

function os.sleep(msec)
  local now = os.clock() + msec/1000
  repeat until os.clock() >= now
end

--[[function that saves in a file the winning chromosome's input sequence
the file is opened in append mode (a) so all the winning chromosomes will be saved
--]]
function saveWinInputs(candidate)
    print("saving winning candidate into \"winning_candidates.txt\"");
    file = io.open("winning_candidates.txt", "a");
    for j=1, tablelength(candidate.inputSeq) do
        file:write(candidate.inputSeq[j], "\n");
    end
    file:close();
end

-- note: those functions cannot be local otherwise they couldn't be invoked in the main script
