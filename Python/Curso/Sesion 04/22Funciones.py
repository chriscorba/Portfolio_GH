# Creamos un programa que usando funciones pida un nombre y salude al usuario

# -----------------------------------------------
# Programa: Saludo mediante una función
# Descripción: Define una función que recibe un
# nombre como parámetro y muestra un saludo.
# -----------------------------------------------

# Definición de la función.
# Recibe un parámetro llamado "nombre".
def saludar(nombre):
    # Muestra un saludo personalizado utilizando el nombre recibido.
    print(f"¡Hola, {nombre}! Bienvenido/a.")


# Programa principal

# Solicita al usuario que ingrese su nombre.
nombre_usuario = input("Ingrese su nombre: ")

# Llama a la función "saludar" enviando como argumento
# el nombre ingresado por el usuario.
saludar(nombre_usuario)