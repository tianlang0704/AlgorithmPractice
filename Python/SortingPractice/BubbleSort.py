from array import array
from tools.Generator import Generator

def bubble_sort(arr:list):
    for i in range(len(arr)):
        for j in range(i + 1, len(arr)):
            iValue = arr[i]
            jValue = arr[j]
            if (jValue < iValue):
                arr[i] = jValue
                arr[j] = iValue

def main():
    arr = Generator.GenArr(10)
    print(arr)
    bubble_sort(arr)
    print(arr)

main()