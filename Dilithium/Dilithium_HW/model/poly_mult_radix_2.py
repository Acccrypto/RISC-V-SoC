import random
import math

#precompute the twiddle factors
w_rom = []
winv_rom = []
kesai = 1753
q = 8380417
#inv_kesai = pow(kesai,512) % q

def bitreverse(n,l):
    r = 0
    for i in range(l):
        r = (r << 1) | (n & 1)
        n = n >> 1
    return r

for i in range(1, 256):
    w_rom.append(pow(kesai,bitreverse(i,8)) % q)

for i in range(1, 256):
    winv_rom.append(-w_rom[255-i] % q)

print(w_rom)
print(winv_rom)
#print(len(w_rom))
#print(inv_kesai)

def wrttf0():
    fo = open('tf0.txt', 'w')

    for i in range(0, 63):
        fo.write('6\'d%d: Q <= 23\'d%s;\n' % (i, int(w_rom[i])))

    fo.close()

def wrttf1():
    fo = open('tf1.txt', 'w')

    for i in range(63, 127, 2):
        fo.write('5\'d%d: Q <= 46\'b%s%s;\n' % ((i-63)/2, bin(w_rom[i])[2:].zfill(23), bin(w_rom[i+1])[2:].zfill(23)))

    fo.close()

def wrttf2():
    fo = open('tf2.txt', 'w')

    for i in range(127, 255, 4):
        fo.write('5\'d%d: Q <= 92\'b%s%s%s%s;\n' % ((i-127)/4, bin(w_rom[i])[2:].zfill(23), bin(w_rom[i+1])[2:].zfill(23), bin(w_rom[i+2])[2:].zfill(23), bin(w_rom[i+3])[2:].zfill(23)))

    fo.close()

def DIT_NR_NTT(a,w_rom):
    n = len(a)
    log_n = int(math.log(n,2))
    r = 0
    for p in range(log_n-1,-1,-1):
        J = int(pow(2,p))
        for k in range(int(n/(2*J))):
            w = w_rom[r]
            r = r + 1
            for j in range(J):
                #print('%d %d %d\n' % (a[k*2*J+j], a[k*2*J+j+J], w))
                u = a[k*2*J+j] % q
                t = (a[k*2*J+j+J] * w) % q
                a[k*2*J+j] = (u + t) % q
                a[k*2*J+j+J] = (u - t) % q
                #print('%d %d\n' % (a[k*2*J+j], a[k*2*J+j+J]))

    return a

def op21(a):
    if a & 1 == 0:
        r = (a >> 1) % q
    else:
        r = ((a >> 1) + ((q + 1)>>1)) % q
    return r

def DIF_RN_INTT(a,w_rom):
    n = len(a)
    log_n = int(math.log(n,2))
    r = len(w_rom)-1
    for i in range(log_n):
        J = int(pow(2,i))
        for k in range(int(n/(2*J))):
            w = w_rom[r]
            r = r - 1
            for j in range(J):
                print('%d %d %d\n' % (a[k*2*J+j], a[k*2*J+j+J], w))
                u = a[k*2*J+j] % q
                t = a[k*2*J+j+J] % q
                a[k*2*J+j] = (op21(u + t)) % q
                a[k*2*J+j+J] = (op21(t - u) * w) % q
                print('%d %d\n' % (a[k*2*J+j], a[k*2*J+j+J]))
    return a

def pwm(x,y):
    N = len(x)
    z = []
    for i in range(N):
        z.append((x[i] * y[i]) % q)
        #print('%d %d %d\n' % (x[i], y[i], z[i]))
    return z

a = []
for i in range(256):
    a.append(i)

def wrtbk():
    fo = [[],[],[],[]]
    fo[0] = open('bank0_r2.txt', 'w')
    fo[1] = open('bank1_r2.txt', 'w')
    fo[2] = open('bank2_r2.txt', 'w')
    fo[3] = open('bank3_r2.txt', 'w')

    for i in range(0, 128):
        sn = ((i >> 6) & 1) ^ ((i >> 5) & 1) ^ ((i >> 4) & 1) ^ ((i >> 3) & 1) ^ ((i >> 2) & 1)
        sd = (sn * 2) & 3
        bank_i = (sd + (i & 3)) & 3
        fo[bank_i].write('%s %s\n' % (bin(a[2*i])[2:].zfill(23), bin(a[2*i+1])[2:].zfill(23)))

    fo[0].close()
    fo[1].close()
    fo[2].close()
    fo[3].close()


def test():
    a = []
    for i in range(256):
        a.append(i)
    #b = [0] * 256
    #b[0] = 1
    ffta = DIT_NR_NTT(a,w_rom)
    #fftb = DIT_NR_NTT(b,w_rom)
    #print("ffta = ",ffta)
    #print("fftb = ",fftb)

    c = pwm(ffta,ffta)
    #print("c = ",c)

    ifftc = DIF_RN_INTT(c,w_rom)
    print("ifftc = ",ifftc)

#test()
#wrtbk()
#wrttf2()
