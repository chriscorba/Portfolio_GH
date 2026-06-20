#El programa simulara una calculadora básica, utilizando while true, mostrando un menú de 4 opciones: suma, resta, multiplicación y divisón; y realice la operación que el usuario elija,no uses funciones pero utiliza try -except para prevenir errores.
while True: #Bucle infinito para mostrar el menú y realizar operaciones hasta que el usuario decida salir
    print("="*27)
    print("--- MENÚ DE OPERACIONES ---")
    print("="*27)
    print("1. Suma")
    print("2. Resta")
    print("3. Multiplicación")
    print("4. División")
    print("5. Salir")

    opcion = input("\n""Elige una opción: ")

    if opcion == "5":
        print("Programa finalizado.")
        break

    try:
        num1 = float(input("\n""Ingresa el primer número: "))
        num2 = float(input("Ingresa el segundo número: "))

        if opcion == "1":
            resultado = num1 + num2
            print("\n""Resultado:", resultado)

        elif opcion == "2":
            resultado = num1 - num2
            print("\n""Resultado:", resultado)

        elif opcion == "3":
            resultado = num1 * num2
            print("\n""Resultado:", resultado)

        elif opcion == "4":
            resultado = num1 / num2
            print("\n""Resultado:", resultado)

        else:
            print("\n""Opción no válida.")

    except ValueError:
        print("\n""Error: Debes ingresar números válidos.")

    except ZeroDivisionError:
        print("\n""Error: No se puede dividir entre cero.")

    except Exception as e:
        print("\n""Ocurrió un error:", e)
    print("\n""¡Gracias por usar la calculadora!")
    print("\n")    