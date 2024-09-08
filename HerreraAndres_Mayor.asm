# Primer código: Número mayor (mínimo 3 números)

        .data
prompt_numbers: .asciiz "¿Cuántos números deseas ingresar? (mínimo 3, máximo 5): "
prompt_input:   .asciiz "Ingresa el número: "
result_msg:     .asciiz "El número mayor es: "

        .text
        .globl main

main:
        # Solicitar cantidad de números a comparar
        li      $v0, 4               # syscall para imprimir cadena
        la      $a0, prompt_numbers   # cargar dirección del mensaje
        syscall                      # imprime "¿Cuántos números deseas ingresar?"
        
        # Leer cantidad de números
        li      $v0, 5               # syscall para leer entero
        syscall                      # obtener el número ingresado
        move    $t0, $v0             # almacenar la cantidad de números en $t0

        # Verificar si el número está entre 3 y 5
        li      $t1, 3               # mínimo 3 números
        li      $t2, 5               # máximo 5 números
        blt     $v0, $t1, error      # si es menor que 3, error
        bgt     $v0, $t2, error      # si es mayor que 5, error

        # Ingresar los números
        li      $t3, 0               # índice para contar los números ingresados
        li      $t4, -2147483648      # valor inicial para el número mayor (el menor valor posible)

input_loop:
        beq     $t3, $t0, find_max    # si ya se ingresaron todos los números, pasar a buscar el mayor
        
        # Solicitar número
        li      $v0, 4               # syscall para imprimir cadena
        la      $a0, prompt_input    # cargar dirección del mensaje
        syscall                      # imprime "Ingresa el número: "
        
        # Leer número ingresado
        li      $v0, 5               # syscall para leer entero
        syscall
        move    $t5, $v0             # almacenar el número ingresado en $t5
        
        # Comparar con el número mayor actual
        blt     $t5, $t4, skip       # si el número ingresado es menor que el mayor, salta
        move    $t4, $t5             # si es mayor, actualiza el valor del número mayor

skip:
        addi    $t3, $t3, 1          # incrementar índice
        j       input_loop           # repetir el ciclo hasta ingresar todos los números

find_max:
        # Mostrar el número mayor
        li      $v0, 4               # syscall para imprimir cadena
        la      $a0, result_msg      # cargar dirección del mensaje
        syscall                      # imprime "El número mayor es: "
        
        # Imprimir el número mayor
        move    $a0, $t4             # cargar el número mayor en $a0
        li      $v0, 1               # syscall para imprimir entero
        syscall                      # imprime el número mayor

        # Salir del programa
        li      $v0, 10              # syscall para salir
        syscall

error:
        # Mensaje de error si se ingresa un número fuera de rango (menor a 3 o mayor a 5)
        li      $v0, 4
        la      $a0, prompt_numbers  # reutilizamos este mensaje como ejemplo
        syscall
        li      $v0, 10
        syscall
