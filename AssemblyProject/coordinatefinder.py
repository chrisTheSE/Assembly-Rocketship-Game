#x = int(input("Enter x: "))
#y = int(input("Enter y: "))

xvals =  0,1,2,3,4,5,6,7,8,9,10,11,0,1,2,3,4,5,6,7,8,9,10,11,0,11       
yvals =  0,0,0,0,0,0,0,0,0,0, 0, 0,2,2,2,2,2,2,2,2,2,2, 2, 2,1, 1
width = 64
height = 32
#address = (y * width + x) * 4
#print(address)

for i in range(0, 1000):
    address = (yvals[i] * width + xvals[i]) * 4
    print(str(address) + ", ", end ='')    