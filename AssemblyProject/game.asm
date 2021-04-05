#####################################################################
#
# CSCB58 Winter 2021 Assembly Final Project
# University of Toronto, Scarborough
#
# Student: Christopher Suh, 1006003664, suhchris
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8 (update this as needed)
# - Unit height in pixels: 8 (update this as needed)
# - Display width in pixels: 512 (update this as needed)
# - Display height in pixels: 256 (update this as needed)
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestones have been reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 1/2/3/4 (choose the one the applies)
#
# Which approved features have been implemented for milestone 4?
# (See the assignment handout for the list of additional features)
# 1. (fill in the feature, if any)
# 2. (fill in the feature, if any)
# 3. (fill in the feature, if any)
# ... (add more if necessary)
#
# Link to video demonstration for final submission:
# - (insert YouTube / MyMedia / other URL here). Make sure we can view it!
#
# Are you OK with us sharing the video with people outside course staff?
# - yes / no / yes, and please share this project github link as well!
#
# Any additional information that the TA needs to know:
# - (write here, if any)
#
#####################################################################

# Bitmap display starter code
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#

.eqv BASE_ADDRESS 0x10008000	# Bitmap base address
.eqv SHIP_SIZE  8 		# Pixel size of the ship
.eqv WIDTH 64 			# Bitmap width
.eqv HEIGHT 32 			# Bitmap height
.eqv REFRESH_RATE 40 		# 40ms
.eqv KEY_PRESSED 0xffff0000	# Address of where 1 or 0 is stored depending on if a key has been pressed

# Colours
.eqv BLACK 0x00000000		# Black color
.eqv GREY 0x808080 		# Grey color
.eqv ORANGE 0xffa500 		# Orange color
.eqv DARK_BLUE 0x00008b 	# Dark blue color
.eqv LIGHT_BLUE 0xadd8e6 	# Light blue color
# Giant Asteroid colours
.eqv R1 0xd32f2f 	# Red color 1
.eqv R2 0xe53835 	# Red color 2
.eqv R3 0xef5250	# Red color 3
.eqv O3 0xff5622	# Orange color 1
.eqv Y1 0xffc107	# Yellow color 1
.eqv Y2 0xffeb3b	# Yellow color 2
# Normal Asteroid colours
.eqv G1 0x9e9e9e	# Grey color 1
.eqv G2 0x757575	# Grey color 2

.data
str1:	.asciiz 	"sss\n"
ship_posx:	.word	10, 10, 11, 11, 11, 11, 12, 12 # X cords of the ship
ship_posy:	.word	15, 16, 14, 15, 16, 17, 15, 16 # Y cords of the ship
ship_rgb:	.word	ORANGE, ORANGE, DARK_BLUE, DARK_BLUE, DARK_BLUE, DARK_BLUE, LIGHT_BLUE, LIGHT_BLUE # Pixel colors corresponding to x/y arrays above
erase_ship:	.word	BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK 				   # Pixel colors used to erase the ship
asteroid1:	.word	0, 256, -252, 4, 260, 516, -248, 8, 264, 520, 12, 268, -1			   # Coords for asteroid relative to (0,0) top left pixel of asteroid	
asteroid1_clr:  .word	G2, G2, G2, G1, G1, G2, G2, G1, G1, G2, G2, G2
asteroid2:	.word	0, 256, 512, -252, 4, 260, 516, 772, 8, 264, 520, -1			   	   # Coords for asteroid relative to (0,0) top left pixel of asteroid	
asteroid2_clr:  .word	G1, G2, G1, G1, G2, G2, G2, G1, G1, G2, G1
asteroid3:	.word	0, -252, 4, 260, 8, -1			   	   				   # Coords for asteroid relative to (0,0) top left pixel of asteroid	
asteroid3_clr:  .word	G2, G2, G1, G2, G2
asteroid4:	.word	0, 256, 512, -252, 4, 260, 516, 772, -248, 8, 264, 520, 776, -244, 12, 268, 524, 780, 16, 272, 528, -1	# Coords for asteroid relative to (0,0) top left pixel of asteroid	
asteroid4_clr:  .word	G1, G2, G2, G1, G2, G1, G1, G2, G2, G1, G1, G1, G2, G2, G1, G1, G2, G1, G2, G2, G1
erase_astro:	.word	BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK
asteroids:	.word	0, 0, 0, 0, 0										   # Stores the (0,0) coordinates for all the asteroids
astro_types:	.word	0, 0, 0, 0, 0
astro_speed:	.word	1, 2, 1, 2, 1										   # Store the asteroid types for above array of asteroids
game_cycle:	.word	1										   # There are 59 game cycles before we reset back to 1
giant_asteroid: .word	R1, R1, R2, R3, R1, R1, R1, R2, R3, R2, R2, R3, 

.text	
	  li $s3, 0 		# Game time
	  li $s4, 0 		# Game Score
	  la $s5, asteroids	# Asteroid array
	  la $s6, astro_types	# Asteroid types
	  
	  li $a0, 0
	  jal spawn_astro	# Spawn asteroids for the first time
	  
	#  li $a0, 4
	 # jal spawn_astro	# Spawn asteroids for the first time
	 
	#  li $a0, 8
	#  jal spawn_astro	# Spawn asteroids for the first time
	  
	 # li $a0, 12
	 # jal spawn_astro	# Spawn asteroids for the first time
	  
	 # li $a0, 16
	 # jal spawn_astro	# Spawn asteroids for the first time
	  
# $a0 holds the index of the asteroid to be updated
# $a1 holds the astro color array base address
# $a2 holds the astro coordinates base address (offsets from the base pixel)	  
	  
################ Main Game Loop ################
GAMELOOP: la $s0, KEY_PRESSED 	# Load address of KEY_PRESSED
	  lw $s1, 0($s0)	# Get value stored at address KEY_PRESSED
	  beq $s1, 0, no_input 	# If $s1 = 0 then skip to no_input, else continue to handle user input
	  sw $zero, 0($s0) 	# Reset value at address KEY_PRESSED to 0
	  lw $a0, 4($s0)	# Load value of key pressed into $a0 
	  
	  jal update_ship	# Calls the update_ship function with the key pressed stored is $a0
no_input:
		
	li $a0, 0		# $a0 = index of asteroid
	#la $s2, astro_types
	#addi $s2, $s2, 0	# astro_types[0]
	#lw $s4, 0($s2)		# $s4 = astro_types[0]
	
	la $a1, asteroid1_clr	# $a1 = astro colors
	la $a2, asteroid1	# $a2 = astro offsets

	jal update_astro	# Update positions of asteroids
	
	la $a0, ship_rgb 	# Draw ship using ship_rgb colors for the ships pixels
	jal draw_ship 		# Draw the ship on the screen (position may have updated)

	# Wait at the end of the loop before next graphic refresh
	li $v0, 32
	li $a0, REFRESH_RATE # Wait REFRESH_RATE ms
	syscall
	
	addi $s3, $s3, 1	# Gametime++
	j GAMELOOP
	
	li $v0, 10 # terminate the program gracefully
	syscall
	
############################# Game Functions #############################################
#li $s5, 0 		# Loop increment
#updateloop: beq $s5, 5, endupdate	
#	move $a0, $s5		# $a0 = index of asteroid
#	la $s2, astro_types
#	add $s2, $s2, $s5		# astro_types[0]
#	lw $s4, 0($s2)		# $s4 = astro_types[0]
#	
#	# Based on random number 0-3, a random asteroid type will be spawned
#	beq $s4, 0, update_a1
#	beq $s4, 1, update_a2
#	beq $s4, 2, update_a3
#	beq $s4, 3, update_a4
#
#update_a1:
#	la $a1, asteroid1_clr
#	la $a2, asteroid1
#	j skipper
#update_a2:
#	la $a1, asteroid2_clr
#	la $a2, asteroid2
#	j skipper
#update_a3:
#	la $a1, asteroid3_clr
#	la $a2, asteroid3
#	j skipper
#update_a4:
#	la $a1, asteroid4_clr
#	la $a2, asteroid4
#skipper:
#	jal update_astro	# Update positions of asteroids
#	addi $s5, $s5, 1	# Loop increment++
#	j updateloop
#endupdate:







##### Spawn Asteroid #####
# $a0 holds the asteroid coords index and holds the asteroid types index
spawn_astro: 
	# Store the $ra register for this function
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	la $t5, asteroids	# Asteroid array
	la $t6, astro_types	# Asteroid types
	add $t5, $t5, $a0	# Load base address of asteroid coords array
	add $t6, $t6, $a0	# Load base address of asteroid types array
	
	# Choose a random y location to spawn an asteroid
	li $v0, 42
	li $a0, 0
	li $a1, 27		# Generates a random number between (0, 27)
	syscall
	addi $t3, $a0, 1	# Get random number between (1, 28)
	
	# Choose a random x location to spawn an asteroid
	li $v0, 42
	li $a0, 0
	li $a1, 4		# Generates a random number between (0, 4)
	syscall
	addi $t2, $a0, 55	# Get random number between (55, 59)
	add $a1, $zero, $t3	# $a1 = yCoord to spawn asteroid
	add $a0, $zero, $t2	# $a0 = xCoord to spawn asteroid
	
	jal get_addr		# Call get_addr(x,y)
	add $t2, $zero, $v0	# $t2 = OFFSET

	sw $t2, 0($t5)		# asteroids[i] = $t2 = random spawn location
	
	# Choose a random asteroid type to spawn 0-3
	li $v0, 42
	li $a0, 0
	li $a1, 3		# Generates a random number between (0, 3)
	syscall
	add $t3, $a0, $zero	
	
	sw $t3, 0($t6)		# astro_types[i] = $t3 = random asteroid type
	
	# Load the $ra register for this function
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

#####################

##### Update Asteroids #####
# $a0 holds the index of the asteroid to be updated
# $a1 holds the astro color array base address
# $a2 holds the astro coordinates base address (offsets from the base pixel)
update_astro: 
	# Store the $ra register for this function
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	move $t0, $a2 		# Asteroid offsets from base coord
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	
	move $t4, $a1		# Astro color array base address
	la $t5, asteroids	# Asteroid array
	la $t6, astro_types	# Asteroid types
	la $t7, astro_speed	# Asteroid speed
	
	
	#addi $sp, $sp, -4
	#sw $a0, 0($sp)		# Store pixel index
	add $t5, $t5, $a0	# Load base pixel of the asteroid
	add $t6, $t6, $a0	# Load astro type
	add $t7, $t7, $a0	# Load astro speed
	
	lw $t8, 0($t5)		# Asteroid position index
	
	### Increment asteroid position based on astro speed ###
	li $t2, -4
	lw $t3, 0($t7)
	mult $t3, $t2
	mflo $t2
	add $t2, $t8, $t2	# asteroids[i]--
	sw $t2, 0($t5)		# asteroids[i] = asteroids[i] - 1 (So asteroids move leftwards)
	
	### Erase old asteroid position ###
	la $a0, erase_astro	# $a0 = astro color mapping
	lw $t0, 0($sp)		# $t0 = astro base address offsets
	addi $sp, $sp, 4
	move $a1, $t0		# $a1 = astro offsets array
	# must account for astro speed
	li $t1, 4
	lw $t2, 0($t7)		# $t2 = astro_speed
	mult $t2, $t1		# astro_speed * 4
	mflo $t1		# $t1 = astro_speed * 4
	add $a2, $t8, $t1	# $a2 = astro position pixel + astro_speed * 4
	# Call draw_astro to delete old asteroid position
	addi $sp, $sp, -16
	sw $t4, 0($sp)
	sw $t0, 4($sp)
	sw $t8, 8($sp)
	sw $t5, 12($sp)
	jal draw_astro
	lw $t4, 0($sp)
	lw $t0, 4($sp)
	lw $t8, 8($sp)
	lw $t5, 12($sp)
	addi $sp, $sp, 16

	### Check if asteroid is at the boundary, if so respawn it ###
	lw $a0, 0($t5)		# $t2 = asteroid pixel
	
	addi $sp, $sp, -12
	sw $t4, 0($sp)
	sw $t0, 4($sp)
	sw $t8, 8($sp)
	jal astro_within_frame
	lw $t4, 0($sp)
	lw $t0, 4($sp)
	lw $t8, 8($sp)
	addi $sp, $sp, 12
	
	move $t2, $v1
	#lw $a0, 0($sp)		# Load pixel index
	#addi $sp, $sp, 4
	bnez $t2, no_respawn 
	### Respawn asteroid ###
	li $a0, 0
	#li $t1, 4
	#mult $a0, $t1
	#mflo $a0
	#addi $sp, $sp, -12
	#sw $t4, 0($sp)
	#sw $t0, 4($sp)
	#sw $t8, 8($sp)
	jal spawn_astro	# Call spawn astro function
	#lw $t4, 0($sp)
	#lw $t0, 4($sp)
	#lw $t8, 8($sp)
	#addi $sp, $sp, 12
	j  skip5 
no_respawn:	
												
	### Draw asteroid ###
	move $a0, $t4		# $a0 = astro color array
	move $a1, $t0		# $a1 = astro coords array
	move $a2, $t8		# $a2 = astro base pixel
	jal draw_astro
skip5:  # Load the $ra register for this function
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
#####################

##### Draw Asteroids #####
# $a0 holds the colour mapping for the asteroid
# $a1 holds the coordinates for the asteroid
# $a2 holds a random base pixel to draw the asteroid from
draw_astro: 
	add $t0, $zero, $a1 		# Load address for asteroid coords
	add $t4, $zero, $a0 		# Load address for asteroid pixel colors
	add $t3, $zero, $a2		# $t3 = random base pixel to draw asteroid from
	li $t2, BASE_ADDRESS 		# The base address of the bitmap
	li $t1, -1 			# Loop exit point

loop3:  lw $t6, 0($t0) 			# $t6 = asteroidCord[i]
	beq $t6, $t1, END3
	
	add $t5, $t2, $t3 	# $t5 = BASE_ADDRESS + base pixel value		
	add $t5, $t5, $t6 	# $t5 = BASE_ADDRESS + base pixel value	+ asteroidCord[i]
	lw $t6, 0($t4) 		# $t6 = current rbg pixel color
	sw $t6, 0($t5) 		# Set pixel at $t5 to color $t6
	
	addi $t0, $t0, 4 	# asteroidCord++
	addi $t4, $t4, 4 	# asteroidColor++
	j loop3
END3: jr $ra

#####################

##### Draw Ship #####
# $a0 holds the colour mapping for the ship (same length as array above holding the color value for pixel at the same index)
draw_ship: 
	la $t0, ship_posx 	# Load address for ship positions x cords. offset = 0
	la $t4, ship_posy 	# Load address for ship positions y cords. offset = 0
	add $t3, $zero, $a0 	# Load address for ship pixel colors from the $a0 parameter loaded at calltime
	li $t1, SHIP_SIZE 	# Counter end point for the loop
	li $t2, BASE_ADDRESS 	# The base address of the bitmap
	li $t7, 0 		# Loop increment

loop:   beq $t7, $t1, END
	lw $a0, 0($t0) # $a0 = XCord[i]
	lw $a1, 0($t4) # $a1 = YCord[i]
	
	# Call get_addr to get BASE_ADDRESS offset from x,y cords
	addi $sp, $sp, -24
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t4, 12($sp)
	sw $t3, 16($sp)
	sw $ra, 20($sp)
	
	jal get_addr
	
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $t4, 12($sp)
	lw $t3, 16($sp)
	lw $ra, 20($sp)
	addi $sp, $sp, 24
	
	add $t5, $zero, $v0 	# $t5 = get_addr(x,y) = OFFSET		
	add $t5, $t2, $t5 	# $t5 = BASE_ADDRESS + OFFSET
	lw $t6, 0($t3) 		# $t6 = current rbg pixel color
	sw $t6, 0($t5) 		# Set pixel at $t5 to color $t6
	
	addi $t0, $t0, 4 	# Xcord++
	addi $t4, $t4, 4 	# Ycord++
	addi $t3, $t3, 4 	# ShipColor++
	addi $t7, $t7, 1	# Loop increment++
	j loop
END: jr $ra

#####################

#### Get x and y ####
# $a0 holds the pixel address
# $v0 holds x cord
# $v1 holds y cord
get_xy:
	move $t0, $a0		# $t0 = pixel address
	li $t1, 4
	div $t0, $t1		#  pixel address / 4
	mflo $t0		# $t0 = pixel address / 4
	li $t1, WIDTH		# $t1 = WIDTH
	div $t0, $t1		# (pixel address / 4) / WIDTH
	mflo $v1		# $v1 = (pixel address / 4) / WIDTH = y
	mfhi $v0		# $v0 = (pixel address / 4) % WIDTH = x
	
	jr $ra
###########################

#### Get address offset ####
# $a0 holds x cord
# $a1 holds y cord
get_addr:
	add $t0,$zero, $a0 	# $t0 = x
	add $t1,$zero, $a1 	# $t1 = y
	li $t2, WIDTH 		# $t2 = width of bitmap
	mult $t1, $t2 		# y * width
	mflo $t2		# $t2 = y * width
	add $t2, $t0, $t2 	# $t2 = y * width + x
	sll $t2, $t2, 2		# $t2 = (y * width + x) * 4
	
	add $v0, $zero, $t2

	jr $ra
###########################

##### Update Ship #####
# $a0 holds address to array of addresses of where ship currently is currently located
# $a1 holds the colour mapping for the ship (same length as array above holding the color value for pixel at the same index)
update_ship: 
	la $t0, ship_posx 	# Load address for ship positions x cords. offset = 0
	la $t4, ship_posy 	# Load address for ship positions y cords. offset = 0
	li $t1, SHIP_SIZE 	# Counter end point for the loop
	li $t7, 0 		# Loop increment
	add $t8, $zero, $a0	# $t8 = ASCII value of key press
	li $t3, 0		# Change in X position
	li $t2, 0		# Change in Y position
	
	beq $t8, 0x61, respond_to_a	# If $t8 = a go to respond_to_a
	beq $t8, 0x77, respond_to_w	# If $t8 = w go to respond_to_w
	beq $t8, 0x73, respond_to_s	# If $t8 = s go to respond_to_s
	beq $t8, 0x64, respond_to_d	# If $t8 = d go to respond_to_d
	j END2				# Otherwise no update needed, skip to END
	
respond_to_a:
	addi $t3, $t2, -1	# Move the ship coordinates to the left by 1 pixel
	j skip
respond_to_w:
	addi $t2, $t2, -1	# Move the ship coordinates up by 1 pixel
	j skip
respond_to_s:
	addi $t2, $t2, 1	# Move the ship coordinates down by 1 pixel
	j skip
respond_to_d:
	addi $t3, $t2, 1	# Move the ship coordinates to the right by 1 pixel
skip:
	# Store the variables we need before calling functions
	addi $sp, $sp, -32 	# Make space on the stack then store needed registers
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	sw $t4, 16($sp)
	sw $t7, 20($sp)
	sw $t8, 24($sp)
	sw $ra, 28($sp)
	
	# Check to ensure ship is within boundaries
	add $a0, $zero, $t3	# Store change in x position in $a0
	add $a1, $zero, $t2	# Store change in y position in $a1
	jal within_frame	# Check if ship is within frame
	
	beq $v1, 0, UNLOAD	# Skip past the erase_ship function since ship is not moving and thus no update needed
	# Delete old position of the ship by turning pixels black
	la $a0, erase_ship 	# Draw ship using erase_ship colors for the ships pixels
	jal draw_ship 		# Will erase the old position of the ship

UNLOAD:				# Used since we want to skip erase_ship if ship not within the frame and we need to unload the stack
	lw $t0, 0($sp)		# Pop items off stack back to local registers
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $t3, 12($sp)
	lw $t4, 16($sp)
	lw $t7, 20($sp)
	lw $t8, 24($sp)
	lw $ra, 28($sp)
	addi $sp, $sp, 32 
	
	beq $v1, 0, END2	# Skip to the end since no update needed because new ship position is outside boundaries	

loop2:   beq $t7, $t1, END2
	lw $t5, 0($t0) 		# $t5 = XCord[i]
	lw $t6, 0($t4) 		# $t6 = YCord[i]
	add $t5, $t5, $t3 	# $t5 = $t5 + x_movement
	add $t6, $t6, $t2 	# $t6 = $t6 + y_movement
	sw $t5, 0($t0) 		# XCord[i] = XCord[i] + x_movement
	sw $t6, 0($t4) 		# YCord[i] = YCord[i] + y_movement

	# Update loop increments for the next iteration
	addi $t0, $t0, 4 	# Xcord++
	addi $t4, $t4, 4 	# Ycord++
	addi $t7, $t7, 1	# Loop increment++
	j loop2
END2: jr $ra
#####################

#### Check if astro is within boundaries ####
# $a0 holds the pixel address
# $v1 holds return value. 1 is within boundaries. 0 if outside boundaries
astro_within_frame:
	add $sp, $sp, -4
	sw $ra, 0($sp)
	
	move $t0, $a0
	jal get_xy
	move $t1, $v0			# $t1 = x
	move $t2, $v1			# $t2 = y
	
	bgtz $t1, within2		# The leftmost pixel of the asteroid is outside the left side boundary	
	li $v1, 0 			# The provided asteroid coordinate is not within frame	
	j skip3
within2: li $v1, 1 			# The provided asteroid coordinate is within frame    
skip3: lw $ra, 0($sp)
       add $sp, $sp, 4
       jr $ra	
###########################

#### Check if ship is within boundaries ####
# $a0 holds x_movement
# $a1 holds y_movement
# $v1 holds return value. 1 is within boundaries. 0 if outside boundaries
within_frame:
	la $t4, ship_posx	# Load address for x_position array
	lw $t5, 0($t4)		# Load value for first x cord of the pixel of space ship into $t5
	add $t0, $t5, $a0 	# Leftmost pixel
	lw $t5, 28($t4)		# Load value for first x cord of the pixel of space ship into $t5 issue may originate from here
	add $t1, $t5, $a0 	# Rightmost pixel
	
	la $t4, ship_posy	# Load address for y_position array
	lw $t5, 8($t4)		# Load value for first y cord of the pixel of space ship into $t5
	add $t2, $t5, $a1	# Uppermost pixel
	lw $t5, 20($t4)		# Load value for first y cord of the pixel of space ship into $t5
	add $t3, $t5, $a1	# Lowest pixel
	
	bltz $t0, not_within		# The leftmost pixel of the ship is outside the left side boundary	
	li $t6, WIDTH			# Store bitmap width in $t6		
	bge $t1, $t6, not_within	# The rightmost pixel of the ship is outside the right side boundary
	bltz $t2, not_within		# The topmost pixel of the ship is outside the top boundary
	li $t6, HEIGHT			# Store bitmap height in $t6		
	bge $t3, $t6, not_within	# The bottom most pixel of the ship is below bottom boundary
				

within: li $v1, 1 # The provided ship coordinate is within frame
	j skip2
			
not_within: li $v1, 0 # The provided ship coordinate is not within frame
	    
skip2: jr $ra	
###########################

