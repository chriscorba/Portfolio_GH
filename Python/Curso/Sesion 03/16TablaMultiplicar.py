# El programa muestra la tabla de multiplicar de un número

#comportate como un programador en python y realiza un programa que usando el ciclo while pida al usuario un número y muestre su tabla de multiplicar (del 1 al 10), despues preguntar si desea consultar otra tabla y continuar, hasta que el usuario decida salir, por ahora utiliza un try except para el manejo de introducir el numero cuya tabla se mostrara en la pantalla.
continuar = 's'
while continuar.lower() == 's':
    try:
        numero = int(input("Ingrese un número para ver su tabla de multiplicar: "))
        multiplicador = 1
        print(f"\nTabla de multiplicar del {numero}:\n")
        while multiplicador <= 10:
            resultado = numero * multiplicador
            print(f"{numero} x {multiplicador} = {resultado}")
            multiplicador += 1        
    except ValueError:
        print("Error: Debe ingresar un número válido.")

    continuar = input("\n¿Desea consultar otra tabla de multiplicar? (s/n): ")

print("\nPrograma finalizado.\n")



