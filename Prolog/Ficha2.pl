fatorial(0, 1).                   
fatorial(N, F):- N > 0,
N1 is N-1,
fatorial(N1, F1), 
F is F1 * N.

somaRec(0, 0).                   
somaRec(N, F):- N > 0,
N1 is N-1,
somaRec(N1, F1), 
F is F1 + N.

fibonacci(0, ). 
fibonacci(1, 1).                   
fibonacci(N, F):- N > 0,
N1 is N-1, N2 is N-2,
fibonacci(N1, F1), 
fibonacci(N2, F2), 
F is F1 + F2.

isPrime(N):- N > 0,
N1 is N-1,
isPrime(N1), 
F is F1 + N.