import csv
import random
import math
import operator
cimport cython
cimport numpy as np
import numpy as np
from numpy cimport ndarray
cdef extern from "math.h":
	double sqrt(double m)


'''from loadDataset import loadDataset
from euclideanDistance import euclideanDistance
from getNeighbors import getNeighbors
from getResponse import getResponse
from getAccuracy import getAccuracy
without modifiying the code to cython
real	0m4.863s
user	0m4.660s
sys	    0m0.144s
after changing the for loop in loadDataset

real	0m5.134s
user	0m4.888s
sys	0m0.136s

run time
real	0m0.693s
user	0m0.680s
sys	0m0.008s
aditya@aditya-Lenovo-ideapad-110-15ACL:~/Desktop/task1$ time gcc -Os -I /usr/include/python3.5m -o taskFileOutputObject taskFileOutput1.c -lpython3.5m -lpthread -lm -lutil -ldl
compile time
real	0m2.454s
user	0m2.360s
sys	0m0.080s



'''
 
def loadDataset(filename, split, trainingSet=[] , testSet=[]):
	cdef long x
	cdef long y
	with open(filename, 'rt') as csvfile:
		lines = csv.reader(csvfile)
		dataset = list(lines)
		for x from 0 <= x < (len(dataset)-1):
			for y from 0 <= y < 4:
				dataset[x][y] = float(dataset[x][y])
				if random.random() < split:
					trainingSet.append(dataset[x])
				else:
					testSet.append(dataset[x])
	
 
def euclideanDistance(instance1, instance2, length):
	cdef double distance
	distance = 0
	for x from 0 <= x < length:
	#for x in range(length):
		distance += pow((instance1[x] - instance2[x]), 2)
	return sqrt(distance)
 
def getNeighbors(trainingSet , testInstance , k):
	distances = []
	cdef int length
	cdef float dist
	length = len(testInstance)-1
	for x from 0 <= x < (len(trainingSet)):
	#for x in range(len(trainingSet)):
		dist = euclideanDistance(testInstance, trainingSet[x], length)
		distances.append((trainingSet[x], dist))
	distances.sort(key=operator.itemgetter(1))
	neighbors = []
	for x from 0 <= x < k:
	#for x in range(k):
		neighbors.append(distances[x][0])
	return neighbors
 
def getResponse(neighbors):
	classVotes = {}
	for x from 0 <= x < (len(neighbors)):
	#for x in range(len(neighbors)):
		response = neighbors[x][-1]
		if response in classVotes:
			classVotes[response] += 1
		else:
			classVotes[response] = 1
	sortedVotes = sorted(classVotes.items(), key=operator.itemgetter(1), reverse=True)
	return sortedVotes[0][0]
 
def getAccuracy(testSet, predictions):
	cdef int correct
	correct = 0
	for x from 0 <= x < (len(testSet)):
	#for x in range(len(testSet)):
		if testSet[x][-1] == predictions[x]:
			correct += 1
	return (correct/float(len(testSet))) * 100.0
	
def main():
	# prepare data
	cdef int k
	cdef float split
	cdef double accuracy
	trainingSet = []
	testSet=[]
	split = 0.67
	loadDataset('iris.data', split, trainingSet, testSet)
	print('Train set: ' + repr(len(trainingSet)))
	print('Test set: ' + repr(len(testSet)))
	# generate predictions
	predictions=[]
	k = 3
	for x from 0 <= x < (len(testSet)):
	#for x in range(len(testSet)):
		neighbors = getNeighbors(trainingSet, testSet[x], k)
		result = getResponse(neighbors)
		predictions.append(result)
		print('> predicted=' + repr(result) + ', actual=' + repr(testSet[x][-1]))
	accuracy = getAccuracy(testSet, predictions)
	print('Accuracy: ' + repr(accuracy) + '%')
	
main()
