x = [13, 5, 6, 2, 5]
y = [5, 2, 5, 13]

a = [14, 27, 1, 4, 2, 50, 3, 1]
b = [2, 4, -4, 3, 1, 1, 14, 27, 50]

def f(x, y):
    results = []
    [results.append(i) for i in x if i not in y]
    [results.append(i) for i in y if i not in x]
    return results[0]