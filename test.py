from time import sleep
i = 0
while (True):
    try:
        print("test", i)
        i += 1
        with open("test.txt", "w+") as f:
            print(i)
            f.write(str(i))
        sleep(1)
    except KeyboardInterrupt:
        break
    