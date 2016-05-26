#!/usr/bin/python

import csv
import json

# The number of questions in the survey. Any entry with a different number will be dropped.
# This needs to be adjusted if used for a different study
NUMQUESTIONS = 88

hits = json.load(open('data.json', 'rb'))

workers = []
data = []
for hit in hits:
#	if 'workerId' not in hit:
#		print hit
	worker = {'postID': hit['postId']}

	hitObject = {}
	for key in hit:
		dash = key.rfind('-')
		hitKey = key[:dash]
		index = key[dash+1:]

		if index.isdigit():

			if index not in hitObject:
				hitObject[index] = { 'postID': hit['postId'] }

			hitObject[index][hitKey] = hit[key]

		else:
			worker[key] = hit[key]

	if len(hitObject.keys()) == NUMQUESTIONS:
		data.append(hitObject)
		workers.append(worker)
	else: # Finding too many means NUMQUESTIONS is probably wrong
		print 'Wrong number of records ('+str(len(hitObject.keys()))+') for '+hit['postId']

datalist = []
dataKeys = set()
for hitObject in data:
	for key in hitObject:
		hitObject[key]['totalSequence'] = key
		for k in hitObject[key].keys():
			dataKeys.add(k)
		datalist.append(hitObject[key])

with open('reshaped-unique.csv', 'wb') as outFile:
	outCSV = csv.DictWriter(outFile, dataKeys)

	outCSV.writeheader()
	outCSV.writerows(datalist)

workerKeys = set()
for w in workers:
	for key in w.keys():
		workerKeys.add(key)

with open('demographics.csv', 'wb') as outFile:
	outCSV = csv.DictWriter(outFile, workerKeys)

	outCSV.writeheader()
	outCSV.writerows(workers)

print str(len(workers))+' workers, '+str(len(datalist))+' records.'