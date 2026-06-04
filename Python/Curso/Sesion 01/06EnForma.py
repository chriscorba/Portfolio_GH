#El programa debe pedir el nombre y peso del usuario y lo clasifique, si es mayor a 80 debe avisar "Estas pasado de peso", si es menor a 80 debe avisar "Estas en tu peso ideal", de lo contrario avisar "Estas en forma", el programa no debe usar validaciones por ahora, solo código simple
nombre = input("Ingresa tu nombre: ")
peso = float(input("Ingresa tu peso: "))

if peso > 80:
    print(f"{nombre}, estas pasado de peso.")
elif peso < 80:
    print(f"{nombre}, estas en forma.")
