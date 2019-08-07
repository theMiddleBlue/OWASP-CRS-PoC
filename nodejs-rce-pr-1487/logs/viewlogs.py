import os, json, re, time
from glob import glob

currentdir=os.path.dirname(os.path.abspath(__file__))

class bcolors:
	HEADER = '\033[95m'
	OKBLUE = '\033[94m'
	OKGREEN = '\033[92m'
	WARNING = '\033[93m'
	FAIL = '\033[91m'
	ENDC = '\033[0m'
	BOLD = '\033[1m'
	UNDERLINE = '\033[4m'

while True:
	result = [y for x in os.walk(currentdir+'/audit') for y in glob(os.path.join(x[0], '*'))]

	for f in result:
		if os.path.isfile(f):
			json_d = json.load(open(f, 'r'))
			msg = ''

			#print(json.dumps(json_d,indent=4))

			if "audit_data" in json_d and "messages" in json_d["audit_data"]:
				for m in json_d["audit_data"]["messages"]:
					ruleid = re.search('\[id "([^"]+)"\]', m)
					msg = re.search('\[msg "([^"]+)"\]', m)
					data = re.search('\[data "([^"]+)"\]', m)

					if msg:
						print("["+bcolors.WARNING+ruleid.group(1)+bcolors.ENDC+"] "+bcolors.OKGREEN+msg.group(1)+bcolors.ENDC)

					if data:
						print("\t`- "+data.group(1))
			os.remove(f)

	time.sleep(.500)
