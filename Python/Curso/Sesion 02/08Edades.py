#Realiza un programa en python que pida el nombre y la edad a un usuario y lo clasifique segun su edad, si es menor a 12 años, debe avisar: "Eres un niño", si su edad es entre 12 y 18 "Eres un adolescente", si es entre 19 y 30 "Eres un joven", si es entre 31 y 45 "Eres un adulto", y si es mayor a 45 "Eres un adulto mayor". no uses funciones ni manejo de excepciones, es un programa de nivel basico y explica cada linea de código.

# Pedimos el nombre del usuario
nombre = input("Ingrese su nombre: ")

# Pedimos la edad del usuario y la convertimos a número entero
edad = int(input("Ingrese su edad: "))

# Comparamos la edad y escribimos el resultado correspondiente
if edad < 12:
    print(nombre + ", eres un niño")
elif edad <= 18:
    print(nombre + ", eres un adolescente")
elif edad <= 30:
    print(nombre + ", eres un joven")
elif edad <= 45:
    print(nombre + ", eres un adulto")
else:
    print(nombre + ", eres un adulto mayor")
