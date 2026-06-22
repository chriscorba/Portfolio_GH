# Calculadora básica con while y manejo de excepciones
opcion = 0
while opcion != 5:
    print("\n=== CALCULADORA BÁSICA ===")
    print("1. Sumar")
    print("2. Restar")
    print("3. Multiplicar")
    print("4. Dividir")
    print("5. Salir")
    try:
        opcion = int(input("Seleccione una opción: "))
        if opcion >= 1 and opcion <= 4:
            try:
                num1 = float(input("Ingrese el primer número: "))
                num2 = float(input("Ingrese el segundo número: "))
                if opcion == 1:
                    resultado = num1 + num2
                    print("Resultado:", resultado)
                elif opcion == 2:
                    resultado = num1 - num2
                    print("Resultado:", resultado)
                elif opcion == 3:
                    resultado = num1 * num2
                    print("Resultado:", resultado)
                elif opcion == 4:
                    if num2 != 0:
                        resultado = num1 / num2
                        print("Resultado:", resultado)
                    else:
                        print("Error: no se puede dividir entre cero.")
            except ValueError:
                print("Error: debe ingresar números válidos.")
        elif opcion == 5:
            print("Saliendo de la calculadora...")
        else:
            print("Error: opción inválida. Ingrese un número del 1 al 5.")
    except ValueError:
        print("Error: debe ingresar un número entero para seleccionar la operación.")