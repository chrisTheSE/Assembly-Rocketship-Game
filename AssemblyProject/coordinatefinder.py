#x = int(input("Enter x: "))
#y = int(input("Enter y: "))
xvals = 0,1,1,1,2
yvals = 0,-1,0,1,0
width = 64
height = 32
#address = (y * width + x) * 4
#print(address)

for i in range(0, 100):
    address = (yvals[i] * width + xvals[i]) * 4
    print(str(address) + ", ", end ='')    