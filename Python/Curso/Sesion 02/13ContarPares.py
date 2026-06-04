#El programa cuenta los numeros pares del 1 al 250

contador = 0
#El ciclo for recorre los numeros del 1 al 250 y verifica si cada numero es par utilizando el operador modulo (%). Si el numero es par, se incrementa el contador en 1. Al final, se imprime la cantidad de numeros pares encontrados.
for numero in range(1, 251):
    #El operador modulo (%) devuelve el resto de la division entre el numero y 2. Si el resultado es 0, significa que el numero es divisible por 2 y por lo tanto es par.   
    if numero % 2 == 0:
        #Si el numero es par, se incrementa el contador en 1.
        contador += 1
    print(numero, end=" ")
#Finalmente, se imprime el resultado de la cantidad de numeros pares encontrados del 1 al 250.  
print("\n" + "=" * 50)
print("La cantidad de numeros pares del 1 al 250 es:", contador)
