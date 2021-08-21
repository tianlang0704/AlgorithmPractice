import math
import random
import sys

class Generator:
    def GenArr(size):
        res = []
        for i in range(size):
            res.append(random.randint(-sys.maxsize, sys.maxsize))
        return res