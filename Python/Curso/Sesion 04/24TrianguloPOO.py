# ----------------------------------------------------------
# Programa: Cálculo del área de dos triángulos
# Descripción:
# Define una clase llamada Triangulo con los atributos
# base y altura, y un método que calcula el área.
# El programa solicita al usuario los datos de dos
# triángulos y muestra el área de cada uno.
# ----------------------------------------------------------

# Definición de la clase Triangulo
class Triangulo:
    # Constructor de la clase
    def __init__(self, base, altura):
        # Inicializa los atributos del objeto
        self.base = base
        self.altura = altura

    # Funcion que calcula y retorna el área del triángulo (Funcion si retorna valor, Metodo no retorna valor)
    def area(self):
        return (self.base * self.altura) / 2 #tiene retorno de valor

# ------------------------
# Programa principal
# ------------------------

print("=== TRIÁNGULO 1 ===")
base1 = float(input("Ingrese la base: "))
altura1 = float(input("Ingrese la altura: "))

print("\n=== TRIÁNGULO 2 ===")
base2 = float(input("Ingrese la base: "))
altura2 = float(input("Ingrese la altura: "))

# Creación de los objetos
triangulo1 = Triangulo(base1, altura1)
triangulo2 = Triangulo(base2, altura2)

# Mostrar resultados
print("\n===== RESULTADOS =====")
print(f"Área del Triángulo 1: {triangulo1.area():.3f}")
print(f"Área del Triángulo 2: {triangulo2.area():.2f}")