#Name : Devi Kandasamy
#E-campus id : W1003221
# Date of submission : 5/26/2014

#!/usr/bin/ruby
require 'pp'

class Maze
    @row = 0
	@column = 0
	@grid = nil
	@found = false
	
	def initialize ()
		@row = 0
		@column = 0
		@grid = nil
	end
	
	def validate_file(filename)
		if File.exist?  (filename)
			puts "Note: Valid file name"
		else
			puts "Note: Invalid file name"
			abort("Exiting...")
		end
	end
	
	def readable(filename)
		if File.readable?  (filename)
			puts "Note: #{filename} has readable permission"
		else
			puts "Error: File doesn't have read permission"
			abort("Exiting...")
		end
	end
	
	def validate_fileContent(filename)
		if File.zero?  (filename)
			puts "Warning: File #{filename} is empty"
			abort "Exiting.."
		end
	end	

	def Maze.border(grid, row, column)
	    for i in 0..row-1
			grid[i][0]=5 #5- for borders
			grid[i][column-1]=5
			grid[0][i]=5
			grid[row-1][i]=5
		end
	end
	
	def initialize_params(filename)
		File.open(filename, "r").each_line do |line|
			if @row == 0 and @column == 0   
			    @row, @column = line.split(',')
				@row = @row.to_i  
				@column = @column.to_i
				if @row == 0 or @column == 0  
					puts "Error: Row column should have a non-zero value"
					abort("Exiting...")	
				end
				@grid = Array.new(@row+2).map{ |x| Array.new(@column+2)}
				Maze.border(@grid, @row+2, @column+2)
			else 
				x,y = line.split(',')
				x = x.to_i
				y = y.to_i
				if x <0 or x >= @row   
					puts "Error: Encountered an erroneous x-coordinate value"
					abort("Exiting...")	
				end
				if y <0 or y >= @column   
					puts "Error: Encountered an erroneous y-coordinate value"
					abort("Exiting...")
				end
				@grid[x+1][y+1] = 6 #Blocking cell (x,y)
			end
		end 
	end

	def writable(filename)
		if File.writable?  (filename)
			puts "Note: #{filename} has writable permission"
		else
			puts "Error: File doesn't have write permission"
			abort("Exiting...")
		end
	end
	
	def generate_html(filename)
		file = File.open("#{filename}", "w")
		file.write("<!DOCTYPE html>\n")
		file.write("<html>\n")
		file.write("<head>\n")
		file.write("<title> Maze </title>\n")
		file.write("<link href=\"style.css\" rel=\"stylesheet\" type=\"text/css\" />\n")
		file.write("</head>\n")
		file.write("<body>\n")
		file.write("<h1> Welcome to maze!!! <\h1>\n")
		file.write("<table cellspacing=\"30\" cellpadding=\"30\">\n")
		puts "Output:"
		puts "S - start"
		puts "F - finish"
		puts "@ - path from start to finish"
		puts "X - blocked cells"
		puts ".. - unblocked cells"
		print "------------------------------------\n"
		for i in 1..@column
			file.write("<tr>")
			for j in 1..@row
				if i==1 and j==1
					print "|  S  |"
					file.write("<td background='start.png'></td>\n")
				elsif i==@column and j==@row
					print "|  F  |"
					file.write("<td background='finish.png'></td>\n")
				elsif @grid[i][j] == 6
					print "|  X  |"
					file.write("<td background='block.png'></td>\n")
				elsif @grid[i][j] == 9
					print "|  @  |"
					file.write("<td background='blub.jpg'></td>\n")
				else
					print "|  .. |"
					file.write("<td background='path.png'></td>\n")
				end
			end
			puts "\n"
			print "------------------------------------"
			puts "\n"
			file.write("</tr>\n")
		end
		file.write("</table>\n")
		file.write("<br><br>\n")
		if @found == true
			file.write("<h1>Hurray!!! Path found!!!</h1>")
		else
			file.write("<h1>Oops!!! No Path found, Better luck next time!!!</h1>")
		end
		file.write("<h2> Instructions: </h2>\n")
		file.write("<h2> 1. To play the game - Copy the maze.rb and style.css to your system </h2>\n") 
		file.write("<h2> 2. Copy the sample input file - the file will have the row*column of maze and the vertices of blocked cells, you can change the dimensions and vaues as per your interest</h2>\n") 
		file.write("<h3> Pre-requisite: </h3>\n")
		file.write("<h3> Your machine should be installed with ruby, in order to play this game </h3>\n")
		file.write("<h2> 3. Execute the maze.rb and give the input file as input on the prompt</h2> \n")
		file.write("<br><br>\n")
		file.write("<h2> Algorithm: </h2>\n")
		file.write("<h2> 1. The first cell of the table is the start index and the last cell of the table is the last index </h2> \n")
		file.write("<h2> 2. The path from the first to last is traversed by using depth first search algorithm</h2> \n")
		file.write("<h2> 3. Each time when the cell is visited, the adjacent cells are pushed to the stack</h2> \n")
		file.write("<h2> 4. The last vertex is popped and marked as visited </h2>\n")
		file.write("<h2> 5. In the map the predecessor to the cell is mapped, to track the visited path </h2>\n")
		file.write("<h3 align=\"right\" > Developed by Devi Kandasamy(W1003221) </h3>\n")
		file.write("<h3 align=\"right\"> COEN 278: Web programming II  </h3>\n")
		file.write("<h3 align=\"right\"> Assignment -3 </h3>\n")
		file.write("</body></html>\n")
	end
	
	def compute_path()
		coord = Struct.new(:x, :y)
        stack=[]
        start = coord.new
        start.x = 1
        start.y = 1
        finish = coord.new
        finish.x = @row
        finish.y = @column
		pathmap = Hash.new
		stack.push(start)
		while (stack.size() != 0 )
			cell = stack.pop()
			@grid[cell.x][cell.y] = 7 #Marking it visited
			if @grid[cell.x - 1] [cell.y] == nil 
			    leftcell = coord.new
				leftcell.x = cell.x - 1
				leftcell.y  = cell.y
				pathmap[leftcell] = cell
				@grid[leftcell.x][leftcell.y] = 8#pushing a cell into stack
				stack.push(leftcell)
			end			
			if @grid[cell.x] [cell.y - 1] == nil 
			    topcell = coord.new
				topcell.x = cell.x
				topcell.y  = cell.y - 1
				pathmap[topcell] = cell
				@grid[topcell.x][topcell.y] = 8
				stack.push(topcell)
			end				
			if @grid[cell.x + 1] [cell.y] == nil 
				rightcell = coord.new
				rightcell.x = cell.x + 1
				rightcell.y  = cell.y
				pathmap[rightcell] = cell
				if cell.x + 1 == finish.x and cell.y == finish.y
					puts "Reached destination- Path: "
					@found = true
					break;
				end
					@grid[rightcell.x][rightcell.y] = 8
					stack.push(rightcell)
		    end			
			if @grid[cell.x] [cell.y + 1] == nil 
				bottomcell = coord.new
				bottomcell.x = cell.x
				bottomcell.y  = cell.y  + 1
				pathmap[bottomcell] = cell
				if cell.x == finish.x and cell.y + 1 == finish.y
					puts "Reached destination- Path: "
					@found = true
					break;
				end
				@grid[bottomcell.x][bottomcell.y] = 8
				stack.push(bottomcell)
			end
		end
		if @found == true			
			cell = finish
            while cell !=  start 
				puts "#{cell.x-1}, #{cell.y-1}"
				@grid[cell.x][cell.y]=9
				puts "=>"
				prevcell = pathmap[cell]
				cell = prevcell
			end
			puts "#{cell.x-1}, #{cell.y-1}"
			@grid[cell.x][cell.y]=9
		else
			puts "Oops!!! No path to reach the finish"
			puts "Better luck next time!!!"
		end
	end
end

#Main
mazeobject = Maze.new()
puts "Enter the input file name: "	
filename = gets.chomp.strip
mazeobject.validate_file("#{filename}")
mazeobject.readable("#{filename}")
mazeobject.validate_fileContent("#{filename}")
file = File.new('maze.html', 'w')
mazeobject.writable("maze.html")
mazeobject.initialize_params("#{filename}")
mazeobject.compute_path()
mazeobject.generate_html("maze.html")



