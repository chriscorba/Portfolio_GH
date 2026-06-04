#El programa cuenta en orden inverso del 25 al 1 usando un ciclo for, y al finalizar muestra un mensaje indicando que el programa terminó.
import time
for numero in range(25, 0, -4):  # Usamos range(25, 0, -4) para contar de 25 a 1, el tercer parametro -4 indica que el conteo es en orden inverso y los saltos son de 4 en 4.
    print(numero)  # Imprimimos el numero actual en cada iteracion.
    time.sleep(1)  # Pausa de medio segundo entre cada numero para que sea mas legible
print("El programa terminó.")  # Al finalizar el ciclo for, mostramos un aviso de que el programa termino.
