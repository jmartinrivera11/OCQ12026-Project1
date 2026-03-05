# MipsGraphicsBridge

Proyecto en C++ para conectar entrada tipo MIPS con salida gráfica usando **olcPixelGameEngine**.

## Requisitos

- Linux
- CMake
- g++ / make
- EasyMIPS

## Compilar

```bash
cmake -S . -B build
cmake --build build
```

## Ejecutar

```bash
./EasyMIPS --run front.asm --sc-handler build/libmips_display.so
```

## Compilar y ejecutar en una sola línea (recomendado)

```bash
cmake --build build && ./EasyMIPS --run front.asm --sc-handler build/libmips_display.so
```

Útil cuando hiciste cambios y quieres reconstruir antes de correr.

## Limpieza y recompilación completa

```bash
rm -rf build
cmake -S . -B build
cmake --build build
```