import sys
import os


files = [f for f in os.listdir("./scripts/descriptors") if os.path.isfile(os.path.join("./scripts/descriptors", f))]
files2 = [(f + " [Prefab]") for f in os.listdir("./scripts/prefab_descriptors") if os.path.isfile(os.path.join("./scripts/prefab_descriptors", f))]

allfiles = files + files2

allfiles.sort()

for i in range(len(allfiles)):
	v = allfiles[i]
	
	if v == sys.argv[1]:
		allfiles.remove(v)
		break

for i in range(len(allfiles)):
	v = allfiles[i]
	
	if v > sys.argv[1]:
		print("Place below:", allfiles[i-1]) # place below this
		print("Place Above:", v) # place above this
		print(":< :", allfiles[i+1])
		break