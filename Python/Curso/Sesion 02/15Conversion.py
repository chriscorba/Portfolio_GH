#El programa debe convertir de una moneda a otra mostrando un menu

while True:
    print("\n--- MENÚ DE CONVERSIÓN ---")
    print("1. Convertir dólares a Soles")
    print("2. Convertir dólares a Pesos Mexicanos")
    print("3. Salir")

    opcion = input("Elige una opción: ")

    if opcion == "3":
        print("Programa finalizado.")
        break

    try:
        dolares = float(input("Ingresa la cantidad de dólares: "))

        if opcion == "1":
            tipo_cambio = float(input("Ingresa el tipo de cambio a Soles: "))
            resultado = dolares * tipo_cambio
            print("Equivale a", resultado, "Soles")

        elif opcion == "2":
            tipo_cambio = float(input("Ingresa el tipo de cambio a Pesos Mexicanos: "))
            resultado = dolares * tipo_cambio
            print("Equivale a", resultado, "Pesos Mexicanos")

        else:
            print("Opción no válida.")

    except ValueError:
        print("Error: Debes ingresar números válidos.")

    except Exception as e:
        print("Ocurrió un error:", e)