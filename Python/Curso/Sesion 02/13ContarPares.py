#El programa cuenta los numeros pares del 1 al 250

contador = 0
sumaPares = 0
print("Los numeros pares del 1 al 250...")
print("=" * 40)  # Línea separadora

#Ciclo for para recorrer los numeros del 1 al 250
for numero in range(1, 251):
    if numero % 2 == 0: #verificamos si el numero es par
        contador = contador + 1
        sumaPares = sumaPares + numero
        print(numero, end=" ") # Mostrar los numeros pares

print("\n" + "-" * 40) # Línea separadora
print(f"Total de numeros pares entre el 1 y el 250: {contador}")
print(f"Suma de los numeros pares entre el 1 y el 250: {sumaPares}")
print("¡Programa terminado!")