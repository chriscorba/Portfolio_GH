# # ----------------------------------------------------------
# Programa: Clase Persona con Programación Orientada a Objetos
# Descripción:
# Se crea una clase llamada Persona con un constructor que
# inicializa los atributos nombre y edad. Además, se implementa
# un método para mostrar un saludo personalizado.
# ----------------------------------------------------------

# Definición de la clase Persona
class Persona:   
    # Definimoos el CONSTRUCTOR de la clase (parte privada).
    # Se ejecuta automáticamente al crear un objeto.
    def __init__(self, nombre, edad): #Inicializador de la estructura de la clase Persona
        # Inicializa el atributo nombre.
        self.nombre = nombre
        # Inicializa el atributo edad.
        self.edad = edad

    # Definimos un metodo llamado saludar (parte publica).
    def saludar(self):
        print(f"Hola, mi nombre es {self.nombre} y tengo {self.edad} años.")

# ------------------------
# Programa principal
# ------------------------

# Creación de los objetos de la clase Persona.
persona1 = Persona("Juan", 25)
persona2 = Persona("Ana", 31)
persona3 = Persona("Maria", 22)

# Mensaje indicando que los objetos fueron creados.
print("Se crearon correctamente los objetos de la clase Persona.\n")

# Mostrar los atributos del primer objeto.
print("Datos de la persona 1:")
print(f"Nombre: {persona1.nombre}")
print(f"Edad: {persona1.edad}\n")

# Mostrar los atributos del segundo objeto.
print("Datos de la persona 2:")
print(f"Nombre: {persona2.nombre}")
print(f"Edad: {persona2.edad}\n")

print("Datos de la persona 3:")
print(f"Nombre: {persona3.nombre}")
print(f"Edad: {persona3.edad}\n")

# Llamada al método saludar() de cada objeto.
print("Saludos de las personas:")
persona1.saludar()
persona2.saludar()
persona3.saludar()