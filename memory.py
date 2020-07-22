with open('main_memory.bin', 'w') as mem:
    for i in range(1024):
        mem.write('{:032b}\n'.format(0))
    
    for i in range(2 ** 13):
        mem.write('{:032b}\n'.format(i))
    
    for i in range((32 - 9) * 2 ** 10):
        mem.write('{:032b}\n'.format(0))