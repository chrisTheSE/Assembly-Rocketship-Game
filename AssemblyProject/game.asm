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
.eqv SHIP_SIZE  12 		# Pixel size of the ship
.eqv WIDTH 64 			# Bitmap width
.eqv HEIGHT 32 			# Bitmap height
.eqv REFRESH_RATE 80 		# 40ms
.eqv KEY_PRESSED 0xffff0000	# Address of where 1 or 0 is stored depending on if a key has been pressed

# Colours
.eqv WHITE 0xFFFFFF		# White color
.eqv RED   0xf44236		# Red color
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
gameover_text:  .word   0, 256, 512, 768, 1024, 1280, 4, 8, 12, 772, 776, 780, 24, 28, 32, 36, 40, 1304,	# Store the pixel values for gameover text
 1308, 1312, 1316, 1320, 32, 288, 544, 800, 1056, 1312, 52, 308, 564, 820, 1076, 1332, 64, 320, 576, 832,
 1088, 1344, 2048, 2052, 2056, 2304, 2560, 2564, 2568, 2824, 3080, 3076, 3072, 2064, 2068, 3088, 3092,
 2320, 2576, 2832, 2076, 2332, 2588, 2844, 3100, 2084, 2340, 2596, 2852, 3108, 2080, 3104, 2092, 2348,
 2604, 2860, 3116, 2096, 2100, 2608, 2612, 2360, 2616, 2868, 3128, 2112, 2368, 2624, 2880, 3136, 2116,
 2628, 3140, 568, 828, -1
zero:		.word   0, 256, 512, 768, 1024, 8, 264, 520, 776, 1032, 4, 8, 1028, 1032, -1
one:		.word   0, 4, 260, 516, 772, 1028, 1024, 1032, -1
two:		.word	0, 4, 8, 1024, 1028, 1032, 8, 264, 520, 1032, 516, 512, 768, -1
three:		.word	0, 4, 8, 1024, 1028, 1032, 8, 264, 520, 776, 1032, 516, -1
four:		.word	0, 256, 512, 8, 264, 520, 776, 1032, 516, -1
five:		.word	0, 256, 512, 1024, 8, 520, 776, 1032, 4, 8, 1028, 1032, 516, -1
six:		.word	0, 256, 512, 768, 1024, 8, 520, 776, 1032, 4, 8, 1028, 1032, 516, -1
seven:		.word	0, 4, 8, 264, 520, 776, 1032, -1
eight:		.word	0, 256, 512, 768, 1024, 8, 264, 520, 776, 1032, 4, 8, 1028, 1032, 516, -1
nine:		.word	0, 4, 8, 264, 520, 776, 1032, 256, 512, 516, -1
ship_posx:	.word	10, 10, 11, 11, 11, 11, 12, 12, 10, 10, 12, 12 # X cords of the ship
ship_posy:	.word	15, 16, 14, 15, 16, 17, 15, 16, 14, 17, 14, 17 # Y cords of the ship
ship_rgb:	.word	ORANGE, ORANGE, DARK_BLUE, DARK_BLUE, DARK_BLUE, DARK_BLUE, LIGHT_BLUE, LIGHT_BLUE, BLACK, BLACK, BLACK, BLACK # Pixel colors corresponding to x/y arrays above
shipcol_rgb:	.word	ORANGE, ORANGE, DARK_BLUE, RED, RED, DARK_BLUE, LIGHT_BLUE, LIGHT_BLUE, RED, RED, RED, RED # Pixel colors corresponding to x/y arrays above
erase_ship:	.word	BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK 				   # Pixel colors used to erase the ship
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
astro_speed:	.word	1, 1, 1, 1, 1										   # Store the asteroid types for above array of asteroids
game_cycle:	.word	1										   # There are 59 game cycles before we reset back to 1
giant_asteroid: .word	R1, R1, R2, R3, R1, R1, R1, R2, R3, R2, R2, R3, 
ship_health:	.word   10										   # Ship health
num_collides:	.word   0										 # The total number of ship collisions
score:		.word   0									   # The total score
time:		.word   0										# game time

.text	
RESTART:  jal draw_space	# Clear the screen before restarting
	 # li $s3, 0 		# Game time
	 # li $s4, 0 		# Game Score
	  la $s5, asteroids	# Asteroid array
	  la $s6, astro_types	# Asteroid types
	  
	  li $a0, 0
	  jal spawn_astro	# Spawn asteroids for the first time
	  
	  li $a0, 4
	  jal spawn_astro	# Spawn asteroids for the first time
	 
	  li $a0, 8
	  jal spawn_astro	# Spawn asteroids for the first time
	  
	  li $a0, 12
	  jal spawn_astro	# Spawn asteroids for the first time
	  
	  li $a0, 16
	  jal spawn_astro	# Spawn asteroids for the first time
	  
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
		
	li $s5, 0 		# Loop increment
	li $s6, 4
updateloop: beq $s5, 5, endupdate
	la $a1, ship_health			
	lw $a2, 0($a1)			# $a1 = health
	blez $a2, gameover		# If health goes to 0 or less, than game over
	
	la $s2, astro_types
	mult $s5, $s6
	mflo $a0
	add $s2, $s2, $a0		# astro_types[0]
	#sll $a0, $s5, 2		# $a0 = i * 4
	#move $a0, $s5		# $a0 = index of asteroid
	lw $s4, 0($s2)		# $s4 = astro_types[0]
	
	
	# Based on random number 0-3, a random asteroid type will be spawned
	beq $s4, 0, update_a1
	beq $s4, 1, update_a2
	beq $s4, 2, update_a3
	beq $s4, 3, update_a4

update_a1:
	la $a1, asteroid1_clr
	la $a2, asteroid1
	j skipper
update_a2:
	la $a1, asteroid2_clr
	la $a2, asteroid2
	j skipper
update_a3:
	la $a1, asteroid3_clr
	la $a2, asteroid3
	j skipper
update_a4:
	la $a1, asteroid4_clr
	la $a2, asteroid4
skipper:
	jal update_astro	# Update positions of asteroids
	
	sll $a0, $s5, 2		# $a0 = astro index * 4
	jal astro_collisions	# Call astro_collisions
	beq $v0, 0, no_col		# Branch is no collision
	li $s7, 1	# Set $s7 to ship_rgb
no_col:	
	addi $s5, $s5, 1	# Loop increment++
	j updateloop
endupdate:
	
	beq $s7, 0, no_crash
	la $a0, shipcol_rgb	# Set $s7 to ship_rgb
	# Reduce the ships health by 1
	la $a2, ship_health
	lw $a1, 0($a2)
	add $a1, $a1, -1
	sw $a1, 0($a2)
	j end12
no_crash: 
	la $a0, ship_rgb	# Set $s7 to ship_rgb
end12:  li $s7, 0		# Reset to 0
	#la $a0, ship_rgb 	# Draw ship using ship_rgb colors for the ships pixels
	#move $a0, $s7 		# Draw ship using ship_rgb (or shipcol_rgb) colors for the ships pixels
	jal draw_ship 		# Draw the ship on the screen (position may have updated)

	# Wait at the end of the loop before next graphic refresh
	li $v0, 32
	li $a0, REFRESH_RATE # Wait REFRESH_RATE ms
	syscall
	
	la $s3, time
	lw $s4, 0($s3)
	addi $s4, $s4, 1	# Gametime++
	sw $s4, 0($s3)
	
	li $a2, 100
	div $s4, $a2
	mfhi $a2
	beq $a2, 0, add_score
	j no_change
add_score:
	la $s3, score
	lw $s4, 0($s3)
	addi $s4, $s4, 1	# score++
	sw $s4, 0($s3)	
no_change:	
	
	j GAMELOOP
gameover:
	jal draw_space		# Clear the screen
	
	add $t4, $0, WHITE		# $t4 = white color
	la $t0, gameover_text 		# Load address for gameover text coords
	#add $t4, $zero, $a0 		# Load address for asteroid pixel colors
	li $t3, 788			# $t3 = pixel to start drawing gameover from
	li $t2, BASE_ADDRESS 		# The base address of the bitmap
	li $t1, -1 			# Loop exit point

loop9:  lw $t6, 0($t0) 			# $t6 = asteroidCord[i]
	beq $t6, $t1, END14
	
	add $t5, $t2, $t3 	# $t5 = BASE_ADDRESS + base pixel value		
	add $t5, $t5, $t6 	# $t5 = BASE_ADDRESS + base pixel value	+ gotextCord[i]
	sw $t4, 0($t5) 		# Set pixel at $t5 to color $t4
	
	addi $t0, $t0, 4 	# gotextCord++
	j loop9
END14:
	
	
	
	
	la $s0, score
	lw $s1, 0($s0)		# $t0 = score
	
	li $s2, 10
	div $s1, $s2
	mfhi $s3		# score % 10 ( the first digit of the score)
	sub $s1, $s1, $s3	# score - score % 10 = newscore
	div $s1, $s2		# Shift right newscore by 1 decimal place
	mflo $s1
	div $s1, $s2
	mfhi $s4		# newscore %10 ( the second digit of the score)
	sub $s1, $s1, $s4	# score - score % 10 = newscore
	div $s1, $s2	# Shift right newscore by 1 decimal place
	mflo $s1
	# $s3 first digit, $s4 second digit, $s1 third digit
	
	# Print First digit
	move $a0, $s1
	li $a1, 2924
	jal draw_text
	# Print second digit
	move $a0, $s4
	li $a1, 2940
	jal draw_text
	# Print third digit
	move $a0, $s3
	li $a1, 2956
	jal draw_text
	
	li $v0, 10 # terminate the program gracefully
	syscall
	
############################# Game Functions #############################################

# $a0 holds the digit
# $a1 holds starting pixel
##### Draw text #####
draw_text:
	beq $a0, 0, zero1	# Branch if digit is 0
	beq $a0, 1, one1	# Branch if digit is 1
	beq $a0, 2, two1	# Branch if digit is 2
	beq $a0, 3, three1	# Branch if digit is 3
	beq $a0, 4, four1	# Branch if digit is 4
	beq $a0, 5, five1	# Branch if digit is 5
	beq $a0, 6, six1	# Branch if digit is 6
	beq $a0, 7, seven1	# Branch if digit is 7
	beq $a0, 8, eight1	# Branch if digit is 8
	beq $a0, 9, nine1	# Branch if digit is 9

zero1:
	la $t0, zero 		# Load address for digit text coords
	j finished8
one1:
	la $t0, one 		# Load address for digit text coords
	j finished8
two1:
	la $t0, two 		# Load address for digit text coords
	j finished8
three1:
	la $t0, three 		# Load address for digit text coords
	j finished8
four1:
	la $t0, four 		# Load address for digit text coords
	j finished8
five1:
	la $t0, five 		# Load address for digit text coords
	j finished8
six1:
	la $t0, six 		# Load address for digit text coords
	j finished8
seven1:
	la $t0, seven 		# Load address for digit text coords
	j finished8
eight1:
	la $t0, eight 		# Load address for digit text coords
	j finished8
nine1:
	la $t0, nine 		# Load address for digit text coords
finished8:
	add $t4, $0, WHITE		# $t4 = white color
	#add $t0, $0,$a0 		# Load address for gameover text coords
	#add $t4, $zero, $a0 		# Load address for asteroid pixel colors
	add $t3,$0, $a1			# $t3 = pixel to start drawing gameover from
	li $t2, BASE_ADDRESS 		# The base address of the bitmap
	li $t1, -1 			# Loop exit point

loop7:  lw $t6, 0($t0) 			# $t6 = asteroidCord[i]
	beq $t6, $t1, END15
	
	add $t5, $t2, $t3 	# $t5 = BASE_ADDRESS + base pixel value		
	add $t5, $t5, $t6 	# $t5 = BASE_ADDRESS + base pixel value	+ gotextCord[i]
	sw $t4, 0($t5) 		# Set pixel at $t5 to color $t4
	
	addi $t0, $t0, 4 	# gotextCord++
	j loop7
END15: jr $ra

##############################

##### Paint Space #####
draw_space: 
	li $t2, BASE_ADDRESS 		# The base address of the bitmap
	li $t1, 64 			# Loop row exit point
	li $t0, 32 			# Loop col exit point
	li $t3, 0 			# Loop row increment
	li $t4, 0 			# Loop col increment

row:    beq $t3, $t1, END9		# Exit when $t3 = 13
	li $t4, 0			# Reset inner loop counter to 0
col:    beq $t4, $t0, ENDCOL		# Exit when $t4 = 32
	add $a0, $zero, $t3 		# $a0 = row
	add $a1, $zero, $t4 		# $a1 = col
	
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
	li $t6, BLACK 	# $t6 = BLACK
	sw $t6, 0($t5) 		# Set pixel at $t5 to color $t6

	addi $t4, $t4, 1	# Loop col increment++
	j col
ENDCOL:	
	addi $t3, $t3, 1	# Loop row increment++
	j row
END9: jr $ra

#####################


#### Check for collisions ####
# $a0 holds the astro index
# $v0 holds return value. 1 is collision. 0 if no collision
astro_collisions:
	add $sp, $sp, -4
	sw $ra, 0($sp)
	
	### Get ship boundaries ###
	la $t0, ship_posx	# Load address for x_position array
	move $t2, $t0
	lw $t5, 0($t0)		# Load value for first x cord of the pixel of space ship into $t5
	add $t0, $t5, $0 	# Leftmost pixel
	lw $t5, 28($t2)		# Load value for first x cord of the pixel of space ship into $t5 issue may originate from here
	add $t1, $t5, $0 	# Rightmost pixel
	
	la $t4, ship_posy	# Load address for y_position array
	lw $t5, 8($t4)		# Load value for first y cord of the pixel of space ship into $t5
	add $t2, $t5, $0	# Uppermost pixel
	lw $t5, 20($t4)		# Load value for first y cord of the pixel of space ship into $t5
	add $t3, $t5, $0	# Lowest pixel
	# $t3 lowest pixel, $t2 uppermost pixel, $t1 rightmost pixel, $t0 leftmost pixel
	
	### Get astro boundaries ###
	la $t6, astro_types
	add $t6, $t6, $a0		# $t6 = astro_types[0 + i] address
	lw $t6, 0($t6)			# $t6 = astro_types[0 + i]
	la $t4, asteroids
	add $t4, $t4, $a0		# $t4 = asteroids[0 + i]
	lw $a0, 0($t4)			# $a0 = asteroids[i] = asteroid pixel address
	
	addi $sp, $sp, -20
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	sw $t6, 16($sp)
	jal get_xy			# Convert astro pixel address into x,y coords
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $t3, 12($sp)
	lw $t6, 16($sp)
	addi $sp, $sp, 20
	
	move $t4, $v0			# $t4 = x
	move $t5, $v1			# $t5 = y
	# $t4 astro x_cord, $t5 astro y_cord
	
	# Based on random number 0-3, a random asteroid type will be spawned
	beq $t6, 0, astrotype1
	beq $t6, 1, astrotype2
	beq $t6, 2, astrotype3
	beq $t6, 3, astrotype4
astrotype1:	
	addi $t6, $t4, 0	# Leftmost pixel
	addi $t7, $t4, 3	# Rightmost pixel
	addi $t8, $t5, -1	# Uppermost pixel
	addi $t4, $t5, 2	# Lowermost pixel
	j skip10
astrotype2:
	addi $t6, $t4, 0	# Leftmost pixel
	addi $t7, $t4, 2	# Rightmost pixel
	addi $t8, $t5, -1	# Uppermost pixel
	addi $t4, $t5, 3	# Lowermost pixel
	j skip10
astrotype3:
	addi $t6, $t4, 0	# Leftmost pixel
	addi $t7, $t4, 2	# Rightmost pixel
	addi $t8, $t5, -1	# Uppermost pixel
	addi $t4, $t5, 1	# Lowermost pixel
	j skip10
astrotype4:
	addi $t6, $t4, 0	# Leftmost pixel
	addi $t7, $t4, 4	# Rightmost pixel
	addi $t8, $t5, -1	# Uppermost pixel
	addi $t4, $t5, 3	# Lowermost pixel
skip10: # $t6 leftmost pixel, $t7 rightmost pixel, $t8 uppermost pixel, $t4 lowermost pixel
	
	#AL <= SR AND SL <= AR then horizontal collision
	bgt $t6, $t1, finish
	bgt $t0, $t7, finish
	#SLO >= AHI AND ALO >= SHI then vertical collision
	blt $t3, $t8, finish
	blt $t4, $t2, finish
   	# Collision!!!
	li $v0, 1			# $v0 = 1 ->> collision happened
	# Update number of collisions
	la $t0, num_collides
	lw $t1, 0($t0)
	addi $t1, $t1, 1		# num_collides++
	sw $t1, 0($t0)
	j end11
	
finish:					# No collision
	li $v0, 0			# $v0 = 0 ->> no collision occured
end11:			
	lw $ra, 0($sp)
        add $sp, $sp, 4
        jr $ra	
###########################

##### Spawn Asteroid #####
# $a0 holds the asteroid coords index and holds the asteroid types index
spawn_astro: 
	# Store the $ra register for this function
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	move $t1, $a0 #added recently
	la $t5, asteroids	# Asteroid array
	la $t6, astro_types	# Asteroid types
	add $t5, $t5, $a0	# Load base address of asteroid coords array
	add $t6, $t6, $a0	# Load base address of asteroid types array
	
	# Choose a random y location to spawn an asteroid
	li $v0, 42
	li $a0, 0
	li $a1, 24		# Generates a random number between (0, 24)
	syscall
	addi $t3, $a0, 4	# Get random number between (4, 28)

	# Choose a random x location to spawn an asteroid
	li $v0, 42
	li $a0, 1
	li $a1, 9		# Generates a random number between (0, 9)
	syscall
	addi $t2, $a0, 50	# Get random number between (50, 59)
	add $a1, $zero, $t3	# $a1 = yCoord to spawn asteroid
	add $a0, $zero, $t2	# $a0 = xCoord to spawn asteroid
	
	jal get_addr		# Call get_addr(x,y)
	add $t2, $zero, $v0	# $t2 = OFFSET

	sw $t2, 0($t5)		# asteroids[i] = $t2 = random spawn location
	
	# Choose a random asteroid type to spawn 0-3
	li $v0, 42
	li $a0, 2
	li $a1, 3		# Generates a random number between (0, 3)
	syscall
	add $t3, $a0, $zero	
	##li $t3, 0 ## adde this delete after
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
	
	addi $sp, $sp, -4
	sw $a0, 0($sp)		# Store pixel index
	
	move $t0, $a2 		# Asteroid offsets from base coord
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	
	move $t4, $a1		# Astro color array base address
	la $t5, asteroids	# Asteroid array
	la $t6, astro_types	# Asteroid types
	la $t7, astro_speed	# Asteroid speed
	
	
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
	lw $a0, 0($sp)		# Load pixel index
	addi $sp, $sp, 4
	bnez $t2, no_respawn 
	### Respawn asteroid ###
	#li $t1, 4
	#mult $a0, $t1
	#mflo $a0
	jal spawn_astro	# Call spawn astro function
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

