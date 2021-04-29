case_str = "1"
for i in range(2, 10020):
    if i%2 == 0:
        case_str = case_str+f" {i}"
    else:
        case_str = f"{i} "+case_str
arr = [ int(i) for i in case_str.split() ]
# def qsort(arr: list):
#     n = len(arr)
#     if n == 0:
#         return arr
#     pivot = arr[n // 2]
#     l = [ i for i in arr if i < pivot ]
#     g = [ i for i in arr if i > pivot ]
#     cnt = arr.count(pivot)
#     print(pivot)
#     return qsort(l) + [pivot] * cnt + qsort(g)
# qsort(arr)
print(case_str)