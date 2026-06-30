# ----------------------------------------------------------
# Programa: Herencia con la clase Figura
# Descripción:
# Se implementa la herencia mediante una clase base
# llamada Figura y dos clases derivadas: Rectangulo
# y Circulo. Cada clase hija implementa su propio
# método para calcular el área.
# ----------------------------------------------------------

# Importa la librería math para utilizar la constante pi
import math

# Clase base
class Figura:

    # Constructor de la clase
    def __init__(self, color, forma):
        # Inicializa los atributos comunes
        self.color = color
        self.forma = forma

    # Método par dibujar la figura
    def dibujar(self):
        print(f"Se está dibujando un(a) {self.forma} de color {self.color}.")

# Clase derivada Rectangulo
class Rectangulo(Figura): #Esta heredando "Color" y "Forma", puede utilizar solo una o ambas

    # Constructor de la clase
    def __init__(self, color, base, altura):
        # Llama al constructor de la clase padre
        super().__init__(color, "Rectángulo") #esta usando solo el "color"

        # Inicializa los atributos propios
        self.base = base
        self.altura = altura

    # Método que calcula el área del rectángulo
    def calcular_area(self):
        return self.base * self.altura

# Clase derivada Circulo
class Circulo(Figura):

    # Constructor de la clase
    def __init__(self, color, radio):
        # Llama al constructor de la clase padre
        super().__init__(color, "Círculo") #esta usando solo el "color"

        # Inicializa el atributo propio
        self.radio = radio

    # Método que calcula el área del círculo
    def calcular_area(self):
        return math.pi * (self.radio ** 2)

# ------------------------
# Programa principal
# ------------------------

# Crear objetos
rectangulo = Rectangulo("Azul", 10, 5)
circulo = Circulo("Rojo", 7)

# Mostrar información del rectángulo
print("=== RECTÁNGULO ===")
rectangulo.dibujar()
print(f"Área: {rectangulo.calcular_area():.2f}\n")

# Mostrar información del círculo
print("=== CÍRCULO ===")
circulo.dibujar()
print(f"Área: {circulo.calcular_area():.2f}")


# Se heredan los atributos mas no los valores
