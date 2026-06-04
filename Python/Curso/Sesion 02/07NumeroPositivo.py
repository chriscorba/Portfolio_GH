# Actua como un programador en phyton y crrea un programa que pida un numero al usuario y le informe si es positivo o negativo, no uses funciones ni manejo de excepciones, es un programa de nivel basico y explica cada linea de código.

# El programa pide un numero al usuario y muestra si es positivo o negativo.
# No se usan funciones ni manejo de excepciones, es un programa de nivel basico.
numero = input('Ingresa un numero: ')  # Se pide al usuario que escriba un numero.
numero = float(numero)  # Se convierte la cadena de texto en un numero real.
if numero >= 0:  # Se verifica si el numero es mayor o igual a cero.
    print('El numero es positivo')  # Si la condicion es verdadera, se muestra mensaje de positivo.
else:  # Si la condicion anterior es falsa, se ejecuta esta parte.
    print('El numero es negativo')  # Se muestra mensaje de negativo.
