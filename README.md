# MipsGraphicsBridge

Proyecto en C++ para conectar entrada tipo MIPS con salida gráfica usando **olcPixelGameEngine**.

## Requisitos mínimos

- Linux
- CMake
- g++

## Uso rápido

### 1) Clonar el repositorio

```bash
git clone git@github.com:jmartinrivera11/OCQ12026-Project1.git
cd OCQ12026-Project1
```

### 2) Compilar

```bash
cmake -S . -B build
cmake --build build
```

### 3) Ejecutar

```bash
./EasyMIPS --run front.asm --sc-handler build/libmips_display.so
```