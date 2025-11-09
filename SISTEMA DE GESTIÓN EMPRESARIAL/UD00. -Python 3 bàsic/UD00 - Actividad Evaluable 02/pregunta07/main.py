# main.py

import sys
from es_palindromo import esPalindromo
from es_primo import esPrimo

def main():
    if len(sys.argv) != 3:
        print("Uso: python main.py <archivo_entrada> <archivo_salida>")
        sys.exit(1)

    archivo_entrada = sys.argv[1]
    archivo_salida = sys.argv[2]

    with open(archivo_entrada, 'r', encoding='utf-8') as f:
        numeros = [int(line.strip()) for line in f if line.strip().isdigit()]

    palindromos = [n for n in numeros if esPalindromo(n)]
    primos = [n for n in numeros if esPrimo(n)]
    ambos = [n for n in numeros if esPalindromo(n) and esPrimo(n)]

    with open(archivo_salida, 'w', encoding='utf-8') as f:
        f.write(f"Hay {len(palindromos)} números palíndromos\n")
        f.write(f"Hay {len(primos)} números primos.\n")
        for n in ambos:
            f.write(f"{n}\n")

if __name__ == "__main__":
    main()