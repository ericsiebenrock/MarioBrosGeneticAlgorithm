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

-- TABLE UTILS -------------------------------------------------------------------------
--[[
given a table, this function returns the number of entries in it (the size of the table)
--]]
function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function table.val_to_str ( v )
  if "string" == type( v ) then
    v = string.gsub( v, "\n", "\\n" )
    if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
      return "'" .. v .. "'"
    end
    return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
  else
    return "table" == type( v ) and table.tostring( v ) or
      tostring( v )
  end
end

function table.key_to_str ( k )
  if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
    return k
  else
    return "[" .. table.val_to_str( k ) .. "]"
  end
end
-- conversion of a table to a string
function table.tostring( tbl )
  local result, done = {}, {}
  for k, v in ipairs( tbl ) do
    table.insert( result, table.val_to_str( v ) )
    done[ k ] = true
  end
  for k, v in pairs( tbl ) do
    if not done[ k ] then
      table.insert( result,
        table.key_to_str( k ) .. "=" .. table.val_to_str( v ) )
    end
  end
  return "{" .. table.concat( result, "," ) .. "}"
end

-- FILE UTILS ---------------------------------------------------------------
-- see if the file exists
function file_exists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

--[[function that saves in a file the winning chromosome's input sequence
the file is opened in write mode (w) so only one winning chromosome will be saved
--]]
function saveWinInputs(candidate)
    print("saving winning candidate into \"winning_candidates.txt\"");
    file = io.open("winning_candidates.txt", "w");
    for j=1, tablelength(candidate.inputSeq) do
        file:write(table.tostring(candidate.inputSeq[j]), "\n");
    end
    file:close();
end

function readWinInputs()
    if not file_exists("winning_candidates.txt") then return {} end
    lines = {}
    for line in io.lines(file) do
        lines[#lines + 1] = line
    end
    return lines
end

-- note: those functions cannot be local otherwise they couldn't be invoked in the main script
