from numpy import random

a = []
b = []
c = []

for i in range(0, 32):
    a.append(i)
random.shuffle(a)
fo = open("sfrom.txt", "w")
for i in range(0, 32):
    fo.write('8\'d%d: new_addr = 6\'d%d;\n' % (i, a[i]))

for i in range(23, 32):
    c.append(a[i])
    c.append(a[i]+32)
    c.append(a[i]-16)
    c.append(a[i]+16)
for i in range(0, 16):
    b.append(i)
for i in range(32, 48):
    b.append(i)
random.shuffle(b)
k = 9
while True:
    swap = 0
    for i in range(0,9):
        for j in range(4*i,36):
            if b[i] == c[j]:
                t = b[i]
                b[i] = b[k]
                b[k] = t
                k = k + 1
                swap = 1
                break
        if swap == 1:
            break
    if swap == 0:
        break
for i in range(0, 32):
    fo.write('8\'d%d: new_addr = 6\'d%d;\n' % (i+32, b[i]))

a = []
c = []
for i in range(23, 32):
    c.append(b[i])
    c.append(b[i]+16)
    c.append(b[i]-8)
    c.append(b[i]+8)
for i in range(0, 8):
    a.append(i)
for i in range(16, 24):
    a.append(i)
for i in range(32, 40):
    a.append(i)
for i in range(48, 56):
    a.append(i)
random.shuffle(a)
k = 9
while True:
    swap = 0
    for i in range(0,9):
        for j in range(4*i,36):
            if a[i] == c[j]:
                t = a[i]
                a[i] = a[k]
                a[k] = t
                k = k + 1
                swap = 1
                break
        if swap == 1:
            break
    if swap == 0:
        break
for i in range(0, 32):
    fo.write('8\'d%d: new_addr = 6\'d%d;\n' % (i+32*2, a[i]))

b = []
c = []
for i in range(23, 32):
    c.append(a[i])
    c.append(a[i]+8)
    c.append(a[i]-4)
    c.append(a[i]+4)
for i in range(0, 8):
    b.append(8*i)
    b.append(8*i+1)
    b.append(8*i+2)
    b.append(8*i+3)
random.shuffle(b)
k = 9
while True:
    swap = 0
    for i in range(0,9):
        for j in range(4*i,36):
            if b[i] == c[j]:
                t = b[i]
                b[i] = b[k]
                b[k] = t
                k = k + 1
                swap = 1
                break
        if swap == 1:
            break
    if swap == 0:
        break
for i in range(0, 32):
    fo.write('8\'d%d: new_addr = 6\'d%d;\n' % (i+32*3, b[i]))

a = []
c = []
for i in range(23, 32):
    c.append(b[i])
    c.append(b[i]+4)
    c.append(b[i]-2)
    c.append(b[i]+2)
for i in range(0, 16):
    a.append(4*i)
    a.append(4*i+1)
random.shuffle(a)
k = 9
while True:
    swap = 0
    for i in range(0,9):
        for j in range(4*i,36):
            if a[i] == c[j]:
                t = a[i]
                a[i] = a[k]
                a[k] = t
                k = k + 1
                swap = 1
                break
        if swap == 1:
            break
    if swap == 0:
        break
for i in range(0, 32):
    fo.write('8\'d%d: new_addr = 6\'d%d;\n' % (i+32*4, a[i]))

b = []
c = []
for i in range(23, 32):
    c.append(a[i])
    c.append(a[i]+2)
    c.append(a[i]-1)
    c.append(a[i]+1)
for i in range(0, 32):
    b.append(2*i)
random.shuffle(b)
k = 9
while True:
    swap = 0
    for i in range(0,9):
        for j in range(4*i,36):
            if b[i] == c[j]:
                t = b[i]
                b[i] = b[k]
                b[k] = t
                k = k + 1
                swap = 1
                break
        if swap == 1:
            break
    if swap == 0:
        break
for i in range(0, 32):
    fo.write('8\'d%d: new_addr = 6\'d%d;\n' % (i+32*5, b[i]))

a = []
c = []
for i in range(23, 32):
    c.append(b[i])
for i in range(0, 32):
    a.append(2*i)
random.shuffle(a)
k = 9
while True:
    swap = 0
    for i in range(0,9):
        for j in range(i,9):
            if a[i] == c[j]:
                t = a[i]
                a[i] = a[k]
                a[k] = t
                k = k + 1
                swap = 1
                break
        if swap == 1:
            break
    if swap == 0:
        break
for i in range(0, 32):
    fo.write('8\'d%d: new_addr = 6\'d%d;\n' % (i+32*6, a[i]))

b = []
c = []
for i in range(23, 32):
    c.append(a[i])
for i in range(0, 32):
    b.append(2*i)
random.shuffle(b)
k = 9
while True:
    swap = 0
    for i in range(0,9):
        for j in range(i,9):
            if b[i] == c[j]:
                t = b[i]
                b[i] = b[k]
                b[k] = t
                k = k + 1
                swap = 1
                break
        if swap == 1:
            break
    if swap == 0:
        break
for i in range(0, 32):
    fo.write('8\'d%d: new_addr = 6\'d%d;\n' % (i+32*7, b[i]))
fo.close()