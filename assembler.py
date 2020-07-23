#!/usr/bin/env python3
cmds = []
string = []
co = {'add':'0000', 'adc':'0000', 'adz':'0000', 'adi':'0001', 'ndu':'0010', 'ndc':'0010', 'ndz':'0010', 'lw':'0100', 'sw':'0101', 'lm':'0110', 'sm':'0111', 'lhi':'0011', 'beq':'1100', 'jal':'1000', 'jlr':'1001', 'mvi':'1010', 'mov':'1011'}
ex = {'add':'000', 'adc':'010', 'adz':'001', 'ndu':'000', 'ndc':'010', 'ndz':'001'}
r = {'r0':'000','r1':'001','r2':'010','r3':'011','r4':'100','r5':'101','r6':'110','r7':'111'}
with open('code.asm','r') as f:
	cmds = f.readlines()
	for cmd in cmds:
		a = cmd.strip().replace(",", " ").split()
		if a[0] == 'add' or a[0] == 'adc' or a[0] == 'adz' or a[0] == 'ndu' or a[0] == 'ndc' or a[0] == 'ndz':
			string.append(co[a[0]]+r[a[2]]+r[a[3]]+r[a[1]]+ex[a[0]])
		elif a[0] == 'adi':
			string.append(co[a[0]]+r[a[2]]+r[a[1]]+a[3])
		elif a[0] == 'sm' or a[0] == 'lm' or a[0] == 'lhi' or a[0] == 'jal' or a[0] == 'mvi':
			string.append(co[a[0]]+r[a[1]]+a[2])
		elif a[0] == 'lw' or a[0] == 'sw' or a[0] == 'beq':
			string.append(co[a[0]]+r[a[1]]+r[a[2]]+a[3])
		elif a[0] == 'jlr' or a[0] == 'mov':
			string.append(co[a[0]]+r[a[1]]+r[a[2]]+'000000')

			
with open('memory.txt','w') as f:
	string = [hex(int(i[:4], 2)).replace('0x', '')+hex(int(i[4:8], 2)).replace('0x', '')+hex(int(i[8:12], 2)).replace('0x', '')+hex(int(i[12:], 2)).replace('0x', '')+' //'+j.rstrip() for i,j in zip(string, cmds)]	
	f.writelines(["%s\n" %item for item in string])

