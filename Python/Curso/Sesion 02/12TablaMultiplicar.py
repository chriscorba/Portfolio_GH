#Realiza un programa en phyton que pida un numero al usuario y usando el cilo for, muestre la tabla de multiplicar de dicho numero
#Realiza un programa en Python que pida un número al usuario y usando el ciclo for, muestre la tabla de multiplicar de dicho número.

import time
numero = int(input("Ingrese un número: "))

print(f"\nTabla de multiplicar del {numero}:")
print("=" * 30)  # Línea separadora
for i in range(1, 11):
    resultado = numero * i
    print(f"{numero} x {i} = {resultado}")
    time.sleep(1)  # Pausa de 1 segundo entre cada línea para que sea más legible
print("=" * 30)  # Línea separadora
print("¡Tabla de multiplicar completa!")