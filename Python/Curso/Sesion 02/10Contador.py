#Realiza un programa en python que, usando un ciclo for, muestre los numeros del 1 al 25, y al terminar muestre un aviso que indique que el programa terminó. Explicar cada linea de texto
# Este programa usa un ciclo for para mostrar los numeros del 1 al 25
# y muestra un mensaje de termino al finalizar.

# Importamos libreria time para usar funciones relacionadas con el tiempo
import time
# Recorremos los numeros de 1 a 25 usando range(1, 26).For sir para hacer ciclos
for numero in range(1, 26):
    # Imprimimos el numero actual en cada iteracion.
    print(numero)
    time.sleep(1)  # Pausa de medio segundo entre cada numero para que sea mas legible

# Al terminar el ciclo for, mostramos un aviso de que el programa termino.
print("El programa terminó.")
