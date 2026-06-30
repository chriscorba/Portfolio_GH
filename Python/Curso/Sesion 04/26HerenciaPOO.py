#El programa ejemplifica el concepto de herencia en POO

# ----------------------------------------------------------
# Programa: Herencia en Programación Orientada a Objetos
# Descripción:
# Se define una clase base llamada Animal y una clase
# derivada llamada Perro. La clase Perro hereda los
# atributos y métodos de Animal, además de incorporar
# un nuevo atributo y un método propio.
# ----------------------------------------------------------


# Definición de la clase base
class Animal:  
    # Constructor de la clase base
    def __init__(self, nombre):
        # Inicializa el atributo nombre
        self.nombre = nombre

    # Método que indica que el animal está comiendo
    def comer(self):
        print(f"{self.nombre} está comiendo.")


# Clase derivada que hereda de Animal
class Perro(Animal):
    # Constructor de la clase derivada
    def __init__(self, nombre, raza):
        # Llama al constructor de la clase padre,
        super().__init__(nombre) #este atributo es heredado,esta inicializado en la super clase

        # Inicializa el atributo propio de la clase Perro
        self.raza = raza

    # Método propio de la clase Perro
    def ladrar(self):
        print(f"{self.nombre}, de raza {self.raza}, está ladrando: ¡Guau, guau!")


# ------------------------
# Programa principal
# ------------------------

# Crear un objeto de la clase Perro
perro1 = Perro("Max", "Labrador")

# Mostrar información del objeto
print("=== DATOS DEL PERRO ===")
print(f"Nombre: {perro1.nombre}")
print(f"Raza: {perro1.raza}\n")

# Invocar el método heredado de la clase Animal
print("Método heredado:")
perro1.comer()

# Invocar el método propio de la clase Perro
print("\nMétodo propio:")
perro1.ladrar()