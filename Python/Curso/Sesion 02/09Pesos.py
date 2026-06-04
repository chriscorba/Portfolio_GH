#Realiza un programa en python que pida el nombre y el peso de una persona y lo  clasifique de la siguiente forma: si el peso es menor a 60 debe avisar, "eres de complexion delgada"; si el peso esta entre 61 y 75, "eres de complexión atletica"; si el peso esta entre 76 y 90, "eres corpulento"; en cualquier otro caso, "eres gordito"
nombre = input("Introduce tu nombre: ")
peso = float(input("Introduce tu peso en kilogramos: "))

if peso <=60:
    print(f"{nombre}, eres de complexión delgada")
elif 61 <= peso <= 75:
    print(f"{nombre}, eres de complexión atlética")
elif 76 <= peso <= 90:
    print(f"{nombre}, eres corpulento")
else:
    print(f"{nombre}, eres gordito")
