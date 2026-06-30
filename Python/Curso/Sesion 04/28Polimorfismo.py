# Mostramos el polimorfismo en python

# ----------------------------------------------------------
# Programa: Polimorfismo en Programación Orientada a Objetos
# Descripción:
# Se implementa el concepto de polimorfismo mediante
# una clase base llamada Animal y tres clases derivadas:
# Perro, Gato y Oso. Cada clase sobrescribe el método
# comunicarse() con un comportamiento diferente.
# ----------------------------------------------------------

# Definición de la clase base
class Animal:

    # Método que debe ser implementado por las clases hijas
    def comunicarse(self):
        raise NotImplementedError(
            "Las clases hijas deben implementar el método comunicarse()."
        )

# Definición de la clase hija Perro
class Perro(Animal):
    # Sobrescribe el método de la clase base
    def comunicarse(self):
        return "El perro dice: ¡Guau, guau!"

# Definición de la clase hija Gato
class Gato(Animal):
    # Sobrescribe el método de la clase base
    def comunicarse(self):
        return "El gato dice: ¡Miau, miau!"

# Definición de la clase hija Oso
class Oso(Animal):
    # Sobrescribe el método de la clase base
    def comunicarse(self):
        return "El oso dice: ¡Grrr, grrr!"

class Pollo(Animal):
    # Sobrescribe el método de la clase base
    def comunicarse(self):
        return "El pollo dice: ¡Pio, Pio!"

# ----------------------------------------------------------
# Programa principal
# ----------------------------------------------------------

# Crear los objetos de las clases hijas
perro = Perro()
gato = Gato()
oso = Oso()
pollo = Pollo()

# Almacenar los objetos en una lista de objetos
animales = [perro, gato, oso, pollo]

# Mostrar el comportamiento polimórfico
print("=== COMUNICACIÓN DE LOS ANIMALES ===")

# Recorrer la lista e invocar el mismo método para cada objeto
for animal in animales:
    print(animal.comunicarse())