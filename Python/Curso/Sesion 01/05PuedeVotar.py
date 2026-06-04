# Programa sencillo que pide nombre y edad y dice si la persona puede votar

# Pedimos el nombre al usuario y lo guardamos en la variable 'nombre'
nombre = input("Introduce tu nombre: ")

# Pedimos la edad al usuario y la guardamos en la variable 'edad'
# Usamos int() para convertir la entrada (texto) a un número entero
edad = int(input("Introduce tu edad: "))

# Comprobamos si la edad es mayor o igual a 18
if edad >= 18:
	# Si tiene 18 o más, puede votar
	print(nombre + ", puedes votar.")
else:
	# Si tiene menos de 18, no puede votar
	print(nombre + ", no puedes votar aún.")

# Fin del programa