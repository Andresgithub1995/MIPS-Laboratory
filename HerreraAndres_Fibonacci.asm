        .data
prompt_input:    .asciiz "¿Cuántos números de la serie Fibonacci deseas generar?: "
fibonacci_msg:   .asciiz "Los números de la serie Fibonacci son: "
sum_msg:         .asciiz "La suma de los números de la serie es: "
newline:         .asciiz "\n"

        .text
        .globl main

main:
        # Solicitar cantidad de números de la serie Fibonacci
        li      $v0, 4                 # syscall para imprimir cadena
        la      $a0, prompt_input      # cargar dirección del mensaje
        syscall                        # imprime "¿Cuántos números de la serie Fibonacci deseas generar?"
        
        # Leer cantidad de números
        li      $v0, 5                 # syscall para leer entero
        syscall                        # almacenar el número ingresado en $t0
        move    $t0, $v0               # cantidad de términos en $t0
        
        # Verificar si el número es mayor que 0
        blez    $t0, exit              # si el número es 0 o negativo, salir del programa
        
        # Imprimir mensaje inicial para la serie
        li      $v0, 4                 # syscall para imprimir cadena
        la      $a0, fibonacci_msg     # cargar dirección del mensaje
        syscall                        # imprime "Los números de la serie Fibonacci son: "

        # Inicialización de los primeros dos números de Fibonacci
        li      $t1, 0                 # Primer número (F0)
        li      $t2, 1                 # Segundo número (F1)
        li      $t3, 0                 # Inicializar el acumulador para la suma
        
        # Imprimir el primer número (F0)
        move    $a0, $t1               # Cargar el primer número en $a0
        li      $v0, 1                 # syscall para imprimir entero
        syscall

        # Verificar si solo se quiere 1 número
        beq     $t0, 1, sum            # Si solo se requiere un número, ir directamente a la suma

        # Imprimir el segundo número (F1)
        li      $v0, 4                 # syscall para imprimir nueva línea
        la      $a0, newline
        syscall
        move    $a0, $t2               # Cargar el segundo número en $a0
        li      $v0, 1                 # syscall para imprimir entero
        syscall

        # Sumar los dos primeros números a la acumulación
        add     $t3, $t1, $t2          # Sumar los dos primeros números (F0 + F1)

        # Bucle para generar los números restantes de la serie
        li      $t4, 2                 # Contador inicial de la serie (ya se imprimieron 2 números)

fibonacci_loop:
        beq     $t4, $t0, sum          # Si ya generamos todos los números, ir a la suma
        
        # Generar siguiente número de Fibonacci
        add     $t5, $t1, $t2          # F(n) = F(n-1) + F(n-2)
        
        # Imprimir el siguiente número de Fibonacci
        li      $v0, 4                 # syscall para imprimir nueva línea
        la      $a0, newline
        syscall
        move    $a0, $t5               # Cargar el siguiente número en $a0
        li      $v0, 1                 # syscall para imprimir entero
        syscall
        
        # Actualizar los valores para la siguiente iteración
        move    $t1, $t2               # F(n-2) = F(n-1)
        move    $t2, $t5               # F(n-1) = F(n)
        
        # Sumar el siguiente número al acumulador
        add     $t3, $t3, $t5          # Acumular F(n)
        
        # Incrementar contador
        addi    $t4, $t4, 1
        j       fibonacci_loop         # Repetir el ciclo

sum:
        # Imprimir el mensaje de suma
        li      $v0, 4                 # syscall para imprimir cadena
        la      $a0, sum_msg           # cargar dirección del mensaje
        syscall                        # imprime "La suma de los números de la serie es: "

        # Imprimir la suma de la serie
        move    $a0, $t3               # cargar la suma acumulada en $a0
        li      $v0, 1                 # syscall para imprimir entero
        syscall

        # Salida del programa
exit:
        li      $v0, 10                # syscall para salir del programa
        syscall
