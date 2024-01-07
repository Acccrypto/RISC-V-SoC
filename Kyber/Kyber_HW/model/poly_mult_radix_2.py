import random
import math

#precompute the twiddle factors
w_rom = []
winv_rom = []
kesai = 17
q = 3329
# qinv = q^-1 mod 2^16 = 62209
# qinv = q^-1 mod 2^12 = 769
qinv = 769
# mont = 2^16 mod q = 2285
# mont = 2^12 mod q = 767
mont = 767 
mont_sqr = 2385
#inv_kesai = pow(kesai,512) % q

def montgomery_reduce(a):
    u = (a * qinv) % (1 << 12)
    t = (u * q) % (1 << 24)
    t = a - t
    t = t >> 12
    if (t < 0):
        t = t + q
    return t

def bitreverse(n,l):
    r = 0
    for i in range(l):
        r = (r << 1) | (n & 1)
        n = n >> 1
    return r

for i in range(1, 128):
    w_rom.append(pow(kesai,bitreverse(i,7)) * mont % q)

for i in range(1, 128):
    winv_rom.append(-w_rom[127-i] % q)

#print(w_rom)
#print(winv_rom)
#print(len(w_rom))
#print(inv_kesai)

def wrttf0():
    fo = open('tf0.txt', 'w')

    for i in range(0, 63):
        fo.write('6\'d%d: Q <= 12\'d%s;\n' % (i, int(w_rom[i])))

    fo.close()

def wrttf1():
    fo = open('tf1.txt', 'w')

    for i in range(63, 127, 2):
        fo.write('5\'d%d: Q <= 24\'b%s%s;\n' % ((i-63)/2, bin(w_rom[i])[2:].zfill(12), bin(w_rom[i+1])[2:].zfill(12)))

    fo.close()

def DIT_NR_NTT(a,w_rom):
    n = len(a)
    log_n = int(math.log(n,2))
    r = 0
    for p in range(log_n-1,0,-1):
        J = int(pow(2,p))
        for k in range(int(n/(2*J))):
            w = w_rom[r]
            r = r + 1
            for j in range(J):
                #print('%d %d %d\n' % (a[k*2*J+j], a[k*2*J+j+J], w))
                u = a[k*2*J+j]
                t = montgomery_reduce(a[k*2*J+j+J] * w)
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
    for i in range(1, log_n):
        J = int(pow(2,i))
        for k in range(int(n/(2*J))):
            w = w_rom[r]
            r = r - 1
            for j in range(J):
                #print('%d %d %d\n' % (a[k*2*J+j], a[k*2*J+j+J], w))
                u = a[k*2*J+j] % q
                t = a[k*2*J+j+J] % q
                a[k*2*J+j] = (op21(u + t)) % q
                a[k*2*J+j+J] = montgomery_reduce(op21(t - u) * w)
                #print('%d %d\n' % (a[k*2*J+j], a[k*2*J+j+J]))
    return a

def basemul(a0, a1, b0, b1, w):
    m1 = montgomery_reduce(a0 * b0)
    m2 = montgomery_reduce(a1 * b1)
    m3 = montgomery_reduce(m2 * w)
    s1 = (m1 + m3) % q
    s2 = (a0 + a1) % q
    s3 = (b0 + b1) % q
    m4 = montgomery_reduce(s2 * s3)
    s4 = (m1 + m2) % q
    s5 = (m4 - s4) % q
    return (s1, s5)

def pwm(x,y,w_rom):
    z = []
    for i in range(0, 64):
        #print('%d %d %d %d %d\n' % (x[4*i], x[4*i+1], y[4*i], y[4*i+1], w_rom[i+63]))
        (z0, z1) = basemul(x[4*i], x[4*i+1], y[4*i], y[4*i+1], w_rom[i+63])
        #print('%d %d\n\n' % (z0, z1))
        z.append(z0)
        z.append(z1)
        #print('%d %d %d %d %d\n' % (x[4*i+2], x[4*i+3], y[4*i+2], y[4*i+3], q-w_rom[i+63]))
        (z0, z1) = basemul(x[4*i+2], x[4*i+3], y[4*i+2], y[4*i+3], q-w_rom[i+63])
        #print('%d %d\n\n' % (z0, z1))
        z.append(z0)
        z.append(z1)
    return z

def madd(x,y):
    z = []
    for i in range(0, 256):
        a = montgomery_reduce(x[i] * mont_sqr)
        b = (a + y[i]) % q
        z.append(b)
    return z

a = []
b = []
for i in range(256):
    a.append(i)
b = [1] * 256

def test():
    #print("a = ",a)
    ffta = DIT_NR_NTT(a, w_rom)
    #fftb = DIT_NR_NTT(b, w_rom)
    print("ffta = ", ffta)
    #print("fftb = ",fftb)

    #c = pwm(a, b, w_rom)
    #print("c = ",c)

    #ifftc = DIF_RN_INTT(c, w_rom)
    #print("ifftc = ",ifftc)

    #d = [0] * 256
    #e = madd(ifftc, d)
    #print("e = ", e)

test()
#wrttf0()
#wrttf1()